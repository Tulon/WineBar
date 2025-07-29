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

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/models/wine_prefix_dir_structure.dart';

import '../utils/prefix_descriptor.dart';

typedef WinePrefixCreatedCallback = void Function(WinePrefix prefix);

@immutable
class WinePrefix extends Equatable {
  final WinePrefixDirStructure dirStructure;
  final PrefixDescriptor descriptor;

  const WinePrefix({required this.dirStructure, required this.descriptor});

  WinePrefix.broken({required String outerDir})
    : this(
        dirStructure: WinePrefixDirStructure.fromOuterDir(outerDir),
        descriptor: PrefixDescriptor.brokenPrefix(
          name: '${path.basename(outerDir)} (broken)',
        ),
      );

  bool get isBroken => descriptor.isBroken;

  @override
  List<Object> get props => [dirStructure, descriptor];
}
