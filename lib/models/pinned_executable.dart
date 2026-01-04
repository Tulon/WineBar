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
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:io/io.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/models/pinned_executable_settings.dart';

@immutable
class PinnedExecutable extends Equatable
    implements Comparable<PinnedExecutable> {
  /// Inside this directory we have a pin.json file carrying the rest of our fields,
  /// and also the icon.png file if [hasIcon] is true.
  final String pinDirectory;

  final String label;
  final String windowsPathToExecutable;
  final bool hasIcon;
  final PinnedExecutableSettings settings;

  // These constants should be kept in sync with those in WritePinnedExecutableJson.cpp.
  static final _labelKey = 'label';
  static final _windowsPathToExecutableKey = 'windowsPathToExecutable';
  static final _hasIconKey = 'hasIcon';
  static final _settingsKey = 'settings';
  static final _jsonFileName = 'pin.json';

  const PinnedExecutable._({
    required this.pinDirectory,
    required this.label,
    required this.windowsPathToExecutable,
    required this.hasIcon,
    required this.settings,
  });

  @override
  List<Object?> get props => [
    pinDirectory,
    label,
    windowsPathToExecutable,
    hasIcon,
    settings,
  ];

  /// Compares by lower-cased [label] and then by lower-cased [windowsPathToExecutable].
  @override
  int compareTo(PinnedExecutable other) {
    final labelComp = label.toLowerCase().compareTo(other.label.toLowerCase());
    if (labelComp != 0) {
      return labelComp;
    }

    return windowsPathToExecutable.toLowerCase().compareTo(
      other.windowsPathToExecutable.toLowerCase(),
    );
  }

  static Future<PinnedExecutable> loadFromPinDirectory(
    String pinDirectory,
  ) async {
    final jsonFilePath = _jsonFilePath(pinDirectory: pinDirectory);
    final jsonString = await File(jsonFilePath).readAsString();
    final json = jsonDecode(jsonString);

    final label = json[_labelKey] as String;
    final windowsPathToExecutable = json[_windowsPathToExecutableKey] as String;
    final hasIcon = json[_hasIconKey] as bool;

    PinnedExecutableSettings? settings;
    try {
      final jsonSettings = json[_settingsKey];
      if (jsonSettings is Map<String, dynamic>) {
        settings = PinnedExecutableSettings.fromJson(jsonSettings);
      }
    } catch (e, stackTrace) {
      GetIt.I.get<Logger>().e(
        'Failed to load settings for pinned executable "$label"',
        error: e,
        stackTrace: stackTrace,
      );
    }

    return PinnedExecutable._(
      pinDirectory: pinDirectory,
      label: label,
      windowsPathToExecutable: windowsPathToExecutable,
      hasIcon: hasIcon,
      settings: settings ?? PinnedExecutableSettings.defaultSettings(),
    );
  }

  static String _jsonFilePath({required String pinDirectory}) {
    return path.join(pinDirectory, _jsonFileName);
  }

  /// Updates the pin.json file on disk. The icon.png (if present) is not touched.
  Future<void> updateOnDisk() {
    final jsonFilePath = _jsonFilePath(pinDirectory: pinDirectory);
    return File(jsonFilePath).writeAsString(_formatPinJsonFile());
  }

  String _formatPinJsonFile() {
    final Map<String, dynamic> json = {
      _labelKey: label,
      _windowsPathToExecutableKey: windowsPathToExecutable,
      _hasIconKey: hasIcon,
      _settingsKey: settings.toJson(),
    };

    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  Future<PinnedExecutable> copyToAnotherPinDirectory(
    String newPinDirectory,
  ) async {
    await copyPath(pinDirectory, newPinDirectory);

    return PinnedExecutable._(
      pinDirectory: newPinDirectory,
      label: label,
      windowsPathToExecutable: windowsPathToExecutable,
      hasIcon: hasIcon,
      settings: settings,
    );
  }

  /// Note that [pinDirectory] is intentionally not included here.
  /// Use [copyToAnotherPinDirectory] if you need to modify it.
  PinnedExecutable copyWith({
    String? label,
    String? windowsPathToExecutable,
    bool? hasIcon,
    PinnedExecutableSettings? settings,
  }) {
    return PinnedExecutable._(
      pinDirectory: pinDirectory,
      label: label ?? this.label,
      windowsPathToExecutable:
          windowsPathToExecutable ?? this.windowsPathToExecutable,
      hasIcon: hasIcon ?? this.hasIcon,
      settings: settings ?? this.settings,
    );
  }
}
