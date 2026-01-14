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

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:winebar/blocs/prefix_list_item/prefix_list_item_state.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/services/running_wine_processes_tracker.dart';

class PrefixListItemBloc extends Cubit<PrefixListItemState> {
  final _runningProcessesTracker = GetIt.I.get<RunningWineProcessesTracker>();
  final WinePrefixId _prefixId;

  PrefixListItemBloc({required int prefixId})
    : _prefixId = prefixId,
      super(
        PrefixListItemState.initialState(
          numAppsRunning: GetIt.I
              .get<RunningWineProcessesTracker>()
              .numProcessesRunningInPrefix(prefixId),
        ),
      ) {
    _runningProcessesTracker.addListener(_onProcessStartedOrStopped);
  }

  @override
  Future<void> close() {
    _runningProcessesTracker.removeListener(_onProcessStartedOrStopped);
    return super.close();
  }

  void setPrefixBeingDeleted(bool prefixBeingDeleted) {
    if (state.isPrefixBeingDeleted != prefixBeingDeleted) {
      emit(state.copyWith(isPrefixBeingDeleted: prefixBeingDeleted));
    }
  }

  void _onProcessStartedOrStopped() {
    emit(
      state.copyWith(
        numAppsRunning: _runningProcessesTracker.numProcessesRunningInPrefix(
          _prefixId,
        ),
      ),
    );
  }
}
