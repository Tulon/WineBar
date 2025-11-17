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

#include "WritePinJson.h"

#include "EscapeAndQuoteJsonString.h"
#include "WStringRuntimeError.h"

#include <format>
#include <fstream>

void
writePinJson(
    std::wstring_view pinDirectory, std::wstring_view label,
    std::wstring_view windowsPathToExecutable, bool hasIcon)
{
    // These constants are to be kept in sync with those in pinned_executable.dart
    static std::string_view const kLabelKey = "label";
    static std::string_view const kWindowsPathToExecutableKey = "windowsPathToExecutable";
    static std::string_view const kHasIconKey = "hasIcon";
    static std::wstring_view const kJsonFileName = L"pin.json";

    std::wstring const filePath = std::format(L"{}\\{}", pinDirectory, kJsonFileName);

    std::ofstream strm(filePath.c_str(), std::ios::binary);

    if (!strm)
    {
        throw WStringRuntimeError(std::format(L"Failed to open file {} for writing", filePath));
    }

    strm << std::format(
        "{{\n"
        "  \"{}\": {},\n"
        "  \"{}\": {},\n"
        "  \"{}\": {}\n"
        "}}",
        kWindowsPathToExecutableKey, escapeAndQuoteJsonString(windowsPathToExecutable), kLabelKey,
        escapeAndQuoteJsonString(label), kHasIconKey, (hasIcon ? "true" : "false"));

    strm.flush();

    if (!strm)
    {
        throw WStringRuntimeError(std::format(L"I/O error writing to {}", filePath));
    }
}
