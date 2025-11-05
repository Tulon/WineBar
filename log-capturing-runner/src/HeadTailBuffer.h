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
 * The purpose of a HeadTailBuffer object is to read from a file descriptor from time to time
 * and keep up to N first bytes of the stream and up to M last bytes, with the constraint that
 * those data ranges are distinct.
 */

#include "HeadBuffer.h"
#include "StreamStatus.h"
#include "TailBuffer.h"

#include <stddef.h>

typedef struct HeadTailBuffer HeadTailBuffer;

typedef struct HeadTailBufferData
{
    /**
     * The prefix of the stream. Note that the prefix and the suffix store distinct data.
     */
    HeadBufferData headBufferData;

    /**
     * The suffix of the stream. Note that the prefix and the suffix store distinct data.
     */
    TailBufferData tailBufferData;

    /**
     * Indicates the number of bytes discarded between the head and the tail buffers.
     */
    size_t bytesDiscarded;
} HeadTailBufferData;

HeadTailBuffer* headTailBufferNew(size_t headBufferCapacity, size_t tailBufferCapacity);

void headTailBufferFree(HeadTailBuffer* buffer);

HeadTailBufferData headTailBufferGetData(HeadTailBuffer const* buffer);

/**
 * Reads data from the provided file descriptor and updates the buffer accordingly.
 *
 * @param buffer The buffer to update.
 * @param fd The file descriptor to read data from.
 * @return The status of the input stream, based on the return value of read() / readv().
 *         Should STREAM_ERROR be returned, errno will indicate the exact reason.
 *         Some reasons, like EINTR and EGAIN may need to be treated as a non-error.
 */
StreamStatus headTailBufferAppendFromFd(HeadTailBuffer* buffer, int fd);
