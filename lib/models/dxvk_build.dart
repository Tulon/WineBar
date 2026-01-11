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

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'archive_type.dart';

@immutable
class DxvkBuild extends Equatable {
  final String versionTag;
  final String archiveFileName;
  final ArchiveType archiveType;
  final String downloadUrl;

  const DxvkBuild({
    required this.versionTag,
    required this.archiveFileName,
    required this.archiveType,
    required this.downloadUrl,
  });

  @override
  List<Object> get props => [
    versionTag,
    archiveFileName,
    archiveType,
    downloadUrl,
  ];

  static DxvkBuild get recommendedBuild => DxvkBuild(
    versionTag: 'v2.7.1',
    archiveFileName: 'dxvk-2.7.1.tar.gz',
    archiveType: ArchiveType.tarGz,
    downloadUrl:
        'https://github.com/doitsujin/dxvk/releases/download/v2.7.1/dxvk-2.7.1.tar.gz',
  );
}
