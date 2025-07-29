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

abstract interface class WinetricksDownloadService {
  /// Downloads and installs the "winetricks" script, unless it's already
  /// downloaded and installed, in which case it simply returns the path
  /// to the installed script.
  ///
  /// Should this method fail once, the next attempts will be failing
  /// without retrying a download, until the app is restarted or unless
  /// [forceRetry] is set to true.
  Future<String> prepareWinetricksScript({bool forceRetry = false});
}
