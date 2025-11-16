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

// This runner runs the command it's told to run and captures its stdout,
// stderr, and the exit status to files, but in such a way that it will only
// write a limited number of bytes. Besides, after running the command, it
// runs "wineserver -w" in order to wait for the running wine processes to
// finish. When running inside muvm, we can't return as soon as the wine
// executable exits, as that happens before the process it has started
// finishes.

#include "FdSetCloexecFlag.h"
#include "FdSetNonblockFlag.h"
#include "Log.h"
#include "RunEventLoop.h"
#include "SpawnProcess.h"

#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/signalfd.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static int
setupSignalsAndReturnSignalFd(sigset_t* oldSigMask, Log* log)
{
    sigset_t handledSignalsSet;

    if (sigemptyset(&handledSignalsSet) == -1)
    {
        logPrintf(log, "sigemptyset() failed: %s\n", strerror(errno));
        return -1;
    }

    static int const signals[] = {SIGTERM, SIGCHLD};

    for (size_t i = 0; i < sizeof(signals) / sizeof(signals[0]); ++i)
    {
        if (sigaddset(&handledSignalsSet, signals[i]) == -1)
        {
            logPrintf(log, "sigaddset() failed: %s\n", strerror(errno));
            return -1;
        }
    }

    if (sigprocmask(SIG_BLOCK, &handledSignalsSet, oldSigMask) == -1)
    {
        logPrintf(log, "sigprocmask() failed: %s\n", strerror(errno));
        return -1;
    }

    int const signalFd = signalfd(-1, &handledSignalsSet, SFD_NONBLOCK | SFD_CLOEXEC);
    if (signalFd == -1)
    {
        logPrintf(log, "signalfd() failed: %s\n", strerror(errno));
        return -1;
    }

    return signalFd;
}

int
main(int argc, char* argv[])
{
    int exitCode = EXIT_FAILURE;

    if (argc < 3)
    {
        fprintf(stderr, "Usage: %s <outdir> <command> [args]\n", argv[0]);
        return exitCode;
    }

    char const* const outDir = argv[1];

    struct stat outDirStat;
    if (lstat(outDir, &outDirStat) == -1 || (outDirStat.st_mode & S_IFMT) != S_IFDIR)
    {
        fprintf(stderr, "Output directory %s doesn't exist or is not a directory\n", outDir);
        return exitCode;
    }

    char const* const disableLoggingEnvVar = getenv("LOG_CAPTURING_RUNNER_DISABLE_LOGGING");
    bool const disableLogging = disableLoggingEnvVar && atoi(disableLoggingEnvVar) != 0;

    Log* log = logOpenFile(outDir, "log-capturing-runner.txt", disableLogging);
    if (!log)
    {
        return exitCode;
    }

    char* const wineserverExecutablePath = getenv("WINESERVER");
    if (!wineserverExecutablePath)
    {
        // After the main command we run "wineserver -w" in order to wait for any application
        // processes still running to finish.
        logPrintf(log, "The required WINESERVER environment variable wasn't provided\n");
        goto close_log;
    }

    if (!getenv("WINEPREFIX"))
    {
        // The wineserver process seems to use the WINEPREFIX environment variable, so we insist
        // for it to be set. I've observed that without the WINEPREFIX environment variable set,
        // "wineserver -w" exits immediately, when it was expected to wait for the running processes
        // to finish.
        logPrintf(log, "The required WINEPREFIX environment variable wasn't provided\n");
        goto close_log;
    }

    char** mainChildCommandLine = argv + 2;

    sigset_t oldSigMask;
    int const signalFd = setupSignalsAndReturnSignalFd(&oldSigMask, log);
    if (signalFd == -1)
    {
        goto close_log;
    }

    SpawnedProcess const spawnedProcess = spawnProcess(
        mainChildCommandLine, /*stdinStream=*/SPAWNED_PROCESS_STDIO_DEFAULT,
        /*stdoutStream=*/SPAWNED_PROCESS_STDIO_PIPE,
        /*stderrStream=*/SPAWNED_PROCESS_STDIO_PIPE, &oldSigMask, log);
    if (spawnedProcess.pid == -1)
    {
        logPrintf(log, "Failed to spawn process %s: %s\n", argv[2], strerror(errno));
        goto close_signalfd;
    }

    if (!fdSetNonblockFlag(spawnedProcess.stdoutPipeFd, true) ||
        !fdSetNonblockFlag(spawnedProcess.stderrPipeFd, true))
    {
        logPrintf(log, "Failed to set the non-blocking flag on a file descriptor\n");
        goto close_pipes;
    }

    // After the process we've just spawned finishes, we'll run wineserver -w in order to wait
    // for any application processes still running to finish. There is no need for these pipes
    // to be inherited by that process, though that shouldn't hurt either.
    fdSetCloexecFlag(spawnedProcess.stdoutPipeFd, true);
    fdSetCloexecFlag(spawnedProcess.stderrPipeFd, true);

    exitCode = runEventLoop(
        outDir, wineserverExecutablePath, spawnedProcess.pid, spawnedProcess.stdoutPipeFd,
        spawnedProcess.stderrPipeFd, signalFd, log, disableLogging);

    return exitCode;

close_pipes:
    close(spawnedProcess.stderrPipeFd);
    close(spawnedProcess.stdoutPipeFd);

close_signalfd:
    close(signalFd);

close_log:
    logClose(log);

    return exitCode;
}
