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
import 'package:winebar/models/d3d_8_to_11_implementation.dart';

@immutable
class ExplicitD3d8To11ImplementationState extends Equatable {
  final bool useParticularD3d8To11Implementation;
  final D3d8To11Implementation selectedD3d8To11Implementation;

  const ExplicitD3d8To11ImplementationState({
    required this.useParticularD3d8To11Implementation,
    required this.selectedD3d8To11Implementation,
  });

  const ExplicitD3d8To11ImplementationState.defaultState()
    : this(
        useParticularD3d8To11Implementation: false,
        selectedD3d8To11Implementation: D3d8To11Implementation.dxvk,
      );

  @override
  List<Object?> get props => [
    useParticularD3d8To11Implementation,
    selectedD3d8To11Implementation,
  ];

  ExplicitD3d8To11ImplementationState copyWith({
    bool? useParticularD3d8To11Implementation,
    D3d8To11Implementation? selectedD3d8To11Implementation,
  }) {
    return ExplicitD3d8To11ImplementationState(
      useParticularD3d8To11Implementation:
          useParticularD3d8To11Implementation ??
          this.useParticularD3d8To11Implementation,
      selectedD3d8To11Implementation:
          selectedD3d8To11Implementation ?? this.selectedD3d8To11Implementation,
    );
  }

  /// If a particular implementation was explicitly selected, that
  /// implementation is returned. Otherwise, null is returned.
  D3d8To11Implementation? get explicitlySelectedD3d8To11Implementation =>
      useParticularD3d8To11Implementation
      ? selectedD3d8To11Implementation
      : null;
}
