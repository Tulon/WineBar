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

#include <signal.h>
#include <unistd.h>

typedef struct SpawnedProcess
{
    /**
     * The PID of the spawned process, or -1 on error.
     */
    pid_t pid;

    /**
     * The pipe fds are only set if the corresponding SpawnedProcessStream was set to
     * SPAWNED_PROCESS_STDIO_PIPE. Otherwise, these members are set to -1.
     */
    int stdinPipeFd;
    int stdoutPipeFd;
    int stderrPipeFd;
} SpawnedProcess;

/**
 * This enum specifies how stdin / stdout / stderr of the spawned process should behave.
 */
typedef enum SpawnedProcessStdio
{
    /**
     * The spawned process will create its own stream that won't be connected anywhere.
     */
    SPAWNED_PROCESS_STDIO_DEFAULT,

    /**
     * The parent process creates a pipe and a child process connects to it. The other
     * end of the pipe is returned in the SpawnedProcess structure.
     */
    SPAWNED_PROCESS_STDIO_PIPE,
} SpawnedProcessStdio;

/**
 * Forks and execs a new process.
 *
 * @param commandLine The argv[] of the new process, terminated by a null pointer.
 * @param stdinStream Specifies what to do with the STDIO stream.
 * @param stdoutStream Specifies what to do with the STDOUT stream.
 * @param stderrStream Specifies what to do with the STDERR stream.
 * @return A SpawnedProcess instance. In case of an error, SpawnedProcess.pid is set to -1.
 */
SpawnedProcess spawnProcess(
    char* commandLine[], SpawnedProcessStdio stdinStream, SpawnedProcessStdio stdoutStream,
    SpawnedProcessStdio stderrStream, sigset_t const* sigMask, Log* log);
