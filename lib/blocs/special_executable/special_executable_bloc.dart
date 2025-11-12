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

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:winebar/blocs/special_executable/special_executable_state.dart';
import 'package:winebar/exceptions/generic_exception.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/process_log.dart';
import 'package:winebar/models/process_output.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/repositories/running_special_executables_repo.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/services/winetricks_download_service.dart';
import 'package:winebar/utils/command_line_to_wine_args.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';

abstract class SpecialExecutableBloc extends Cubit<SpecialExecutableState> {
  final logger = GetIt.I.get<Logger>();
  final runningSpecialExecutablesRepo = GetIt.I
      .get<RunningSpecialExecutablesRepo>();
  final StartupData startupData;
  final WinePrefix winePrefix;
  WineProcess? _runningProcess;
  CancelableOperation<WineProcessResult>? _cancellableProcessResultGetter;

  @protected
  SpecialExecutableBloc({required this.startupData, required this.winePrefix})
    : super(SpecialExecutableState.defaultState()) {
    final runningProcess = runningSpecialExecutablesRepo.tryFind(
      prefix: winePrefix,
      executableSlot: executableSlot,
    );

    if (runningProcess != null) {
      _attachToRunningProcess(runningProcess);
    }
  }

  /// To be implemented in a subclass.
  SpecialExecutableSlot get executableSlot;

  @override
  Future<void> close() async {
    if (_cancellableProcessResultGetter != null) {
      await _cancellableProcessResultGetter!.cancel();
      _cancellableProcessResultGetter = null;
    }
    return super.close();
  }

  /// To be implemented in a subclasses.
  /// In case of launching the winetricks script, the [commandLine] shall
  /// not contain the winetricks script itself, only its arguments.
  Future<WineProcessResult> runProcess({
    required List<String> commandLine,
    required WineInstallationDescriptor wineInstDescriptor,
    required void Function(WineProcess) onProcessStarted,
  });

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
              emit(
                state.copyWith(
                  isRunning: false,
                  processOutputGetter: () =>
                      ProcessOutput(logs: processResult.logs),
                ),
              );
            },
            onError: (e) {
              // We don't log anything here because we log stuff when we
              // catch errors coming from _runProcess(). Those errors
              // include anything we can catch here and more.
              emit(
                state.copyWith(
                  isRunning: false,
                  processOutputGetter: () => ProcessOutput(
                    logs: [ProcessLog(name: 'Error', content: e.toString())],
                  ),
                ),
              );
            },
          )
          .whenComplete(() {
            _runningProcess = null;
            _cancellableProcessResultGetter = null;
          }),
    );
  }

  void killProcessIfRunning() {
    if (_runningProcess != null) {
      _runningProcess!.kill();
    }
  }

  void startProcess(List<String> commandLine) {
    if (state.isRunning || _runningProcess != null) {
      logger.w(
        "Trying to run a special executable "
        "\"${executableSlot.name}\" that's already running",
      );
      return;
    }

    emit(state.copyWith(isRunning: true, processOutputGetter: () => null));

    unawaited(
      _runProcess(
        commandLine: commandLine,
        onProcessStarted: (runningProcess) {
          runningSpecialExecutablesRepo.add(
            prefix: winePrefix,
            executableSlot: executableSlot,
            wineProcess: runningProcess,
          );
          _attachToRunningProcess(runningProcess);
        },
      ).catchError((e, stackTrace) {
        logger.w(
          'Error running special executable "${executableSlot.name}":\n${e.toString()}',
          stackTrace: stackTrace,
        );

        // _attachToRunningProcess() does set isRunning to false in case of an error,
        // but in case the exception was thrown before _attachToRunningProcess() is
        // called, we still need this.
        emit(state.copyWith(isRunning: false));
      }),
    );
  }

  Future<void> _runProcess({
    required List<String> commandLine,
    required void Function(WineProcess) onProcessStarted,
  }) async {
    final wineInstDescriptor =
        await WineInstallationDescriptor.forWineInstallDir(
          winePrefix.descriptor.getAbsPathToWineInstall(
            toplevelDataDir: startupData.localStoragePaths.toplevelDataDir,
          ),
        );

    await runProcess(
      commandLine: commandLine,
      wineInstDescriptor: wineInstDescriptor,
      onProcessStarted: onProcessStarted,
    );
  }
}

abstract class RegularSpecialExecutableBloc extends SpecialExecutableBloc {
  @protected
  RegularSpecialExecutableBloc({
    required super.startupData,
    required super.winePrefix,
  });

