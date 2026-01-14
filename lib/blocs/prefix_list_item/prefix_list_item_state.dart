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

@immutable
class PrefixListItemState extends Equatable {
  final int numAppsRunning;
  final bool isPrefixBeingDeleted;

  const PrefixListItemState({
    required this.numAppsRunning,
    required this.isPrefixBeingDeleted,
  });

  const PrefixListItemState.initialState({required int numAppsRunning})
    : this(numAppsRunning: numAppsRunning, isPrefixBeingDeleted: false);

  @override
  List<Object?> get props => [numAppsRunning, isPrefixBeingDeleted];

  PrefixListItemState copyWith({
    int? numAppsRunning,
    bool? isPrefixBeingDeleted,
  }) {
    return PrefixListItemState(
      numAppsRunning: numAppsRunning ?? this.numAppsRunning,
      isPrefixBeingDeleted: isPrefixBeingDeleted ?? this.isPrefixBeingDeleted,
    );
  }
}
