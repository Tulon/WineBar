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

/// @docImport 'package:winebar/services/dxvk_installation_service.dart';
library;

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/exceptions/wine_command_failed_exception.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';

/// A collection of tasks involving running Wine.
class WineTasks {
  /// Prevents instantiating, except from within this library.
  WineTasks._();

  static void createAndRegisterInstance() {
    GetIt.I.registerSingleton<WineTasks>(WineTasks._());
  }

  static void registerMockInstance(WineTasks instance) {
    GetIt.I.registerSingleton<WineTasks>(instance);
  }

  static WineTasks get instance {
    return GetIt.I.get<WineTasks>();
  }

  /// Runs the Wine prefix initialization routine, which involves
  /// running the wine executable.
  ///
  /// If [cancelHookReceiver] is provided, it will be called shortly
  /// and passed a function that may be used to cancel this task.
  /// Cancelling a task usually results in the Future returned from
  /// this function to be completed with an error.
  ///
  /// If the Wine process exists with a non-zero status, the returned
  /// Future will be completed with [WineCommandFailedException].
  Future<void> initializeWinePrefix({
    void Function(void Function() cancel)? cancelHookReceiver,
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  }) async {
    final wineProcess = await _startWineProcess(
      wineArgs: [
        // Invoking wineboot.exe rather than just 'wineboot' means we won't
        // have to run this command through start.exe. See commandLineToWineArgs()
        // for details.
        'wineboot.exe',
        '-u',
      ],
      winePrefix: winePrefix,
      wineInstDescriptor: wineInstDescriptor,
      runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      slot: specialExecutableSlot,
    );

    if (cancelHookReceiver != null) {
      cancelHookReceiver(wineProcess.kill);
    }

    final processResult = await wineProcess.result;

    if (processResult.exitCode != 0) {
      throw WineCommandFailedException(
        'The "wineboot -u" command failed',
        processResult: processResult,
      );
    }
  }

  /// Sets the HiDPI scale factor in Wine's registry, which involves
  /// running the wine executable.
  ///
  /// If [cancelHookReceiver] is provided, it will be called shortly
  /// and passed a function that may be used to cancel this task.
  /// Cancelling a task usually results in the Future returned from
  /// this function to be completed with an error.
  ///
  /// If the Wine process exists with a non-zero status, the returned
  /// Future will be completed with [WineCommandFailedException].
  Future<void> setHiDpiScale({
    required double hiDpiScale,
    void Function(void Function() cancel)? cancelHookReceiver,
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  }) async {
    final wineProcess = await _startWineProcess(
      wineArgs: [
        // Invoking reg.exe rather than just 'reg' means we won't
        // have to run this command through start.exe. See
        // commandLineToWineArgs() for details.
        'reg.exe',
        'add',
        'HKEY_CURRENT_USER\\Control Panel\\Desktop',
        '/v',
        'LogPixels',
        '/t',
        'REG_DWORD',
        '/d',
        (hiDpiScale * 96).round().toString(),
        '/f',
      ],
      winePrefix: winePrefix,
      wineInstDescriptor: wineInstDescriptor,
      runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      slot: specialExecutableSlot,
    );

    if (cancelHookReceiver != null) {
      cancelHookReceiver(wineProcess.kill);
    }

    final processResult = await wineProcess.result;

    if (processResult.exitCode != 0) {
      throw WineCommandFailedException(
        'The "wine reg" command failed',
        processResult: processResult,
      );
    }
  }

  /// Enables the already-installed DXVK by modifying Wine's DLL override
  /// registry entries, which involves running the wine executable.
  ///
  /// Before DXVK can be enabled, it has to be installed using
  /// [DxvkInstallationService].
  ///
  /// Note that this function should not be used with GE Proton prefixes,
  /// as the "proton" helper script uses a different mechanism (the
  /// PROTON_USE_WINED3D environment variable) to switch between DXVK
  /// and WineD3D. [DxvkInstallationService] will set
  /// [DxvkInstallationPlan.needInstall] to false for GE Proton prefixes,
  /// and that should be interpreted as a prohibition to call this function.
  ///
  /// If [cancelHookReceiver] is provided, it will be called shortly
  /// and passed a function that may be used to cancel this task.
  /// Cancelling a task usually results in the Future returned from
  /// this function to be completed with an error.
  ///
  /// If the Wine process exists with a non-zero status, the returned
  /// Future will be completed with [WineCommandFailedException].
  Future<void> setupDxvkDllOverrides({
    void Function(void Function() cancel)? cancelHookReceiver,
    required StartupData startupData,
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  }) {
    const val = 'native,builtin';

    return updateDllOverrides(
      // The '*' prefix means to apply this setting to libraries located
      // anywhere, not just in the c:\windows\system32 and c:\windows\syswow64.
      // Not sure if that's really necessary, but winetricks does it like that.
      valuesToSetOrRemove: {
        'd3d8': null,
        '*d3d8': val,
        'd3d9': null,
        '*d3d9': val,
        'd3d10core': null,
        '*d3d10core': val,
        'd3d11': null,
        '*d3d11': val,
        'dxgi': null,
        '*dxgi': val,
      },

      cancelHookReceiver: cancelHookReceiver,
      startupData: startupData,
      winePrefix: winePrefix,
      wineInstDescriptor: wineInstDescriptor,
      runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      specialExecutableSlot: specialExecutableSlot,
    );
  }

