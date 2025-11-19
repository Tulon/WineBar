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
import 'package:winebar/blocs/prefix_list/prefix_list_state.dart';
import 'package:winebar/blocs/pinned_executable_set/pinned_executable_set_state.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';

import '../../models/wine_prefix.dart';

class PrefixListBloc extends Cubit<PrefixListState> {
  final logger = GetIt.I.get<Logger>();

  /// Prefix deletion operations are asynchronous but need to be executed
  /// sequentially. This future corresponds to the completion of the last
  /// of them.
  var _lastPrefixDeletionOperationCompletion = Future<void>.value();

  CancelableOperation<PinnedExecutableSetState>?
  _ongoingPinnedExecutablesLoadingOp;

  PrefixListBloc(List<WinePrefix> prefixes)
    : super(PrefixListState.initialState(prefixes: prefixes));

  /// See the docs for [PrefixListState.prefixListEvent] for why we need
  /// such a method and when to call it.
  void clearPrefixListEvent() {
    emit(state.copyWith(prefixListEventGetter: () => null));
  }

  void addPrefix(WinePrefix newPrefix) {
    // Just in case such prefix was already there.
    emit(
      state.copyWithPrefixRemoved(
        prefixOuterDir: newPrefix.dirStructure.outerDir,
      ),
    );

    emit(state.copyWithAdditionalPrefix(newPrefix));
  }

  void startDeletingPrefix(WinePrefix prefixToDelete) {
    unawaited(_deletePrefix(prefixToDelete));
  }

  Future<void> _deletePrefix(WinePrefix prefixToDelete) async {
    _lastPrefixDeletionOperationCompletion = _lastPrefixDeletionOperationCompletion
        .then((_) async {
          await recursiveDeleteAndLogErrors(
            Directory(prefixToDelete.dirStructure.outerDir),
          );

          if (isClosed) {
            return;
          }

          emit(
            state.copyWithPrefixRemoved(
              prefixOuterDir: prefixToDelete.dirStructure.outerDir,
            ),
          );
        })
        .catchError((e, stackTrace) {
          logger.e(
            'Failed to delete prefix at ${prefixToDelete.dirStructure.outerDir}',
            error: e,
            stackTrace: stackTrace,
          );
        });
  }

  Future<PinnedExecutableSetState?> startLoadingPinnedExecutablesFor(
    WinePrefix prefix,
  ) async {
    if (_ongoingPinnedExecutablesLoadingOp != null) {
      await _ongoingPinnedExecutablesLoadingOp!.cancel();
    }

    _ongoingPinnedExecutablesLoadingOp = CancelableOperation.fromFuture(
      PinnedExecutableSetState.loadFromDisk(prefix.dirStructure.pinsDir),
    );

    try {
      return await _ongoingPinnedExecutablesLoadingOp!.value;
    } catch (e, stackTrace) {
      logger.e(
        'Failed to load the list of pinned executables',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    } finally {
      _ongoingPinnedExecutablesLoadingOp = null;
    }
  }
}
