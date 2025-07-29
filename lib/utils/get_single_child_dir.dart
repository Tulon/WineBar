/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025 Josif Arcimovic
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

import 'dart:io';

/// Checks if a given directory contains a single entity and that entity
/// is also a directory. If so, returns that child directory. Otherwise,
/// returns null.
Future<Directory?> getSingleChildDir(Directory dir) async {
  Directory? candidate;

  await for (final entity in dir.list()) {
    if (entity is Directory) {
      if (candidate == null) {
        candidate = entity;
      } else {
        // Have more than one child directory.
        return null;
      }
    } else {
      // Have a child that's not a directory.
      return null;
    }
  }

  return candidate;
}
