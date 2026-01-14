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

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/command_line_to_wine_args.dart';
import 'package:winebar/utils/startup_data.dart';

import 'pinned_executable_state.dart';

class PinnedExecutableBloc extends Cubit<PinnedExecutableState> {
  final logger = GetIt.I.get<Logger>();
  final runningPinnedExecutablesRepo = GetIt.I
      .get<RunningExecutablesRepo<PinnedExecutable>>();
  final WinePrefix winePrefix;
  final PinnedExecutable pinnedExecutable;
  WineProcess? _runningProcess;
  CancelableOperation<WineProcessResult>? _cancellableProcessResultGetter;

  PinnedExecutableBloc({
    required this.winePrefix,
    required this.pinnedExecutable,
    required bool isContextMenuOpen,
  }) : super(
         PinnedExecutableState(
           isRunning: false,
           isContextMenuOpen: isContextMenuOpen,
           isMouseOver: false,
         ),
       ) {
    final runningProcess = runningPinnedExecutablesRepo.tryFindRunningProcess(
      prefixId: winePrefix.id,
      slot: pinnedExecutable,
    );

    if (runningProcess != null) {
      _attachToRunningProcess(runningProcess);
    }
  }

  @override
  Future<void> close() async {
    if (_cancellableProcessResultGetter != null) {
      await _cancellableProcessResultGetter!.cancel();
      _cancellableProcessResultGetter = null;
    }
    return super.close();
  }

  void _attachToRunningProcess(WineProcess runningProcess) {
    assert(_runningProcess == null);
    assert(_cancellableProcessResultGetter == null);

    // This is necessary to be able to kill it while it's running.
    _runningProcess = runningProcess;

    if (!state.isRunning) {
      // This happens when we are called from a constructor.
      emit(state.copyWith(isRunning: true));
    }

    _cancellableProcessResultGetter = CancelableOperation.fromFuture(
      runningProcess.result,
    );

    unawaited(
      _cancellableProcessResultGetter!.value
          .then(
            (processResult) {
              emit(state.copyWith(isRunning: false));
            },
            onError: (e) {
              logger.w(
                'Error running executable ${pinnedExecutable.windowsPathToExecutable}:\n${e.toString()}',
              );
              emit(state.copyWith(isRunning: false));
            },
          )
          .whenComplete(() {
            _runningProcess = null;
            _cancellableProcessResultGetter = null;
          }),
    );
  }

  void setContextMenuOpen(bool contextMenuOpen) {
    if (contextMenuOpen != state.isContextMenuOpen) {
      emit(state.copyWith(isContextMenuOpen: contextMenuOpen));
    }
  }

  void setMouseOver(bool mouseOver) {
    if (mouseOver != state.isMouseOver) {
      emit(state.copyWith(isMouseOver: mouseOver));
    }
  }

  void killProcessIfRunning() {
    if (_runningProcess != null) {
      _runningProcess!.kill();
    }
  }

  void launchPinnedExecutable() {
    if (state.isRunning || _runningProcess != null) {
      logger.w(
        "Trying to run pinned executable "
        "${pinnedExecutable.windowsPathToExecutable} that's already running",
      );
      return;
    }

    emit(state.copyWith(isRunning: true));

    unawaited(
      _startProcess()
          .then((runningProcess) {
            runningPinnedExecutablesRepo.addRunningProcess(
              prefixId: winePrefix.id,
              slot: pinnedExecutable,
              wineProcess: runningProcess,
            );
            _attachToRunningProcess(runningProcess);
          })
          .catchError((e, stackTrace) {
            logger.w(
              'Error starting executable ${pinnedExecutable.windowsPathToExecutable}:\n${e.toString()}',
            );

            // _attachToRunningProcess() does set isRunning to false in case of an error,
            // but in case the exception was thrown before _attachToRunningProcess() is
            // called, we still need this.
            emit(state.copyWith(isRunning: false));
          }),
    );
  }

  Future<WineProcess> _startProcess() async {
    final startupData = StartupData.instance;
    final utilityService = GetIt.I.get<UtilityService>();

    final wineInstDescriptor = await utilityService
        .wineInstallationDescriptorForWineInstallDir(
          winePrefix.descriptor.getAbsPathToWineInstall(
            toplevelDataDir: startupData.localStoragePaths.toplevelDataDir,
          ),
        );

    List<String> wineArgsForLaunchingExecutable(String executablePath) {
      return commandLineToWineArgs([executablePath]);
    }

    final processOutputDir = await startupData.localStoragePaths
        .createProcessOutputDir();

    final wineProcess = await startupData.wineProcessRunnerService.start(
      processOutputDir: processOutputDir,
      commandLine: wineInstDescriptor.buildWineInvocationCommand(
        winePrefix: winePrefix,
        wineArgs: wineArgsForLaunchingExecutable(
          pinnedExecutable.windowsPathToExecutable,
        ),
      ),
      envVars: await wineInstDescriptor.getEnvVarsForWine(
        winePrefix: winePrefix,
        processOutputDir: processOutputDir.path,
        pinnedExecutableSettings: pinnedExecutable.settings,
        forWinetricks: false,

        // For maximum performance, we disable capturing logs from pinned
        // executables.
        disableLogs: true,
      ),
    );

    return wineProcess;
  }
}
