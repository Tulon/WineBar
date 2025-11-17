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
#include "IconFromPortableExecutable.h"
#include "OwnedTypes.h"
#include "SignedIndexIconSelector.h"
#include "ToWindowsFilePath.h"
#include "WStringException.h"
#include "WriteIconToPng.h"
#include "WritePinJson.h"

#include <shlwapi.h>

#include <exception>
#include <format>
#include <iostream>
#include <string>
#include <string_view>

namespace
{

bool
tryExtractIconFromExecutable(
    wchar_t const* windowsExecutableFilePath, wchar_t const* windowsPngOutputPath)
{
    int const iconResolution = 256;

    OwnedIcon icon = makeOwnedIcon();

    try
    {
        icon = iconForFile(windowsExecutableFilePath, iconResolution);
    }
    catch (WStringException const& e)
    {
        std::wcout << e.what() << std::endl;
    }
    catch (std::exception const& e)
    {
        std::cout << e.what() << std::endl;
    }

    if (!icon)
    {
        std::wcout
            << std::format(
                   L"Failed to get an icon for {}. Will try to get a default icon instead.",
                   windowsExecutableFilePath)
            << std::endl;

        try
        {
            SignedIndexIconSelector iconSelector(-(INT_PTR)IDI_WINLOGO);
            icon = iconFromPortableExecutable(L"user32", iconSelector, iconResolution);
        }
        catch (WStringException const& e)
        {
            std::wcout << L"Failed to get a default icon: " << e.what() << std::endl;
        }
        catch (std::exception const& e)
        {
            std::cout << "Failed to get a default icon: " << e.what() << std::endl;
        }
    }

    if (!icon)
    {
        return false;
    }

    try
    {
        writeIconToPng(icon.get(), windowsPngOutputPath);
        return true;
    }
    catch (WStringException const& e)
    {
        std::wcout << e.what() << std::endl;
    }
    catch (std::exception const& e)
    {
        std::cout << e.what() << std::endl;
    }

    return false;
}

} // namespace

void
fillPinDirectory(wchar_t const* windowsPinDir, wchar_t const* unixOrWindowsPinTargetPath)
{
    static wchar_t const kExtractedIconFileName[] = L"icon.png";

    auto const windowsPinTargetPath = toWindowsFilePath(unixOrWindowsPinTargetPath);

    auto const windowsPngOutputPath = std::format(L"{}\\{}", windowsPinDir, kExtractedIconFileName);

    bool const iconExtracted =
        tryExtractIconFromExecutable(windowsPinTargetPath.c_str(), windowsPngOutputPath.c_str());

    wchar_t const* windowsPinTargetFileName = PathFindFileNameW(windowsPinTargetPath.c_str());
    wchar_t const* windowsPinTargetExtension = PathFindExtensionW(windowsPinTargetFileName);
    std::wstring_view const label(windowsPinTargetFileName, windowsPinTargetExtension);

    writePinJson(windowsPinDir, label, windowsPinTargetPath, iconExtracted);
}
