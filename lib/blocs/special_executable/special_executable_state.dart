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
import 'package:flutter/foundation.dart';
import 'package:winebar/models/process_log.dart';

@immutable
class SpecialExecutableState extends Equatable {
  final bool isRunning;

  /// This field will be set when the process finishes.
  final List<ProcessLog>? processLogs;

  const SpecialExecutableState({
    required this.isRunning,
    required this.processLogs,
  });

  const SpecialExecutableState.defaultState()
    : this(isRunning: false, processLogs: null);

  @override
  List<Object?> get props => [isRunning, processLogs];

  SpecialExecutableState copyWith({
    bool? isRunning,
    ValueGetter<List<ProcessLog>?>? processLogsGetter,
  }) {
    return SpecialExecutableState(
      isRunning: isRunning ?? this.isRunning,
      processLogs: processLogsGetter != null
          ? processLogsGetter()
          : processLogs,
    );
  }
}
