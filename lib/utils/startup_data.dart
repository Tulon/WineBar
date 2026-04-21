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

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/exceptions/error_with_more_details_url.dart';
import 'package:winebar/exceptions/generic_exception.dart';
import 'package:winebar/models/prefix_descriptor.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/settings_file_helper.dart';

import '../exceptions/data_dir_not_recognized_exception.dart';
import '../models/settings_json_file.dart';
import '../models/wine_prefix.dart';
import 'app_info.dart';
import 'local_storage_paths.dart';

class StartupData {
  final LocalStoragePaths localStoragePaths;
  final List<WinePrefix> winePrefixes;
  final WineProcessRunnerService wineProcessRunnerService;
  final bool isIntelHost;
  final bool wineWillRunUnderMuvm;

  StartupData._({
    required this.localStoragePaths,
    required this.winePrefixes,
    required this.wineProcessRunnerService,
    required this.isIntelHost,
    required this.wineWillRunUnderMuvm,
  });

  static void asyncCreateAndRegisterInstance() {
    GetIt.I.registerSingletonAsync<StartupData>(_load);
  }

  static void registerMockInstance(StartupData instance) {
    GetIt.I.registerSingleton<StartupData>(instance);
  }

  static Future<StartupData> get asyncInstance {
    return GetIt.I.getAsync<StartupData>();
  }

  static StartupData get instance {
    return GetIt.I.get<StartupData>();
  }

  static Future<StartupData> _load() async {
    final localStoragePaths = LocalStoragePaths.get();
    final toplevelDataDirectory = Directory(localStoragePaths.toplevelDataDir);

    final pageSize = await _getPageSize();
    final archName = await _getArchNameFromUname();

    // See the list of possible strings returned from "uname -a":
    // https://stackoverflow.com/a/78630608
    final isIntelHost = archName.contains('86');

    final isNon4kPageSize = pageSize != 4096;

    final isSnapVersion = Platform.environment.containsKey('SNAP');

    // Q: Why are we forcing muvm to be used in a Snap environment on ARM64
    //    even on non-Apple hardware?
    // A: FEX-EMU (not to be confused with FEX-enabled builds of Wine) can't
    //    work in a Snap confined environment without an additional emulation
    //    layer. The Generic-ARM64-support.md document at the root of this
    //    repo explains why. Muvm provides that additional emulation layer,
    //    so such a setup may work in theory.
    final muvmNeeded =
        archName == 'aarch64' && (isNon4kPageSize || isSnapVersion);

    if (muvmNeeded) {
      if (!await File('/dev/kvm').exists()) {
        throw ErrorWithMoreDetailsUrl(
          'This system lacks the hardware virtualization capabilities '
          '(/dev/kvm is missing) that are required to run WineBar.',
          moreDetailsUrl:
              'https://github.com/Tulon/WineBar/blob/main/Generic-ARM64-support.md',
        );
      }

      if (isSnapVersion && Platform.environment['SNAP_KVM_CONNECTED'] != '1') {
        throw GenericException(
          'WineBar on ARM64 needs read-write access to /dev/kvm. Ordinary '
          'apps normally have such access, but not Snaps. To grant such '
          'access, run the following command from the command line:\n\n'
          'sudo snap connect winebar:kvm :kvm\n\n'
          'Then, restart WineBar.',
        );
      }

      if (!await _isMuvmAvailable()) {
        throw GenericException(
          'This system needs muvm / FEX to be able to run Windows apps. '
          'The Snap version of WineBar has muvm built-in. Otherwise, '
          'please install it using "sudo dnf install muvm fex-emu" or similar',
        );
      }
    }

    final settingsFileHelper = SettingsFileHelper(
      wineWillRunUnderMuvm: muvmNeeded,
    );

    if (await toplevelDataDirectory.exists()) {
      await _loadSettingsFromExistingDataDir(
        localStoragePaths: localStoragePaths,
        settingsFileHelper: settingsFileHelper,
      );
    } else {
      await toplevelDataDirectory.create();
      await _createNewSettingsJsonFile(
        localStoragePaths: localStoragePaths,
        settingsFileHelper: settingsFileHelper,
      );
    }

    final tempDir = Directory(localStoragePaths.tempDir);
    await recursiveDeleteAndLogErrors(tempDir);
    await tempDir.create();

    await Directory(localStoragePaths.wineInstallsDir).create();
    await Directory(localStoragePaths.winePrefixesDir).create();
    await Directory(localStoragePaths.dxvkPackagesDir).create();

    final winePrefixes = await _loadWinePrefixes(
      localStoragePaths: localStoragePaths,
    );

    final wineProcessRunningService = WineProcessRunnerService(
      toplevelTempDir: localStoragePaths.tempDir,
      logCapturingRunnerPath: LocalStoragePaths.logCapturingRunnerPath,
      runWithMuvm: muvmNeeded,
    );

    return StartupData._(
      localStoragePaths: localStoragePaths,
      winePrefixes: winePrefixes,
      wineProcessRunnerService: wineProcessRunningService,
      isIntelHost: isIntelHost,
      wineWillRunUnderMuvm: muvmNeeded,
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

  static Future<String> _getArchNameFromUname() async {
    try {
      final processResult = await Process.run('uname', ['-m']);
      return processResult.stdout.toString().trim();
    } catch (e, stackTrace) {
      final logger = GetIt.I.get<Logger>();
      logger.e(
        'Failed to get the host architecture name using "uname -m"',
        error: e,
        stackTrace: stackTrace,
      );
      throw GenericException(
        'Unable to get the architecture name: ${e.toString()}',
      );
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

  static Future<void> _loadSettingsFromExistingDataDir({
    required LocalStoragePaths localStoragePaths,
    required SettingsFileHelper settingsFileHelper,
  }) async {
    try {
      final settingsJsonFile = await SettingsJsonFile.loadAndUpgrade(
        localStoragePaths.settingsJsonFilePath,
        settingsFileHelper: settingsFileHelper,
      );

      if (settingsJsonFile.appPackageId != AppInfo.appPackageId) {
        throw DataDirNotRecognizedException(localStoragePaths.toplevelDataDir);
      }

      GetIt.I.registerSingleton<AppSettingsService>(
        AppSettingsService(
          initialSettings: settingsJsonFile,
          localStoragePaths: localStoragePaths,
        ),
      );
    } catch (e) {
      throw DataDirNotRecognizedException(localStoragePaths.toplevelDataDir);
    }
  }

  static Future<void> _createNewSettingsJsonFile({
    required LocalStoragePaths localStoragePaths,
    required SettingsFileHelper settingsFileHelper,
  }) async {
    final settingsJsonFile = SettingsJsonFile(
      appPackageId: AppInfo.appPackageId,
      suppressedWarnings: settingsFileHelper
          .buildDefaultSetOfSuppressedWarnings(),
    );

    await settingsJsonFile.save(localStoragePaths.settingsJsonFilePath);

    GetIt.I.registerSingleton<AppSettingsService>(
      AppSettingsService(
        initialSettings: settingsJsonFile,
        localStoragePaths: localStoragePaths,
      ),
    );
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

      final prefixDescriptor = WinePrefixDescriptor.fromJsonString(
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
