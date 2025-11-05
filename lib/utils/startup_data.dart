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
import 'package:winebar/exceptions/generic_exception.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/prefix_descriptor.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';

import '../exceptions/data_dir_not_recognized_exception.dart';
import '../models/wine_prefix.dart';
import 'app_info.dart';
import 'local_storage_paths.dart';
import 'settings_json_file.dart';

class StartupData {
  final LocalStoragePaths localStoragePaths;
  final List<WinePrefix> winePrefixes;
  final String logCapturingRunnerPath;
  final String runAndPinWin32LauncherPath;
  final WineProcessRunnerService wineProcessRunnerService;

  StartupData({
    required this.localStoragePaths,
    required this.winePrefixes,
    required this.logCapturingRunnerPath,
    required this.runAndPinWin32LauncherPath,
    required this.wineProcessRunnerService,
  });

  static Future<StartupData> load() async {
    final localStoragePaths = await LocalStoragePaths.get();
    final toplevelDataDirectory = Directory(localStoragePaths.toplevelDataDir);

    final pageSize = await _getPageSize();
    final muvmNeeded = pageSize != 4096;

    if (muvmNeeded) {
      if (!await _isMuvmAvailable()) {
        throw GenericException(
          'This system needs muvm / FEX to be able to run Windows apps. '
          'Please install it using "sudo dnf install muvm fex-emu" or similar',
        );
      }
    }

    if (await toplevelDataDirectory.exists()) {
      await _checkExistingOwnersJsonFile(localStoragePaths: localStoragePaths);
    } else {
      await toplevelDataDirectory.create();
      await _createNewSettingsJsonFile(localStoragePaths: localStoragePaths);
    }

    final tempDir = Directory(localStoragePaths.tempDir);
    await recursiveDeleteAndLogErrors(tempDir);
    await tempDir.create();

    await Directory(localStoragePaths.wineInstallsDir).create();
    await Directory(localStoragePaths.winePrefixesDir).create();

    final winePrefixes = await _loadWinePrefixes(
      localStoragePaths: localStoragePaths,
    );

    final wineProcessRunningService = WineProcessRunnerService(
      toplevelTempDir: localStoragePaths.tempDir,
      logCapturingRunnerPath: LocalStoragePaths.logCapturingRunnerPath,
      runWithMuvm: muvmNeeded,
    );

    return StartupData(
      localStoragePaths: localStoragePaths,
      winePrefixes: winePrefixes,
      logCapturingRunnerPath: LocalStoragePaths.logCapturingRunnerPath,
      runAndPinWin32LauncherPath: LocalStoragePaths.runAndPinWin32LauncherPath,
      wineProcessRunnerService: wineProcessRunningService,
    );
  }

  static Future<int> _getPageSize() async {
    try {
      final processResult = await Process.run('getconf', ['PAGE_SIZE']);
      return int.parse(processResult.stdout);
    } catch (e, stackTrace) {
      final logger = GetIt.I.get<Logger>();
      logger.e(
        'Failed to get the page size using "getconf PAGE_SIZE"',
        error: e,
        stackTrace: stackTrace,
      );
      throw GenericException('Unable to get the page size: ${e.toString()}');
    }
  }

  static Future<bool> _isMuvmAvailable() async {
    try {
      final result = await Process.run('which', ['muvm']);
      return result.exitCode == 0;
    } catch (e, stackTrace) {
      // This is not normal. If muvm is not installed, 'which' should just
      // return a non-zero code.
      final logger = GetIt.I.get<Logger>();
      logger.w(
        'Runnining "which muvm" failed',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  static Future<void> _checkExistingOwnersJsonFile({
    required LocalStoragePaths localStoragePaths,
  }) async {
    final settingsJsonFile = File(localStoragePaths.settingsJsonFilePath);

    try {
      final fileAsString = await settingsJsonFile.readAsString();
      final fileData = SettingsJsonFile.fromJsonString(fileAsString);

      if (fileData.appPackageId != AppInfo.appPackageId) {
        throw DataDirNotRecognizedException(localStoragePaths.toplevelDataDir);
      }
    } catch (e) {
      throw DataDirNotRecognizedException(localStoragePaths.toplevelDataDir);
    }
  }

  static Future<void> _createNewSettingsJsonFile({
    required LocalStoragePaths localStoragePaths,
  }) async {
    final fileData = SettingsJsonFile(appPackageId: AppInfo.appPackageId);

    final settingsJsonFile = File(localStoragePaths.settingsJsonFilePath);
    await settingsJsonFile.writeAsString(fileData.toJsonString());
  }

  static Future<List<WinePrefix>> _loadWinePrefixes({
    required LocalStoragePaths localStoragePaths,
  }) async {
    final winePrefixes = <WinePrefix>[];

    final winePrefixesDir = Directory(localStoragePaths.winePrefixesDir);

    // Does nothing if the directory exists already.
    await winePrefixesDir.create();

    await for (final entity in winePrefixesDir.list()) {
      if (entity is Directory) {
        await _loadWinePrefixFromOuterDir(
          winePrefixOuterDir: entity,
          sink: winePrefixes,
        );
      }
    }

    return winePrefixes;
  }

  static Future<void> _loadWinePrefixFromOuterDir({
    required Directory winePrefixOuterDir,
    required List<WinePrefix> sink,
  }) async {
    final prefixDirStructure = WinePrefixDirStructure.fromOuterDir(
      winePrefixOuterDir.path,
    );

    try {
      final prefixJsonFileContents = await File(
        prefixDirStructure.prefixJsonFilePath,
      ).readAsString();

      final prefixDescriptor = PrefixDescriptor.fromJsonString(
        prefixJsonFileContents,
      );

      final prefix = WinePrefix(
        dirStructure: prefixDirStructure,
        descriptor: prefixDescriptor,
      );

      sink.add(prefix);
    } catch (e, stackTrace) {
      final logger = GetIt.I.get<Logger>();
      logger.w(
        'Found a broken wine prefix at "${winePrefixOuterDir.path}',
        error: e,
        stackTrace: stackTrace,
      );

      // We add broken prefixes to the list anyway, to give the user the opportunity
      // to delete them manually.
      sink.add(WinePrefix.broken(outerDir: winePrefixOuterDir.path));
    }
  }
}
