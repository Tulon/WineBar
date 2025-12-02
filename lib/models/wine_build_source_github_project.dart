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

import 'package:dio/dio.dart';

import 'archive_type.dart';
import 'cached_wine_build_source.dart';
import 'wine_build.dart';
import 'wine_release.dart';

/// Sources the list of wine releses and builds from the releases of a
/// public github project.
class WineBuildSourceGithubProject extends CachedWineBuildSource {
  @override
  final String label;

  @override
  final String? details;

  @override
  final bool recommended;

  @override
  final String directoryName;

  @override
  final String circleAvatarText;

  final String githubRepoOwner;
  final String githubProjectName;
  final Dio dio;

  WineBuildSourceGithubProject({
    required this.label,
    this.details,
    this.recommended = false,
    required this.directoryName,
    required this.circleAvatarText,
    required this.githubRepoOwner,
    required this.githubProjectName,
    required this.dio,
  });

  @override
  Future<List<WineRelease>> fetchAvailableReleases() async {
    final encodedRepoOwner = Uri.encodeComponent(githubRepoOwner);
    final encodedProjectName = Uri.encodeComponent(githubProjectName);

    final url =
        'https://api.github.com/repos/$encodedRepoOwner/$encodedProjectName/releases';

    final headers = <String, String>{
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };

    final response = await dio.getUri(
      Uri.parse(url),
      options: Options(headers: headers, responseType: ResponseType.json),
    );

    final List<WineRelease> wineReleases = [];

    for (var releaseJson in response.data as List) {
      final releaseMap = releaseJson as Map<String, dynamic>;

      final prereleaseFlag = releaseMap['prerelease'] as bool;
      if (prereleaseFlag) {
        continue;
      }

      final releaseName = releaseMap['name'] as String;
      final assetsList = releaseMap['assets'] as List;

      final List<WineBuild> wineBuilds = [];

      for (final assetJson in assetsList) {
        final assetMap = assetJson as Map<String, dynamic>;
        final assetName = assetMap['name'] as String;
        final assetDownloadUrl = assetMap['browser_download_url'] as String;

        final archiveType = ArchiveType.fromFileNameOrFilePath(assetName);
        if (archiveType != null) {
          wineBuilds.add(
            WineBuild(
              archiveFileName: assetName,
              archiveType: archiveType,
              downloadUrl: assetDownloadUrl,
            ),
          );
        }
      }

      wineReleases.add(
        WineRelease(releaseName: releaseName, builds: wineBuilds),
      );
    }

    return wineReleases;
  }
}