  /// Removes all DXVK-related DLL overrides, which involves running the
  /// wine executable.
  ///
  /// Removing the DXVK DLL overrides essentially brings the prefix to its
  /// default Direct3D 8-11 implementation, even if DXVK's DLLs still
  /// sit in system directories.
  ///
  /// Unlike [setupDxvkDllOverrides], this function may be used with GE Proton
  /// prefixes.
  ///
  /// If [cancelHookReceiver] is provided, it will be called shortly
  /// and passed a function that may be used to cancel this task.
  /// Cancelling a task usually results in the Future returned from
  /// this function to be completed with an error.
  ///
  /// If the Wine process exists with a non-zero status, the returned
  /// Future will be completed with [WineCommandFailedException].
  Future<void> clearDxvkDllOverrides({
    void Function(void Function() cancel)? cancelHookReceiver,
    required StartupData startupData,
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  }) {
    return updateDllOverrides(
      valuesToSetOrRemove: {
        'd3d8': null,
        '*d3d8': null,
        'd3d9': null,
        '*d3d9': null,
        'd3d10core': null,
        '*d3d10core': null,
        'd3d11': null,
        '*d3d11': null,
        'dxgi': null,
        '*dxgi': null,
      },

      cancelHookReceiver: cancelHookReceiver,
      startupData: startupData,
      winePrefix: winePrefix,
      wineInstDescriptor: wineInstDescriptor,
      runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      specialExecutableSlot: specialExecutableSlot,
    );
  }

  /// Adds or removes Windows registry values under
  /// [HKEY_CURRENT_USER\\Software\\Wine\\DllOverrides], which involves
  /// running the wine executable.
  ///
  /// The format of values under the given key is given in [1].
  /// Setting a value to null removes the given entry.
  ///
  /// If [cancelHookReceiver] is provided, it will be called shortly
  /// and passed a function that may be used to cancel this task.
  /// Cancelling a task usually results in the Future returned from
  /// this function to be completed with an error.
  ///
  /// If the Wine process exists with a non-zero status, the returned
  /// Future will be completed with [WineCommandFailedException].
  ///
  /// [1]: https://gitlab.winehq.org/dmjc/wine/-/blob/aa25b6203b613ad9f8ece388fa2a210e52fde2b6/documentation/dll-overrides
  Future<void> updateDllOverrides({
    required Map<String, String?> valuesToSetOrRemove,
    void Function(void Function() cancel)? cancelHookReceiver,
    required StartupData startupData,
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  }) async {
    final dllOverridesTempDir = await Directory(
      startupData.localStoragePaths.tempDir,
    ).createTemp('dll-overrides-');

    try {
      final buf = StringBuffer();

      // This .reg file format supports removing values.
      buf.writeln('Windows Registry Editor Version 5.00');

      buf.writeln('[HKEY_CURRENT_USER\\Software\\Wine\\DllOverrides]');

      for (final MapEntry(key: key, value: val)
          in valuesToSetOrRemove.entries) {
        final valStr = val == null ? '-' : '"$val"';
        buf.writeln('"$key"=$valStr');
      }

      final regFile = File(
        path.join(dllOverridesTempDir.path, 'dll-overrides.reg'),
      );
      await regFile.writeAsString(buf.toString());

      // According to [1], HKEY_CURRENT_USER\Software is shared between
      // 64-bit and 32-bit registry views, so there is no need to invoke
      // reg.exe twice with /reg:32 and /reg:64 flags.
      // [1]: https://learn.microsoft.com/en-us/windows/win32/winprog64/shared-registry-keys

      final wineProcess = await _startWineProcess(
        wineArgs: [
          // Invoking reg.exe rather than just 'reg' means we won't
          // have to run this command through start.exe. See
          // commandLineToWineArgs() for details.
          'reg.exe',
          'import',
          regFile.path,
        ],
        winePrefix: winePrefix,
        wineInstDescriptor: wineInstDescriptor,
        runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
        slot: specialExecutableSlot,
      );

      if (cancelHookReceiver != null) {
        cancelHookReceiver(wineProcess.kill);
      }

      final processResult = await wineProcess.result;

      if (processResult.exitCode != 0) {
        throw WineCommandFailedException(
          'The "wine reg import" command failed',
          processResult: processResult,
        );
      }
    } finally {
      await recursiveDeleteAndLogErrors(dllOverridesTempDir);
    }
  }

  static Future<WineProcess> _startWineProcess<SlotType>({
    required List<String> wineArgs,
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SlotType> runningSpecialExecutablesRepo,
    required SlotType slot,
  }) async {
    final startupData = StartupData.instance;

    final processOutputDir = await startupData.localStoragePaths
        .createProcessOutputDir();

    final wineProcess = await startupData.wineProcessRunnerService.start(
      processOutputDir: processOutputDir,
      commandLine: wineInstDescriptor.buildWineInvocationCommand(
        winePrefix: winePrefix,
        wineArgs: wineArgs,
      ),
      envVars: await wineInstDescriptor.getEnvVarsForWine(
        winePrefix: winePrefix,
        processOutputDir: processOutputDir.path,
        pinnedExecutableSettings: null,
        forWinetricks: false,
        disableLogs: false,
      ),
    );

    runningSpecialExecutablesRepo.addRunningProcess(
      prefixId: winePrefix.id,
      slot: slot,
      wineProcess: wineProcess,
    );

    return wineProcess;
  }
}
