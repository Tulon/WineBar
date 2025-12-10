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
import 'package:winebar/models/settings_json_file.dart';
import 'package:winebar/models/wine_arch_warning.dart';
import 'package:winebar/services/wine_process_runner_service.dart';

import '../../models/wine_build.dart';
import '../../models/wine_build_source.dart';
import '../../models/wine_release.dart';

enum PrefixCreationStep {
  selectWineBuildSource,
  selectWineRelease,
  selectWineBuild,
  setOptions,
}

PrefixCreationStep laterPrefixCreatonStepOfTwo(
  PrefixCreationStep a,
  PrefixCreationStep b,
) {
  return a.index > b.index ? a : b;
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

  /// Depending on the type of the selected build (win32, win64, wow64,
  /// win64/wow64 switchable), a warning may be raised. This field stores
  /// that warning, unless the warning in question is suppressed via
  /// [SettingsJsonFile.suppressedWarnings].
  final WineArchWarning? selectedWineBuildArchWarning;

  /// If set to true, [selectedWineBuildArchWarning.suppressableWarning] is to
  /// be suppressed when the 'Proceed Anyway' button is pressed. If
  /// [selectedWineBuildArchWarning] is null or
  /// [selectedWineBuildArchWarning.suppressableWarning] is null, this value
  /// plays no role.
  final bool selectedWineBuildArchWarningToBeSuppressed;

  final String prefixName;
  final String? prefixNameErrorMessage;
  final double hiDpiScale;

  /// Whether to use the wow64 mode on Wine builds that support both the
  /// win64 and the wow64 modes (think GE Proton).  Null here indicates that
  /// we are creating a prefix that uses a Wine build that only supports a
  /// single mode.
  final bool? wow64ModePreferred;

  /// On Wine builds that support both the win64 and the wow64 modes (think
  /// GE Proton), whether [wow64ModePreferred] is set to true or to false,
  /// a warning may be raised. This field stores that warning, unless the
  /// warning in question is suppressed via
  /// [SettingsJsonFile.suppressedWarnings].
  final WineArchWarning? wow64ModePreferenceWarning;

  /// If set to true, [wow64ModePreferenceWarning.suppressableWarning] is to
  /// be suppressed at prefix creation time. If [wow64ModePreferenceWarning]
  /// is null or [wow64ModePreferenceWarning.suppressableWarning] is null,
  /// this value plays no role.
  final bool wow64ModePreferenceWarningToBeSuppressed;

  final PrefixCreationStatus prefixCreationStatus;
  final String? prefixCreationFailureMessage;
  final WineProcessResult? prefixCreationFailedProcessResult;

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
    required this.selectedWineBuildArchWarning,
    required this.selectedWineBuildArchWarningToBeSuppressed,
    required this.prefixName,
    required this.prefixNameErrorMessage,
    required this.hiDpiScale,
    required this.wow64ModePreferred,
    required this.wow64ModePreferenceWarning,
    required this.wow64ModePreferenceWarningToBeSuppressed,
    required this.prefixCreationStatus,
    required this.prefixCreationFailureMessage,
    required this.prefixCreationFailedProcessResult,
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
        selectedWineBuildArchWarning: null,
        selectedWineBuildArchWarningToBeSuppressed: false,
        prefixName: '',
        prefixNameErrorMessage: null,
        hiDpiScale: 1.0,
        wow64ModePreferred: null,
        wow64ModePreferenceWarning: null,
        wow64ModePreferenceWarningToBeSuppressed: false,
        prefixCreationStatus: PrefixCreationStatus.notStarted,
        prefixCreationFailureMessage: null,
        prefixCreationFailedProcessResult: null,
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
    selectedWineBuildArchWarning,
    selectedWineBuildArchWarningToBeSuppressed,
    prefixName,
    prefixNameErrorMessage,
    hiDpiScale,
    wow64ModePreferred,
    wow64ModePreferenceWarning,
    wow64ModePreferenceWarningToBeSuppressed,
    prefixCreationStatus,
    prefixCreationFailureMessage,
    prefixCreationFailedProcessResult,
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
    ValueGetter<WineArchWarning?>? selectedWineBuildArchWarningGetter,
    bool? selectedWineBuildArchWarningToBeSuppressed,
    String? prefixName,
    ValueGetter<String?>? prefixNameErrorMessageGetter,
    double? hiDpiScale,
    ValueGetter<bool?>? wow64ModePreferredGetter,
    ValueGetter<WineArchWarning?>? wow64ModePreferenceWarningGetter,
    bool? wow64ModePreferenceWarningToBeSuppressed,
    PrefixCreationStatus? prefixCreationStatus,
    ValueGetter<String?>? prefixCreationFailureMessageGetter,
    ValueGetter<WineProcessResult?>? prefixCreationFailedProcessResultGetter,
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
      selectedWineBuildArchWarning: selectedWineBuildArchWarningGetter != null
          ? selectedWineBuildArchWarningGetter()
          : selectedWineBuildArchWarning,
      selectedWineBuildArchWarningToBeSuppressed:
          selectedWineBuildArchWarningToBeSuppressed ??
          this.selectedWineBuildArchWarningToBeSuppressed,
      prefixName: prefixName ?? this.prefixName,
      prefixNameErrorMessage: prefixNameErrorMessageGetter != null
          ? prefixNameErrorMessageGetter()
          : prefixNameErrorMessage,
      hiDpiScale: hiDpiScale ?? this.hiDpiScale,
      wow64ModePreferred: wow64ModePreferredGetter != null
          ? wow64ModePreferredGetter()
          : wow64ModePreferred,
      wow64ModePreferenceWarning: wow64ModePreferenceWarningGetter != null
          ? wow64ModePreferenceWarningGetter()
          : wow64ModePreferenceWarning,
      wow64ModePreferenceWarningToBeSuppressed:
          wow64ModePreferenceWarningToBeSuppressed ??
          this.wow64ModePreferenceWarningToBeSuppressed,
      prefixCreationStatus: prefixCreationStatus ?? this.prefixCreationStatus,
      prefixCreationFailureMessage: prefixCreationFailureMessageGetter != null
          ? prefixCreationFailureMessageGetter()
          : prefixCreationFailureMessage,
      prefixCreationFailedProcessResult:
          prefixCreationFailedProcessResultGetter != null
          ? prefixCreationFailedProcessResultGetter()
          : prefixCreationFailedProcessResult,
      prefixCreationOperationProgress:
          prefixCreationOperationProgressGetter != null
          ? prefixCreationOperationProgressGetter()
          : prefixCreationOperationProgress,
    );
  }
}
