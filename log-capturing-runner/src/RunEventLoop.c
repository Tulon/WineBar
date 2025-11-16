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

#include "RunEventLoop.h"

#include "HeadTailBuffer.h"
#include "MinMax.h"
#include "SpawnProcess.h"
#include "StreamStatus.h"
#include "TimespecUtils.h"

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/signalfd.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PER_CHANNEL_HALF_BUFFER_SIZE 8192
#define LOG_WRITE_DELAY_MS 500

typedef struct StdioStream
{
    /**
     * "stdout.txt" / "stderr.txt".
     */
    char const* fileName;

    HeadTailBuffer* headTailBuffer;

    struct timespec lastWriteToDiskTime;

    bool updatedSinceLastWrittenToDisk;
} StdioStream;

typedef struct EventLoopContext
{
    /**
     * Indicates we are to exit the event loop on the next iteration.
     */
    bool exiting;

    /**
     * Gets set to true when we receive a SIGTERM.
     */
    bool terminationRequested;

    char const* outDir;

    // Here, "main child" refers to the process we were asked to run.
    // If the main child has finished already, this member is set to -1.
    pid_t mainChildPid;
    int mainChildExitCode;

    // After the main child exits, we launch "wineserver -w" in order to wait for any application
    // processes still running to finish. When we are not running "wineserver -w", this member is
    // set to -1.
    pid_t wineserverWChildPid;

    // When we receive a SIGTERM while "wineserver -w" is running, we call "wineserver -k" to
    // make "wineserver -w" exit. When we are not running "wineserver -k", this member is set to
    // -1.
    pid_t wineserverKChildPid;

    char* wineserverExecutablePath;

    // Note: these members won't be initialized if disableLogCapture is set to false.
    StdioStream stdoutStream;
    StdioStream stderrStream;

    bool disableLogCapture;
} EventLoopContext;

static bool
initStdioStream(StdioStream* stream, char const* fileName)
{
    stream->fileName = fileName;

    memset(&stream->lastWriteToDiskTime, 0, sizeof(stream->lastWriteToDiskTime));

    stream->updatedSinceLastWrittenToDisk = false;

    stream->headTailBuffer =
        headTailBufferNew(PER_CHANNEL_HALF_BUFFER_SIZE, PER_CHANNEL_HALF_BUFFER_SIZE);

    return stream->headTailBuffer != NULL;
}

static void
freeStdioStream(StdioStream* stream)
{
    headTailBufferFree(stream->headTailBuffer);
    stream->headTailBuffer = NULL;
}

static EventLoopContext*
eventLoopContextNew(
    char const* outDir, char* wineserverExecutablePath, pid_t mainChildPid,
    int mainChildStdoutReadFd, int mainChildStderrReadFd, int signalFd, bool disableLogCapture)
{
    EventLoopContext* ctx = malloc(sizeof(EventLoopContext));
    if (!ctx)
    {
        goto skip_free_context;
    }

    ctx->exiting = false;
    ctx->terminationRequested = false;
    ctx->outDir = outDir;

    ctx->mainChildPid = mainChildPid;
    ctx->mainChildExitCode = 1; // A generic error.

    ctx->wineserverWChildPid = -1;
    ctx->wineserverKChildPid = -1;
    ctx->wineserverExecutablePath = wineserverExecutablePath;

    ctx->disableLogCapture = disableLogCapture;

    if (!disableLogCapture)
    {
        if (!initStdioStream(&ctx->stdoutStream, "stdout.txt"))
        {
            goto skip_free_stdout_stream;
        }

        if (!initStdioStream(&ctx->stderrStream, "stderr.txt"))
        {
            goto skip_free_stderr_stream;
        }
    }

    return ctx;

    freeStdioStream(&ctx->stderrStream);
skip_free_stderr_stream:

    freeStdioStream(&ctx->stdoutStream);
skip_free_stdout_stream:

    free(ctx);
skip_free_context:

    return NULL;
}

static void
eventLoopContextFree(EventLoopContext* ctx)
{
    if (!ctx->disableLogCapture)
    {
        freeStdioStream(&ctx->stderrStream);
        freeStdioStream(&ctx->stdoutStream);
    }
    free(ctx);
}

