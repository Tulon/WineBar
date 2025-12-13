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

import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:winebar/models/suppressable_warning.dart';
import 'package:winebar/utils/app_info.dart';
import 'package:winebar/utils/cast_or_null.dart';
import 'package:winebar/utils/settings_file_helper.dart';

/// Represents the contents of the settings.json file located at the root of
/// the app's data directory.
@immutable
class SettingsJsonFile extends Equatable {
  /// See [AppInfo.appPackageId].
  final String appPackageId;

  final Set<SuppressableWarning> suppressedWarnings;

  static final _appPackageIdKey = 'appPackageId';
  static final _suppressedWarningsKey = 'suppressedWarnings';

  const SettingsJsonFile({
    required this.appPackageId,
    required this.suppressedWarnings,
  });

  @override
  List<Object> get props => [appPackageId, suppressedWarnings];

  factory SettingsJsonFile._fromJsonString(
    String jsonString, {
    required SettingsFileHelper settingsFileHelper,
  }) {
    return SettingsJsonFile._fromJson(
      jsonDecode(jsonString),
      settingsFileHelper: settingsFileHelper,
    );
  }

  factory SettingsJsonFile._fromJson(
    Map<String, dynamic> json, {
    required SettingsFileHelper settingsFileHelper,
  }) {
    final applicationId = json[_appPackageIdKey] as String;

    return SettingsJsonFile(
      appPackageId: applicationId,
      suppressedWarnings:
          _readJsonSuppressedWarnings(
            castOrNull<List<dynamic>>(json[_suppressedWarningsKey]),
          ) ??
          settingsFileHelper.buildDefaultSetOfSuppressedWarnings(),
    );
  }

  static Future<SettingsJsonFile> loadAndUpgrade(
    String filePath, {
    required SettingsFileHelper settingsFileHelper,
  }) async {
    final file = File(filePath);
    final fileAsString = await file.readAsString();

    final settings = SettingsJsonFile._fromJsonString(
      fileAsString,
      settingsFileHelper: settingsFileHelper,
    );

    final settingsAsString = settings.toJsonString();
    if (fileAsString != settingsAsString) {
      try {
        await file.writeAsString(settingsAsString);
      } catch (e, stackTrace) {
        GetIt.I.get<Logger>().e(
          'Failed to write the settings file',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    return settings;
  }

  Future<void> save(String filePath) async {
    await File(filePath).writeAsString(toJsonString());
  }

  String toJsonString() {
    final Map<String, dynamic> json = {
      _appPackageIdKey: appPackageId,
      _suppressedWarningsKey: _buildJsonSuppressedWarnings(),
    };

    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  bool isWarningSuppressed(SuppressableWarning warning) {
    return suppressedWarnings.contains(warning);
  }

  SettingsJsonFile copyWithWarningSuppressionState(
    SuppressableWarning warning, {
    required bool suppressed,
  }) {
    return copyWith(
      suppressedWarnings: {
        ...suppressedWarnings.where(
          (existingWarning) => existingWarning != warning,
        ),
        if (suppressed) warning,
      },
    );
  }

  SettingsJsonFile copyWith({
    String? appPackageId,
    Set<SuppressableWarning>? suppressedWarnings,
  }) {
    return SettingsJsonFile(
      appPackageId: appPackageId ?? this.appPackageId,
      suppressedWarnings: suppressedWarnings ?? this.suppressedWarnings,
    );
  }

  static Set<SuppressableWarning>? _readJsonSuppressedWarnings(
    List<dynamic>? jsonSuppressedWarningsList,
  ) {
    if (jsonSuppressedWarningsList == null) {
      return null;
    }

    final suppressedWarnings = <SuppressableWarning>{};

    for (final warning in SuppressableWarning.values) {
      if (jsonSuppressedWarningsList.contains(warning.jsonString)) {
        suppressedWarnings.add(warning);
      }
    }

    return suppressedWarnings;
  }

  List<String> _buildJsonSuppressedWarnings() {
    return suppressedWarnings.map((warning) => warning.jsonString).toList();
  }
}
