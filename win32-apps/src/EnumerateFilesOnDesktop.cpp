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

#include "EnumerateFilesOnDesktop.h"

#include "ErrorString.h"
#include "ScopeCleanup.h"
#include "WStringRuntimeError.h"

#include <shlobj.h>
#include <windows.h>

#include <filesystem>
#include <format>

std::vector<std::wstring>
enumerateFilesOnDesktop()
{
    std::vector<std::wstring> files;

    PWSTR desktopFolder = nullptr;

    HRESULT hr = SHGetKnownFolderPath(FOLDERID_Desktop, KF_FLAG_DEFAULT, nullptr, &desktopFolder);

    // The docs say to call CoTaskMemFree() even if SHGetKnownFolderPath fails.
    ScopeCleanup desktopFolderCleanup([desktopFolder] { CoTaskMemFree(desktopFolder); });

    if (FAILED(hr))
    {
        throw WStringRuntimeError(
            std::format(
                L"SHGetKnownFolderPath(FOLDERID_Desktop) failed: {}",
                errorStringFromErrorCode(GetLastError()).get()));
    }

    for (auto const& entry : std::filesystem::directory_iterator(desktopFolder))
    {
        files.push_back(entry.path().wstring());
    }

    return files;
}
