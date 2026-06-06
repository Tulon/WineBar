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

import 'package:winebar/utils/l10n.dart';

enum D3d8To11Implementation {
  dxvk(jsonString: 'dxvk', label: 'DXVK'),
  wineD3D(jsonString: 'wined3d', label: 'WineD3D');

  final String jsonString;
  final String label;

  const D3d8To11Implementation({required this.jsonString, required this.label});

  String get explanationText {
    return switch (this) {
      dxvk => L10n.current.dxvkOptionExplanation,
      wineD3D => L10n.current.wineD3DOptionExplanation,
    };
  }

  static D3d8To11Implementation? fromJsonString(String? jsonString) {
    return values.where((impl) => impl.jsonString == jsonString).firstOrNull;
  }
}
