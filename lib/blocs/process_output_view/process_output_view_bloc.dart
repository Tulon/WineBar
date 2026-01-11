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

import '../../models/process_output.dart';
import 'process_output_view_state.dart';

class ProcessOutputViewBloc extends Cubit<ProcessOutputViewState> {
  ProcessOutputViewBloc({required ProcessOutput processOutput})
    : super(
        ProcessOutputViewState(
          processOutput: processOutput,
          selectedLogIndex: processOutput.logs.isEmpty ? null : 0,
        ),
      );

  void setSelectedLogIndex(int logIndex) {
    if (logIndex != state.selectedLogIndex) {
      emit(state.copyWith(selectedLogIndexGetter: () => logIndex));
    }
  }
}
