/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025-2026 Josif Arcimovic
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
#include "DetectAddedOrUpdatedFilesOnDesktop.h"
#include "EnumerateFilesOnDesktop.h"
#include "FileLogger.h"
#include "FileOnDesktop.h"
#include "FillPinDirectory.h"
#include "Logger.h"
#include "NoOpLogger.h"
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
#include <iterator>
#include <memory>
#include <string>
#include <utility>
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

    if (argc < 4)
    {
        fwprintf(
            stderr,
            L"Usage: %ls <unix_logs_dir> <unix_pins_dir> <unix_or_windows_executable> [args...]\n",
            argv[0]);
        return 1;
    }

    wchar_t const* unixLogsDir = argv[1];
    wchar_t const* unixPinsDir = argv[2];
    wchar_t const* unixOrWindowsExecutable = argv[3];

    std::unique_ptr<Logger> logger;

    try
    {
        // toWindowFilePath() throws if the path doesn't exist.
        logger = std::make_unique<FileLogger>(
            std::format(L"{}\\installer-runner.txt", toWindowsFilePath(unixLogsDir)).c_str());
    }
    catch (WStringException const& e)
    {
        fwprintf(stderr, L"Failed to create a log file: %ls\n", e.what());
        logger = std::make_unique<NoOpLogger>();
    }
    catch (std::exception const& e)
    {
        fprintf(stderr, "Failed to create a log file: %s\n", e.what());
        logger = std::make_unique<NoOpLogger>();
    }

    try
    {
        // These will throw if the paths don't exist.
        auto const windowsPinsDir = toWindowsFilePath(unixPinsDir);
        auto const windowsExecutable = toWindowsFilePath(unixOrWindowsExecutable);

        std::vector<FileOnDesktop> desktopFilesBefore = enumerateFilesOnDesktop();

        int const exitCode = runProcess(windowsExecutable.c_str(), argv + 4, argc - 4, *logger);

        logger->writeFormatted(L"Installer finished with status {}.\n", exitCode);

        std::vector<FileOnDesktop> desktopFilesAfter = enumerateFilesOnDesktop();

        std::vector<FileOnDesktop> const newDesktopFiles = detectAddedOrUpdatedFilesOnDesktop(
            std::move(desktopFilesBefore), std::move(desktopFilesAfter),
            /*removeDuplicates=*/true);

        logger->writeFormatted(
            L"Detected {} added or updated files on the desktop.\n", newDesktopFiles.size());

        int numPinsExtracted = 0;
        int numPinsFailedToExtract = 0;
        int pinSubdirNumber = 0;
        for (FileOnDesktop const& fileOnDesktop : newDesktopFiles)
        {
            ++pinSubdirNumber;

            std::wstring const windowsPinSubdir =
                std::format(L"{}\\{}", windowsPinsDir, pinSubdirNumber);

            std::wstring const pinTargetFilePath = fileOnDesktop.filePath();

            logger->writeFormatted(L"Extracting information from {}.\n", pinTargetFilePath);

            try
            {
                std::filesystem::create_directory(windowsPinSubdir);
                fillPinDirectory(windowsPinSubdir.c_str(), pinTargetFilePath.c_str(), *logger);
                ++numPinsExtracted;
            }
            catch (WStringException const& e)
            {
                ++numPinsFailedToExtract;
                logger->writeFormatted(L"{}\n", e.what());
            }
            catch (std::exception const& e)
            {
                ++numPinsFailedToExtract;
                logger->writeFormatted("{}\n", e.what());
            }
        }

        if (!newDesktopFiles.empty())
        {
            logger->writeFormatted(L"\nExtracted pinning info for {} apps.\n", numPinsExtracted);

            if (numPinsFailedToExtract > 0)
            {
                logger->writeFormatted(
                    L"Failed to extract pinning info for {} apps.\n", numPinsFailedToExtract);
            }
        }

        return exitCode;
    }
    catch (WStringException const& e)
    {
        logger->writeFormatted(L"{}\n", e.what());
        return 1;
    }
    catch (std::exception const& e)
    {
        logger->writeFormatted("{}\n", e.what());
        return 1;
    }
}

} // extern "C"
