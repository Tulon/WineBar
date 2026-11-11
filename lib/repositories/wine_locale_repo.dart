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

import 'package:language_code/language_code.dart';
import 'package:winebar/models/wine_locale.dart';

abstract interface class WineLocaleRepo {
  static WineLocaleRepo load() {
    final locales = <WineLocale>[];
    final posixNamesToSuppress = <String>{};

    // The LanguageCodes enum also lists the 3-letter locales,
    // which we don't want.
    final posixNamePattern = RegExp(r'^(\w\w)(_|$)');

    for (final langCode in LanguageCodes.values) {
      final match = posixNamePattern.firstMatch(langCode.code);
      if (match != null) {
        if (match.group(1)!.isNotEmpty) {
          // Since we've found a locale containing a country code, we suppress
          // the locale with the same language code but without a country code.
          // The reason we do is that that we can't add the encoding to locale
          // names consisting of just the language code. At least, Wine doesn't
          // understand it when it's present. Adding the encoding fixes the
          // input of international text in non-Unicode Windows apps, so by
          // suppressing those language-code-only locales, we are trying to
          // prevent the user from making a selection that will result in them
          // not being able to enter international text.
          posixNamesToSuppress.add(match.group(0)!);
        }

        locales.add(
          WineLocale(
            posixName: langCode.code,
            localizedDisplayName: langCode.nativeName,
            englishDisplayName: langCode.englishName,
          ),
        );
      }
    }

    return _WineLocaleRepo(
      locales
          .where(
            (locale) =>
                posixNamesToSuppress.contains(locale.posixName) == false,
          )
          .toList(),
    );
  }

  Iterable<WineLocale> get localesOrderedByDisplayString;

  WineLocale? tryFind({required String? posixName});
}

class _WineLocaleRepo implements WineLocaleRepo {
  /// This map is indexed by [WineLocale.posixName] and ordered by [WineLocale.displayString]
  final LinkedHashMap<String, WineLocale> locales =
      LinkedHashMap<String, WineLocale>();

  _WineLocaleRepo(List<WineLocale> locales) {
    locales.sort((a, b) => a.displayString.compareTo(b.displayString));

    for (final locale in locales) {
      this.locales[locale.posixName] = locale;
    }
  }

  @override
  Iterable<WineLocale> get localesOrderedByDisplayString => locales.values;

  @override
  WineLocale? tryFind({required String? posixName}) => locales[posixName];
}
