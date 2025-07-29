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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

/// Represents the contents of the prefix.json file located in the
/// outer prefix directory. The other prefix directory contains
/// the 'prefix' subdirectory along with the 'prefix.json' file.
@immutable
class PrefixDescriptor extends Equatable {
  static const String _nameKey = 'name';
  static const String _relPathToWineInstallKey = 'relPathToWineInstall';

  final String name;

  /// This path is relative to the toplevel data directory.
  final String relPathToWineInstall;

  bool get isBroken => relPathToWineInstall == '';

  const PrefixDescriptor({
    required this.name,
    required this.relPathToWineInstall,
  });

  const PrefixDescriptor.brokenPrefix({required String name})
    : this(name: name, relPathToWineInstall: '');

  @override
  List<Object> get props => [name, relPathToWineInstall];

  String getAbsPathToWineInstall({required String toplevelDataDir}) {
    return path.normalize(path.join(toplevelDataDir, relPathToWineInstall));
  }

  factory PrefixDescriptor.fromJsonString(String jsonString) {
    return PrefixDescriptor.fromJson(jsonDecode(jsonString));
  }

  factory PrefixDescriptor.fromJson(Map<String, dynamic> json) {
    final name = json[_nameKey] as String;
    final relPathToWineInstall = json[_relPathToWineInstallKey] as String;

    return PrefixDescriptor(
      name: name,
      relPathToWineInstall: relPathToWineInstall,
    );
  }

  String toJsonString() {
    final Map<String, dynamic> json = {
      _nameKey: name,
      _relPathToWineInstallKey: relPathToWineInstall,
    };

    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}
