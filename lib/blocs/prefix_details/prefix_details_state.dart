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
import 'package:winebar/models/wine_prefix.dart';

@immutable
class PrefixDetailsState extends Equatable {
  final WinePrefix prefix;
  final bool fileSelectionInProgress;

  const PrefixDetailsState({
    required this.prefix,
    required this.fileSelectionInProgress,
  });

  const PrefixDetailsState.initialState({required WinePrefix prefix})
    : this(prefix: prefix, fileSelectionInProgress: false);

  @override
  List<Object?> get props => [prefix, fileSelectionInProgress];

  PrefixDetailsState copyWith({
    WinePrefix? prefix,
    bool? fileSelectionInProgress,
  }) {
    return PrefixDetailsState(
      prefix: prefix ?? this.prefix,
      fileSelectionInProgress:
          fileSelectionInProgress ?? this.fileSelectionInProgress,
    );
  }
}
