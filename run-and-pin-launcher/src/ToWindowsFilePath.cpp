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

#include "ToWindowsFilePath.h"

#include "UnixToWindowsFilePath.h"
#include "WStringRuntimeError.h"

#include <format>

std::wstring
toWindowsFilePath(std::wstring_view unixOrWindowsFilePath)
{
    if (!unixOrWindowsFilePath.starts_with(L"/"))
    {
        return std::wstring(unixOrWindowsFilePath);
    }

    if (auto const convertedPath = unixToWindowsFilePath(unixOrWindowsFilePath))
    {
        return *convertedPath;
    }

    throw WStringRuntimeError(
        std::format(
            L"Failed to convert {} to a Windows path. "
            L"For a successful conversion, the path has to exist.",
            unixOrWindowsFilePath));
}
