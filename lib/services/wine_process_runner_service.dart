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
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/exceptions/generic_process_exception.dart';

import '../utils/env_vars_to_muvm_args.dart';

void _validateCommandLine(List<String> commandLine) {
  if (commandLine.isEmpty) {
    throw GenericProcessException("Command line can't be empty");
  }
}

/// Runs a wine process (or a process that may invoke wine) either directly
/// or through muvm.
abstract interface class WineProcessRunnerService {
  Future<WineProcess> start({
    required List<String> commandLine,
    required Map<String, String> envVars,
  });
}

abstract interface class WineProcess {
  /// The returned future will complete when the process finishes
  /// one way or another (including getting killed).
  Future<WineProcessResult> get result;

  /// Returns true if the signal has been delivered.
  /// Otherwise, the process can be assumed to be already dead.
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]);
}

abstract interface class WineProcessResult {
  /// The process's exit code. If null, that indicates either that
  /// the target process never started within a wrapper process
  /// or that the wrapper process was forcefully killed.
  int? get exitCode;

  Uint8List get stdout;
  Uint8List get stderr;
}

class _WineProcessResult implements WineProcessResult {
  @override
  final int? exitCode;

  @override
  final Uint8List stdout;

  @override
  final Uint8List stderr;

  _WineProcessResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });
}

class DirectWineProcessRunnerService implements WineProcessRunnerService {
  final logger = GetIt.I.get<Logger>();

  @override
  Future<WineProcess> start({
    required List<String> commandLine,
    required Map<String, String> envVars,
  }) async {
    _validateCommandLine(commandLine);

    final process = await Process.start(
      commandLine.first,
      commandLine.sublist(1),
      environment: envVars,
    );

    return _DirectWineProcess(process);
  }
}

class MuvmWineProcessRunnerService implements WineProcessRunnerService {
  final logger = GetIt.I.get<Logger>();
  final String toplevelTempDir;
  final String muvmWrapperScriptPath;

  MuvmWineProcessRunnerService({
    required this.toplevelTempDir,
    required this.muvmWrapperScriptPath,
  });

  @override
  Future<WineProcess> start({
    required List<String> commandLine,
    required Map<String, String> envVars,
  }) async {
    _validateCommandLine(commandLine);

    // muvm doesn't propagate the stdout, stderr or even the exit code of the
    // process it runs. So, we create a temporary directory and write those
    // things there as files.
    final tempOutDir = await Directory(
      toplevelTempDir,
    ).createTemp('process-outdir-');

    final muvmProcess = await Process.start('muvm', [
      // This option is supposed to forward stdin / stdout from the process
      // running in the virtual machine, but that only seems to happen when
      // stdin / stdout are connected to a terminal. However, it has another
      // useful side effect: In case another muvm process is already running,
      // the 2nd muvm process won't exit immediately but will wait for the
      // existing one to finish. With or without --interactive, the command
      // will actually run in the existing virtual machine.
      '--interactive',

      ...envVarsToMuvmArgs(envVars),
      '-e',
      'OUTDIR=${tempOutDir.path}',
      '--',
      muvmWrapperScriptPath,
      ...commandLine,
    ]);

    return _MuvmWineProcess(muvmProcess: muvmProcess, tempOutDir: tempOutDir);
  }
}

class _DirectWineProcess implements WineProcess {
  final Process process;
  final _completer = Completer<WineProcessResult>();
  final _stdoutBuilder = BytesBuilder();
  final _stderrBuilder = BytesBuilder();

  _DirectWineProcess(this.process) {
    final stdoutClosedFuture = process.stdout.forEach(
      (bytes) => _stdoutBuilder.add(bytes),
    );

    final stderrClosedFuture = process.stderr.forEach(
      (bytes) => _stderrBuilder.add(bytes),
    );

    unawaited(
      (process.exitCode, stdoutClosedFuture, stderrClosedFuture).wait.then(
        (rec) {
          _completer.complete(
            _WineProcessResult(
              exitCode: rec.$1,
              stdout: _stdoutBuilder.toBytes(),
              stderr: _stderrBuilder.toBytes(),
            ),
          );
        },
        onError: (e) {
          _completer.complete(
            _WineProcessResult(
              exitCode: e.values.$1,
              stdout: _stdoutBuilder.toBytes(),
              stderr: _stderrBuilder.toBytes(),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<WineProcessResult> get result {
    return _completer.future;
  }

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    return process.kill(signal);
  }
}

class _MuvmWineProcess implements WineProcess {
  final Process muvmProcess;
  final Directory tempOutDir;
  final _completer = Completer<WineProcessResult>();

  _MuvmWineProcess({required this.muvmProcess, required this.tempOutDir}) {
    unawaited(
      muvmProcess.exitCode
          .then<void>((_) async {
            // muvm's exit code seems to be always 0, so we ignore it.

            final statusString = await File(
              path.join(tempOutDir.path, 'status.txt'),
            ).readAsString().catchError((e) => '');

            final exitCode = int.tryParse(statusString.trim());

            final stdout = await File(
              path.join(tempOutDir.path, 'stdout.txt'),
            ).readAsBytes().catchError((e) => Uint8List(0));

            final stderr = await File(
              path.join(tempOutDir.path, 'stderr.txt'),
            ).readAsBytes().catchError((e) => Uint8List(0));

            _completer.complete(
              _WineProcessResult(
                exitCode: exitCode,
                stdout: stdout,
                stderr: stderr,
              ),
            );
          })
          .catchError(
            (e, stackTrace) => _completer.completeError(e, stackTrace),
          ),
    );
  }

  @override
  Future<WineProcessResult> get result {
    return _completer.future;
  }

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    return muvmProcess.kill(signal);
  }
}
