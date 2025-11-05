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

/**
 * The purpose of a TailBuffer object is to read from a file descriptor from time to time
 * and only keep the last N bytes read (possibly across different reads). Think of the Unix
 * `tail` utility that does a similar thing. To avoid constantly doing memmove(), the
 * implementation is using a ring buffer, which means the stored data won't generally be
 * continous.
 *
 * In addition, TailBuffer can optionally make a callback each time it discards some old
 * data. That makes it easy to implement a HEAD + TAIL buffer, where the data discarded
 * from the tail buffer is written to the head buffer, until it's full.
 */

#include "StreamStatus.h"

#include <sys/uio.h>

#include <stddef.h>

typedef struct TailBuffer TailBuffer;

typedef struct TailBufferData
{
    struct iovec chunks[2];
    int numChunks;
} TailBufferData;

TailBuffer* tailBufferNew(size_t capacity);

void tailBufferFree(TailBuffer* buffer);

TailBufferData tailBufferGetData(TailBuffer const* buffer);

/**
 * Reads data from the provided file descriptor and updates the buffer accordingly.
 *
 * @param buffer The buffer to update.
 * @param fd The file descriptor to read data from.
 * @param processDiscardedData If provided, this callback is called when data from the
 *        beginning of the buffer has to be discarded to make room for new data.
 * @param processDiscardedDataContext This argument is passed as the last argument to
 *        @p processDiscardedData.
 * @return The status of the input stream, based on the return value of read() / readv().
 *         Should STREAM_ERROR be returned, errno will indicate the exact reason.
 *         Some reasons, like EINTR and EGAIN may need to be treated as a non-error.
 */
StreamStatus tailBufferAppendFromFd(
    TailBuffer* buffer, int fd,
    void (*processDiscardedData)(char* data, size_t size, void* context),
    void* processDiscardedDataContext);
