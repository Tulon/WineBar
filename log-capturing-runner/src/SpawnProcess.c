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

#include "SpawnProcess.h"

#include "FdSetCloexecFlag.h"

#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/**
 * Creates a pipe if the value of @p stdio requires it.
 *
 * Returns true if the pipe was created or if that wasn't necessary.
 * Returns false on error.
 */
static bool
maybeMakePipe(int pipeFds[2], SpawnedProcessStdio stdio)
{
    switch (stdio)
    {
    case SPAWNED_PROCESS_STDIO_DEFAULT:
        return true;
    case SPAWNED_PROCESS_STDIO_PIPE:
        return pipe(pipeFds) != -1;
    }

    assert(!"Unreachable");
    return true;
}

/**
 * Duplicates a file descriptor if the value of @p stdio requires it.
 *
 * Returns true if the descriptor was duplicated or if that wasn't necessary.
 * Returns false on error.
 */
static bool
dupFdIfNecessary(int sourceFd, int targetFd, SpawnedProcessStdio stdio)
{
    switch (stdio)
    {
    case SPAWNED_PROCESS_STDIO_DEFAULT:
        return true;
    case SPAWNED_PROCESS_STDIO_PIPE:
        return dup2(sourceFd, targetFd) != -1;
    }

    assert(!"Unreachable");
    return true;
}

static void
setFdCloexecIfOpen(int fd)
{
    if (fd != -1)
    {
        fdSetCloexecFlag(fd, true);
    }
}

static void
closeFdIfOpen(int fd)
{
    if (fd != -1)
    {
        close(fd);
    }
}

static void
closePipeIfOpen(int pipeFds[2])
{
    for (int i = 0; i < 2; ++i)
    {
        closeFdIfOpen(pipeFds[i]);
    }
}

SpawnedProcess
spawnProcess(
    char* commandLine[], SpawnedProcessStdio stdinStream, SpawnedProcessStdio stdoutStream,
    SpawnedProcessStdio stderrStream, sigset_t const* sigMask, Log* log)
{
    SpawnedProcess ret = {.pid = -1, .stdinPipeFd = -1, .stdoutPipeFd = -1, .stderrPipeFd = -1};

    int stdinPipe[2] = {-1, -1};
    int stdoutPipe[2] = {-1, -1};
    int stderrPipe[2] = {-1, -1};
    pid_t pid = -1;

    if (!maybeMakePipe(stdinPipe, stdinStream) || !maybeMakePipe(stdoutPipe, stdoutStream) ||
        !maybeMakePipe(stderrPipe, stderrStream))
    {
        logPrintf(log, "Creating a pipe failed: %s\n", strerror(errno));
        goto close_pipes;
    }

    pid = fork();
    if (pid == -1)
    {
        // Error.
        logPrintf(log, "fork() failed: %s\n", strerror(errno));
        goto close_pipes;
    }
    else if (pid == 0)
    {
        // Child process.

        if (sigMask)
        {
            if (sigprocmask(SIG_SETMASK, sigMask, NULL) == -1)
            {
                logPrintf(log, "sigprocmask() failed in child process: %s\n", strerror(errno));
                exit(EXIT_FAILURE);
            }
        }

        // Duplicate the appropriate end of the pipes into the stdio descriptor numbers.
        if (!dupFdIfNecessary(stdinPipe[0], STDIN_FILENO, stdinStream) ||
            !dupFdIfNecessary(stdoutPipe[1], STDOUT_FILENO, stdoutStream) ||
            !dupFdIfNecessary(stderrPipe[1], STDERR_FILENO, stderrStream))
        {
            logPrintf(log, "Duplicating a file descriptor failed: %s\n", strerror(errno));
            exit(EXIT_FAILURE);
        }

        // Close the pipes. We've already duplicated the appropriate ends that we will use.
        closePipeIfOpen(stdinPipe);
        closePipeIfOpen(stdoutPipe);
        closePipeIfOpen(stderrPipe);

        // This function only returns on error.
        execvp(commandLine[0], commandLine);

        logPrintf(log, "execvp() failed: %s\n", strerror(errno));

        exit(EXIT_FAILURE);
    }
    else
    {
        // Parent process.

        // Close the ends of pipes the parent is not going to need.
        closeFdIfOpen(stdinPipe[0]);
        closeFdIfOpen(stdoutPipe[1]);
        closeFdIfOpen(stderrPipe[1]);

        // If the parent process spawns more child processes, there is no need for
        // them to inherit the pipes for communicating with the given child process.
        setFdCloexecIfOpen(stdinPipe[1]);
        setFdCloexecIfOpen(stdoutPipe[0]);
        setFdCloexecIfOpen(stderrPipe[0]);

        ret.pid = pid;
        ret.stdinPipeFd = stdinPipe[1];
        ret.stdoutPipeFd = stdoutPipe[0];
        ret.stderrPipeFd = stderrPipe[0];
        return ret;
    }

close_pipes:
    closePipeIfOpen(stderrPipe);
    closePipeIfOpen(stdoutPipe);
    closePipeIfOpen(stdinPipe);

    return ret;
}
