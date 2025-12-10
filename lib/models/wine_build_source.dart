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

import 'wine_release.dart';

abstract interface class WineBuildSource {
  String get label;

  String? get details;

  bool get recommended;

  /// When we have a directory in the filesystem that corresponds to an
  /// instance of WineBuildSource, we name it according to this property.
  String get directoryName;

  String get circleAvatarText;

  /// This will be true for the "GE Proton" build source. Newer GE Proton
  /// builds support the WOW64 mode by setting the environment variable
  /// PROTON_USE_WOW64=1.
  /// This variable being set to true makes the "Prefer WOW64 mode" toggle
  /// to appear on the prefix creation dialog. If the build in question
  /// doesn't actually support the WOW64 mode, the state of that toggle
  /// won't hany consequences.
  /// As for the prefix settings dialog, we determine whether to show that
  /// toggle by examining the directory structure of the wine installation
  /// in question.
  bool get buildsMaySupportBothWin64AndWow64Modes;

  /// Fetches or returns a cached list of Wine releases, where each release
  /// holds a list of builds (think Github assets).
  ///
  /// If [refresh] is set to true, the list of Wine releases will be fetched
  /// again, even if it's already cached.
  Future<List<WineRelease>> getAvailableReleases({bool refresh = false});
}
