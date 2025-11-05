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

#include "Log.h"

#include "FdSetCloexecFlag.h"

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Log
{
    FILE* file;
};

static void
markAsCloexec(FILE* file)
{
    int fd = fileno(file);
    if (fd == -1)
    {
        fprintf(stderr, "fileno() failed: %s\n", strerror(errno));
        return;
    }

    if (!fdSetCloexecFlag(fd, true))
    {
        fprintf(
            stderr, "Failed to set the close-on-exec flag on a file descriptor: %s\n",
            strerror(errno));
        return;
    }
}

Log*
logOpenFile(char const* outDir, char const* fileName)
{
    Log* log = malloc(sizeof(Log));
    if (!log)
    {
        return NULL;
    }

    size_t const outDirLen = strlen(outDir);
    size_t const fileNameLen = strlen(fileName);

    char logFilePath[outDirLen + 1 + fileNameLen + 1];
    snprintf(logFilePath, sizeof(logFilePath), "%s/%s", outDir, fileName);

    log->file = fopen(logFilePath, "w");
    if (log->file)
    {
        markAsCloexec(log->file);
    }
    else
    {
        fprintf(stderr, "Failed to open the log file %s: %s\n", logFilePath, strerror(errno));
        // We don't treat the failure to open a log file as fatal.
    }

    return log;
}

void
logClose(Log* log)
{
    assert(log);

    if (log->file)
    {
        fclose(log->file);
    }

    free(log);
}

void
logPrintf(Log* log, char const* format, ...)
{
    assert(log);

    if (log->file)
    {
        va_list args;
        va_start(args, format);
        vfprintf(log->file, format, args);
        va_end(args);

        // When we run under muvm and the user terminates the muvm process,
        // we get terminated in a way that doesn't let us react in any way.
        // So, flusing after each write is what we do to get the proper log
        // in such a case.
        fflush(log->file);
    }
}
