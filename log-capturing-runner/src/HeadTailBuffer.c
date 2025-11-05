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

#include "HeadTailBuffer.h"

#include <stdlib.h>

struct HeadTailBuffer
{
    HeadBuffer* headBuffer;
    TailBuffer* tailBuffer;
    size_t bytesDiscarded;
};

HeadTailBuffer*
headTailBufferNew(size_t headBufferCapacity, size_t tailBufferCapacity)
{
    HeadTailBuffer* buffer = malloc(sizeof(HeadTailBuffer));
    if (!buffer)
    {
        goto skip_free_buffer;
    }

    if (!(buffer->headBuffer = headBufferNew(headBufferCapacity)))
    {
        goto skip_free_head_buffer;
    }

    if (!(buffer->tailBuffer = tailBufferNew(tailBufferCapacity)))
    {
        goto skip_free_tail_buffer;
    }

    buffer->bytesDiscarded = 0;

    return buffer;

    tailBufferFree(buffer->tailBuffer);
skip_free_tail_buffer:

    headBufferFree(buffer->headBuffer);
skip_free_head_buffer:

    free(buffer);
skip_free_buffer:

    return NULL;
}

void
headTailBufferFree(HeadTailBuffer* buffer)
{
    if (!buffer)
    {
        return;
    }

    tailBufferFree(buffer->tailBuffer);
    headBufferFree(buffer->headBuffer);
    free(buffer);
}

HeadTailBufferData
headTailBufferGetData(HeadTailBuffer const* buffer)
{
    HeadTailBufferData data = {
        .headBufferData = headBufferGetData(buffer->headBuffer),
        .tailBufferData = tailBufferGetData(buffer->tailBuffer),
        .bytesDiscarded = buffer->bytesDiscarded};

    return data;
}

static void
processDataDiscardedByTailBuffer(char* data, size_t size, void* context)
{
    HeadTailBuffer* buffer = context;
    size_t const bytesConsumed = headBufferAppend(buffer->headBuffer, data, size);
    buffer->bytesDiscarded += size - bytesConsumed;
}

StreamStatus
headTailBufferAppendFromFd(HeadTailBuffer* buffer, int fd)
{
    return tailBufferAppendFromFd(
        buffer->tailBuffer, fd, &processDataDiscardedByTailBuffer, buffer);
}
