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

#include "IconFromPortableExecutableOrIcoFile.h"

#include "IconFromIcoFile.h"
#include "IconFromPortableExecutable.h"
#include "OwnedTypes.h"
#include "WStringException.h"
#include "WStringRuntimeError.h"

#include <windows.h>

#include <format>

OwnedIcon
iconFromPortableExecutableOrIcoFile(
    wchar_t const* filePath, ResourceIconSelector& iconSelector, int iconResolution)
{
    auto const loadedModule =
        makeOwnedModule(LoadLibraryExW(filePath, nullptr, LOAD_LIBRARY_AS_DATAFILE));

    if (loadedModule)
    {
        return iconFromPortableExecutable(loadedModule.get(), iconSelector, iconResolution);
    }

    try
    {
        return iconFromIcoFile(filePath, iconResolution);
    }
    catch (WStringException const& e)
    {
        throw WStringRuntimeError(
            std::format(
                L"File {} is not a portable executable and trying to open it as an .ico file "
                L"resulted in the following error: {}",
                filePath, e.what()));
    }
}
