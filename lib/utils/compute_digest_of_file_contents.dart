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

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

Future<Digest> computeDigestOfFileContents({
  required String filePath,
  required Hash hash,
}) async {
  final file = File(filePath);
  final fileStream = file.openRead();

  final digestSink = AccumulatorSink<Digest>();
  final hasherInput = hash.startChunkedConversion(digestSink);

  await for (final chunk in fileStream) {
    hasherInput.add(chunk);
  }

  hasherInput.close();

  return digestSink.events.single;
}