static void
processStreamEvents(EventLoopContext* ctx, StdioStream* stdioStream, struct pollfd* pfd, Log* log)
{
    bool error = (pfd->revents & (POLLERR | POLLNVAL)) != 0;
    bool eof = false;

    if (pfd->revents & POLLIN)
    {
        StreamStatus const streamStatus =
            headTailBufferAppendFromFd(stdioStream->headTailBuffer, pfd->fd);

        stdioStream->updatedSinceLastWrittenToDisk = true;

        if (streamStatus == STREAM_ERROR)
        {
            if (errno != EINTR && errno != EWOULDBLOCK)
            {
                error = true;
            }
        }
        else if (streamStatus == STREAM_EOF)
        {
            eof = true;
        }
    }
    else if (pfd->revents & POLLHUP)
    {
        eof = true;
    }

    if (pfd->fd >= 0 && (error || eof))
    {
        pfd->fd = -pfd->fd; // This effectively disables polling the given fd.
    }
}

static void
onSigtermReceived(EventLoopContext* ctx, struct signalfd_siginfo const* siginfo, Log* log)
{
    ctx->terminationRequested = true;

    if (ctx->mainChildPid != -1)
    {
        logPrintf(log, "Received SIGTERM. Forwarding it to the child.\n");

        if (kill(ctx->mainChildPid, SIGTERM) == -1)
        {
            logPrintf(log, "kill() failed on the main child: %s.\n", strerror(errno));
        }
        else
        {
            logPrintf(log, "SIGTERM delivered to the main child.\n");
        }
    }

    if (ctx->wineserverWChildPid != -1)
    {
        logPrintf(log, "Received SIGTERM while \"wineserver -w\" was running.\n");

        // Wineserver seems to ignore SIGTERM. The correct way to kill it is running
        // "wineserver -k".
        if (ctx->wineserverKChildPid != -1)
        {
            logPrintf(
                log,
                "Normally, we would run \"wineserver -k\" in such a case, but it's already "
                "running, so we do nothing.\n");
        }
        else
        {
            logPrintf(log, "Running \"wineserver -k\" to force \"wineserver -w\" to exit.\n");

            char* wineserverKCommandLine[] = {ctx->wineserverExecutablePath, "-k", NULL};
            ctx->wineserverKChildPid =
                spawnProcess(
                    wineserverKCommandLine, /*stdinStream=*/SPAWNED_PROCESS_STDIO_DEFAULT,
                    /*stdoutStream=*/SPAWNED_PROCESS_STDIO_DEFAULT,
                    /*stderrStream*/ SPAWNED_PROCESS_STDIO_DEFAULT, NULL, log)
                    .pid;

            if (ctx->wineserverKChildPid == -1)
            {
                logPrintf(
                    log, "Failed to start the \"wineserver -k\" process: %s\n", strerror(errno));
                ctx->exiting = true;
            }
        }
    }

    // We don't exit until the child actually terminates.
}

static void
onSigchldReceived(EventLoopContext* ctx, struct signalfd_siginfo const* siginfo, Log* log)
{
    // We still have to do waitpid() to avoid a zombie process.
    waitpid(siginfo->ssi_pid, NULL, WNOHANG);

    if (siginfo->ssi_pid == ctx->mainChildPid)
    {
        logPrintf(log, "The main child process exited with status %d.\n", (int)siginfo->ssi_status);

        ctx->mainChildPid = -1;
        ctx->mainChildExitCode = siginfo->ssi_status;

        logPrintf(log, "Running \"wineserver -w\" to wait for background processes to finish.\n");

        if (ctx->terminationRequested)
        {
            ctx->exiting = true;
        }
        else
        {
            // Start "wineserver -w" in order to wait for any application processes still
            // running to finish.
            char* wineserverWCommandLine[] = {ctx->wineserverExecutablePath, "-w", NULL};
            ctx->wineserverWChildPid =
                spawnProcess(
                    wineserverWCommandLine, /*stdinStream=*/SPAWNED_PROCESS_STDIO_DEFAULT,
                    /*stdoutStream=*/SPAWNED_PROCESS_STDIO_DEFAULT,
                    /*stderrStream*/ SPAWNED_PROCESS_STDIO_DEFAULT, NULL, log)
                    .pid;

            if (ctx->wineserverWChildPid == -1)
            {
                logPrintf(
                    log, "Failed to start the \"wineserver -w\" process: %s\n", strerror(errno));
                ctx->exiting = true;
            }
        }
    }
    else if (siginfo->ssi_pid == ctx->wineserverWChildPid)
    {
        logPrintf(
            log, "The \"wineserver -w\" process exited with status %d.\n",
            (int)siginfo->ssi_status);

        ctx->wineserverWChildPid = -1;
        ctx->exiting = true;
    }
}

static void
processSignalEvent(EventLoopContext* ctx, struct signalfd_siginfo const* siginfo, Log* log)
{
    switch (siginfo->ssi_signo)
    {
    case SIGTERM:
        onSigtermReceived(ctx, siginfo, log);
        break;
    case SIGCHLD:
        onSigchldReceived(ctx, siginfo, log);
        break;
    default:
        logPrintf(log, "Unexpected signal (%d) received\n", siginfo->ssi_signo);
        break;
    }
}

