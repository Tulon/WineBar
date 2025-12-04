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
import 'package:winebar/exceptions/generic_exception.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';

abstract interface class WineInstallationDescriptor {
  /// Regular Wine (not Proton) creates symlinks for folders liks Desktop and
  /// Documents inside a prefix that point to the corresponding folders in your
  /// home directory. We want prefixes to be self contained, so we replace
  /// those symlinks with regular directories on prefix creation. This field
  /// tells us whether we have to do that for a given Wine installation.
  bool get needsHomeIsolation;

  /// Proton builds (not all of them though) have a bundled winetricks script.
  /// This field is set to true if that's the case.
  bool get hasBundledWinetricks;

  /// Proton creates an extra 'pfx' directory under
  /// [WindPrefixDirStructure.innerDir]. So, in case of a Proton installation,
  /// '${prefixDirStructure.innerDir}/pfx' is returned, while otherwise,
  /// prefixDirStructure.innerDir itself is returned.
  String getInnermostPrefixDir({
    required WinePrefixDirStructure prefixDirStructure,
  });

  /// Takes the list of arguments for the wine executable and prepends the
  /// appropriate executable or a wrapper script to them.
  List<String> buildWineInvocationCommand({required List<String> wineArgs});

  /// Takes the list of arguments for the winetricks script and prepends the
  /// appropriate version of the winetricks script - either the external one
  /// or the one bundled with the wine installation. The
  /// [externalWinetricksScriptPath] may be null if [hasBundledWinetricks]
  /// returns true.
  List<String> buildWinetricksInvocationCommand({
    required String? externalWinetricksScriptPath,
    required List<String> winetricksArgs,
  });

  /// Returns the map of environment variables for starting a Wine or Proton
  /// process.
  ///
  /// The [processOutputDir] is a directory where process logs are to be
  /// written.
  Map<String, String> getEnvVarsForWine({
    required WinePrefixDirStructure prefixDirStructure,
    required String processOutputDir,
    required bool forWinetricks,
    required bool disableLogs,
  });

  /// Don't use directly - use
  /// [UtilityService.WineInstallationDescriptorForWineInstallDir] instead.
  static Future<WineInstallationDescriptor> forWineInstallDir(
    String wineInstallDir,
  ) async {
    return _WineInstallationDescriptor(
      protonLauncherScript: await _checkFileExists(
        path.join(wineInstallDir, 'proton'),
      ),
      protonfixesWinetricksScript: await _checkFileExists(
        path.join(wineInstallDir, 'protonfixes', 'winetricks'),
      ),
      protonfixesBinWinetricksScript: await _checkFileExists(
        path.join(wineInstallDir, 'protonfixes', 'bin', 'winetricks'),
      ),
      binWineExecutable: await _checkFileExists(
        path.join(wineInstallDir, 'bin', 'wine'),
      ),
      binWineserverExecutable: await _checkFileExists(
        path.join(wineInstallDir, 'bin', 'wineserver'),
      ),
      binWine64Executable: await _checkFileExists(
        path.join(wineInstallDir, 'bin', 'wine64'),
      ),
      filesBinWineExecutable: await _checkFileExists(
        path.join(wineInstallDir, 'files', 'bin', 'wine'),
      ),
      filesBinWine64Executable: await _checkFileExists(
        path.join(wineInstallDir, 'files', 'bin', 'wine64'),
      ),
      filesBinWineserverExecutable: await _checkFileExists(
        path.join(wineInstallDir, 'files', 'bin', 'wineserver'),
      ),
      filesBinWow64WineExecutable: await _checkFileExists(
        path.join(wineInstallDir, 'files', 'bin-wow64', 'wine'),
      ),
      filesBinWow64WineserverExecutable: await _checkFileExists(
        path.join(wineInstallDir, 'files', 'bin-wow64', 'wineserver'),
      ),
    );
  }

  static Future<String?> _checkFileExists(String filePath) async {
    if (await File(filePath).exists()) {
      return filePath;
    } else {
      return null;
    }
  }
}

class _WineAndWineserverExecutables {
  final String wineExecutable;
  final String wineserverExecutable;

  _WineAndWineserverExecutables({
    required this.wineExecutable,
    required this.wineserverExecutable,
  });

