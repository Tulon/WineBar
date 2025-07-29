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

import '../../models/wine_build.dart';
import '../../models/wine_build_source.dart';
import '../../models/wine_release.dart';

enum PrefixCreationStep {
  selectWineBuildSource,
  selectWineRelease,
  selectWineBuild,
  setOptions,
}

enum PrefixCreationStatus {
  notStarted,
  downloadingAndExtractingWineBuild,
  creatingWinePrefix,
  failed,
  succeeded;

  bool get isInProgress {
    switch (this) {
      case notStarted:
      case failed:
      case succeeded:
        return false;
      case downloadingAndExtractingWineBuild:
      case creatingWinePrefix:
        return true;
    }
  }
}

@immutable
class PrefixCreationState extends Equatable {
  final PrefixCreationStep currentStep;
  final PrefixCreationStep maxAccessibleStep;
  final bool wineBuildsFetchingInProgress;
  final String? wineBuildsFetchingErrorMessage;
  final WineBuildSource? selectedBuildSource;
  final List<WineRelease> wineReleasesToSelectFrom;
  final WineRelease? selectedWineRelease;
  final List<WineBuild> wineBuildsToSelectFrom;
  final WineBuild? selectedWineBuild;
  final String prefixName;
  final String? prefixNameErrorMessage;
  final double hiDpiScale;
  final PrefixCreationStatus prefixCreationStatus;
  final String? prefixCreationFailureMessage;

  /// Corresponds to a progress (between 0 and 1) in those states
  /// where prefixCretionStatus.isInProgress is true. A null value
  /// is allowed in those states and indicates the exact progress
  /// is not available.
  final double? prefixCreationOperationProgress;

  PrefixCreationState({
    required this.currentStep,
    required this.maxAccessibleStep,
    required this.wineBuildsFetchingInProgress,
    required this.wineBuildsFetchingErrorMessage,
    required this.selectedBuildSource,
    required this.wineReleasesToSelectFrom,
    required this.selectedWineRelease,
    required this.wineBuildsToSelectFrom,
    required this.selectedWineBuild,
    required this.prefixName,
    required this.prefixNameErrorMessage,
    required this.hiDpiScale,
    required this.prefixCreationStatus,
    required this.prefixCreationFailureMessage,
    required this.prefixCreationOperationProgress,
  }) {
    assert(currentStep.index <= maxAccessibleStep.index);
  }

  PrefixCreationState.defaultState()
    : this(
        currentStep: PrefixCreationStep.values.first,
        maxAccessibleStep: PrefixCreationStep.values.first,
        wineBuildsFetchingInProgress: false,
        wineBuildsFetchingErrorMessage: null,
        selectedBuildSource: null,
        wineReleasesToSelectFrom: const [],
        selectedWineRelease: null,
        wineBuildsToSelectFrom: const [],
        selectedWineBuild: null,
        prefixName: '',
        prefixNameErrorMessage: null,
        hiDpiScale: 1.0,
        prefixCreationStatus: PrefixCreationStatus.notStarted,
        prefixCreationFailureMessage: null,
        prefixCreationOperationProgress: null,
      );

  @override
  List<Object?> get props => [
    currentStep,
    maxAccessibleStep,
    wineBuildsFetchingInProgress,
    wineBuildsFetchingErrorMessage,
    selectedBuildSource,
    wineReleasesToSelectFrom,
    selectedWineRelease,
    wineBuildsToSelectFrom,
    selectedWineBuild,
    prefixName,
    prefixNameErrorMessage,
    hiDpiScale,
    prefixCreationStatus,
    prefixCreationFailureMessage,
    prefixCreationOperationProgress,
  ];

  PrefixCreationState copyWith({
    PrefixCreationStep? currentStep,
    PrefixCreationStep? maxAccessibleStep,
    bool? wineBuildsFetchingInProgress,
    ValueGetter<String?>? wineBuildsFetchingErrorMessageGetter,
    ValueGetter<WineBuildSource?>? selectedBuildSourceGetter,
    List<WineRelease>? wineReleasesToSelectFrom,
    ValueGetter<WineRelease?>? selectedWineReleaseGetter,
    List<WineBuild>? wineBuildsToSelectFrom,
    ValueGetter<WineBuild?>? selectedWineBuildGetter,
    String? prefixName,
    ValueGetter<String?>? prefixNameErrorMessageGetter,
    double? hiDpiScale,
    PrefixCreationStatus? prefixCreationStatus,
    ValueGetter<String?>? prefixCreationFailureMessageGetter,
    ValueGetter<double?>? prefixCreationOperationProgressGetter,
  }) {
    return PrefixCreationState(
      currentStep: currentStep ?? this.currentStep,
      maxAccessibleStep: maxAccessibleStep ?? this.maxAccessibleStep,
      wineBuildsFetchingInProgress:
          wineBuildsFetchingInProgress ?? this.wineBuildsFetchingInProgress,
      wineBuildsFetchingErrorMessage:
          wineBuildsFetchingErrorMessageGetter != null
          ? wineBuildsFetchingErrorMessageGetter()
          : wineBuildsFetchingErrorMessage,
      selectedBuildSource: selectedBuildSourceGetter != null
          ? selectedBuildSourceGetter()
          : selectedBuildSource,
      wineReleasesToSelectFrom:
          wineReleasesToSelectFrom ?? this.wineReleasesToSelectFrom,
      selectedWineRelease: selectedWineReleaseGetter != null
          ? selectedWineReleaseGetter()
          : selectedWineRelease,
      wineBuildsToSelectFrom:
          wineBuildsToSelectFrom ?? this.wineBuildsToSelectFrom,
      selectedWineBuild: selectedWineBuildGetter != null
          ? selectedWineBuildGetter()
          : selectedWineBuild,
      prefixName: prefixName ?? this.prefixName,
      prefixNameErrorMessage: prefixNameErrorMessageGetter != null
          ? prefixNameErrorMessageGetter()
          : prefixNameErrorMessage,
      hiDpiScale: hiDpiScale ?? this.hiDpiScale,
      prefixCreationStatus: prefixCreationStatus ?? this.prefixCreationStatus,
      prefixCreationFailureMessage: prefixCreationFailureMessageGetter != null
          ? prefixCreationFailureMessageGetter()
          : prefixCreationFailureMessage,
      prefixCreationOperationProgress:
          prefixCreationOperationProgressGetter != null
          ? prefixCreationOperationProgressGetter()
          : prefixCreationOperationProgress,
    );
  }
}