static void
processSignalFdEvents(EventLoopContext* ctx, struct pollfd* pfd, Log* log)
{
    if (pfd->revents & (POLLERR | POLLNVAL))
    {
        logPrintf(
            log,
            "[FATAL] Error on a signal file descriptor. Killing the child processes and "
            "exiting.\n");

        if (ctx->mainChildPid != -1)
        {
            kill(ctx->mainChildPid, SIGTERM);
        }

        // As for "wineserver -w", it seems to ignore SIGTERM.

        ctx->exiting = true;
        return;
    }

    if (pfd->revents & POLLIN)
    {
        struct signalfd_siginfo siginfo;
        ssize_t const bytesRead = read(pfd->fd, &siginfo, sizeof(siginfo));
        if (bytesRead < 0)
        {
            if (errno != EINTR && errno != EWOULDBLOCK)
            {
                logPrintf(
                    log, "[FATAL] Error reading from a signal file descriptor: %s\n",
                    strerror(errno));
                ctx->exiting = true;
                return;
            }
        }
        else if (bytesRead == 0)
        {
            // Should never happen, but it's not a problem if it does.
        }
        else if (bytesRead != sizeof(siginfo))
        {
            logPrintf(
                log, "[FATAL] Unexpected number of bytes read from a signal file descriptor\n");
            ctx->exiting = true;
        }
        else
        {
            processSignalEvent(ctx, &siginfo, log);
        }
    }
}

static void
writeHeadTailBuffer(HeadTailBuffer* buffer, char const* outDir, char const* fileName)
{
    size_t const outDirLen = strlen(outDir);
    size_t const fileNameLen = strlen(fileName);

    char filePath[outDirLen + 1 + fileNameLen + 1];
    snprintf(filePath, sizeof(filePath), "%s/%s", outDir, fileName);

    FILE* fp = fopen(filePath, "wb");
    if (!fp)
    {
        // We don't log this situation, as this function may get called many times.
        return;
    }

    HeadTailBufferData const data = headTailBufferGetData(buffer);

    if (fwrite(data.headBufferData.data, 1, data.headBufferData.size, fp) !=
        data.headBufferData.size)
    {
        goto done;
    }

    if (data.bytesDiscarded > 0)
    {
        if (fprintf(fp, "\n\n------------------- cut ----------------------\n\n") < 0)
        {
            goto done;
        }
    }

    for (int i = 0; i < data.tailBufferData.numChunks; ++i)
    {
        struct iovec const* chunk = &data.tailBufferData.chunks[i];
        if (fwrite(chunk->iov_base, 1, chunk->iov_len, fp) != chunk->iov_len)
        {
            goto done;
        }
    }

done:
    fclose(fp);
}

static void
writeExitStatus(int exitCode, char const* outDir, char const* fileName, Log* log)
{
    size_t const outDirLen = strlen(outDir);
    size_t const fileNameLen = strlen(fileName);

    char filePath[outDirLen + 1 + fileNameLen + 1];
    snprintf(filePath, sizeof(filePath), "%s/%s", outDir, fileName);

    FILE* fp = fopen(filePath, "wb");
    if (!fp)
    {
        logPrintf(log, "Failed to open file %s for writing: %s\n", filePath, strerror(errno));
        return;
    }

    fprintf(fp, "%d", exitCode);
    fclose(fp);
}

static int64_t
msTillWriteToDisk(StdioStream const* stream, struct timespec now)
{
    if (!stream->updatedSinceLastWrittenToDisk)
    {
        return INT64_MAX; // Doesn't need to be written.
    }

    if (isZeroTimespec(stream->lastWriteToDiskTime))
    {
        return 0; // Was never written to disk, so now is a good time.
    }

    struct timespec const nextWriteTime =
        timespecAddMsecs(stream->lastWriteToDiskTime, LOG_WRITE_DELAY_MS);

    return msecsFromTo(now, nextWriteTime);
}

static int
computePollTimeoutMs(EventLoopContext const* ctx)
{
    if (ctx->disableLogCapture)
    {
        return -1; // No timeout.
    }

    struct timespec const now = monotonicTimeNow();

    int64_t const msTillWriteStdout = msTillWriteToDisk(&ctx->stdoutStream, now);
    int64_t const msTillWriteStderr = msTillWriteToDisk(&ctx->stderrStream, now);
    int64_t const msTillAnyWrite = MIN(msTillWriteStdout, msTillWriteStderr);

    // poll() takes an int as a timeout and interprets a negative value as an
    // infinite timeout, so we have to clip our int64_t timeout from both sides.
    return (int)MIN((int64_t)INT_MAX, MAX(0, msTillAnyWrite));
}