  static _WineAndWineserverExecutables? tryCombination(
    String? wineExecutable,
    String? wineserverExecutable,
  ) {
    if (wineExecutable != null && wineserverExecutable != null) {
      return _WineAndWineserverExecutables(
        wineExecutable: wineExecutable,
        wineserverExecutable: wineserverExecutable,
      );
    } else {
      return null;
    }
  }
}

class _WineInstallationDescriptor implements WineInstallationDescriptor {
  final String? protonLauncherScript;
  final String? protonfixesWinetricksScript;
  final String? protonfixesBinWinetricksScript;
  final String? binWineExecutable;
  final String? binWineserverExecutable;
  final String? binWine64Executable;
  final String? filesBinWineExecutable;
  final String? filesBinWine64Executable;
  final String? filesBinWineserverExecutable;
  final String? filesBinWow64WineExecutable;
  final String? filesBinWow64WineserverExecutable;

  _WineInstallationDescriptor({
    required this.protonLauncherScript,
    required this.protonfixesWinetricksScript,
    required this.protonfixesBinWinetricksScript,
    required this.binWineExecutable,
    required this.binWineserverExecutable,
    required this.binWine64Executable,
    required this.filesBinWineExecutable,
    required this.filesBinWine64Executable,
    required this.filesBinWineserverExecutable,
    required this.filesBinWow64WineExecutable,
    required this.filesBinWow64WineserverExecutable,
  });

  @override
  bool get needsHomeIsolation => protonLauncherScript == null;

  @override
  bool get hasBundledWinetricks =>
      (protonfixesWinetricksScript ?? protonfixesBinWinetricksScript) != null;

  @override
  String getInnermostPrefixDir({
    required WinePrefixDirStructure prefixDirStructure,
  }) {
    if (protonLauncherScript != null) {
      return path.join(prefixDirStructure.innerDir, 'pfx');
    } else {
      return prefixDirStructure.innerDir;
    }
  }

  @override
  List<String> buildWineInvocationCommand({required List<String> wineArgs}) {
    if (protonLauncherScript != null) {
      return [protonLauncherScript!, 'run', ...wineArgs];
    } else {
      return [
        _findWineAndWineserverExecutables(forWinetricks: false).wineExecutable,
        ...wineArgs,
      ];
    }
  }

  @override
  List<String> buildWinetricksInvocationCommand({
    required String? externalWinetricksScriptPath,
    required List<String> winetricksArgs,
  }) {
    final bundledWinetricksScriptPath =
        protonfixesBinWinetricksScript ?? protonfixesWinetricksScript;

    if (bundledWinetricksScriptPath != null) {
      return [bundledWinetricksScriptPath, ...winetricksArgs];
    } else if (externalWinetricksScriptPath != null) {
      return [externalWinetricksScriptPath, ...winetricksArgs];
    } else {
      throw GenericException(
        "This wine prefix doesn't bundle a winetricks script "
        "and neither was an external one provided.",
      );
    }
  }

