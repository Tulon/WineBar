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
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/exceptions/generic_process_exception.dart';
import 'package:winebar/models/process_log.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';

void _validateCommandLine(List<String> commandLine) {
  if (commandLine.isEmpty) {
    throw GenericProcessException("Command line can't be empty");
  }
}

ProcessLog? _maybeBuildLog(String name, Uint8List content) {
  return content.isEmpty
      ? null
      : ProcessLog(
          name: name,
          content: utf8.decode(content, allowMalformed: true),
        );
}

/// Runs a wine process (or a process that may invoke wine) either directly
/// or through muvm.
abstract interface class WineProcessRunnerService {
  factory WineProcessRunnerService({
    required String toplevelTempDir,
    required String logCapturingRunnerPath,
    required bool runWithMuvm,
  }) {
    return _WineProcessRunnerService(
      toplevelTempDir: toplevelTempDir,
      logCapturingRunnerPath: logCapturingRunnerPath,
      runWithMuvm: runWithMuvm,
    );
  }

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

class WineProcessResult {
  /// The process's exit code. The value of null typically indicates
  /// a crash in the log-capturing-runner process.
  final int? exitCode;

  final List<ProcessLog> logs;

  WineProcessResult({required this.exitCode, required this.logs});
}

class _WineProcessRunnerService implements WineProcessRunnerService {
  final logger = GetIt.I.get<Logger>();
  final String toplevelTempDir;
  final String logCapturingRunnerPath;
  final bool runWithMuvm;

  _WineProcessRunnerService({
    required this.toplevelTempDir,
    required this.logCapturingRunnerPath,
    required this.runWithMuvm,
  });

  @override
  Future<WineProcess> start({
    required List<String> commandLine,
    required Map<String, String> envVars,
  }) async {
    _validateCommandLine(commandLine);

    // muvm doesn't propagate the stdout, stderr or even the exit code of the
    // process it runs. So, we create a temporary directory and wrap the
    // command with log-capturing-runner that writes the logs and the exit
    // code to files in that directory. In the non-muvm case we still use the
    // tempory directory and log-capturing-runner, just to avoid having a
    // separate logic for such a case.
    final tempOutDir = await Directory(
      toplevelTempDir,
    ).createTemp('process-outdir-');

    final (executable, args) = _buildExecutableAndArgs(
      tempOutDir: tempOutDir.path,
      commandLine: commandLine,
      envVars: envVars,
    );

    logger.i(
      'Running command:\n'
      '${[executable, ...args].join(' ')}',
    );

    final process = await Process.start(
      executable,
      args,

      // Muvm doesn't pass its environment to the child, so in this case,
      // we pass the environment through the command-line arguments
      // (see _buildExecutableAndArgs()).
      environment: runWithMuvm ? null : envVars,
    );

    return _WineProcessWithLogCapturingRunner(
      process: process,
      tempOutDir: tempOutDir,
    );
  }

  (String, List<String>) _buildExecutableAndArgs({
    required String tempOutDir,
    required List<String> commandLine,
    required Map<String, String> envVars,
  }) {
    // Q: Why do we have to pass the environment variables as arguments to
    //    log-capturing-runner?
    // A: When muvm is not used, we could just pass them to Process.start()
    //    directly. However, muvm doesn't propagate the environment variables
    //    to the process it starts in the virtual machine. We could pass
    //    those environment variables to muvm itself, using the -e ENV=VAL
    //    syntax, but it turns out the environment variables specified that
    //    way in one muvm invocation may be visible in another [1]. Therefore,
    //    the safest way that works in all cases is to pass them as arguments
    //    to log-capturing-runner.
    //    [1]: https://github.com/AsahiLinux/muvm/issues/206
    final logCapturingRunnerArgs = [
      tempOutDir,
      ..._envVarsToLogCapturingRunnerArgs(envVars),
      ...commandLine,
    ];

    if (!runWithMuvm) {
      return (logCapturingRunnerPath, logCapturingRunnerArgs);
    } else {
      final muvmArgs = [
        // This option is supposed to forward stdin / stdout from the process
        // running in the virtual machine, but that only seems to happen when
        // stdin / stdout are connected to a terminal. However, it has another
        // useful side effect: In case another muvm process is already running,
        // the 2nd muvm process won't exit immediately but will wait for the
        // existing one to finish. With or without --interactive, the command
        // will actually run in the existing virtual machine.
        '--interactive',

        '--',

        logCapturingRunnerPath,
        ...logCapturingRunnerArgs,
      ];

      return ('muvm', muvmArgs);
    }
  }

  static List<String> _envVarsToLogCapturingRunnerArgs(
    Map<String, String> envVars,
  ) {
    List<String> args = [];
    for (final entry in envVars.entries) {
      args.add('-e');
      args.add('${entry.key}=${entry.value}');
    }
    return args;
  }
}

class _WineProcessWithLogCapturingRunner implements WineProcess {
  final Process process;
  final Directory tempOutDir;
  final _completer = Completer<WineProcessResult>();

  _WineProcessWithLogCapturingRunner({
    required this.process,
    required this.tempOutDir,
  }) {
    unawaited(
      process.exitCode
          .then(_processNormalCompletion)
          .catchError(
            (e, stackTrace) => _completer.completeError(e, stackTrace),
          ),
    );
  }

  Future<void> _processNormalCompletion(int exitCode) async {
    // Muvm doesn't propagate the status code from the child, so we don't use
    // the exitCode argument and instead read it form status.txt.

    final statusString = await File(
      path.join(tempOutDir.path, 'status.txt'),
    ).readAsString().catchError((e) => '');

    final exitCode = int.tryParse(statusString.trim());

    // The log files are size-limted, so it's totally fine
    // to read them into memory.
    final stdout = await File(
      path.join(tempOutDir.path, 'stdout.txt'),
    ).readAsBytes().catchError((e) => Uint8List(0));

    final stderr = await File(
      path.join(tempOutDir.path, 'stderr.txt'),
    ).readAsBytes().catchError((e) => Uint8List(0));

    final logCapturingRunnerLog = await File(
      path.join(tempOutDir.path, 'log-capturing-runner.txt'),
    ).readAsBytes().catchError((e) => Uint8List(0));

    await recursiveDeleteAndLogErrors(tempOutDir);

    _completer.complete(
      WineProcessResult(
        exitCode: exitCode,
        logs: [
          ?_maybeBuildLog("STDOUT", stdout),
          ?_maybeBuildLog("STDERR", stderr),
          ?_maybeBuildLog("Log capturing runner", logCapturingRunnerLog),
        ],
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