/**
 * Writes a buffered stdout / stderr stream to disk, but only if it's dirty
 * and the time has come to do so. If @p now is null, the time is not checked
 * and the last written time is not updated. This mode is used when doing one
 * last write on exit.
 */
static void
maybeWriteStdioStreamToDisk(
    EventLoopContext* ctx, StdioStream* stdioStream, struct timespec const* now)
{
    if (stdioStream->updatedSinceLastWrittenToDisk &&
        (!now || msTillWriteToDisk(stdioStream, *now) <= 0))
    {
        writeHeadTailBuffer(stdioStream->headTailBuffer, ctx->outDir, stdioStream->fileName);
        stdioStream->updatedSinceLastWrittenToDisk = false;

        if (now)
        {
            stdioStream->lastWriteToDiskTime = *now;
        }
    }
}

int
runEventLoop(
    char const* outDir, char* wineserverExecutablePath, pid_t mainChildPid,
    int mainChildStdoutReadFd, int mainChildStderrReadFd, int signalFd, Log* log,
    bool disableLogCapture)
{
    enum
    {
        SIGNAL_FD_IDX,
        STDOUT_READ_FD_IDX,
        STDERR_READ_FD_IDX,
        NUM_POLL_FDS
    };

    struct pollfd pollFds[NUM_POLL_FDS];

    pollFds[SIGNAL_FD_IDX].fd = signalFd;
    pollFds[SIGNAL_FD_IDX].events = POLLIN;
    pollFds[STDOUT_READ_FD_IDX].fd = disableLogCapture ? -1 : mainChildStdoutReadFd;
    pollFds[STDOUT_READ_FD_IDX].events = POLLIN;
    pollFds[STDERR_READ_FD_IDX].fd = disableLogCapture ? -1 : mainChildStderrReadFd;
    pollFds[STDERR_READ_FD_IDX].events = POLLIN;

    EventLoopContext* ctx = eventLoopContextNew(
        outDir, wineserverExecutablePath, mainChildPid, mainChildStdoutReadFd,
        mainChildStderrReadFd, signalFd, disableLogCapture);
    if (!ctx)
    {
        return EXIT_FAILURE;
    }

    while (!ctx->exiting)
    {
        int const pollTimeoutMs = computePollTimeoutMs(ctx);
        int const pollRes = poll(pollFds, NUM_POLL_FDS, pollTimeoutMs);

        if (pollRes < 0)
        {
            // Error condition.

            if (errno == EINTR)
            {
                // The poll() was interrupted by a signal other than those we expect
                // from signalFd. That's not a problem and we just continue.
                continue;
            }
            else
            {
                logPrintf(log, "poll() failed: %s\n", strerror(errno));
                break;
            }
        }
        else
        {
            // We either have a timeout (pollres == 0) or some fd events.
            // Note that we want to call maybeWriteStdioStreamToDisk() in both cases.

            if (pollRes > 0)
            {
                if (!ctx->disableLogCapture)
                {
                    processStreamEvents(ctx, &ctx->stdoutStream, &pollFds[STDOUT_READ_FD_IDX], log);
                    processStreamEvents(ctx, &ctx->stderrStream, &pollFds[STDERR_READ_FD_IDX], log);
                }
                processSignalFdEvents(ctx, &pollFds[SIGNAL_FD_IDX], log);
            }

            if (!disableLogCapture)
            {
                // Q: Why can't we simply write stdout.txt / stderr.txt once on exit?
                // A: When we run under muvm and the user terminates the muvm process,
                //    we get terminated in a way that doesn't let us react in any way.
                //    Without periodic proactive writes, we'd have no logs at all in
                //    such a case.
                struct timespec const now = monotonicTimeNow();
                maybeWriteStdioStreamToDisk(ctx, &ctx->stdoutStream, &now);
                maybeWriteStdioStreamToDisk(ctx, &ctx->stderrStream, &now);
            }
        }
    }

    writeExitStatus(ctx->mainChildExitCode, ctx->outDir, "status.txt", log);

    if (!disableLogCapture)
    {
        maybeWriteStdioStreamToDisk(ctx, &ctx->stdoutStream, NULL);
        maybeWriteStdioStreamToDisk(ctx, &ctx->stderrStream, NULL);
    }

    int const mainChildExitCode = ctx->mainChildExitCode;

    eventLoopContextFree(ctx);

    return mainChildExitCode;
}