  @override
  Map<String, String> getEnvVarsForWine({
    required WinePrefixDirStructure prefixDirStructure,
    required String processOutputDir,
    required bool forWinetricks,
    required bool disableLogs,
  }) {
    final wineAndWineserverExecutables = _findWineAndWineserverExecutables(
      forWinetricks: true,
    );

    final envVars = <String, String>{};

    if (forWinetricks) {
      envVars['WINE'] = wineAndWineserverExecutables.wineExecutable;

      envVars['WINETRICKS_LATEST_VERSION_CHECK'] = 'disabled';

      // I hoped this would get rid of UI messages like
      // 'winetricks latest version check update disabled', but unfortunately
      // it doesn't. I've opened a ticket to address this:
      // https://github.com/Winetricks/winetricks/issues/2430
      envVars['WINETRICKS_SUPER_QUIET'] = '1';

      if (protonLauncherScript != null) {
        // For winetricks to be able to find the user directory under C:\Users.
        envVars['LOGNAME'] = 'steamuser';
      }
    }

    // This variable is used both by wine (not by Proton) and also by our
    // log-capturing-runner executable.
    envVars['WINESERVER'] = wineAndWineserverExecutables.wineserverExecutable;

    // Wineprefix is needed even on Proton, as it's used by wineserver when
    // we invoke it with -w in order to make it exit gracefully rather than
    // getting killed by muvm.
    envVars['WINEPREFIX'] = getInnermostPrefixDir(
      prefixDirStructure: prefixDirStructure,
    );

    if (disableLogs) {
      envVars['LOG_CAPTURING_RUNNER_DISABLE_LOGGING'] = '1';
    }

    if (protonLauncherScript == null) {
      envVars['WINEDLLOVERRIDES'] = 'winemenubuilder.exe=d';
    } else if (!forWinetricks) {
      // Winetricks doesn't run the "proton" script, so it doesn't need any
      // of the following variables.

      // Any temporary directory would do here.
      envVars['STEAM_COMPAT_CLIENT_INSTALL_PATH'] = processOutputDir;

      envVars['STEAM_COMPAT_DATA_PATH'] = prefixDirStructure.innerDir;

      // Without the UMU_ID environment variable, the proton launcher script
      // tries to launch all executables through stream.exe. That's not a problem
      // by itself, as steam.exe is a small launcher that's open-source, included
      // in Proton builds and supports running non-steam apps, yet it's simply a
      // waste to have an extra executable running.
      envVars['UMU_ID'] = '1';

      // Not sure if this one does more good or bad.
      //envVars['PROTON_FORCE_LARGE_ADDRESS_AWARE'] = '1';

      if (!disableLogs) {
        envVars['PROTON_LOG'] = '1';

        // This could result in steam-proton.log file appearing in
        // processOutputDir, but in practice, that doesn't happen.
        // Check out the setup_logging() function in the `proton`
        // script and the way it's called to understand why.
        //
        // If we were setting the `StreamGameId`, environment variable,
        // then a `stream-${StreamGameId}.log` would be created.
        //
        // In any case, it's a good idea to set this variable whenever
        // wet set `PROTON_LOG`, as should the logic in the `proton` script
        // change, we may end up polluting the user's home directory with
        // proton logs.
        envVars['PROTON_LOG_DIR'] = processOutputDir;
      }
    }

    return envVars;
  }

  _WineAndWineserverExecutables _findWineAndWineserverExecutables({
    required bool forWinetricks,
  }) {
    // For winetricks, we want a 32-bit wine, if the prefix provides both a
    // 32-bit one and a 64-bit one. At least, that's what proton does.
    if (forWinetricks) {
      return _checkValueNotNull(
        value:
            _WineAndWineserverExecutables.tryCombination(
              binWineExecutable,
              binWineserverExecutable,
            ) ??
            _WineAndWineserverExecutables.tryCombination(
              filesBinWineExecutable,
              filesBinWineserverExecutable,
            ),
        errMsgIfNull:
            'Failed to locate the wine / wineserver executables for '
            'winetricks',
      );
    } else if (protonLauncherScript != null &&
        false /*use_wow64_mode_in_proton*/ ) {
      return _checkValueNotNull(
        value: _WineAndWineserverExecutables.tryCombination(
          filesBinWow64WineExecutable,
          filesBinWow64WineserverExecutable,
        ),
        errMsgIfNull:
            'Failed to locate the wine / wineserver executables for wow64 bit '
            'mode on proton',
      );
    } else {
      // Otherwise, we pick a 64-bit one or whichever is available.
      return _checkValueNotNull(
        value:
            _WineAndWineserverExecutables.tryCombination(
              binWine64Executable,
              binWineserverExecutable,
            ) ??
            _WineAndWineserverExecutables.tryCombination(
              filesBinWine64Executable,
              filesBinWineserverExecutable,
            ) ??
            _WineAndWineserverExecutables.tryCombination(
              binWineExecutable,
              binWineserverExecutable,
            ) ??
            _WineAndWineserverExecutables.tryCombination(
              filesBinWineExecutable,
              filesBinWineserverExecutable,
            ),
        errMsgIfNull: 'Failed to locate the wine / wineserver executables',
      );
    }
  }

  T _checkValueNotNull<T>({required T? value, required String errMsgIfNull}) {
    if (value == null) {
      throw Exception(errMsgIfNull);
    } else {
      return value;
    }
  }
}
