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

import '../models/archive_type.dart';

abstract interface class DownloadAndExtractionService {
  Future<DownloadAndExtractionProcess> startDownloadAndExtractionProcess({
    required Uri archiveUri,
    required ArchiveType archiveType,
    required String extractionDir,
    DownloadAndExtractionProgressCallback? progressCallback,
  });
}

typedef DownloadAndExtractionProgressCallback =
    void Function(int bytesDownloaded, int? bytesTotal);

/// Note that there is no failure case here. That's because failures
/// are communicated as completions with error via
/// DownloadAndExtractionProcess.completionFuture.
enum DownloadAndExtractionOutcome { succeeded, cancelled }

abstract interface class DownloadAndExtractionProcess {
  Future<DownloadAndExtractionOutcome> get completionFuture;

  /// Cancels the download and extraction process. Calling this method
  /// results in completionFuture being completed with
  /// DownloadAndExtractionOutcome.cancelled, unless the download and
  /// extraction process has already completed by the time cancel()
  /// was called.
  void cancel();
}
