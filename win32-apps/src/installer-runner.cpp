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
#include "EnumerateFilesOnDesktop.h"
#include "FillPinDirectory.h"
#include "RunProcess.h"
#include "ScopeCleanup.h"
#include "ToWindowsFilePath.h"
#include "WStringException.h"

#include <windows.h>

// This one has to go after <windows.h>
#include <shellapi.h>

#include <algorithm>
#include <cstdio>
#include <exception>
#include <filesystem>
#include <format>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

extern "C"
{

int WINAPI
wWinMain(HINSTANCE /*hInstance*/, HINSTANCE /*hPrevInstance*/, PWSTR /*pCmdLine*/, int /*nCmdShow*/)
{
    // When the "Run Installer" function is invoked, Wine runs this launcher first, which
    // in turn runs the target executable. The launcher enumerates the items in the Desktop
    // folder before and after running the the target executable (the installer) in order to
    // detect which items were added by the installer. For each of those items, it extracts
    // their icon and other metadata and writes them to a pin directory.

    CoInitializer const coInitializer;

    int argc = 0;
    LPWSTR* argv = CommandLineToArgvW(GetCommandLineW(), &argc);

    ScopeCleanup const argvCleanup([argv] { LocalFree(argv); });

    if (argc < 3)
    {
        wprintf(L"Usage: %ls <unix_pins_dir> <unix_or_windows_executable> [args...]\n", argv[0]);
        return 1;
    }

    wchar_t const* unixPinsDir = argv[1];
    wchar_t const* unixOrWindowsExecutable = argv[2];

    try
    {
        // These will throw if the paths don't exist.
        auto const windowsPinsDir = toWindowsFilePath(unixPinsDir);
        auto const windowsExecutable = toWindowsFilePath(unixOrWindowsExecutable);

        std::vector<std::wstring> desktopFilesBefore = enumerateFilesOnDesktop();
        std::sort(desktopFilesBefore.begin(), desktopFilesBefore.end());

        int const exitCode = runProcess(windowsExecutable.c_str(), argv + 3, argc - 3);

        std::vector<std::wstring> desktopFilesAfter = enumerateFilesOnDesktop();
        std::sort(desktopFilesAfter.begin(), desktopFilesAfter.end());

        std::vector<std::wstring> addedDesktopFiles;
        std::set_difference(
            desktopFilesAfter.begin(), desktopFilesAfter.end(), desktopFilesBefore.begin(),
            desktopFilesBefore.end(), std::back_inserter(addedDesktopFiles));

        int pinSubdirNumber = 0;
        for (auto const& pinTargetFile : addedDesktopFiles)
        {
            ++pinSubdirNumber;

            std::wstring const windowsPinSubdir =
                std::format(L"{}\\{}", windowsPinsDir, pinSubdirNumber);

            try
            {
                std::filesystem::create_directory(windowsPinSubdir);
                fillPinDirectory(windowsPinSubdir.c_str(), pinTargetFile.c_str());
            }
            catch (WStringException const& e)
            {
                std::wcout << e.what() << std::endl;
            }
            catch (std::exception const& e)
            {
                std::cout << e.what() << std::endl;
            }
        }

        return exitCode;
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
}

} // extern "C"
