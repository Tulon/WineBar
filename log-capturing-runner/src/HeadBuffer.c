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

#include "HeadBuffer.h"

#include "MinMax.h"

#include <stdlib.h>
#include <string.h>

struct HeadBuffer
{
    char* data;
    size_t size;
    size_t capacity;
};

HeadBuffer*
headBufferNew(size_t capacity)
{
    HeadBuffer* buffer = malloc(sizeof(HeadBuffer) + capacity);

    if (buffer)
    {
        buffer->data = (char*)(buffer + 1);
        buffer->size = 0;
        buffer->capacity = capacity;
    }

    return buffer;
}

void
headBufferFree(HeadBuffer* buffer)
{
    free(buffer);
}

HeadBufferData
headBufferGetData(HeadBuffer const* buffer)
{
    HeadBufferData data = {.data = buffer->data, .size = buffer->size};
    return data;
}

size_t
headBufferAppend(HeadBuffer* buffer, void const* data, size_t size)
{
    size_t const bytesToWrite = MIN(buffer->capacity - buffer->size, size);

    if (bytesToWrite > 0)
    {
        memcpy(buffer->data + buffer->size, data, bytesToWrite);
        buffer->size += bytesToWrite;
    }

    return bytesToWrite;
}
