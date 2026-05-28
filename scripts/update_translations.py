#!/bin/env python3

# This script translates the English localization file into other languages.
# It's quite ad-hoc. By default, it uses the local AI I have installed in
# OSX on my Macbook Air M2 24GB. My setup is this: LMStudio is installed
# and the local server is enabled at http://127.0.0.1:1234. Authentication
# is disabled. The model I currently use is specified below. It's the largest
# model that my hardware can handle.
#
# Requires:
#   pip3 install openai

from __future__ import annotations

import json
import re
import os
import sys
from itertools import islice
from openai import OpenAI
from pathlib import Path
from textwrap import dedent

# A conservative limit for the local LLM model I use.
# The model seems to be able to handle somewhat
# larger inputs but then the quality of the output
# seems to drop, up to producing invalid JSON.
MAX_SYMBOLS_IN_BATCH = 4000

MASTER_ARB_FILE_NAME = "app_en.arb"

default_endpoint = "http://127.0.0.1:1234/v1"
default_api_key = "disabled but can't be empty"
default_model_name = "openai/gpt-oss-20b"

endpoint_env_var = "OPENAI_ENDPOINT"
api_key_env_var = "OPENAI_API_KEY"
model_name_env_var = "OPENAI_MODEL_NAME"

endpoint = os.environ.get(endpoint_env_var)
if endpoint is None:
    endpoint = default_endpoint

api_key = os.environ.get(api_key_env_var)
if api_key is None:
    api_key = default_api_key

model_name = os.environ.get(model_name_env_var)
if model_name is None:
    model_name = default_model_name


def json_to_string(json_object):
    return json.dumps(json_object, ensure_ascii=False, indent=2)


def load_arb_file(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)


def save_arb_file(file_path, json_object):
    with open(file_path, "w", newline="", encoding="utf-8") as f:
        json.dump(json_object, f, ensure_ascii=False, indent=2)


def extract_locale_name(arb_file_name_or_path):
    arb_file_path = Path(arb_file_name_or_path)
    m = re.fullmatch(r"app_(.*)", arb_file_path.stem)
    if m:
        return m.group(1)
    else:
        raise TranslatorException(f"Unexpected ARB file name: {arb_file_path.name}")


class TranslatorException(Exception):
    def __init__(self, message: str):
        self.message = message
        super().__init__(message)
        self.message = message

    def __str__(self) -> str:
        return self.message


class TranslationValidationError(TranslatorException): ...


