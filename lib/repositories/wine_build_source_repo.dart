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
import 'package:winebar/models/wine_build_source_github_project.dart';

import '../models/wine_build_source.dart';

abstract interface class WineBuildSourceRepo {
  List<WineBuildSource> get sources;

  factory WineBuildSourceRepo({required Dio dio}) {
    return _WineBuildSourceRepo(dio: dio);
  }
}

class _WineBuildSourceRepo implements WineBuildSourceRepo {
  @override
  final List<WineBuildSource> sources;

  _WineBuildSourceRepo({required Dio dio})
    : sources = [
        WineBuildSourceGithubProject(
          label: 'Kronek',
          details: 'Provides Vanilla, Staging, TkG and Proton Wine builds.',
          directoryName: 'Kronek',
          circleAvatarText: 'KR',
          buildsMaySupportBothWin64AndWow64Modes: false,
          githubRepoOwner: 'Kron4ek',
          githubProjectName: 'Wine-Builds',
          dio: dio,
        ),
        WineBuildSourceGithubProject(
          label: 'GE Proton',
          details:
              'Provides Proton builds with DXVK / VK3D included. '
              'Recommended for games and other fullscreen apps.',
          recommended: true,
          directoryName: 'GE_Proton',
          circleAvatarText: 'GE',
          buildsMaySupportBothWin64AndWow64Modes: true,
          githubRepoOwner: 'GloriousEggroll',
          githubProjectName: 'proton-ge-custom',
          dio: dio,
        ),
      ];
}
