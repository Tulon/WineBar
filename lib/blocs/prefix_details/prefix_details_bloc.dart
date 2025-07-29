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
import 'package:winebar/repositories/running_pinned_executables_repo.dart';
import 'package:winebar/utils/startup_data.dart';

import '../../models/pinned_executable.dart';
import '../../models/pinned_executable_set.dart';
import 'prefix_details_state.dart';

class PrefixDetailsBloc extends Cubit<PrefixDetailsState> {
  final logger = GetIt.I.get<Logger>();
  final runningPinnedExecutablesRepo = GetIt.I
      .get<RunningPinnedExecutablesRepo>();
  final StartupData startupData;

  PrefixDetailsBloc(super.initialState, {required this.startupData});

  void setFileSelectionInProgress(bool inProgress) {
    emit(state.copyWith(fileSelectionInProgress: inProgress));
  }

  Future<void> pinExecutable(PinnedExecutable executablePinnedInTempDir) async {
    PinnedExecutableSet? newPinnedExecutables;
    try {
      newPinnedExecutables = await state.pinnedExecutables
          .copyWithAdditionalPinnedExecutable(executablePinnedInTempDir);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to add a new pinned executable',
        error: e,
        stackTrace: stackTrace,
      );
    }

    if (newPinnedExecutables != null) {
      emit(state.copyWith(pinnedExecutables: newPinnedExecutables));
    }
  }

  void initiateUnpinningExecutable(PinnedExecutable pinnedExecutable) {
    unawaited(_unpinExecutable(pinnedExecutable));
  }

  Future<void> _unpinExecutable(PinnedExecutable pinnedExecutable) async {
    // TODO: need to wait while any ongoing pinning / unpinning operation finishes.
    final newPinnedExecutables = await state.pinnedExecutables
        .copyWithPinnedExecutableRemoved(pinnedExecutable);

    emit(state.copyWith(pinnedExecutables: newPinnedExecutables));
  }
}