class Message:
    """
    Represents both the "messageId" and "@messageId" fields in an ARB file.
    """

    DESCRIPTION_KEY = "description"

    X_TRANSLATIONS_KEY = "x-translations"
    """
    We make it possible to override a machine translation with a manual one.

    Example
    -------
    ```json
    "helloWorld": "Hello, world!"
    "@helloWorld": {
        "description": "...",
        "x-translations": {
            "es": "¡Hola, mundo!"
        }
    }
    ```

    This very syntax is also supported by a popular Dart package called
    Smart ARB translator [1].

    [1]: https://pub.dev/packages/smart_arb_translator
    """

    X_SOURCE_MESSAGE_KEY = "x-source-message"
    """
    Inside the metadata for translated messages, we include the source message,
    in order to detect modifications to the source message later.

    Example
    -------
     ```json
    "helloWorld": "¡Hola, mundo!"
    "@helloWorld": {
        "description": "...",
        "x-source-message": "Hello, world!"
    }
    ```
    """

    def __init__(self, *, message_id: str, text: str, metadata: dict):
        self.message_id = message_id
        self.text = text
        self.metadata = metadata

    @classmethod
    def validate_translation(
        cls, *, message_id: str, source_message_text: str, translated_message_text: str
    ):
        # For now, we validate only the simple placeholders
        # (no plurals / select / gender expressions).

        source_message_placeholders = {
            m.group(0) for m in re.finditer(r"\{\w+\}", source_message_text)
        }

        translated_message_placeholders = {
            m.group(0) for m in re.finditer(r"\{\w+\}", translated_message_text)
        }

        if source_message_placeholders != translated_message_placeholders:
            raise TranslationValidationError(
                f"The set of placeholders is different in the translation"
            )

    def with_manual_translation(self, *, target_locale_name: str) -> Message | None:
        """
        A source message may carry manual translations into some languages.
        If this message carries a translation into the specified language,
        this method returns a Message instance with that translation.
        Otherwise, it returns None.

        Note that manual translations are validated at load time and the
        invalid ones are skipped, so if a source message carries a manual
        translation, we can assume it passed validation already.
        """

        translations_dict = self.metadata.get(self.X_TRANSLATIONS_KEY)
        if translations_dict is None:
            return

        manual_translation = translations_dict.get(target_locale_name)
        if manual_translation is None:
            return

        return Message(
            message_id=self.message_id,
            text=manual_translation,
            metadata=self._build_translated_metadata(translated_arb_fragment={}),
        )

        return True

    def add_to_machine_translation_arb_fragment(self, arb_fragment: dict) -> Message:
        """
        Adds 2 fields to the fragment dictionary: f"{self.message_id}" and
        f"@{self.message_id}". The metadata fields irrelevant for machine
        translation are removed.
        """

        # Only keep the "description" key in the metadata get rid of anything else.
        stripped_metadata = {
            key: val
            for key, val in self.metadata.items()
            if key == self.DESCRIPTION_KEY
        }

        arb_fragment[self.message_id] = self.text
        arb_fragment[f"@{self.message_id}"] = stripped_metadata

    def with_validated_machine_translation(
        self, *, translated_arb_fragment: dict
    ) -> Message:
        """
        When called on a source message from the master ARB file and
        given the machine translation output, this method produces the
        message to be put into a translated ARB file.

        Parameters
        ----------
        translation_arb_fragment : dict
            The JSON object that contains the f"{self.message_id}"
            and optionally the f"@{self.message_id}" keys.
            It may also contain other keys corresponding to other
            messages.

        Returns
        -------
        A Message instance to be put into a translated ARB file.

        Raises
        ------
        TranslationValidationError
            If the translated message fails validation, for instance
            when the source and the translated message have a different
            set of placeholders.
        """

        translated_text = translated_arb_fragment.get(self.message_id)
        if translated_text is None:
            raise TranslationValidationError(
                f'The machine translation misses the "{self.message_id}" key'
            )

        # This may throw
        self.validate_translation(
            message_id=self.message_id,
            source_message_text=self.text,
            translated_message_text=translated_text,
        )

        translated_metadata = self._build_translated_metadata(
            translated_arb_fragment=translated_arb_fragment
        )

        return Message(
            message_id=self.message_id,
            text=translated_text,
            metadata=translated_metadata,
        )

    def _build_translated_metadata(self, *, translated_arb_fragment: dict) -> dict:
        """
        Takes the metadata from this message (assumed to be a source message),
        modifies it so that it can be put into a translated ARB file and
        finally returns that modified metadata.

        Parameters
        ----------
        translated_arb_fragment : dict
            The json object that may optionally contain the f"@{self.message_id}"
            key. It may also contain other keys corresponding to other messages.
            When applying a manual translation, just pass an empty dict.
        """

        # Clone the source message metadata while removing any custom keys.
        translated_metadata = {
            key: val for key, val in self.metadata.items() if not key.startswith("x-")
        }

        # Record the original, untranslated text of the message.
        translated_metadata[self.X_SOURCE_MESSAGE_KEY] = self.text

        # The only translatable part of the metadata is the description field.
        metadata_from_translation = translated_arb_fragment.get(f"@{self.message_id}")
        if metadata_from_translation is not None:
            translated_description = metadata_from_translation.get(self.DESCRIPTION_KEY)
            if translated_description is not None:
                translated_metadata[self.DESCRIPTION_KEY] = translated_description

        return translated_metadata


