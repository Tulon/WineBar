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

/// Returns null if [prefixName] is valid and an error message otherwise.
String? validatePrefixName(String prefixName) {
  if (prefixName.isEmpty) {
    return "Prefix name can't be empty";
  } else if (!_validPrefixPattern.hasMatch(prefixName) ||
      prefixName.contains('/') ||
      prefixName.contains('\\')) {
    return 'Illegal symbols present';
  } else {
    // Prefix name valid.
    return null;
  }
}

final _validPrefixPattern = RegExp(
  r'^[\p{Letter}\p{Mark}\p{Number}\p{Punctuation} ]+$',
  unicode: true,
);
