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
import 'package:winebar/models/process_log.dart';

import 'process_logs_view_state.dart';

class ProcessLogsViewBloc extends Cubit<ProcessLogsViewState> {
  ProcessLogsViewBloc({required List<ProcessLog> processLogs})
    : super(
        ProcessLogsViewState(
          processLogs: processLogs,
          selectedLogIndex: processLogs.isEmpty ? null : 0,
        ),
      );

  void setSelectedLogIndex(int logIndex) {
    if (logIndex != state.selectedLogIndex) {
      emit(state.copyWith(selectedLogIndexGetter: () => logIndex));
    }
  }
}
