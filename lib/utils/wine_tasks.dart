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

import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';

Future<WineProcess> startTaskOfPrefixInitialization({
  required StartupData startupData,
  required WinePrefix winePrefix,
  required WineInstallationDescriptor wineInstDescriptor,
  required RunningExecutablesRepo<SpecialExecutableSlot>
  runningSpecialExecutablesRepo,
  required SpecialExecutableSlot specialExecutableSlot,
}) {
  return _startWineProcess(
    wineArgs: [
      // Invoking wineboot.exe rather than just 'wineboot' means we won't
      // have to run this command through start.exe. See commandLineToWineArgs()
      // for details.
      'wineboot.exe',
      '-u',
    ],
    startupData: startupData,
    winePrefix: winePrefix,
    wineInstDescriptor: wineInstDescriptor,
    runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
    slot: specialExecutableSlot,
  );
}

Future<WineProcess> startTaskOfSettingHiDpiScale({
  required double hiDpiScale,
  required StartupData startupData,
  required WinePrefix winePrefix,
  required WineInstallationDescriptor wineInstDescriptor,
  required RunningExecutablesRepo<SpecialExecutableSlot>
  runningSpecialExecutablesRepo,
  required SpecialExecutableSlot specialExecutableSlot,
}) {
  return _startWineProcess(
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
    startupData: startupData,
    winePrefix: winePrefix,
    wineInstDescriptor: wineInstDescriptor,
    runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
    slot: specialExecutableSlot,
  );
}

Future<WineProcess> _startWineProcess<SlotType>({
  required List<String> wineArgs,
  required StartupData startupData,
  required WinePrefix winePrefix,
  required WineInstallationDescriptor wineInstDescriptor,
  required RunningExecutablesRepo<SlotType> runningSpecialExecutablesRepo,
  required SlotType slot,
}) async {
  final processOutputDir = await startupData.localStoragePaths
      .createProcessOutputDir();

  final wineProcess = await startupData.wineProcessRunnerService.start(
    processOutputDir: processOutputDir,
    commandLine: wineInstDescriptor.buildWineInvocationCommand(
      wineArgs: wineArgs,
    ),
    envVars: wineInstDescriptor.getEnvVarsForWine(
      prefixDirStructure: winePrefix.dirStructure,
      processOutputDir: processOutputDir.path,
      forWinetricks: false,
      disableLogs: false,
    ),
  );

  runningSpecialExecutablesRepo.addRunningProcess(
    prefix: winePrefix,
    slot: slot,
    wineProcess: wineProcess,
  );

  return wineProcess;
}
