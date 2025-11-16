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

#pragma once

#include "Log.h"

#include <stdbool.h>
#include <unistd.h>

/**
 * Runs the event loop until the child exists and then runs "wineserver -w" in order to wait
 * for the still running wine processes to finish. Finally, it saves the "status.txt",
 * "stdout.txt", "stderr.txt" in @p outDir.
 *
 * @param outDir The directory to store the "status.txt", "stdout.txt", "stderr.txt" files in.
 *        This directory is presumed to exist already.
 * @param wineserverExecutablePath The path to the "wineserever" executable. We run
 *        "wineserver -w" aftter the main child in order to wait for any application
 *        processes still running to finish.
 * @param mainChildPid The PID of the process we were told to run. It's called "main child"
 *        because we also run "wineserver -w" afterwards.
 * @param mainChildStdoutReadFd The file descriptor through which we can read the main
 *        child's stdout.
 * @param mainChildStderrReadFd The file descriptor through which we can rean the main\
 *        child's stderr.
 * @param signalFd The file descriptor returned from signalfd() through which we expect to
 *        be notified of SIGCHLD and SIGTERM signals.
 * @param log The log object.
 * @param disableLogCapture If set to true, disables capturing stdout / stderr from the
 *        child process.
 * @return The exit code of the child process.
 */
int runEventLoop(
    char const* outDir, char* wineserverExecutablePath, pid_t mainChildPid,
    int mainChildStdoutReadFd, int mainChildStderrReadFd, int signalFd, Log* log,
    bool disableLogCapture);
