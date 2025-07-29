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

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

/// Deletes a file or a directory with all its contents.
/// Does nothing if [fsEntity] doesn't exist.
/// Errors are logged but otherwise ignored.
Future<void> recursiveDeleteAndLogErrors(FileSystemEntity fsEntity) async {
  try {
    await fsEntity.delete(recursive: true);
  } catch (e, stackTrace) {
    final logger = GetIt.I.get<Logger>();
    logger.e(
      'Failed to remove ${fsEntity.path}',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