class TranslationSource:
    def __init__(self, file_path, *, supported_locale_names: set):
        file_path = Path(file_path)
        self.file_name = file_path.name
        self.json = load_arb_file(file_path)
        self.locale_name = extract_locale_name(file_path)

        self._validate(supported_locale_names=supported_locale_names)

    def _validate(self, *, supported_locale_names: set):
        for metadata_id, metadata in self.json.items():
            if not metadata_id.startswith("@"):
                # Skip non-metadata fields.
                continue

            message_id = metadata_id[1:]
            if message_id.startswith("@"):
                # This means the original key started with "@@", like "@@locale".
                # Those are not associated with messages, so we skip them.
                continue

            if message_id not in self.json:
                print(
                    f'[{self.file_name}] [WARNING] Key "{metadata_id}" exists '
                    f'but "{message_id}" doesn\'t'
                )
                continue

            message_text = self.json[message_id]

            translations_dict = metadata.get(Message.X_TRANSLATIONS_KEY)
            if translations_dict is None:
                continue

            if not isinstance(translations_dict, dict):
                print(
                    f'[{self.file_name}] [WARNING] The key "{metadata_id}" -> '
                    f'"{Message.X_TRANSLATIONS_KEY}" exists but doesn\'t '
                    "hold a JSON object"
                )
                del metadata[Message.X_TRANSLATIONS_KEY]
                continue

            # We may end up modifying translations_dict, so we copy it.
            for locale_name, manual_translation in dict(translations_dict).items():
                if locale_name not in supported_locale_names:
                    print(
                        f'[{self.file_name}] [WARNING] The message "{message_id}" '
                        f'has a manual translation for locale "{locale_name}" '
                        "but we don't have an .arb file for that locale"
                    )
                    del translations_dict[locale_name]
                    continue

                try:
                    Message.validate_translation(
                        message_id=message_id,
                        source_message_text=message_text,
                        translated_message_text=manual_translation,
                    )
                except TranslationValidationError as e:
                    print(
                        f"[{self.file_name}] [WARNING] The manual translation for message "
                        f'"{message_id}" for locale "{locale_name}" has failed validation '
                        "(see below) and won't be considered"
                    )
                    print(f"[{self.file_name}]   {e}")
                    del translations_dict[locale_name]
                    continue

    def get_message(self, *, message_id: str) -> Message:
        return Message(
            message_id=message_id,
            text=self.json[message_id],
            metadata=self.json.get(f"@{message_id}", {}),
        )


class TranslationDestination:
    def __init__(self, file_path):
        file_path = Path(file_path)

        self.file_name = file_path.name
        self.updated_json = {}

        try:
            self.orig_json = load_arb_file(file_path)
        except json.JSONDecodeError:
            print(f"[{self.file_name}] Invalid JSON. Going to rebuild the file.")
            self.orig_json = {}

        self.locale_name = extract_locale_name(file_path)
        self.updated_json["@@locale"] = self.locale_name

    def try_reusing_existing_translation(self, *, source_message: Message):
        """
        If a translation for a given message already exists and its "x-source-message"
        field matches the provided `source_message`, the method copies the existing
        translation into `self.updated_json` and returns True. Otherwise it does nothing
        and returns False.
        """

        message_id = source_message.message_id

        existing_translation = self.orig_json.get(message_id)
        if existing_translation is None:
            return False

        existing_metadata = self.orig_json.get(f"@{message_id}")
        if existing_metadata is None:
            return False

        translated_from_text = existing_metadata.get(Message.X_SOURCE_MESSAGE_KEY)
        if translated_from_text is None:
            return False

        if translated_from_text != source_message.text:
            return False

        try:
            translated_message = source_message.with_validated_machine_translation(
                translated_arb_fragment=self.orig_json
            )
        except TranslationValidationError:
            return False

        self.set_translated_message(translated_message)
        return True

    def set_translated_message(self, message: Message):
        self.updated_json[message.message_id] = message.text
        self.updated_json[f"@{message.message_id}"] = message.metadata


