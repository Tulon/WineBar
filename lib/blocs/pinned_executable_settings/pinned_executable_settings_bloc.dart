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
import 'package:winebar/blocs/pinned_executable_settings/pinned_executable_settings_state.dart';
import 'package:winebar/models/gpu_info.dart';
import 'package:winebar/models/pinned_executable_settings.dart';

class PinnedExecutableSettingsBloc
    extends Cubit<PinnedExecutableSettingsState> {
  PinnedExecutableSettingsBloc({
    required PinnedExecutableSettings settings,
    required List<GpuInfo> availableGpus,
  }) : super(
         PinnedExecutableSettingsState.fromSettings(
           settings: settings,
           availableGpus: availableGpus,
         ),
       );

  void setParticularGpuToBeUsed(bool useParticularGpu) {
    if (useParticularGpu != state.isParticularGpuToBeUsed) {
      emit(state.copyWith(isParticularGpuToBeUsed: useParticularGpu));
    }
  }

  void setSelectedGpu(GpuInfo? selectedGpu) {
    if (selectedGpu != state.selectedGpu) {
      emit(state.copyWith(selectedGpuGetter: () => selectedGpu));
    }
  }
}
