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

import '../models/wine_build_source.dart';
import '../models/wine_build_source_github_project.dart';
import 'wine_build_source_repo.dart';

class WineBuildSourceRepoImpl implements WineBuildSourceRepo {
  @override
  final List<WineBuildSource> sources;

  WineBuildSourceRepoImpl({required Dio dio})
    : sources = [
        WineBuildSourceGithubProject(
          label: 'Kronek',
          directoryName: 'Kronek',
          circleAvatarText: 'KR',
          githubRepoOwner: 'Kron4ek',
          githubProjectName: 'Wine-Builds',
          dio: dio,
        ),
        WineBuildSourceGithubProject(
          label: 'GE Proton',
          directoryName: 'GE_Proton',
          circleAvatarText: 'GE',
          githubRepoOwner: 'GloriousEggroll',
          githubProjectName: 'proton-ge-custom',
          dio: dio,
        ),
      ];
}