class TranslationUpdater:
    def __init__(
        self,
        *,
        translation_source: TranslationSource,
        translation_destination: TranslationDestination,
        openai: OpenAI,
    ):
        self.translation_source = translation_source
        self.translation_destination = translation_destination
        self.dest_file_name = translation_destination.file_name
        self.openai = openai
        self.message_batch_to_translate: dict[str, Message] = {}
        self.approx_symbols_in_batch = 0
        self.manual_translations_applied = 0
        self.new_machine_translations = 0
        self.up_to_date_machine_translations = 0
        self.system_prompt = self._get_system_prompt(
            src_locale_name=translation_source.locale_name,
            dst_locale_name=translation_destination.locale_name,
        )

    @staticmethod
    def _get_system_prompt(*, src_locale_name, dst_locale_name):
        return dedent(
            f"""
            You are a professional software localizer. You will be localizing a
            Linux app called Wine Bar. The app is a Wine prefix manager.
            It allows users to create Wine prefixes, install Windows software
            into them and run that Windows software. You can think of a Wine
            prefix as of a separate Windows installation. Wine is a Windows
            compatibility layer for Linux. Wine Bar is written in Flutter and
            uses .arb files for localization.
            
            You will be translating from the language corresponding to the locale name
            "{src_locale_name}" into the language corresponding to the locale name
            "{dst_locale_name}".
            
            Each user message will be a fragment of an .arb file to translate.
            To each such message you will respond with a translated version of that
            fragment. Your response has to be raw machine-parseable JSON, without the
            ```json quoting or similar.

            The JSON keys in the translation are to be preserved exactly.

            The JSON fields whose names start with `@` define metadata for the
            message with the same key but without the starting `@`. Of that metadata,
            you only translate the `description` field. Everything else you leave intact.
            Let me reiterate that I do want the `description` fields translated.

            Do preserve explicit newlines and the original trailing punctuation.
            If a message to translate ends with a punctuation mark, its translation
            should end with the corresponding punctuation mark in the target language.
            If it doesn't end with any punctuation mark, neither should its translation.
            When in doubt, try to follow the Material Design Style guide, but generally,
            you should aim to copy the style used in the original message.
            
            Don't translate the following terms: `Wine Bar`, `winetricks`.

            Don't use the term `Windows` in the translation unless the source message
            uses it.
            
            Keep the ARB placeholders intact and respect the syntax of ICU plurals,
            gender and select expressions.
            
            The term `Wine prefix` may be hard to translate. When in doubt,
            transliterate `prefix` and either keep intact or transliterate  `Wine`.
            Sometimes the app mentions just `prefix` while meaning `Wine prefix`.
            """
        )

    def update_translation_destination(self):
        for message_id in self.translation_source.json.keys():
            if message_id.startswith("@"):
                # Skip metadata records.
                continue

            self._process_message(message_id=message_id)

        # Process the remaining messages.
        self._process_accumulated_machine_translation_batch()

        print(
            f"[{self.dest_file_name}] Manual translations: {self.manual_translations_applied}, "
            f"up to date machine translations: {self.up_to_date_machine_translations}, "
            f"new machine translations: {self.new_machine_translations}"
        )

    def _process_message(self, *, message_id):
        source_message = self.translation_source.get_message(message_id=message_id)

        manually_translated_message = source_message.with_manual_translation(
            target_locale_name=self.translation_destination.locale_name
        )

        if manually_translated_message is not None:
            self.translation_destination.set_translated_message(
                manually_translated_message
            )
            self.manual_translations_applied += 1
            return

        if self.translation_destination.try_reusing_existing_translation(
            source_message=source_message
        ):
            self.up_to_date_machine_translations += 1
            return

        message_json = {}
        source_message.add_to_machine_translation_arb_fragment(message_json)
        message_json_symbols = len(json_to_string(message_json))

        if (
            self.approx_symbols_in_batch
            + message_json_symbols
            + len(self.system_prompt)
            > MAX_SYMBOLS_IN_BATCH
        ):
            # Adding this message to the current batch would
            # bring us over the MAX_SYMBOLS_IN_BATCH limit.
            # So, send the batch that we've got for translation
            # and then clear it.

            self._process_accumulated_machine_translation_batch()

        # Add the current message to the batch.
        self.message_batch_to_translate[message_id] = source_message
        self.approx_symbols_in_batch += message_json_symbols

    def _process_accumulated_machine_translation_batch(self):
        if len(self.message_batch_to_translate) == 0:
            # Nothing to translate
            return

        current_batch = self.message_batch_to_translate

        # Sometimes we split our batch into two. This is the 2nd half of it.
        backlog_batch = {}

        # In my experience, reducing the batch size does more for resolving validation
        # failures than raising the temperature.
        def maybe_split_current_batch():
            nonlocal current_batch, backlog_batch
            if len(current_batch) > 1:
                print(f"[{self.dest_file_name}] Splitting the current batch")

                items_to_keep = len(current_batch) // 2
                it = iter(current_batch.items())
                current_batch = dict(islice(it, items_to_keep))

                for key, val in it:
                    backlog_batch[key] = val

        # We start with a temperature of 0 for determinism,
        # but raise it on retries.
        temperatures_by_attempt = [0.0, 0.6, 0.8]

        attempt = -1
        while True:
            attempt += 1

            if len(current_batch) == 0:
                if len(backlog_batch) == 0:
                    # Cleanup and return
                    self.message_batch_to_translate = {}
                    self.approx_symbols_in_batch = 0
                    return
                else:
                    current_batch = backlog_batch
                    backlog_batch = {}

                    # Make proceeding to the backlog after successfully processing
                    # the current_batch not count towards the retry attempts.
                    attempt -= 1

            if attempt >= len(temperatures_by_attempt):
                # We get here when we've exceeded the maximum number of attempts.
                print(
                    f"[{self.dest_file_name}] Still failing after {len(temperatures_by_attempt)} "
                    "attempts. Giving up."
                )
                sys.exit(1)

            temperature = temperatures_by_attempt[attempt]

            arb_fragment_json = {}
            for message in current_batch.values():
                message.add_to_machine_translation_arb_fragment(arb_fragment_json)

            arb_fragment_as_string = json_to_string(arb_fragment_json)

            if attempt > 0:
                print(
                    f"[{self.dest_file_name}] [Retry] Translating a batch of "
                    f"{len(current_batch)} messages (temperature = {temperature})"
                )
            else:
                print(
                    f"[{self.dest_file_name}] Translating a batch of {len(current_batch)} "
                    "messages"
                )

            resp = openai.chat.completions.create(
                model=model_name,
                messages=[
                    {
                        "role": "system",
                        "content": self.system_prompt,
                    },
                    {"role": "user", "content": arb_fragment_as_string},
                ],
                temperature=temperature,
            )

            translated_json_text = resp.choices[0].message.content

            try:
                translated_arb_fragment = json.loads(translated_json_text)
            except json.JSONDecodeError:
                print(f"[{self.dest_file_name}] Invalid JSON was produced by the AI")
                maybe_split_current_batch()
                continue

            had_validation_failures = False

            # Build and validate each translated message.
            # Because we modify current_batch as we go, we have to iterate over a copy of it.
            for message_id, source_message in dict(current_batch).items():
                if message_id.startswith("@"):
                    # Skip metadata records.
                    continue

                try:
                    translated_message = (
                        source_message.with_validated_machine_translation(
                            translated_arb_fragment=translated_arb_fragment
                        )
                    )

                    self.translation_destination.set_translated_message(
                        translated_message
                    )
                    self.new_machine_translations += 1

                    del current_batch[message_id]

                except TranslationValidationError as e:
                    print(
                        f"[{self.dest_file_name}] The machine translation of message "
                        f'"{message_id}" has failed validation (see below)'
                    )
                    print(f"[{self.dest_file_name}]   {e}")

                    had_validation_failures = True

            if had_validation_failures and len(current_batch) > len(backlog_batch) * 2:
                maybe_split_current_batch()


