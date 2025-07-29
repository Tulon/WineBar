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
import 'package:meta/meta.dart';
import 'package:winebar/models/pinned_executable_set.dart';

@immutable
class PrefixDetailsState extends Equatable {
  final bool fileSelectionInProgress;
  final PinnedExecutableSet pinnedExecutables;

  const PrefixDetailsState({
    required this.fileSelectionInProgress,
    required this.pinnedExecutables,
  });

  const PrefixDetailsState.initialState({
    required PinnedExecutableSet pinnedExecutables,
  }) : this(
         fileSelectionInProgress: false,
         pinnedExecutables: pinnedExecutables,
       );

  @override
  List<Object> get props => [fileSelectionInProgress, pinnedExecutables];

  PrefixDetailsState copyWith({
    bool? fileSelectionInProgress,
    PinnedExecutableSet? pinnedExecutables,
  }) {
    return PrefixDetailsState(
      fileSelectionInProgress:
          fileSelectionInProgress ?? this.fileSelectionInProgress,
      pinnedExecutables: pinnedExecutables ?? this.pinnedExecutables,
    );
  }
}
