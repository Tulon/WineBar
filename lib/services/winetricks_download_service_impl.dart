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

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:posix/posix.dart';
import 'package:winebar/exceptions/generic_exception.dart';

import '../utils/app_info.dart';
import '../utils/compute_digest_of_file_contents.dart';
import 'winetricks_download_service.dart';

class WinetricksDownloadServiceImpl implements WinetricksDownloadService {
  final logger = GetIt.I.get<Logger>();
  final Dio dio;
  Completer<String>? preparationAttemptCompleter;
  String? preparedWinetricksScriptPath;

  WinetricksDownloadServiceImpl({required this.dio});

  @override
  Future<String> prepareWinetricksScript({bool forceRetry = false}) async {
    if (preparedWinetricksScriptPath != null) {
      return preparedWinetricksScriptPath!;
    }

    if (preparationAttemptCompleter == null ||
        (preparationAttemptCompleter!.isCompleted && forceRetry)) {
      preparationAttemptCompleter = Completer<String>();

      try {
        final scriptPath = await _verifyExistingOrDownloadNewWinetricksScript();
        preparedWinetricksScriptPath = scriptPath;
        preparationAttemptCompleter!.complete(scriptPath);
      } catch (e, stackTrace) {
        preparationAttemptCompleter!.completeError(e, stackTrace);
      }
    }

    return preparationAttemptCompleter!.future;
  }

  Future<String> _verifyExistingOrDownloadNewWinetricksScript() async {
    final hash = sha256;
    final supportDir = await getApplicationSupportDirectory();

    final installedWinetricksFile = File(
      path.join(supportDir.path, 'winetricks'),
    );

    final expectedWinetricksFileDigest = Digest(
      hex.decode(AppInfo.winetricksSha256),
    );

    try {
      final winetricksFileDigest = await computeDigestOfFileContents(
        filePath: installedWinetricksFile.path,
        hash: hash,
      );

      if (winetricksFileDigest == expectedWinetricksFileDigest) {
        // The file is there and the digest matches. Let's just make it
        // executable (just in case it's not), and we are done.
        return _makeExecutableAndReturn(installedWinetricksFile.path);
      }
    } catch (e, stackTrace) {
      logger.i(
        'Failed to compute a SHA256 hash from ${installedWinetricksFile.path}',
        error: e,
        stackTrace: stackTrace,
      );
    }

    final downloadStream = await _initiateDownload();

    try {
      final winetricksFileDigest = await _saveDownloadAndComputeHash(
        destinationFile: installedWinetricksFile,
        downloadStream: downloadStream,
        hash: hash,
      );

      if (winetricksFileDigest == expectedWinetricksFileDigest) {
        // The file is there and the digest matches. Let's just make it
        // executable (just in case it's not), and we are done.
        return _makeExecutableAndReturn(installedWinetricksFile.path);
      } else {
        throw GenericException(
          "The hash of the downloaded winescript script doesn't match the expected one.\n"
          "Downloaded file: ${installedWinetricksFile.path}\n"
          "Expected SHA256 hash: ${expectedWinetricksFileDigest.toString()}\n"
          "Actual SHA256 hash:   ${winetricksFileDigest.toString()}",
        );
      }
    } catch (e) {
      // Actually, not deleting the downloaded script helps to debug the problem.
      // It's not like we are going to actually launch it.
      // await recursiveDeleteAndLogErrors(installedWinetricksFile);
      rethrow;
    }
  }

  Future<Stream<List<int>>> _initiateDownload() async {
    final String repoOwnerEncoded = Uri.encodeComponent(
      AppInfo.winetricksGithubRepoOwner,
    );

    final String repoNameEncoded = Uri.encodeComponent(
      AppInfo.winetricksGithubRepoName,
    );

    final String tagEncoded = Uri.encodeComponent(AppInfo.winetricksGitTag);

    final url =
        'https://api.github.com/repos/$repoOwnerEncoded/'
        '$repoNameEncoded/contents/src/winetricks?ref=$tagEncoded';

    final headers = <String, String>{
      'Accept': 'application/vnd.github.raw+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };

    final downloadProcess = await dio.getUri(
      Uri.parse(url),
      options: Options(responseType: ResponseType.stream, headers: headers),
    );

    return downloadProcess.data.stream;
  }

  Future<Digest> _saveDownloadAndComputeHash({
    required File destinationFile,
    required Stream<List<int>> downloadStream,
    required Hash hash,
  }) async {
    final fileSink = destinationFile.openWrite(mode: FileMode.writeOnly);

    try {
      final digestSink = AccumulatorSink<Digest>();
      final hasherInput = hash.startChunkedConversion(digestSink);

      await for (final chunk in downloadStream) {
        fileSink.add(chunk);
        hasherInput.add(chunk);
      }

      hasherInput.close();
      return digestSink.events.single;
    } finally {
      await fileSink.close();
    }
  }

  String _makeExecutableAndReturn(String filePath) {
    chmod(filePath, '755');
    return filePath;
  }
}
