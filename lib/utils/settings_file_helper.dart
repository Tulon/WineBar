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

import 'package:winebar/models/suppressable_warning.dart';

abstract interface class SettingsFileHelper {
  factory SettingsFileHelper({required bool wineWillRunUnderMuvm}) {
    return _SettingsFileHelper(wineWillRunUnderMuvm: wineWillRunUnderMuvm);
  }

  /// This list is used when creating a new settings file or when upgrading
  /// an old one that didn't have such a set.
  Set<SuppressableWarning> buildDefaultSetOfSuppressedWarnings();
}

class _SettingsFileHelper implements SettingsFileHelper {
  final bool wineWillRunUnderMuvm;

  _SettingsFileHelper({required this.wineWillRunUnderMuvm});

  @override
  Set<SuppressableWarning> buildDefaultSetOfSuppressedWarnings() {
    return {
      // Muvm means Apple silicon hardware (think Asahi Linux).
      // On such systems, 32-bit libraries are installed along
      // with FEX / muvm. That means in practice, the user is
      // going to have the 32-bit libraries, so there is no need
      // to warn them about them.
      if (wineWillRunUnderMuvm)
        SuppressableWarning.nonWow64ModesRequire32BitLibs,
    };
  }
}
