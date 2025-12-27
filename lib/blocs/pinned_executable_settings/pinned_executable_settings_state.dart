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

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:winebar/models/gpu_info.dart';
import 'package:winebar/models/pinned_executable_settings.dart';

@immutable
class PinnedExecutableSettingsState extends Equatable {
  final bool isParticularGpuToBeUsed;
  final GpuInfo? selectedGpu;

  @override
  List<Object?> get props => [isParticularGpuToBeUsed, selectedGpu];

  const PinnedExecutableSettingsState._({
    required this.isParticularGpuToBeUsed,
    required this.selectedGpu,
  });

  factory PinnedExecutableSettingsState.fromSettings({
    required PinnedExecutableSettings settings,
    required List<GpuInfo> availableGpus,
  }) {
    final selectedGpu = availableGpus
        .where((gpu) => gpu.deviceUuid == settings.desiredGpuUuid)
        .firstOrNull;

    return PinnedExecutableSettingsState._(
      isParticularGpuToBeUsed: selectedGpu != null,
      selectedGpu: selectedGpu ?? availableGpus.firstOrNull,
    );
  }

  PinnedExecutableSettings toSettings() {
    return PinnedExecutableSettings(
      desiredGpuUuid:
          (isParticularGpuToBeUsed ? selectedGpu : null)?.deviceUuid,
    );
  }

  PinnedExecutableSettingsState copyWith({
    bool? isParticularGpuToBeUsed,
    ValueGetter<GpuInfo?>? selectedGpuGetter,
  }) {
    return PinnedExecutableSettingsState._(
      isParticularGpuToBeUsed:
          isParticularGpuToBeUsed ?? this.isParticularGpuToBeUsed,
      selectedGpu: selectedGpuGetter != null
          ? selectedGpuGetter()
          : selectedGpu,
    );
  }
}