  @override
  Future<WineProcessResult> runProcess({
    required List<String> commandLine,
    required WineInstallationDescriptor wineInstDescriptor,
    required void Function(WineProcess) onProcessStarted,
  }) async {
    final wineProcess = await startupData.wineProcessRunnerService.start(
      commandLine: wineInstDescriptor.buildWineInvocationCommand(
        wineArgs: commandLineToWineArgs(commandLine),
      ),
      envVars: wineInstDescriptor.getEnvVarsForWine(
        prefixDirStructure: winePrefix.dirStructure,
        tempDir: startupData.localStoragePaths.tempDir,
      ),
    );

    onProcessStarted(wineProcess);

    return wineProcess.result;
  }
}

class CustomExecutableBloc extends RegularSpecialExecutableBloc {
  CustomExecutableBloc({required super.startupData, required super.winePrefix});

  @override
  SpecialExecutableSlot get executableSlot =>
      SpecialExecutableSlot.customExecutable;
}

class RunAndPinExecutableBloc extends SpecialExecutableBloc {
  final Future<void> Function(PinnedExecutable executablePinnedInTempDir)
  processExecutablePinnedInTempDir;

  RunAndPinExecutableBloc({
    required super.startupData,
    required super.winePrefix,
    required this.processExecutablePinnedInTempDir,
  });

  @override
  SpecialExecutableSlot get executableSlot =>
      SpecialExecutableSlot.runAndPinExecutable;

  @override
  Future<WineProcessResult> runProcess({
    required List<String> commandLine,
    required WineInstallationDescriptor wineInstDescriptor,
    required void Function(WineProcess) onProcessStarted,
  }) async {
    final tempPinDir = await Directory(
      startupData.localStoragePaths.tempDir,
    ).createTemp('pin-');

    try {
      final wineProcess = await startupData.wineProcessRunnerService.start(
        commandLine: wineInstDescriptor.buildWineInvocationCommand(
          wineArgs: _buildWineArgs(
            commandLine: commandLine,
            tempPinDir: tempPinDir,
          ),
        ),
        envVars: wineInstDescriptor.getEnvVarsForWine(
          prefixDirStructure: winePrefix.dirStructure,
          tempDir: startupData.localStoragePaths.tempDir,
        ),
      );

      onProcessStarted(wineProcess);

      final processResult = await wineProcess.result;

      await _tryPinningExecutable(tempPinDir: tempPinDir.path);

      return processResult;
    } finally {
      await recursiveDeleteAndLogErrors(tempPinDir);
    }
  }

  List<String> _buildWineArgs({
    required List<String> commandLine,
    required Directory tempPinDir,
  }) {
    if (commandLine.isEmpty) {
      throw GenericException("Can't execute an empty command line");
    }

    final executable = commandLine.first;

    return [
      startupData.runAndPinWin32LauncherPath,
      tempPinDir.path,
      executable,
      ...commandLineToWineArgs(commandLine),
    ];
  }

  Future<void> _tryPinningExecutable({required String tempPinDir}) async {
    PinnedExecutable? executablePinnedInTempDir;
    try {
      executablePinnedInTempDir = await PinnedExecutable.loadFromPinDirectory(
        tempPinDir,
      );
    } catch (e, stackTrace) {
      logger.e(
        'Failed to read a pin from $tempPinDir',
        error: e,
        stackTrace: stackTrace,
      );
      return;
    }

    try {
      await processExecutablePinnedInTempDir(executablePinnedInTempDir);
    } catch (e, stackTrace) {
      logger.e('Failed to pin an executable', error: e, stackTrace: stackTrace);
      return;
    }
  }
}

class WinetricksExecutableBloc extends SpecialExecutableBloc {
  WinetricksExecutableBloc({
    required super.startupData,
    required super.winePrefix,
  });

  @override
  SpecialExecutableSlot get executableSlot =>
      SpecialExecutableSlot.winetricksExecutable;

  @override
  Future<WineProcessResult> runProcess({
    required List<String> commandLine,
    required WineInstallationDescriptor wineInstDescriptor,
    required void Function(WineProcess) onProcessStarted,
  }) async {
    final winetricksDownloadService = GetIt.I.get<WinetricksDownloadService>();

    String? externalWinetricksScriptPath;

    try {
      if (!wineInstDescriptor.hasBundledWinetricks) {
        externalWinetricksScriptPath = await winetricksDownloadService
            .prepareWinetricksScript(forceRetry: true);
      }
    } catch (e, stackTrace) {
      logger.w(
        'Failed to prepare the winetricks script',
        error: e,
        stackTrace: stackTrace,
      );
      throw GenericException(
        'Failed to prepare the winetricks script:\n${e.toString()}',
      );
    }

    final wineProcess = await startupData.wineProcessRunnerService.start(
      commandLine: wineInstDescriptor.buildWinetricksInvocationCommand(
        externalWinetricksScriptPath: externalWinetricksScriptPath,
        winetricksArgs: commandLine,
      ),
      envVars: wineInstDescriptor.getEnvVarsForWinetricks(
        prefixDirStructure: winePrefix.dirStructure,
      ),
    );

    onProcessStarted(wineProcess);

    return wineProcess.result;
  }
}
