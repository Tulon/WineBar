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

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:winebar/utils/cast_or_null.dart';

@immutable
class DonationSolicitationState extends Equatable {
  final int lastSolicitationUnixTimestamp;
  final int windowsAppsRunTimeSecSinceLastSolicitation;

  static final String _lastSolicitationUnixTimestampKey =
      "lastSolicitationUnixTimestamp";
  static final String _windowsAppsRunTimeSecSinceLastSolicitationKey =
      "windowsAppsRunTimeSecSinceLastSolicitation";

  const DonationSolicitationState({
    required this.lastSolicitationUnixTimestamp,
    required this.windowsAppsRunTimeSecSinceLastSolicitation,
  });

  factory DonationSolicitationState.initialState() {
    return DonationSolicitationState.fromJson(null);
  }

  @override
  List<Object?> get props => [
    lastSolicitationUnixTimestamp,
    windowsAppsRunTimeSecSinceLastSolicitation,
  ];

  int get secondsSinceLastSolicitation {
    return DateTime.timestamp().millisecondsSinceEpoch ~/ 1000 -
        lastSolicitationUnixTimestamp;
  }

  factory DonationSolicitationState.fromJson(Map<String, dynamic>? json) {
    int? lastSolicitationUnixTimestamp = json == null
        ? null
        : castOrNull<int>(json[_lastSolicitationUnixTimestampKey]);

    int? windowsAppsRunTimeSecSinceLastSolicitation = json == null
        ? null
        : castOrNull<int>(json[_windowsAppsRunTimeSecSinceLastSolicitationKey]);

    return DonationSolicitationState(
      lastSolicitationUnixTimestamp:
          lastSolicitationUnixTimestamp ??
          DateTime.timestamp().millisecondsSinceEpoch ~/ 1000,
      windowsAppsRunTimeSecSinceLastSolicitation:
          windowsAppsRunTimeSecSinceLastSolicitation ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _lastSolicitationUnixTimestampKey: lastSolicitationUnixTimestamp,
      _windowsAppsRunTimeSecSinceLastSolicitationKey:
          windowsAppsRunTimeSecSinceLastSolicitation,
    };
  }

  DonationSolicitationState copyWith({
    int? lastSolicitationUnixTimestamp,
    int? windowsAppsRunTimeSecSinceLastSolicitation,
  }) {
    return DonationSolicitationState(
      lastSolicitationUnixTimestamp:
          lastSolicitationUnixTimestamp ?? this.lastSolicitationUnixTimestamp,
      windowsAppsRunTimeSecSinceLastSolicitation:
          windowsAppsRunTimeSecSinceLastSolicitation ??
          this.windowsAppsRunTimeSecSinceLastSolicitation,
    );
  }
}
