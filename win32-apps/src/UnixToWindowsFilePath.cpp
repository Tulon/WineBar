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

#include "UnixToWindowsFilePath.h"

#include "ScopeCleanup.h"

#include <windows.h>

#include <string>

std::optional<std::wstring>
unixToWindowsFilePath(std::wstring_view unixFilePath)
{
    // This approach is used in Wine internally. See here:
    // https://github.com/wine-mirror/wine/blob/01269452e0fbb1f081d506bd64996590a553e2b9/programs/start/start.c#L252

    static std::wstring_view inputPrefix(L"\\\\?\\unix");
    static std::wstring_view outputPrefix(L"\\\\?\\");

    std::wstring inOutPath;
    inOutPath.reserve(inputPrefix.size() + unixFilePath.size());
    inOutPath += inputPrefix;
    inOutPath += unixFilePath;

    HANDLE handle = CreateFileW(
        inOutPath.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, OPEN_EXISTING,
        FILE_FLAG_BACKUP_SEMANTICS, 0);

    if (handle == INVALID_HANDLE_VALUE)
    {
        return std::nullopt;
    }

    ScopeCleanup const handleCleanup([handle] { CloseHandle(handle); });

    auto const len = GetFinalPathNameByHandleW(
        handle, inOutPath.data(), inOutPath.size(), FILE_NAME_NORMALIZED | VOLUME_NAME_DOS);
    if (len == 0 || len > inOutPath.size())
    {
        return std::nullopt;
    }

    inOutPath.resize(len);

    if (inOutPath.starts_with(outputPrefix))
    {
        return inOutPath.substr(outputPrefix.size());
    }
    else
    {
        return inOutPath;
    }
}
