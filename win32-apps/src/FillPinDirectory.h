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

#pragma once

/**
 * Writes pin.json and icon.png to @p windowsPinDir.
 *
 * @param windowsPinDir The Windows-style directory to write the files to.
 * @param unixOrWindowsPinTargetPath The file to pin. Usually that's going to be an executable or
 *        an .lnk file, but we allow pinning any kind of files.
 *
 * @throw WStringRuntimeError On failure. The non-existing @p unixOrWindowsPinTargetPath counts
 *        as a failure, while not being able to extract an icon from it, is not.
 */
void fillPinDirectory(wchar_t const* windowsPinDir, wchar_t const* unixOrWindowsPinTargetPath);
