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
#include "FileLogger.h"
#include "FillPinDirectory.h"
#include "Logger.h"
#include "NoOpLogger.h"
#include "ScopeCleanup.h"
#include "ToWindowsFilePath.h"
#include "WStringException.h"

#include <windows.h>

// This one has to go after <windows.h>
#include <shellapi.h>

#include <cstdio>
#include <exception>
#include <format>
#include <memory>

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

    if (argc < 4)
    {
        wprintf(
            L"Usage: %ls <unix_log_dir> <unix_pin_dir> <unix_or_windows_executable>\n", argv[0]);
        return 1;
    }

    wchar_t const* unixLogsDir = argv[1];
    wchar_t const* unixPinDir = argv[2];
    wchar_t const* unixOrWindowsExecutable = argv[3];

    std::unique_ptr<Logger> logger;

    try
    {
        // toWindowFilePath() throws if the path doesn't exist.
        logger = std::make_unique<FileLogger>(
            std::format(L"{}\\pin-info-extractor.txt", toWindowsFilePath(unixLogsDir)).c_str());
    }
    catch (std::exception const& e)
    {
        fprintf(stderr, "Failed to create a log file: %s\n", e.what());
        logger = std::make_unique<NoOpLogger>();
    }

    try
    {
        auto const windowsPinDir = toWindowsFilePath(unixPinDir);

        fillPinDirectory(windowsPinDir.c_str(), unixOrWindowsExecutable, *logger);

        logger->writeFormatted(L"Pin information extracted successfully\n");

        return 0;
    }
    catch (WStringException const& e)
    {
        logger->writeFormatted(L"{}\n", e.what());
    }
    catch (std::exception const& e)
    {
        logger->writeFormatted("{}\n", e.what());
    }

    return 1;
}

} // extern "C"
