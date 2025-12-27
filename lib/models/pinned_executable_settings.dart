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
import 'package:winebar/utils/cast_or_null.dart';

@immutable
class PinnedExecutableSettings extends Equatable {
  /// Corresponds to [GpuInfo.deviceUuid].
  final String? desiredGpuUuid;

  // These constants should be kept in sync with those in WritePinnedExecutableJson.cpp.
  static final _desiredGpuUuidKey = 'desiredGpuUuid';

  @override
  List<Object?> get props => [desiredGpuUuid];

  const PinnedExecutableSettings({required this.desiredGpuUuid});

  const PinnedExecutableSettings.defaultSettings() : this(desiredGpuUuid: null);

  factory PinnedExecutableSettings.fromJson(Map<String, dynamic> json) {
    final desiredGpuUuid = castOrNull<String?>(json[_desiredGpuUuidKey]);

    return PinnedExecutableSettings(desiredGpuUuid: desiredGpuUuid);
  }

  Map<String, dynamic> toJson() {
    final desiredGpuUuid = this.desiredGpuUuid;

    return {if (desiredGpuUuid != null) _desiredGpuUuidKey: desiredGpuUuid};
  }

  PinnedExecutableSettings copyWith({
    ValueGetter<String?>? desiredGpuUuidGetter,
  }) {
    return PinnedExecutableSettings(
      desiredGpuUuid: desiredGpuUuidGetter != null
          ? desiredGpuUuidGetter()
          : desiredGpuUuid,
    );
  }
}
