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
import 'package:winebar/models/wine_locale.dart';

@immutable
class ExplicitLocaleState extends Equatable {
  final bool useParticularLocale;
  final WineLocale? selectedLocale;

  const ExplicitLocaleState({
    required this.useParticularLocale,
    required this.selectedLocale,
  });

  const ExplicitLocaleState.initialState({required WineLocale? explicitLocale})
    : this(
        useParticularLocale: explicitLocale != null,
        selectedLocale: explicitLocale,
      );

  @override
  List<Object?> get props => [useParticularLocale, selectedLocale];

  String? get explicitLocalePosixName =>
      useParticularLocale ? selectedLocale?.posixName : null;

  ExplicitLocaleState copyWith({
    bool? useParticularLocale,
    ValueGetter<WineLocale?>? selectedLocaleGetter,
  }) {
    return ExplicitLocaleState(
      useParticularLocale: useParticularLocale ?? this.useParticularLocale,
      selectedLocale: selectedLocaleGetter != null
          ? selectedLocaleGetter()
          : selectedLocale,
    );
  }
}
