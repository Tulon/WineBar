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
 * The purpose of a HeadBuffer object is to accept binary data in chunks, but only
 * store the first N bytes of the data stream. Think of the Unix `head` utility that
 * does a similar thing.
 */

#include <stddef.h>

typedef struct HeadBuffer HeadBuffer;

typedef struct HeadBufferData
{
    void* data;
    size_t size;
} HeadBufferData;

HeadBuffer* headBufferNew(size_t capacity);

void headBufferFree(HeadBuffer* buffer);

HeadBufferData headBufferGetData(HeadBuffer const* buffer);

/**
 * Takes a chunk of binary data and writes (some of) it into the buffer, as long as the buffer
 * still has free space.
 *
 * Returns the number of bytes actually written to the buffer. This value may be smaller than
 * @p size.
 */
size_t headBufferAppend(HeadBuffer* buffer, void const* data, size_t size);
