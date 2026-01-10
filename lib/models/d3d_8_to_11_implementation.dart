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

enum D3d8To11Implementation {
  dxvk(
    jsonString: 'dxvk',
    label: 'DXVK',
    explanationText: 'A newer and faster implementation from Proton',
  ),
  wineD3D(
    jsonString: 'wined3d',
    label: 'WineD3D',
    explanationText:
        'A mature implementation from Wine. '
        'To be used in case of issues with DXVK.',
  );

  final String jsonString;
  final String label;
  final String explanationText;

  const D3d8To11Implementation({
    required this.jsonString,
    required this.label,
    required this.explanationText,
  });

  static D3d8To11Implementation? fromJsonString(String? jsonString) {
    return values.where((impl) => impl.jsonString == jsonString).firstOrNull;
  }
}