if __name__ == "__main__":
    openai = OpenAI(
        base_url=endpoint,
        api_key=api_key,
    )

    print("Available LLM models:")
    for model in openai.models.list():
        print(model.id)
    print("")

    script_dir = Path(__file__).resolve().parent
    l10n_dir = script_dir / ".." / "lib" / "l10n"

    translation_arb_files = [
        f for f in l10n_dir.glob("app_*.arb") if f.name != MASTER_ARB_FILE_NAME
    ]

    supported_translation_locale_names = {
        extract_locale_name(f) for f in translation_arb_files
    }

    translation_source_arb_file = l10n_dir / MASTER_ARB_FILE_NAME
    translation_source = TranslationSource(
        translation_source_arb_file,
        supported_locale_names=supported_translation_locale_names,
    )

    num_files_updated = 0

    for arb_file in translation_arb_files:
        translation_destination = TranslationDestination(arb_file)

        translation_updater = TranslationUpdater(
            translation_source=translation_source,
            translation_destination=translation_destination,
            openai=openai,
        )

        translation_updater.update_translation_destination()

        save_arb_file(arb_file, translation_destination.updated_json)

        num_files_updated += 1

    if num_files_updated == 0:
        print(
            f"No .arb files were found in lib/l10n except {MASTER_ARB_FILE_NAME}, "
            "so there are no languages to translate to."
        )
    else:
        print(f"[Success] Updated {num_files_updated} translation files")
        print(
            "The next step is to run `rps generate` to update the .dart "
            "localization files"
        )
