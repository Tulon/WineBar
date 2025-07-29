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

import 'package:meta/meta.dart';

/// Represents the contents of the owner.json file located at the root of
/// the app's data directory.
@immutable
class SettingsJsonFile {
  /// See [AppInfo.appPackageId].
  final String appPackageId;

  static final _appPackageIdKey = 'appPackageId';

  const SettingsJsonFile({required this.appPackageId});

  factory SettingsJsonFile.fromJsonString(String jsonString) {
    return SettingsJsonFile.fromJson(jsonDecode(jsonString));
  }

  factory SettingsJsonFile.fromJson(Map<String, dynamic> json) {
    final applicationId = json[_appPackageIdKey] as String;
    return SettingsJsonFile(appPackageId: applicationId);
  }

  String toJsonString() {
    final Map<String, dynamic> json = {_appPackageIdKey: appPackageId};

    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}
