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
import 'package:winebar/models/process_output.dart';

@immutable
class SpecialExecutableState extends Equatable {
  final bool isRunning;
  final ProcessOutput? processOutput;

  const SpecialExecutableState({
    required this.isRunning,
    required this.processOutput,
  });

  const SpecialExecutableState.defaultState()
    : this(isRunning: false, processOutput: null);

  @override
  List<Object?> get props => [isRunning, processOutput];

  SpecialExecutableState copyWith({
    bool? isRunning,
    ValueGetter<ProcessOutput?>? processOutputGetter,
  }) {
    return SpecialExecutableState(
      isRunning: isRunning ?? this.isRunning,
      processOutput: processOutputGetter != null
          ? processOutputGetter()
          : processOutput,
    );
  }
}
