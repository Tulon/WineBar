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

import 'package:get_it/get_it.dart';
import 'package:winebar/models/suppressable_warning.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/utils/startup_data.dart';

enum WineArchWarning {
  /// See [SuppressableWarning.wow64ModeUnderEmulation].
  wow64ModeUnderEmulation(
    suppressableWarning: SuppressableWarning.wow64ModeUnderEmulation,
  ),

  /// See [SuppressableWarning.nonWow64ModesRequire32BitLibs].
  nonWow64ModesRequire32BitLibs(
    suppressableWarning: SuppressableWarning.nonWow64ModesRequire32BitLibs,
  );

  final SuppressableWarning? suppressableWarning;

  const WineArchWarning({this.suppressableWarning});
}

/// Dual mode Wine builds are those that support both win64 and wow64 modes
/// (think GE Proton). Whichever mode is selected, a warning may be raised,
/// unless it's suppressed in settings. This function returns the warning
/// to show to the user. Suppressed warnings are not returned.
///
/// If [wow64ModeSelected] is null, that indicates the selected Wine build
/// is not a dual mode one. In such a case, this function returns null.
WineArchWarning? wineArchWarningToShowForDualModeBuild({
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
