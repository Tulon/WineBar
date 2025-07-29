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

@immutable
class WinePrefixDirStructure extends Equatable {
  static const String _innerDirName = 'prefix';
  static const String _pinsDirName = 'pins';
  static const String _prefixJsonFileName = 'prefix.json';

  /// Corresponds to '$toplevelDataDir/$prefixName'.
  final String outerDir;

  /// Corresponds to '$toplevelDataDir/$prefixName/prefix'.
  String get innerDir => path.join(outerDir, _innerDirName);

  /// Corresponds to '$toplevelDataDir/$prefixName/pins'.
  String get pinsDir => path.join(outerDir, _pinsDirName);

  /// Corresponds to '$toplevelDataDir/$prefixName/prefix.json'.
  String get prefixJsonFilePath => path.join(outerDir, _prefixJsonFileName);

  const WinePrefixDirStructure.fromOuterDir(this.outerDir);

  @override
  List<Object> get props => [outerDir];
}
