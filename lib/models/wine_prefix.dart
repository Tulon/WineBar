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
import 'package:path/path.dart' as path;
import 'package:winebar/models/wine_prefix_dir_structure.dart';

import 'prefix_descriptor.dart';

typedef WinePrefixId = int;
typedef WinePrefixCreatedCallback = void Function(WinePrefix prefix);

@immutable
class WinePrefix extends Equatable implements Comparable<WinePrefix> {
  static WinePrefixId _lastId = 0;

  /// A numeric Id that's not persisted and that stays the same when
  /// a prefix is updated.
  final WinePrefixId id = ++_lastId;

  final WinePrefixDirStructure dirStructure;
  final WinePrefixDescriptor descriptor;

  WinePrefix({required this.dirStructure, required this.descriptor});

  WinePrefix.broken({required String outerDir})
    : this(
        dirStructure: WinePrefixDirStructure.fromOuterDir(outerDir),
        descriptor: WinePrefixDescriptor.brokenPrefix(
          name: '${path.basename(outerDir)} (broken)',
        ),
      );

  bool get isBroken => descriptor.isBroken;

  @override
  List<Object> get props => [id, dirStructure, descriptor];

  /// Compares by [WinePrefixDescriptor.name] and then by [WinePrefixDirStructure.outerDir].
  @override
  int compareTo(WinePrefix other) {
    final nameComp = descriptor.name.compareTo(other.descriptor.name);
    if (nameComp != 0) {
      return nameComp;
    }

    return dirStructure.outerDir.compareTo(other.dirStructure.outerDir);
  }

  /// The [id] field is not included on purpose, as it's not supposed
  /// to change.
  WinePrefix copyWith({
    WinePrefixDirStructure? dirStructure,
    WinePrefixDescriptor? descriptor,
  }) {
    return WinePrefix(
      dirStructure: dirStructure ?? this.dirStructure,
      descriptor: descriptor ?? this.descriptor,
    );
  }
}
