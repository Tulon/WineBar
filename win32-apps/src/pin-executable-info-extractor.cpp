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
#include "FillPinDirectory.h"
#include "ScopeCleanup.h"
#include "ToWindowsFilePath.h"
#include "WStringException.h"

#include <windows.h>

// This one has to go after <windows.h>
#include <shellapi.h>

#include <cstdio>
#include <exception>
#include <iostream>

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

    try
    {
        auto const windowsPinDir = toWindowsFilePath(unixPinDir);

        fillPinDirectory(windowsPinDir.c_str(), unixOrWindowsExecutable);

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
