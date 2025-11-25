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

enum PrefixUpdateStatus {
  notStarted,
  validationFailed,
  inProgress,
  failed,
  succeeded,
}

@immutable
class PrefixSettingsState extends Equatable {
  final double? hiDpiScale;
  final PrefixUpdateStatus prefixUpdateStatus;
  final String? prefixUpdateFailureMessage;

  const PrefixSettingsState({
    required this.hiDpiScale,
    required this.prefixUpdateStatus,
    required this.prefixUpdateFailureMessage,
  });

  const PrefixSettingsState.initialState({required double? hiDpiScale})
    : this(
        hiDpiScale: hiDpiScale,
        prefixUpdateStatus: PrefixUpdateStatus.notStarted,
        prefixUpdateFailureMessage: null,
      );

  @override
  List<Object?> get props => [
    hiDpiScale,
    prefixUpdateStatus,
    prefixUpdateFailureMessage,
  ];

  PrefixSettingsState copyWith({
    ValueGetter<double?>? hiDpiScaleGetter,
    PrefixUpdateStatus? prefixUpdateStatus,
    ValueGetter<String?>? prefixUpdateFailureMessageGetter,
  }) {
    return PrefixSettingsState(
      hiDpiScale: hiDpiScaleGetter != null ? hiDpiScaleGetter() : hiDpiScale,
      prefixUpdateStatus: prefixUpdateStatus ?? this.prefixUpdateStatus,
      prefixUpdateFailureMessage: prefixUpdateFailureMessageGetter != null
          ? prefixUpdateFailureMessageGetter()
          : prefixUpdateFailureMessage,
    );
  }
}
