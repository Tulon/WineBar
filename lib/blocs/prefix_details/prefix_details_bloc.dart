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

import 'package:bloc/bloc.dart';
import 'package:winebar/models/wine_prefix.dart';

import 'prefix_details_state.dart';

class PrefixDetailsBloc extends Cubit<PrefixDetailsState> {
  PrefixDetailsBloc({required WinePrefix prefix})
    : super(PrefixDetailsState.initialState(prefix: prefix));

  void updatePrefix(WinePrefix prefix) {
    emit(state.copyWith(prefix: prefix));
  }

  void setFileSelectionInProgress(bool inProgress) {
    emit(state.copyWith(fileSelectionInProgress: inProgress));
  }
}
