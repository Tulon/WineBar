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

class AppInfo {
  static final String appName = 'Wine Bar';
  static final String appPackageId = 'io.github.tulon.winebar';

  static final String winetricksGithubRepoOwner = 'Winetricks';
  static final String winetricksGithubRepoName = 'winetricks';
  static final String winetricksGitTag = '20260125';

  // Just the "winetricks" script itself, not the whole github release.
  static final String winetricksSha256 =
      'cc596c76079348c68fadb677012acee28cee185023f587824d37847e8b9446ac';

  static final int maxCharsInPrefixName = 100;
}
