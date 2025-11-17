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

#include "RunProcess.h"

#include "CaseInsensitiveCompare.h"
#include "CommandLineBuilder.h"
#include "ErrorString.h"

#include <windows.h>

#include <cstdio>
#include <cstring>
#include <string>

/**
 * Runs the executable at argv[0], waits for it to exit and returns its exit code.
 */
int
runProcess(wchar_t const* windowsExecutable, wchar_t* args[], int numArgs)
{
    CommandLineBuilder cmdLineBuilder;
    cmdLineBuilder.addArg(windowsExecutable);
    for (int i = 0; i < numArgs; ++i)
    {
        cmdLineBuilder.addArg(args[i]);
    }

    std::wstring commandLine = cmdLineBuilder.retrieveCommandLine();

    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    si.dwFlags |= STARTF_USESTDHANDLES;
    si.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE); // Connect to our stdout.
    si.hStdError = GetStdHandle(STD_ERROR_HANDLE);   // Connect to our stderr.
    ZeroMemory(&pi, sizeof(pi));

    DWORD flags = 0;

    if (caseInsensitiveCompare(windowsExecutable, L"start") == 0 ||
        caseInsensitiveCompare(windowsExecutable, L"start.exe") == 0)
    {
        // start.exe is a console application, so we need to suppress its console
        // window. When wine is told to launch start.exe, it seems to suppress the
        // console on its own. However, in this case, start.exe is started by us,
        // and so it's up to us to suppress it.
        flags |= CREATE_NO_WINDOW;
    }

    // Create the process.
    if (!CreateProcessW(
            nullptr, commandLine.data(), nullptr, nullptr, TRUE, flags, nullptr, nullptr, &si, &pi))
    {
        auto const errorCode = GetLastError();
        wprintf(L"CreateProcess failed: %ls\n", errorStringFromErrorCode(errorCode).get());
        return 1;
    }

    // We create a job object in order to automatically kill our child process in case
    // the parent (us) terminates.
    HANDLE hJob = CreateJobObjectW(nullptr, nullptr);

    // Configure the job object to kill all the processes associated with it when the
    // job closes. The job is closed when the last handle to that job is closed. We never
    // call CloseHandle(hJob), but the handle will be closed automatically when our process
    // terminates, causing the child process to be terminated as well.
    JOBOBJECT_EXTENDED_LIMIT_INFORMATION limitInfo;
    memset(&limitInfo, 0, sizeof(limitInfo));
    limitInfo.BasicLimitInformation.LimitFlags =
        JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE | JOB_OBJECT_LIMIT_SILENT_BREAKAWAY_OK;
    SetInformationJobObject(hJob, JobObjectExtendedLimitInformation, &limitInfo, sizeof(limitInfo));

    // Finally, we assign our child process to the job.
    AssignProcessToJobObject(hJob, pi.hProcess);

    // Wait until child process exits.
    WaitForSingleObject(pi.hProcess, INFINITE);

    DWORD exitCode;
    if (!GetExitCodeProcess(pi.hProcess, &exitCode))
    {
        auto const errorCode = GetLastError();
        wprintf(L"GetExitCodeProcess failed: %ls\n", errorStringFromErrorCode(errorCode).get());
        exitCode = 1;
    }

    // Close process and thread handles.
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    return static_cast<int>(exitCode);
}
