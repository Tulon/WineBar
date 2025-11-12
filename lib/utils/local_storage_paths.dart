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

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:winebar/models/wine_prefix_dir_structure.dart';

import '../models/wine_build.dart';
import '../models/wine_build_source.dart';
import '../models/wine_release.dart';

class LocalStoragePaths {
  static const String _toplevelDirName = 'WineBarData';
  static const String _settingsJsonFileName = 'settings.json';
  static const String _wineInstallsDirName = 'wine-installs';
  static const String _winePrefixesDirName = 'wine-prefixes';
  static const String _tempDirName = 'temp';

  final String homeDir;

  final String toplevelDataDir;

  String get settingsJsonFilePath =>
      path.join(toplevelDataDir, _settingsJsonFileName);

  String get wineInstallsDir =>
      path.join(toplevelDataDir, _wineInstallsDirName);

  String get winePrefixesDir =>
      path.join(toplevelDataDir, _winePrefixesDirName);

  String get tempDir => path.join(toplevelDataDir, _tempDirName);

  LocalStoragePaths({required this.homeDir, required this.toplevelDataDir});

  static String get logCapturingRunnerPath {
    return path.join(
      Directory(Platform.resolvedExecutable).parent.path,
      'bin',
      'log-capturing-runner',
    );
  }

  static String get pinExecutableInfoExtractorPath {
    return path.join(
      Directory(Platform.resolvedExecutable).parent.path,
      'bin-win32',
      'pin-executable-info-extractor.exe',
    );
  }

  static String get runAndPinWin32LauncherPath {
    return path.join(
      Directory(Platform.resolvedExecutable).parent.path,
      'bin-win32',
      'run-and-pin-launcher.exe',
    );
  }

  static Future<LocalStoragePaths> get() async {
    final homeDir = Platform.environment['HOME'];
    if (homeDir == null) {
      throw Exception("Couldn't read the HOME environment variable");
    }

    final toplevelDataDir = path.join(homeDir, _toplevelDirName);
    return LocalStoragePaths(
      homeDir: homeDir,
      toplevelDataDir: toplevelDataDir,
    );
  }

  String getWineInstallDir({
    required WineBuildSource wineBuildSource,
    required WineRelease wineRelease,
    required WineBuild wineBuild,
  }) {
    final buildSourceDir = wineBuildSource.directoryName;
    final wineReleaseDir = _sanitizeName(wineRelease.releaseName);
    final wineBuildDir = _sanitizeName(wineBuild.archiveFileName);

    return path.join(
      toplevelDataDir,
      _wineInstallsDirName,
      buildSourceDir,
      wineReleaseDir,
      wineBuildDir,
    );
  }

  WinePrefixDirStructure getWinePrefixDirStructure({
    required String prefixName,
  }) {
    final prefixDirName = _sanitizeName(prefixName);

    final outerDir = path.join(
      toplevelDataDir,
      _winePrefixesDirName,
      prefixDirName,
    );

    return WinePrefixDirStructure.fromOuterDir(outerDir);
  }

  static final _invalidCharsForFsEntities = RegExp(
    r'([^\p{Letter}\p{Mark}\p{Number}\p{Punctuation} ]|[\p{Zs}<>:/\\|?])+',
    unicode: true,
  );

  String _sanitizeName(String name) {
    final String sanitized = name
        .replaceAll(_invalidCharsForFsEntities, '_')
        .trim();

    final maxLength = 255;
    if (sanitized.length > maxLength) {
      return sanitized.substring(0, maxLength);
    } else if (sanitized.isEmpty) {
      return '_';
    } else {
      return sanitized;
    }
  }
}
