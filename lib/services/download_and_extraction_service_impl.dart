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

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../exceptions/extraction_failed_exception.dart';
import '../models/archive_type.dart';
import 'download_and_extraction_service.dart';

class DownloadAndExtractionServiceImpl implements DownloadAndExtractionService {
  final Dio dio;

  DownloadAndExtractionServiceImpl({required this.dio});

  @override
  Future<DownloadAndExtractionProcess> startDownloadAndExtractionProcess({
    required Uri archiveUri,
    required ArchiveType archiveType,
    required String extractionDir,
    DownloadAndExtractionProgressCallback? progressCallback,
  }) async {
    final extractionProcess = await Process.start('tar', [
      archiveType.tarCompressionOption,
      '-xf',
      '-',
    ], workingDirectory: extractionDir);

    final downloadCancelToken = CancelToken();

    final downloadProcess = await dio.getUri(
      archiveUri,
      options: Options(responseType: ResponseType.stream),
      cancelToken: downloadCancelToken,
      onReceiveProgress: progressCallback == null
          ? null
          : (bytesReceived, bytesTotal) => progressCallback(
              bytesReceived,
              bytesTotal == -1 ? null : bytesTotal,
            ),
    );

    unawaited(extractionProcess.stdout.drain());
    unawaited(extractionProcess.stderr.drain());

    final downloadCompletionFuture = extractionProcess.stdin
        .addStream(downloadProcess.data.stream)
        .then((_) => extractionProcess.stdin.flush())
        .then((_) => extractionProcess.stdin.close());

    return _DownloadAndExtractionProcess(
      archiveUri: archiveUri,
      downloadProcess: downloadProcess,
      downloadCancelToken: downloadCancelToken,
      downloadCompletionFuture: downloadCompletionFuture,
      extractionProcess: extractionProcess,
    );
  }
}

class _DownloadAndExtractionProcess implements DownloadAndExtractionProcess {
  final logger = GetIt.I.get<Logger>();
  final Uri archiveUri;
  final Response downloadProcess;
  final CancelToken downloadCancelToken;
  final Process extractionProcess;
  bool cancelled = false;

  @override
  late final Future<DownloadAndExtractionOutcome> completionFuture;

  _DownloadAndExtractionProcess({
    required this.archiveUri,
    required this.downloadProcess,
    required this.downloadCancelToken,
    required Future downloadCompletionFuture,
    required this.extractionProcess,
  }) {
    completionFuture = (
      downloadCompletionFuture,
      extractionProcess.exitCode,
    ).wait.then(_handleNormalCompletion, onError: _handleErrorCompletion);
  }

  @override
  void cancel() {
    if (!cancelled) {
      cancelled = true;
      downloadCancelToken.cancel();
      extractionProcess.kill();
    }
  }

  DownloadAndExtractionOutcome _handleNormalCompletion(
    (dynamic, int exitCode) result,
  ) {
    if (cancelled) {
      return DownloadAndExtractionOutcome.cancelled;
    } else if (result.$2 != 0) {
      final errorMessage =
          'tar has exited with a non-zero exit code of ${result.$2}';
      logger.w('Decompression of $archiveUri failed:\n$errorMessage');
      throw ExtractionFailedException();
    } else {
      return DownloadAndExtractionOutcome.succeeded;
    }
  }

  DownloadAndExtractionOutcome _handleErrorCompletion(Object e) {
    if (cancelled) {
      return DownloadAndExtractionOutcome.cancelled;
    }

    final error = e as ParallelWaitError;

    if (error.errors.$1 != null) {
      final errorMessage = error.errors.$1.toString();
      logger.w('Downlod of $archiveUri failed:\n$errorMessage');
      throw error.errors.$1;
    } else if (error.errors.$2 != null) {
      final errorMessage = error.errors.$2.toString();
      logger.w('Decompression of $archiveUri failed:\n$errorMessage');
      throw error.errors.$2;
    } else {
      throw Exception('Uknown error');
    }
  }
}
