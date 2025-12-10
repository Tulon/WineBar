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

import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
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
}

class _AppSettingsService implements AppSettingsService {
  final LocalStoragePaths localStoragePaths;
  Future<void> _lastSettingsFileWriteCompletion = Future.value();

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

    _scheduleWritingSettingsFile();
  }

  void _scheduleWritingSettingsFile() {
    _lastSettingsFileWriteCompletion = _lastSettingsFileWriteCompletion
        .then<void>(
          (_) => File(
            localStoragePaths.settingsJsonFilePath,
          ).writeAsString(settings.toJsonString()),
        )
        .catchError((e, stackTrace) {
          GetIt.I.get<Logger>().e(
            'Failed to write the settings file',
            error: e,
            stackTrace: stackTrace,
          );
        });
  }
}
