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
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/wine_locale.dart';

abstract interface class WineLocaleRepo {
  static Future<WineLocaleRepo> loadFromBundle(AssetBundle bundle) {
    return _WineLocaleRepo.loadFromBundle(bundle);
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

  static Future<WineLocaleRepo> loadFromBundle(AssetBundle bundle) async {
    final locales = <WineLocale>[];

    final jsonString = await bundle.loadString('data/locales.json');
    final data = jsonDecode(jsonString);
    if (data is! List) {
      GetIt.I.get<Logger>().e(
        'Failed reading locales.json',
        error: 'Top-level element was not a list',
      );
      return _WineLocaleRepo(locales);
    }

    int skippedEntries = 0;

    for (final entry in data) {
      try {
        locales.add(
          WineLocale(
            posixName: entry[0] as String,
            localizedDisplayName: entry[1] as String?,
            englishDisplayName: entry[2] as String?,
          ),
        );
      } catch (_) {
        ++skippedEntries;
        continue;
      }
    }

    if (skippedEntries > 0) {
      GetIt.I.get<Logger>().w(
        '$skippedEntries entries were skipped while parsing locales.json',
      );
    }

    return _WineLocaleRepo(locales);
  }
}
