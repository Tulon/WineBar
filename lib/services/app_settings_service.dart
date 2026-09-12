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

import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/donation_solicitation_state.dart';
import 'package:winebar/models/settings_json_file.dart';
import 'package:winebar/models/suppressable_warning.dart';
import 'package:winebar/utils/local_storage_paths.dart';

abstract interface class AppSettingsService {
  factory AppSettingsService({
    required LocalStoragePaths localStoragePaths,
    required SettingsJsonFile initialSettings,
  }) {
    return _AppSettingsService(
      localStoragePaths: localStoragePaths,
      settings: initialSettings,
    );
  }

  SettingsJsonFile get settings;

  void setWarningSuppressed(
    SuppressableWarning warning, {
    required bool suppressed,
  });

  void setDonationSolicitationState(DonationSolicitationState state);
}

class _AppSettingsService implements AppSettingsService {
  final LocalStoragePaths localStoragePaths;

  @override
  SettingsJsonFile settings;

  _AppSettingsService({
    required this.localStoragePaths,
    required this.settings,
  });

  @override
  void setWarningSuppressed(
    SuppressableWarning warning, {
    required bool suppressed,
  }) {
    settings = settings.copyWithWarningSuppressionState(
      warning,
      suppressed: suppressed,
    );

    _writeSettingsFile();
  }

  @override
  void setDonationSolicitationState(DonationSolicitationState state) {
    settings = settings.copyWith(donationSolicitationState: state);
    _writeSettingsFile();
  }

  void _writeSettingsFile() {
    try {
      // The reason we use synchronous I/O here is that we may write the settings file
      // from the AppLifecycleListener.onExitRequested callback, where you apparently
      // can't initiate unawaited asynchronous operations.
      final tempFile = File("${localStoragePaths.settingsJsonFilePath}.temp");
      tempFile.writeAsStringSync(settings.toJsonString());
      tempFile.renameSync(localStoragePaths.settingsJsonFilePath);
    } catch (e, stackTrace) {
      GetIt.I.get<Logger>().e(
        'Failed to write the settings file',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
