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
import 'dart:math';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/process_log.dart';
import 'package:winebar/utils/log_accessor.dart';

class SizeLimitedInMemoryLog implements ProcessLogAccessor {
  final String logName;
  final _HeadBuffer _headBuffer;
  late final _TailBuffer _tailBuffer;

  SizeLimitedInMemoryLog({
    required this.logName,
    required Stream<List<int>> byteStream,
    int headSegmentMaxSize = 8192,
    int tailSegmentMaxSize = 8192,
  }) : _headBuffer = _HeadBuffer(capacity: headSegmentMaxSize) {
    _tailBuffer = _TailBuffer(
      capacity: tailSegmentMaxSize,
      onChunkDiscarded: _headBuffer.processDataChunk,
    );

    byteStream.listen(
      _processDataChunk,
      onError: _logError,
      cancelOnError: true,
    );
  }

  @override
  Future<ProcessLog?> tryRetrieveLog() async {
    if (_headBuffer.bufferedDataSize + _tailBuffer.bufferedDataSize == 0) {
      return null;
    }

    String content;

    if (_headBuffer.discardedDataSize == 0) {
      content = utf8.decode(
        _headBuffer.bufferedData + _tailBuffer.bufferedData,
        allowMalformed: true,
      );
    } else {
      final headSection = utf8.decode(
        _headBuffer.bufferedData,
        allowMalformed: true,
      );

      final cutSection =
          "\n\n------------------- cut ----------------------\n\n";

      final tailSection = utf8.decode(
        _tailBuffer.bufferedData,
        allowMalformed: true,
      );

      content = "$headSection$cutSection$tailSection";
    }

    return ProcessLog(name: logName, content: content);
  }

  void _processDataChunk(List<int> chunk) {
    _tailBuffer.processDataChunk(Uint8List.fromList(chunk));
  }

  void _logError(Object error, StackTrace stackTrace) {
    GetIt.I.get<Logger>().e(
      'Error reading log "$logName"',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// A buffer that keeps the first N bytes written to it.
class _HeadBuffer {
  final Uint8List _buffer;
  int _dataEndPos = 0;
  int _discardedBytes = 0;

  _HeadBuffer({required int capacity}) : _buffer = Uint8List(capacity);

  int get discardedDataSize => _discardedBytes;

  int get bufferedDataSize => _dataEndPos;

  Uint8List get bufferedData {
    return _buffer.sublist(0, _dataEndPos);
  }

  void processDataChunk(Uint8List chunk) {
    final bytesToWrite = min(_buffer.length - _dataEndPos, chunk.length);

    _buffer.setRange(_dataEndPos, _dataEndPos + bytesToWrite, chunk);
    _dataEndPos += bytesToWrite;
    _discardedBytes += chunk.length - bytesToWrite;
  }
}

/// A buffer that keeps the last N bytes written to it.
class _TailBuffer {
  final void Function(Uint8List chunk) onChunkDiscarded;

  /// This buffer is a ring buffer, so the following situation is possible:
  /// _dataBeginPos + _dataSize > _buffer.length is possible.
  final Uint8List _buffer;
  int _dataBeginPos = 0;
  int _dataSize = 0;

  _TailBuffer({required int capacity, required this.onChunkDiscarded})
    : _buffer = Uint8List(capacity);

  int get bufferedDataSize => _dataSize;

  Uint8List get bufferedData {
    if (_dataBeginPos + _dataSize <= _buffer.length) {
      return _buffer.sublist(_dataBeginPos, _dataBeginPos + _dataSize);
    } else {
      return Uint8List.fromList(
        _buffer.sublist(_dataBeginPos) +
            _buffer.sublist(0, _dataBeginPos + _dataSize - _buffer.length),
      );
    }
  }

  void processDataChunk(Uint8List chunk) {
    // First, we calculate how much of the existing data will be overwritten.
    final maxBytesToPreserve = max(0, _buffer.length - chunk.length);
    int remainingBytesToDiscard = max(0, _dataSize - maxBytesToPreserve);

    if (remainingBytesToDiscard > 0) {
      // Discard some bytes starting from _dataBeginOffset.
      final bytesToDiscard = min(
        remainingBytesToDiscard,
        _buffer.length - _dataBeginPos,
      );

      onChunkDiscarded(
        _buffer.sublist(_dataBeginPos, _dataBeginPos + bytesToDiscard),
      );

      _dataBeginPos += bytesToDiscard;
      _dataBeginPos %= _buffer.length;
      _dataSize -= bytesToDiscard;
      remainingBytesToDiscard -= bytesToDiscard;
    }

    if (remainingBytesToDiscard > 0) {
      // Discard some bytes starting from the beginning of the buffer.
      final bytesToDiscard = min(remainingBytesToDiscard, _buffer.length);
      onChunkDiscarded(_buffer.sublist(0, bytesToDiscard));
      _dataBeginPos = bytesToDiscard % _buffer.length;
      _dataSize -= bytesToDiscard;
      remainingBytesToDiscard -= bytesToDiscard;
    }

    assert(remainingBytesToDiscard == 0);

    int chunkOffset = 0;
    int chunkBytesRemaining = chunk.length;

    if (chunkBytesRemaining > _buffer.length) {
      // Discard some bytes from the chunk itself.
      final bytesToDiscard = chunkBytesRemaining - _buffer.length;
      onChunkDiscarded(chunk.sublist(chunkOffset, bytesToDiscard));
      chunkOffset += bytesToDiscard;
      chunkBytesRemaining -= bytesToDiscard;
    }

    if (chunkBytesRemaining > 0) {
      // Add some bytes starting from _dataBeginPos + _dataSize.
      final bytesToAdd = min(
        chunkBytesRemaining,
        _buffer.length - (_dataBeginPos + _dataSize),
      );

      _buffer.setRange(
        _dataBeginPos + _dataSize,
        _dataBeginPos + _dataSize + bytesToAdd,
        chunk,
        chunkOffset,
      );

      _dataSize += bytesToAdd;
      chunkOffset += bytesToAdd;
      chunkBytesRemaining -= bytesToAdd;
    }

    if (chunkBytesRemaining > 0) {
      // Add some bytes starting from the beginning of the buffer.
      final bytesToAdd = min(chunkBytesRemaining, _buffer.length);
      _buffer.setRange(0, bytesToAdd, chunk, chunkOffset);
      _dataSize += bytesToAdd;
      chunkOffset += bytesToAdd;
      chunkBytesRemaining -= bytesToAdd;
    }

    assert(chunkBytesRemaining == 0);
  }
}
