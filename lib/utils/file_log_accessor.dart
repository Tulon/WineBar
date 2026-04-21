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
import 'dart:io';
import 'dart:typed_data';

import 'package:winebar/models/process_log.dart';
import 'package:winebar/utils/log_accessor.dart';

class FileLogAccessor implements ProcessLogAccessor {
  final String logName;
  final String filePath;

  FileLogAccessor({required this.logName, required this.filePath});

  @override
  Future<ProcessLog?> tryRetrieveLog() async {
    final bytes = await File(
      filePath,
    ).readAsBytes().catchError((e) => Uint8List(0));

    return bytes.isEmpty
        ? null
        : ProcessLog(
            name: logName,
            content: utf8.decode(bytes, allowMalformed: true),
          );
  }
}
