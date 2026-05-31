/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025-2026 Josif Arcimovic
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:language_code/language_code.dart';
import 'package:winebar/l10n/app_localizations.dart';

class LocaleSelectionButton extends StatefulWidget {
  final void Function(Locale) onLocaleSelected;
  const LocaleSelectionButton({super.key, required this.onLocaleSelected});

  @override
  State<LocaleSelectionButton> createState() => _LocaleSelectionButtonState();
}

class _LocaleSelectionButtonState extends State<LocaleSelectionButton> {
  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      builder: (BuildContext context, SearchController controller) {
        return IconButton(
          icon: const Icon(Icons.translate),
          onPressed: () {
            controller.openView();
          },
        );
      },
      viewBuilder: (suggestions) {
        final suggestionsList = suggestions.toList();
        return ListView.separated(
          itemCount: suggestions.length,
          itemBuilder: (context, index) => suggestionsList[index],
          separatorBuilder: (context, index) => const Divider(),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final lowerCaseSearchString = controller.text.toLowerCase();

        return _buildOrderedLanguageCodes()
            .where((lang) {
              return lang.englishName.toLowerCase().contains(
                    lowerCaseSearchString,
                  ) ||
                  lang.nativeName.toLowerCase().contains(lowerCaseSearchString);
            })
            .map((lang) {
              return ListTile(
                title: Text(lang.nativeName),
                subtitle: lang.englishName == lang.nativeName
                    ? null
                    : Text(lang.englishName),
                onTap: () {
                  setState(() {
                    controller.closeView(lang.nativeName);
                    widget.onLocaleSelected(lang.locale);
                  });
                },
              );
            });
      },
    );
  }

  Iterable<LanguageCodes> _buildOrderedLanguageCodes() sync* {
    /// The preferred locales we want to put at the top of the list.
    final preferredLocales = WidgetsBinding.instance.platformDispatcher.locales
        // It's OK if this creates a duplicate element.
        .followedBy([Locale('en')]);

    final remainingLanguageCandidates = _RemainingLanguageCandidates();

    for (final preferredLocale in preferredLocales) {
      yield* remainingLanguageCandidates.retrieveMatchingLanguages(
        locale: preferredLocale,
      );
    }

    yield* remainingLanguageCandidates.retrieveRemaining();
  }
}

class _RemainingLanguageCandidates {
  static final _orderedLanguageCodesByLocaleName =
      _buildOrderedLanguageCodesByLocaleName();

  final _remainingLanguagesByLocaleName =
      LinkedHashMap<String, LanguageCodes>.of(
        _orderedLanguageCodesByLocaleName,
      );

  Iterable<LanguageCodes> retrieveMatchingLanguages({
    required Locale locale,
  }) sync* {
    final lang = _tryRetrieveMatchingLanguage(localeName: locale.toString());
    if (lang != null) {
      yield lang;
    }

    // We could have tried inexact matches as well, but there is no need,
    // as PlatformDispatchers.locales already contains various candidates
    // for us to try. For instance, when the system locale is set to
    // Brasilian Portugese, PlatformDispatchers.locales will have both
    // 'pt_BR' and 'pt' locales (in that order).
  }

  Iterable<LanguageCodes> retrieveRemaining() sync* {
    for (final lang in _remainingLanguagesByLocaleName.values) {
      yield lang;
    }

    _remainingLanguagesByLocaleName.clear();
  }

  LanguageCodes? _tryRetrieveMatchingLanguage({required String localeName}) {
    final lang = _remainingLanguagesByLocaleName[localeName];
    if (lang != null) {
      _remainingLanguagesByLocaleName.remove(localeName);
      return lang;
    }
    return null;
  }

  static Map<String, LanguageCodes> _buildOrderedLanguageCodesByLocaleName() {
    // The reason we exclude the `zh` locale is that we also have `zh_Hans`
    // (Simplified Chinese) and `zh_Hant` (Traditional Chinese). The reason
    // we even have the generic `zh` variant is because Flutter's
    // localization system doesn't allow us to have `lang_{something}`
    // without having `lang` as well.
    final localeNamesToExclude = <String>{'zh'};

    final entryList = AppLocalizations.supportedLocales
        .where((loc) => !localeNamesToExclude.contains(loc.toString()))
        .map(
          (loc) => MapEntry<String, LanguageCodes>(
            loc.toString(),
            LanguageCodes.fromLocale(loc),
          ),
        )
        .toList();

    entryList.sort((a, b) => _compareLanguageCodes(a.value, b.value));

    return LinkedHashMap.fromEntries(entryList);
  }
}

int _compareLanguageCodes(LanguageCodes a, LanguageCodes b) {
  return a.nativeName.toLowerCase().compareTo(b.nativeName.toLowerCase());
}
