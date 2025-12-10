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
import 'package:get_it/get_it.dart';
import 'package:winebar/models/settings_json_file.dart';
import 'package:winebar/models/wine_arch_warning.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/startup_data.dart';

enum PrefixUpdateStatus {
  notStarted,
  validationFailed,
  inProgress,
  failed,
  succeeded,
}

@immutable
class PrefixSettingsState extends Equatable {
  final double? hiDpiScale;

  /// Whether to use the wow64 mode on Wine builds that support both the
  /// win64 and the wow64 modes (think GE Proton).  Null here indicates that
  /// we are updating a prefix that uses a Wine build that only supports a
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

  final PrefixUpdateStatus prefixUpdateStatus;
  final String? prefixUpdateFailureMessage;
  final WineProcessResult? prefixUpdateFailedProcessResult;

  const PrefixSettingsState({
    required this.hiDpiScale,
    required this.wow64ModePreferred,
    required this.wow64ModePreferenceWarning,
    required this.wow64ModePreferenceWarningToBeSuppressed,
    required this.prefixUpdateStatus,
    required this.prefixUpdateFailureMessage,
    required this.prefixUpdateFailedProcessResult,
  });

  PrefixSettingsState.initialState({
    required StartupData startupData,
    required double? hiDpiScale,
    required bool? wow64ModePreferred,
  }) : this(
         hiDpiScale: hiDpiScale,
         wow64ModePreferred: wow64ModePreferred,
         wow64ModePreferenceWarning: _determineWineArchWarningForDualModeBuild(
           startupData: startupData,
           wow64ModeSelected: wow64ModePreferred,
         ),
         wow64ModePreferenceWarningToBeSuppressed: false,
         prefixUpdateStatus: PrefixUpdateStatus.notStarted,
         prefixUpdateFailureMessage: null,
         prefixUpdateFailedProcessResult: null,
       );

  @override
  List<Object?> get props => [
    hiDpiScale,
    wow64ModePreferred,
    wow64ModePreferenceWarning,
    wow64ModePreferenceWarningToBeSuppressed,
    prefixUpdateStatus,
    prefixUpdateFailureMessage,
    prefixUpdateFailedProcessResult,
  ];

  PrefixSettingsState copyWith({
    ValueGetter<double?>? hiDpiScaleGetter,
    ValueGetter<bool?>? wow64ModePreferredGetter,
    ValueGetter<WineArchWarning?>? wow64ModePreferenceWarningGetter,
    bool? wow64ModePreferenceWarningToBeSuppressed,
    PrefixUpdateStatus? prefixUpdateStatus,
    ValueGetter<String?>? prefixUpdateFailureMessageGetter,
    ValueGetter<WineProcessResult?>? prefixUpdateFailedProcessResultGetter,
  }) {
    return PrefixSettingsState(
      hiDpiScale: hiDpiScaleGetter != null ? hiDpiScaleGetter() : hiDpiScale,
      wow64ModePreferred: wow64ModePreferredGetter != null
          ? wow64ModePreferredGetter()
          : wow64ModePreferred,
      wow64ModePreferenceWarning: wow64ModePreferenceWarningGetter != null
          ? wow64ModePreferenceWarningGetter()
          : wow64ModePreferenceWarning,
      wow64ModePreferenceWarningToBeSuppressed:
          wow64ModePreferenceWarningToBeSuppressed ??
          this.wow64ModePreferenceWarningToBeSuppressed,
      prefixUpdateStatus: prefixUpdateStatus ?? this.prefixUpdateStatus,
      prefixUpdateFailureMessage: prefixUpdateFailureMessageGetter != null
          ? prefixUpdateFailureMessageGetter()
          : prefixUpdateFailureMessage,
      prefixUpdateFailedProcessResult:
          prefixUpdateFailedProcessResultGetter != null
          ? prefixUpdateFailedProcessResultGetter()
          : prefixUpdateFailedProcessResult,
    );
  }

  /// If [wow64ModeSelected] is null, that indicates the selected Wine build
  /// is not a dual mode win64/wow64 one. In such a case, this function
  /// returns null.
  static WineArchWarning? _determineWineArchWarningForDualModeBuild({
    required StartupData startupData,
    required bool? wow64ModeSelected,
  }) {
    WineArchWarning? modeWarning;

    final appSettingsService = GetIt.I.get<AppSettingsService>();

    void setWarningUnlessSuppressed(WineArchWarning warning) {
      final suppressableWarning = warning.suppressableWarning;
      if (suppressableWarning != null) {
        if (!appSettingsService.settings.isWarningSuppressed(
          suppressableWarning,
        )) {
          modeWarning = warning;
        }
      }
    }

    if (wow64ModeSelected == true) {
      if (!startupData.isIntelHost) {
        setWarningUnlessSuppressed(WineArchWarning.wow64ModeUnderEmulation);
      }
    } else if (wow64ModeSelected == false) {
      setWarningUnlessSuppressed(WineArchWarning.nonWow64ModesRequire32BitLibs);
    }

    return modeWarning;
  }
}
