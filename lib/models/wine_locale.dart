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

import 'package:equatable/equatable.dart';

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
    if (lowerCaseSearchString.isEmpty) {
      return true;
    }

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
}
