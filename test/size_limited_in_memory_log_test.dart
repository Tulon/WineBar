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

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:winebar/utils/size_limited_in_memory_log.dart';

Uint8List _getReferenceData(int size) {
  final data = Uint8List(size);
  for (int i = 0; i < size; ++i) {
    data[i] = i & 0x7f;
  }
  return data;
}

void main() {
  test('No data in results in a null log', () async {
    final controller = StreamController<List<int>>();
    final logAccessor = SizeLimitedInMemoryLog(
      logName: 'test',
      byteStream: controller.stream,
    );

    await controller.close();

    final log = await logAccessor.tryRetrieveLog();

    expect(log, null);
  });

  test('Adding data that fits exactly', () async {
    const headBufferCapacity = 40;
    const tailBufferCapacity = 60;
    const chunkSize = 100;
    final referenceData = _getReferenceData(256);

    final controller = StreamController<List<int>>();
    final logAccessor = SizeLimitedInMemoryLog(
      logName: 'test',
      byteStream: controller.stream,
      headSegmentMaxSize: headBufferCapacity,
      tailSegmentMaxSize: tailBufferCapacity,
    );

    controller.add(referenceData.sublist(0, chunkSize));
    await controller.close();

    final log = await logAccessor.tryRetrieveLog();

    expect(log?.content, utf8.decode(referenceData.sublist(0, chunkSize)));
  });

  test('Adding data that leaves space in tail buffer', () async {
    const headBufferCapacity = 40;
    const tailBufferCapacity = 60;
    const chunkSize = 30;
    final referenceData = _getReferenceData(256);

    final controller = StreamController<List<int>>();
    final logAccessor = SizeLimitedInMemoryLog(
      logName: 'test',
      byteStream: controller.stream,
      headSegmentMaxSize: headBufferCapacity,
      tailSegmentMaxSize: tailBufferCapacity,
    );

    controller.add(referenceData.sublist(0, chunkSize));
    await controller.close();

    final log = await logAccessor.tryRetrieveLog();

    expect(log?.content, utf8.decode(referenceData.sublist(0, chunkSize)));
  });

  test('Adding data that leaves space in head buffer', () async {
    const headBufferCapacity = 40;
    const tailBufferCapacity = 60;
    const chunkSize = 80;
    final referenceData = _getReferenceData(256);

    final controller = StreamController<List<int>>();
    final logAccessor = SizeLimitedInMemoryLog(
      logName: 'test',
      byteStream: controller.stream,
      headSegmentMaxSize: headBufferCapacity,
      tailSegmentMaxSize: tailBufferCapacity,
    );

    controller.add(referenceData.sublist(0, chunkSize));
    await controller.close();

    final log = await logAccessor.tryRetrieveLog();

    expect(log?.content, utf8.decode(referenceData.sublist(0, chunkSize)));
  });

  test("Adding data that doesn't fit", () async {
    const headBufferCapacity = 40;
    const tailBufferCapacity = 60;
    const chunkSize = 120;
    final referenceData = _getReferenceData(256);

    final controller = StreamController<List<int>>();
    final logAccessor = SizeLimitedInMemoryLog(
      logName: 'test',
      byteStream: controller.stream,
      headSegmentMaxSize: headBufferCapacity,
      tailSegmentMaxSize: tailBufferCapacity,
    );

    controller.add(referenceData.sublist(0, chunkSize));

    await controller.close();

    final log = await logAccessor.tryRetrieveLog();

    expect(
      log?.content.substring(0, headBufferCapacity),
      utf8.decode(referenceData.sublist(0, headBufferCapacity)),
    );

    expect(
      log?.content.substring(log.content.length - tailBufferCapacity),
      utf8.decode(
        referenceData.sublist(chunkSize - tailBufferCapacity, chunkSize),
      ),
    );

    expect(log?.content.contains("--- cut ---"), true);
  });

  test("Adding data that fits exactly in small chunks", () async {
    const headBufferCapacity = 40;
    const tailBufferCapacity = 60;
    const chunkSize = 50;
    const numChunks = 2;
    final referenceData = _getReferenceData(256);

    final controller = StreamController<List<int>>();
    final logAccessor = SizeLimitedInMemoryLog(
      logName: 'test',
      byteStream: controller.stream,
      headSegmentMaxSize: headBufferCapacity,
      tailSegmentMaxSize: tailBufferCapacity,
    );

    for (int i = 0; i < numChunks; ++i) {
      controller.add(referenceData.sublist(i * chunkSize, (i + 1) * chunkSize));
    }

    await controller.close();

    final log = await logAccessor.tryRetrieveLog();

    expect(
      log?.content,
      utf8.decode(referenceData.sublist(0, chunkSize * numChunks)),
    );
  });

  test("Adding data that doesn't fit in small chunks that fit", () async {
    const headBufferCapacity = 40;
    const tailBufferCapacity = 60;
    const chunkSize = 50;
    const numChunks = 3;
    final referenceData = _getReferenceData(256);

    final controller = StreamController<List<int>>();
    final logAccessor = SizeLimitedInMemoryLog(
      logName: 'test',
      byteStream: controller.stream,
      headSegmentMaxSize: headBufferCapacity,
      tailSegmentMaxSize: tailBufferCapacity,
    );

    for (int i = 0; i < numChunks; ++i) {
      controller.add(referenceData.sublist(i * chunkSize, (i + 1) * chunkSize));
    }

    await controller.close();

    final log = await logAccessor.tryRetrieveLog();

    expect(
      log?.content.substring(0, headBufferCapacity),
      utf8.decode(referenceData.sublist(0, headBufferCapacity)),
    );

    expect(
      log?.content.substring(log.content.length - tailBufferCapacity),
      utf8.decode(
        referenceData.sublist(
          chunkSize * numChunks - tailBufferCapacity,
          chunkSize * numChunks,
        ),
      ),
    );

    expect(log?.content.contains("--- cut ---"), true);
  });
}
