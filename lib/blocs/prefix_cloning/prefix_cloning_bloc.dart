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
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:process/process.dart';
import 'package:winebar/exceptions/wine_command_failed_exception.dart';
import 'package:winebar/models/process_log.dart';
import 'package:winebar/utils/l10n.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/validate_prefix_name.dart';

import '../../exceptions/prefix_already_exists_exception.dart';
import '../../models/wine_prefix.dart';
import 'prefix_cloning_state.dart';

class PrefixCloningBloc extends Cubit<PrefixCloningState> {
  final _logger = GetIt.I.get<Logger>();
  final _startupData = StartupData.instance;

  @protected
  final void Function(WinePrefix newPrefix) onPrefixCloned;

  PrefixCloningBloc({required this.onPrefixCloned})
    : super(PrefixCloningState.defaultState());

  void setTargetPrefixName(String prefixName) {
    final errorMessage = validatePrefixName(prefixName);

    if (state.targetPrefixName != prefixName ||
        state.targetPrefixNameErrorMessage != errorMessage) {
      emit(
        state.copyWith(
          targetPrefixName: prefixName,
          targetPrefixNameErrorMessageGetter: () => errorMessage,
        ),
      );
    }
  }

  Future<void> clonePrefixAndHandleErrors({
    required WinePrefix prefixToClone,
  }) async {
    assert(state.prefixCloningStatus != PrefixCloningStatus.inProgress);

    emit(
      state.copyWith(
        // We have to switch the state early, if only to disable the
        // 'Clone Prefix' button.
        prefixCloningStatus: PrefixCloningStatus.inProgress,

        prefixCloningFailureMessageGetter: () => null,
        prefixCloningFailedProcessLogs: const [],
      ),
    );

    try {
      final newPrefix = await _clonePrefix(prefixToClone: prefixToClone);

      emit(
        state.copyWith(
          prefixCloningStatus: PrefixCloningStatus.succeeded,
          prefixCloningFailureMessageGetter: () => null,
          prefixCloningFailedProcessLogs: const [],
        ),
      );

      _startupData.winePrefixRepo.addPrefix(newPrefix);

      onPrefixCloned(newPrefix);
    } catch (e) {
      final processLogs = e is ProcessFailedException
          ? e.processLogs
          : <ProcessLog>[];

      emit(
        state.copyWith(
          prefixCloningStatus: PrefixCloningStatus.failed,
          prefixCloningFailureMessageGetter: () => e.toString(),
          prefixCloningFailedProcessLogs: processLogs,
        ),
      );
    }
  }

  Future<WinePrefix> _clonePrefix({required WinePrefix prefixToClone}) async {
    final targetPrefixDirStructure = _startupData.localStoragePaths
        .getWinePrefixDirStructure(prefixName: state.targetPrefixName);

    final targetPrefixOuterDir = Directory(targetPrefixDirStructure.outerDir);

    if (await targetPrefixOuterDir.exists()) {
      throw PrefixAlreadyExistsException(prefixName: state.targetPrefixName);
    }

    await targetPrefixOuterDir.create();

    final targetPrefix = WinePrefix(
      status: WinePrefixStatus.operational,

      dirStructure: targetPrefixDirStructure,
      descriptor: prefixToClone.descriptor.copyWith(
        name: state.targetPrefixName,
      ),
    );

    try {
      final result = await GetIt.I.get<ProcessManager>().run([
        'cp',
        '-a',
        path.join(prefixToClone.dirStructure.outerDir, '.'),
        targetPrefixDirStructure.outerDir,
      ]);

      if (result.exitCode != 0) {
        throw ProcessFailedException(
          L10n.current.theCopyingProcessFailedWithExitCode(result.exitCode),
          processLogs: [ProcessLog(name: 'STDERR', content: result.stderr)],
        );
      }

      await File(
        targetPrefixDirStructure.prefixJsonFilePath,
      ).writeAsString(targetPrefix.descriptor.toJsonString());

      return targetPrefix;
    } catch (e, stackTrace) {
      _logger.e(
        'Cloning prefix "${prefixToClone.descriptor.name}" to '
        '"${state.targetPrefixName}" failed',
        error: e,
        stackTrace: stackTrace,
      );
      await recursiveDeleteAndLogErrors(targetPrefixOuterDir);
      rethrow;
    }
  }
}
