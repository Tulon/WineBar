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
import 'package:winebar/blocs/pinned_executable_set/pinned_executable_set_state.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';

import '../../../models/pinned_executable.dart';

class PinnedExecutableSetBloc extends Cubit<PinnedExecutableSetState> {
  final logger = GetIt.I.get<Logger>();
  final StartupData startupData;

  /// Pinning and unpinning operations are asynchronous but need to be executed
  /// sequentially. This future corresponds to the completion of the last pin
  /// or unpin operation.
  var _lastPinUnpinOperationCompletion = Future<void>.value();

  PinnedExecutableSetBloc({
    required PinnedExecutableSetState initialState,
    required this.startupData,
  }) : super(initialState);

  /// See the docs for [PinnedExecutableSetState.pinnedExecutableListEvent] for why we need
  /// such a method and when to call it.
  void clearPinnedExecutanleListEvent() {
    emit(state.copyWith(pinnedExecutableListEventGetter: () => null));
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

          final stateWithExistingExecutableRemoved = await state
              .copyWithPinnedExecutableRemoved(
                windowsPathToExecutable:
                    executablePinnedInTempDir.windowsPathToExecutable,
              );

          if (isClosed) {
            return;
          }

          if (stateWithExistingExecutableRemoved.pinnedExecutableListEvent !=
              null) {
            emit(stateWithExistingExecutableRemoved);
          }

          final stateWithNewExecutableAdded = await state
              .copyWithAdditionalPinnedExecutable(executablePinnedInTempDir);

          if (isClosed) {
            return;
          }

          emit(stateWithNewExecutableAdded);
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

          final stateWithPinnedExecutableRemoved = await state
              .copyWithPinnedExecutableRemoved(
                windowsPathToExecutable:
                    pinnedExecutable.windowsPathToExecutable,
              );

          if (isClosed) {
            return;
          }

          emit(stateWithPinnedExecutableRemoved);
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
}
