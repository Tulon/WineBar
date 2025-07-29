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

#include "IconForFile.h"

#include "CaseInsensitiveCompare.h"
#include "DefaultIconSelector.h"
#include "IconForLnkFile.h"
#include "IconFromAssociatedApplication.h"
#include "IconFromIcoFile.h"
#include "IconFromPortableExecutable.h"
#include "WStringRuntimeError.h"

#include <shlwapi.h>
#include <windows.h>

#include <format>

OwnedIcon
iconForFile(wchar_t const* filePath, int iconResolution)
{
    wchar_t const* extension = PathFindExtensionW(filePath);
    if (extension && caseInsensitiveCompare(extension, L".lnk") == 0)
    {
        return iconForLnkFile(filePath, iconResolution);
    }
    else if (extension && caseInsensitiveCompare(extension, L".exe") == 0)
    {
        DefaultIconSelector iconSelector;
        return iconFromPortableExecutable(filePath, iconSelector, iconResolution);
    }
    else if (extension && caseInsensitiveCompare(extension, L".ico") == 0)
    {
        return iconFromIcoFile(filePath, iconResolution);
    }

    // This handles .msi files.
    if (auto icon = iconFromAssociatedApplication(filePath, iconResolution))
    {
        return icon;
    }

    throw WStringRuntimeError(
        std::format(
            L"{} is not an executable, .ico or .lnk file and doesn't have an associated "
            L"application to open it. Therefore, we can't get an icon for it.",
            filePath));
}
