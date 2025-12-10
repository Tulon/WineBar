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

enum SuppressableWarning {
  /// Unless something changed recently, the WOW64-only Wine builds or
  /// dual-mode builds in WOW64 mode don't work under emulation (fex-emu).
  /// To be more precise, they can't launch 32-bit apps, which includes
  /// WineBar's own helper apps.
  wow64ModeUnderEmulation(jsonString: 'wow64ModeUnderEmulation'),

  /// A non-WOW64-capable build or a dual-mode build not in WOW64 mode,
  /// requires 32-bit libraries installed on the host system.
  nonWow64ModesRequire32BitLibs(jsonString: 'nonWow64ModesRequire32BitLibs');

  final String jsonString;

  const SuppressableWarning({required this.jsonString});
}
