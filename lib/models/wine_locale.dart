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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class WineLocale extends Equatable {
  /// The POSIX locale name. Example: "de_CH" where "de" is the language
  /// and "CH" is the country.
  final String posixName;

  /// The human-friendly locale's name, in its own language.
  /// This field may be null if unknown.
  final String? localizedDisplayName;
  final String? lowerCaseLocalizedDisplayName;

  /// The human-friendly locale's name, in English.
  /// This field may be null if unknown.
  final String? englishDisplayName;
  final String? lowerCaseEnglishDisplayName;

  WineLocale({
    required this.posixName,
    required this.localizedDisplayName,
    required this.englishDisplayName,
  }) : lowerCaseLocalizedDisplayName = localizedDisplayName?.toLowerCase(),
       lowerCaseEnglishDisplayName = englishDisplayName?.toLowerCase();

  /// Note that [posixName] uniquely identifies the locale.
  @override
  List<Object?> get props => [posixName];

  bool matchesLowerCaseSearchString(String lowerCaseSearchString) {
    return lowerCaseEnglishDisplayName?.contains(lowerCaseSearchString) ==
            true ||
        lowerCaseLocalizedDisplayName?.contains(lowerCaseSearchString) == true;
  }

  /// Returns the string that's presented to the user as the locale's name.
  String get displayString {
    // The reason we don't include the native name is that Flutter simply
    // can't display all such names (fonts missing glyphs for rare scripts).
    return englishDisplayName ?? posixName;
  }

  static Future<List<WineLocale>> loadLocaleList() async {
    final locales = <WineLocale>[];

    final jsonString = await rootBundle.loadString('data/locales.json');
    final data = jsonDecode(jsonString);
    if (data is! List) {
      GetIt.I.get<Logger>().e(
        'Failed reading locales.json',
        error: 'Top-level element was not a list',
      );
      return locales;
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

    return locales;
  }
}
