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

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/repositories/running_pinned_executables_repo.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';

import 'pinned_executable_state.dart';

class PinnedExecutableBloc extends Cubit<PinnedExecutableState> {
  final logger = GetIt.I.get<Logger>();
  final runningPinnedExecutablesRepo = GetIt.I
      .get<RunningPinnedExecutablesRepo>();
  final StartupData startupData;
  final WinePrefix winePrefix;
  final PinnedExecutable pinnedExecutable;
  WineProcess? _runningProcess;

  PinnedExecutableBloc._({
    required this.startupData,
    required this.winePrefix,
    required this.pinnedExecutable,
    required WineProcess? runningProcess,
  }) : super(PinnedExecutableState.defaultState()) {
    _setRunningProcess(runningProcess);
  }

  factory PinnedExecutableBloc({
    required StartupData startupData,
    required WinePrefix winePrefix,
    required PinnedExecutable pinnedExecutable,
  }) {
    final runningPinnedExecutablesRepo = GetIt.I
        .get<RunningPinnedExecutablesRepo>();

    final runningProcess = runningPinnedExecutablesRepo.tryFind(
      prefix: winePrefix,
      pinnedExecutable: pinnedExecutable,
    );

    return PinnedExecutableBloc._(
      startupData: startupData,
      winePrefix: winePrefix,
      pinnedExecutable: pinnedExecutable,
      runningProcess: runningProcess,
    );
  }

  void _setRunningProcess(WineProcess? runningProcess) {
    if (identical(_runningProcess, runningProcess)) {
      return;
    }

    _runningProcess = runningProcess;

    if ((runningProcess != null) != state.isRunning) {
      emit(state.copyWith(isRunning: runningProcess != null));
    }

    if (runningProcess != null) {
      unawaited(
        runningProcess.result.whenComplete(() => _setRunningProcess(null)),
      );
    }
  }

  void setMouseOver(bool mouseOver) {
    emit(state.copyWith(mouseOver: mouseOver));
  }

  void killProcessIfRunning() {
    if (_runningProcess != null) {
      _runningProcess!.kill();
    }
  }

  void launchPinnedExecutable() {
    if (state.isRunning) {
      logger.w(
        "Trying to run pinned executable "
        "${pinnedExecutable.windowsPathToExecutable} that's already running",
      );
      return;
    }

    emit(state.copyWith(isRunning: true));

    unawaited(
      _startProcess().then(
        (runningProcess) {
          _setRunningProcess(runningProcess);
        },
        onError: (e) {
          logger.w(
            'Error running executable ${pinnedExecutable.windowsPathToExecutable}:\n${e.toString()}',
          );
          if (_runningProcess != null) {
            emit(state.copyWith(isRunning: false));
          }
        },
      ),
    );
  }

  Future<WineProcess> _startProcess() async {
    final wineInstDescriptor =
        await WineInstallationDescriptor.forWineInstallDir(
          winePrefix.descriptor.getAbsPathToWineInstall(
            toplevelDataDir: startupData.localStoragePaths.toplevelDataDir,
          ),
        );

    List<String> wineArgsForLaunchingExecutable(String executablePath) {
      if (executablePath.toLowerCase().endsWith('.exe')) {
        return [executablePath];
      } else {
        return [
          'start',
          if (executablePath.startsWith('/')) '/unix',
          executablePath,
        ];
      }
    }

    final wineProcess = await startupData.wineProcessRunnerService.start(
      commandLine: wineInstDescriptor.buildWineInvocationCommand(
        wineArgs: wineArgsForLaunchingExecutable(
          pinnedExecutable.windowsPathToExecutable,
        ),
      ),
      envVars: wineInstDescriptor.getEnvVarsForWine(
        prefixDirStructure: winePrefix.dirStructure,
        tempDir: startupData.localStoragePaths.tempDir,
      ),
    );

    runningPinnedExecutablesRepo.add(
      prefix: winePrefix,
      pinnedExecutable: pinnedExecutable,
      wineProcess: wineProcess,
    );

    return wineProcess;
  }
}
