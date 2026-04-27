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

/// @docImport 'package:winebar/models/wine_locale.dart';
library;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/models/d3d_8_to_11_implementation.dart';
import 'package:winebar/utils/cast_or_null.dart';

/// Represents the contents of the prefix.json file located in the
/// outer prefix directory. The other prefix directory contains
/// the 'prefix' subdirectory along with the 'prefix.json' file.
@immutable
class WinePrefixDescriptor extends Equatable {
  static const String _nameKey = 'name';
  static const String _relPathToWineInstallKey = 'relPathToWineInstall';
  static const String _hiDpiScaleKey = 'hiDpiScale';
  static const String _wow64ModePreferredKey = 'wow64ModePreferred';
  static const String _d3d8To11ImplementationKey = 'd3d8To11Implementation';
  static const String _explicitLocalePosixNameKey = 'explicitLocale';

  final String name;

  /// This path is relative to the toplevel data directory.
  final String relPathToWineInstall;

  final double? hiDpiScale;

  /// Whether to use the wow64 mode on Wine builds that support both the
  /// win64 and the wow64 modes (think GE Proton). Null here indicates that
  /// we are using a build that only supports a single mode.
  final bool? wow64ModePreferred;

  final D3d8To11Implementation? d3d8To11Implementation;

  /// If a locale was selected explicitly, this member will hold [WineLocale.posixName].
  final String? explicitLocalePosixName;

  bool get isBroken => relPathToWineInstall == '';

  const WinePrefixDescriptor({
    required this.name,
    required this.relPathToWineInstall,
    required this.hiDpiScale,
    required this.wow64ModePreferred,
    required this.d3d8To11Implementation,
    required this.explicitLocalePosixName,
  });

  const WinePrefixDescriptor.brokenPrefix({required String name})
    : this(
        name: name,
        relPathToWineInstall: '',
        hiDpiScale: null,
        wow64ModePreferred: null,
        d3d8To11Implementation: null,
        explicitLocalePosixName: null,
      );

  @override
  List<Object?> get props => [
    name,
    relPathToWineInstall,
    hiDpiScale,
    wow64ModePreferred,
    d3d8To11Implementation,
    explicitLocalePosixName,
  ];

  String getAbsPathToWineInstall({required String toplevelDataDir}) {
    return path.normalize(path.join(toplevelDataDir, relPathToWineInstall));
  }

  factory WinePrefixDescriptor.fromJsonString(String jsonString) {
    return WinePrefixDescriptor.fromJson(jsonDecode(jsonString));
  }

  factory WinePrefixDescriptor.fromJson(Map<String, dynamic> json) {
    final name = json[_nameKey] as String;
    final relPathToWineInstall = json[_relPathToWineInstallKey] as String;
    final hiDpiScale = castOrNull<double>(json[_hiDpiScaleKey]);
    final wow64ModePreferred = castOrNull<bool>(json[_wow64ModePreferredKey]);
    final d3d8to11Implementation = castOrNull<String>(
      json[_d3d8To11ImplementationKey],
    );
    final explicitLocalePosixName = castOrNull<String>(
      json[_explicitLocalePosixNameKey],
    );

    return WinePrefixDescriptor(
      name: name,
      relPathToWineInstall: relPathToWineInstall,
      hiDpiScale: hiDpiScale,
      wow64ModePreferred: wow64ModePreferred,
      d3d8To11Implementation: D3d8To11Implementation.fromJsonString(
        d3d8to11Implementation,
      ),
      explicitLocalePosixName: explicitLocalePosixName,
    );
  }

  String toJsonString() {
    final d3d8To11Implementation = this.d3d8To11Implementation;

    final Map<String, dynamic> json = {
      _nameKey: name,
      _relPathToWineInstallKey: relPathToWineInstall,
      _hiDpiScaleKey: hiDpiScale,
      _wow64ModePreferredKey: wow64ModePreferred,
      if (d3d8To11Implementation != null)
        _d3d8To11ImplementationKey: d3d8To11Implementation.jsonString,
      if (explicitLocalePosixName != null)
        _explicitLocalePosixNameKey: explicitLocalePosixName,
    };

    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  WinePrefixDescriptor copyWith({
    String? name,
    String? relPathToWineInstall,
    ValueGetter<double?>? hiDpiScaleGetter,
    ValueGetter<bool?>? wow64ModePreferredGetter,
    ValueGetter<D3d8To11Implementation?>? d3d8To11ImplementationGetter,
    ValueGetter<String?>? explicitLocalePosixNameGetter,
  }) {
    return WinePrefixDescriptor(
      name: name ?? this.name,
      relPathToWineInstall: relPathToWineInstall ?? this.relPathToWineInstall,
      hiDpiScale: hiDpiScaleGetter != null ? hiDpiScaleGetter() : hiDpiScale,
      wow64ModePreferred: wow64ModePreferredGetter != null
          ? wow64ModePreferredGetter()
          : wow64ModePreferred,
      d3d8To11Implementation: d3d8To11ImplementationGetter != null
          ? d3d8To11ImplementationGetter()
          : d3d8To11Implementation,
      explicitLocalePosixName: explicitLocalePosixNameGetter != null
          ? explicitLocalePosixNameGetter()
          : explicitLocalePosixName,
    );
  }
}
