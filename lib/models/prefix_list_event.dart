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
import 'package:winebar/models/wine_prefix.dart';

@immutable
sealed class PrefixListEvent {}

class PrefixAddedEvent extends Equatable implements PrefixListEvent {
  /// The zero-based index of the prefix that was just added.
  final int prefixIndex;

  final bool animatedInsertion;

  const PrefixAddedEvent({
    required this.prefixIndex,
    required this.animatedInsertion,
  });

  @override
  List<Object?> get props => [prefixIndex, animatedInsertion];
}

@immutable
class PrefixRemovedEvent extends Equatable implements PrefixListEvent {
  /// The zero-based index of the prefix that just got removed.
  final int prefixIndex;

  final WinePrefix removedPrefix;

  final bool animatedRemoval;

  const PrefixRemovedEvent({
    required this.prefixIndex,
    required this.removedPrefix,
    required this.animatedRemoval,
  });

  @override
  List<Object> get props => [prefixIndex, removedPrefix, animatedRemoval];
}
