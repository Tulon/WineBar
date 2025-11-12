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

#include "IconFromAssociatedApplication.h"

#include "DefaultIconSelector.h"
#include "IconFromPortableExecutable.h"
#include "IconFromPortableExecutableOrIcoFile.h"
#include "SignedIndexIconSelector.h"

#include <shlwapi.h>
#include <windows.h>

#include <charconv>
#include <cwchar>
#include <optional>
#include <string>

namespace
{

/**
 * A convenience wrapper around AssocQueryStringW().
 */
std::optional<std::wstring>
assocQuery(ASSOCSTR queryType, wchar_t const* queryString, wchar_t const* queryExtra)
{
    std::wstring response;
    DWORD size = 0;

    HRESULT hr = AssocQueryStringW(ASSOCF_NONE, queryType, queryString, queryExtra, nullptr, &size);
    if (FAILED(hr))
    {
        return std::nullopt;
    }

    response.resize(size - 1); // The returned size includes the terminating null character.

    hr = AssocQueryStringW(ASSOCF_NONE, queryType, queryString, queryExtra, response.data(), &size);
    if (FAILED(hr))
    {
        return std::nullopt;
    }

    return response;
}

} // namespace

OwnedIcon
iconFromAssociatedApplication(wchar_t const* filePath, int iconResolution)
{
    wchar_t const* extension = PathFindExtensionW(filePath);
    if (!extension || !*extension)
    {
        return makeOwnedIcon();
    }

    std::optional<std::wstring> path;

    path = assocQuery(ASSOCSTR_EXECUTABLE, extension, L"open");
    if (path)
    {
        wprintf(L"[%ls] ASSOCSTR_EXECUTABLE: %ls\n", extension, path->c_str());
    }

    path = assocQuery(ASSOCSTR_DEFAULTICON, extension, nullptr);
    if (path.has_value())
    {
        std::wstring iconFilePath;
        int iconIndex = 0;

        wchar_t const* comma = wcsrchr(path->data(), L',');
        if (comma)
        {
            iconIndex = wcstol(comma + 1, nullptr, 10);
        }

        if (*path == L"%1")
        {
            // Not sure where it's documented, but that's the case for .exe files.
            // Apparently that means: "Take the icon from argv[0]". So, let's do
            // just that.
            iconFilePath = filePath;
        }
        else
        {
            iconFilePath = *path;
            if (comma)
            {
                iconFilePath.resize(comma - path->data());
            }
        }

        SignedIndexIconSelector iconSelector(iconIndex);
        return iconFromPortableExecutableOrIcoFile(
            iconFilePath.c_str(), iconSelector, iconResolution);
    }
    else
    {
        path = assocQuery(ASSOCSTR_EXECUTABLE, extension, L"open");

        if (path.has_value())
        {
            DefaultIconSelector iconSelector;
            return iconFromPortableExecutable(path->c_str(), iconSelector, iconResolution);
        }
    }

    return makeOwnedIcon();
}
