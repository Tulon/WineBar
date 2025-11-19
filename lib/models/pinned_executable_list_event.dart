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
import 'package:winebar/models/pinned_executable.dart';

@immutable
sealed class PinnedExecutableListEvent {}

class PinnedExecutableAddedEvent extends Equatable
    implements PinnedExecutableListEvent {
  /// The zero-based index of the pinned executable that was just added.
  final int pinnedExecutableIndex;

  const PinnedExecutableAddedEvent({required this.pinnedExecutableIndex});

  @override
  List<Object?> get props => [pinnedExecutableIndex];
}

@immutable
class PinnedExecutableRemovedEvent extends Equatable
    implements PinnedExecutableListEvent {
  /// The zero-based index of the pinned executable that just got removed.
  final int pinnedExecutableIndex;

  final PinnedExecutable removedPinnedExecutable;

  const PinnedExecutableRemovedEvent({
    required this.pinnedExecutableIndex,
    required this.removedPinnedExecutable,
  });

  @override
  List<Object> get props => [pinnedExecutableIndex, removedPinnedExecutable];
}
