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

#include "IconFromPortableExecutable.h"

#include "ErrorString.h"
#include "OwnedTypes.h"
#include "PickIconGroupResource.h"
#include "WStringRuntimeError.h"

#include <windows.h>

#include <format>
#include <optional>
#include <utility>

namespace
{

struct LoadedResource
{
    HRSRC mResourceInfo;
    OwnedResourceData mResourceData;
    void const* mResourceBytes;

    /**
     * size_t would be more appropriate but the underlying win32 APIs use DWORD.
     */
    DWORD mResourceSize;
};

std::optional<LoadedResource>
loadResource(HMODULE module, LPCWSTR resourceName, LPCWSTR resourceType)
{
    auto const resourceInfo = FindResource(module, resourceName, resourceType);
    if (!resourceInfo)
    {
        return std::nullopt;
    }

    auto resourceData = makeOwnedResourceData(LoadResource(module, resourceInfo));
    if (!resourceData)
    {
        return std::nullopt;
    }

    auto const resourceBytes = LockResource(resourceData.get());
    if (!resourceBytes)
    {
        return std::nullopt;
    }

    auto const resourceSize = SizeofResource(module, resourceInfo);
    if (resourceSize == 0)
    {
        return std::nullopt;
    }

    return LoadedResource{resourceInfo, std::move(resourceData), resourceBytes, resourceSize};
}

} // namespace

OwnedIcon
iconFromPortableExecutable(
    wchar_t const* filePath, ResourceIconSelector& iconSelector, int iconResolution)
{
    auto const loadedModule =
        makeOwnedModule(LoadLibraryExW(filePath, nullptr, LOAD_LIBRARY_AS_DATAFILE));

    if (!loadedModule)
    {
        throw WStringRuntimeError(
            std::format(
                L"Failed to load executable {}: {}", filePath,
                errorStringFromErrorCode(GetLastError()).get()));
    }

    try
    {
        return iconFromPortableExecutable(loadedModule.get(), iconSelector, iconResolution);
    }
    catch (WStringException const& e)
    {
        throw WStringRuntimeError(
            std::format(L"Failed to extract an icon from executable {}: {}", filePath, e.what()));
    }
}

OwnedIcon
iconFromPortableExecutable(HMODULE module, ResourceIconSelector& iconSelector, int iconResolution)
{
    pickIconGroupResource(module, iconSelector);
    wchar_t const* selectedResourceName = iconSelector.selectedResource();
    if (!selectedResourceName)
    {
        throw WStringRuntimeError(iconSelector.reasonForNoSelection());
    }

    auto const iconGroupResource = loadResource(module, selectedResourceName, RT_GROUP_ICON);
    if (!iconGroupResource.has_value())
    {
        throw WStringRuntimeError(L"Failed to load the RT_GROUP_ICON resource data");
    }

    int const iconResourceId = LookupIconIdFromDirectoryEx(
        (PBYTE)iconGroupResource->mResourceBytes,
        TRUE, // Load the icon not a cursor.
        iconResolution, iconResolution, LR_DEFAULTCOLOR);
    if (iconResourceId == 0)
    {
        throw WStringRuntimeError(
            std::format(
                L"LookupIconIdFromDirectoryEx() failed: {}",
                errorStringFromErrorCode(GetLastError()).get()));
    }

    auto const iconResource = loadResource(module, MAKEINTRESOURCEW(iconResourceId), RT_ICON);
    if (!iconResource.has_value())
    {
        throw WStringRuntimeError(L"Failed to load the RT_ICON resource data");
    }

    const HICON hIcon = CreateIconFromResourceEx(
        (PBYTE)iconResource->mResourceBytes, iconResource->mResourceSize,
        TRUE,       // Loading an icon, not a cursor.
        0x00030000, // Icon data format version.
        iconResolution, iconResolution, LR_DEFAULTCOLOR);
    if (!hIcon)
    {
        throw WStringRuntimeError(
            std::format(
                L"CreateIconFromResourceEx() failed: {}",
                errorStringFromErrorCode(GetLastError()).get()));
    }

    return makeOwnedIcon(hIcon);
}
