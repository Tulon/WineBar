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

#include "CoInitializer.h"
#include "CommandLineBuilder.h"
#include "ErrorString.h"
#include "IconForFile.h"
#include "IconFromPortableExecutable.h"
#include "OwnedTypes.h"
#include "ScopeCleanup.h"
#include "SignedIndexIconSelector.h"
#include "ToWindowsFilePath.h"
#include "WStringException.h"
#include "WriteIconToPng.h"
#include "WritePinnedExecutableJson.h"

#include <shellapi.h>
#include <shlwapi.h>
#include <windows.h>

#include <cstdio>
#include <cstring>
#include <exception>
#include <format>
#include <iostream>
#include <optional>

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

extern "C"
{

int WINAPI
wWinMain(HINSTANCE /*hInstance*/, HINSTANCE /*hPrevInstance*/, PWSTR /*pCmdLine*/, int /*nCmdShow*/)
{
    // This program extracts the executable's icon and some metadata and writes
    // them as files to a directory passed to us as an argument.

    CoInitializer const coInitializer;

    int argc = 0;
    LPWSTR* argv = CommandLineToArgvW(GetCommandLineW(), &argc);

    ScopeCleanup const argvCleanup([argv] { LocalFree(argv); });

    if (argc < 3)
    {
        wprintf(L"Usage: %ls <unix_pin_dir> <unix_or_windows_executable>\n", argv[0]);
        return 1;
    }

    wchar_t const* unixPinDir = argv[1];
    wchar_t const* unixOrWindowsExecutable = argv[2];

    static wchar_t const kExtractedIconFileName[] = L"icon.png";

    try
    {
        // Note that for these conversion to succeed, the directoryies / files have to exist.
        auto const windowsPinDir = toWindowsFilePath(unixPinDir);
        auto const windowsExecutable = toWindowsFilePath(unixOrWindowsExecutable);

        auto const windowsPngOutputPath =
            std::format(L"{}\\{}", windowsPinDir, kExtractedIconFileName);

        bool const iconExtracted =
            tryExtractIconFromExecutable(windowsExecutable.c_str(), windowsPngOutputPath.c_str());

        wchar_t const* windowsExecutableFileName = PathFindFileNameW(windowsExecutable.c_str());
        wchar_t const* windowsExecutableExtension = PathFindExtensionW(windowsExecutableFileName);
        std::wstring_view const label(windowsExecutableFileName, windowsExecutableExtension);

        try
        {
            writePinnedExecutableJsonToPinDirectory(
                windowsPinDir, label, windowsExecutable, iconExtracted);
        }
        catch (WStringException const& e)
        {
            std::wcout << e.what() << std::endl;
            return 1;
        }
        catch (std::exception const& e)
        {
            std::cout << e.what() << std::endl;
            return 1;
        }

        return 0;
    }
    catch (WStringException const& e)
    {
        std::wcout << e.what() << std::endl;
    }
    catch (std::exception const& e)
    {
        std::cout << e.what() << std::endl;
    }

    return 1;
}

} // extern "C"
