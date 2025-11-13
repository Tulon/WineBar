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

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/repositories/running_pinned_executables_repo.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';

import '../../models/pinned_executable.dart';
import 'prefix_details_state.dart';

class PrefixDetailsBloc extends Cubit<PrefixDetailsState> {
  final logger = GetIt.I.get<Logger>();
  final runningPinnedExecutablesRepo = GetIt.I
      .get<RunningPinnedExecutablesRepo>();
  final StartupData startupData;

  /// Pinning and unpinning operations are asynchronous but need to be executed
  /// sequentially. This future corresponds to the completion of the last pin
  /// or unpin operation.
  var _lastPinUnpinOperationCompletion = Future<void>.value();

  PrefixDetailsBloc(super.initialState, {required this.startupData});

  void setFileSelectionInProgress(bool inProgress) {
    emit(state.copyWith(fileSelectionInProgress: inProgress));
  }

  Future<void> pinExecutable(PinnedExecutable executablePinnedInTempDir) {
    _lastPinUnpinOperationCompletion = _lastPinUnpinOperationCompletion
        .then((_) async {
          if (isClosed) {
            unawaited(
              recursiveDeleteAndLogErrors(
                Directory(executablePinnedInTempDir.pinDirectory),
              ),
            );
            return;
          }

          final newPinnedExecutables = await state.pinnedExecutables
              .copyWithAdditionalPinnedExecutable(executablePinnedInTempDir);
          if (isClosed) {
            return;
          }

          emit(
            state.copyWith(
              pinnedExecutables: newPinnedExecutables,
              oldPinnedExecutablesGetter: () => state.pinnedExecutables,
            ),
          );
        })
        .catchError((e, stackTrace) {
          logger.e(
            'Failed to pin an executable',
            error: e,
            stackTrace: stackTrace,
          );
        });

    return _lastPinUnpinOperationCompletion;
  }

  void initiateUnpinningExecutable(PinnedExecutable pinnedExecutable) {
    unawaited(_unpinExecutable(pinnedExecutable));
  }

  Future<void> _unpinExecutable(PinnedExecutable pinnedExecutable) {
    _lastPinUnpinOperationCompletion = _lastPinUnpinOperationCompletion
        .then((_) async {
          if (isClosed) {
            return;
          }

          final newPinnedExecutables = await state.pinnedExecutables
              .copyWithPinnedExecutableRemoved(pinnedExecutable);
          if (isClosed) {
            return;
          }

          emit(
            state.copyWith(
              pinnedExecutables: newPinnedExecutables,
              oldPinnedExecutablesGetter: () => state.pinnedExecutables,
            ),
          );
        })
        .catchError((e, stackTrace) {
          logger.e(
            'Failed to unpin an executable',
            error: e,
            stackTrace: stackTrace,
          );
        });

    return _lastPinUnpinOperationCompletion;
  }

  void forgetOldPinnedExecutables() {
    emit(state.copyWith(oldPinnedExecutablesGetter: () => null));
  }
}
