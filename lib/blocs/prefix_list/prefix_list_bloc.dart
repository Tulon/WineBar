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
import 'package:winebar/models/pinned_executable_set.dart';

import '../../models/wine_prefix.dart';

class PrefixListBloc extends Cubit<List<WinePrefix>> {
  final logger = GetIt.I.get<Logger>();

  CancelableOperation<PinnedExecutableSet>? _ongoingPinnedExecutablesLoadingOp;

  PrefixListBloc(super.initialState);

  void addPrefix(WinePrefix prefix) {
    emit([...state, prefix]);
  }

  void startDeletingPrefix(WinePrefix prefixToDelete) {
    unawaited(
      _deletePrefixDirectory(prefixToDelete)
          .then((_) {
            emit(state.where((prefix) => prefix != prefixToDelete).toList());
          })
          .onError((e, stackTrace) {
            logger.e(
              'Failed to delete wine prefix "${prefixToDelete.descriptor.name}"',
              error: e,
              stackTrace: stackTrace,
            );
          }),
    );
  }

  Future<void> _deletePrefixDirectory(WinePrefix prefix) async {
    await Directory(prefix.dirStructure.outerDir).delete(recursive: true);
  }

  Future<PinnedExecutableSet?> startLoadingPinnedExecutablesFor(
    WinePrefix prefix,
  ) async {
    if (_ongoingPinnedExecutablesLoadingOp != null) {
      await _ongoingPinnedExecutablesLoadingOp!.cancel();
    }

    _ongoingPinnedExecutablesLoadingOp = CancelableOperation.fromFuture(
      PinnedExecutableSet.loadFromDisk(prefix.dirStructure.pinsDir),
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
