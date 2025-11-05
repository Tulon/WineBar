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

#include "TailBuffer.h"

#include "MinMax.h"

#include <sys/ioctl.h>

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct TailBuffer
{
    char* bufferData;

    /**
     * The number of bytes available starting from @p bufferData. Zero capacity is not allowed.
     */
    size_t bufferCapacity;

    /**
     * Specifies where the stored data begins, relative to @p bufferData.
     * This value shall be strictly less than @p bufferCapacity.
     */
    size_t dataBeginOffset;

    /**
     * The size of the data currently stored in the buffer.
     * This value by itself may not exceed the @p bufferCapacity but when summed with
     * @p dataBeginOffset, the sum may exceed it. That indicates the data wraps around.
     */
    size_t dataSize;
};

typedef struct ReservedSpace
{
    struct iovec chunks[4];
    int numChunks;
    size_t totalSpaceReserved;
} ReservedSpace;

static bool
tailBufferCheckInvariants(TailBuffer const* buffer)
{
    if (buffer->bufferCapacity == 0)
    {
        return false;
    }

    if (buffer->dataBeginOffset > buffer->bufferCapacity)
    {
        return false;
    }

    if (buffer->dataBeginOffset == buffer->bufferCapacity && buffer->bufferCapacity > 0)
    {
        return false;
    }

    if (buffer->dataSize > buffer->bufferCapacity)
    {
        return false;
    }

    return true;
}

TailBuffer*
tailBufferNew(size_t capacity)
{
    if (capacity == 0)
    {
        // Having a buffer with zero capacity doesn't make any sense and would cause
        // problems should we allow it.
        return NULL;
    }

    TailBuffer* buffer = malloc(sizeof(TailBuffer) + capacity);

    if (buffer)
    {
        buffer->bufferData = (char*)(buffer + 1);
        buffer->bufferCapacity = capacity;
        buffer->dataBeginOffset = 0;
        buffer->dataSize = 0;
        assert(tailBufferCheckInvariants(buffer));
    }

    return buffer;
}

void
tailBufferFree(TailBuffer* buffer)
{
    assert(tailBufferCheckInvariants(buffer));

    free(buffer);
}

TailBufferData
tailBufferGetData(TailBuffer const* buffer)
{
    assert(tailBufferCheckInvariants(buffer));

    TailBufferData data;

    int numChunks = 0;

    {
        // The 1st data chunk is the one that starts at the beginning of the data and goes
        // till the end of the data or till the end of the buffer, whichever comes first.

        size_t const dataChunkSize =
            MIN(buffer->dataSize, buffer->bufferCapacity - buffer->dataBeginOffset);

        if (dataChunkSize > 0)
        {
            data.chunks[numChunks].iov_base = buffer->bufferData + buffer->dataBeginOffset;
            data.chunks[numChunks].iov_len = dataChunkSize;
            ++numChunks;
        }
    }

    {
        // The 2nd data chunk is the one that starts at the beginning of the buffer
        // and goes till the end of the data.

        // This one may be negative, so we use a signed type on purpose.
        ptrdiff_t const dataChunkSize =
            buffer->dataBeginOffset + buffer->dataSize - buffer->bufferCapacity;

        if (dataChunkSize > 0)
        {
            data.chunks[numChunks].iov_base = buffer->bufferData;
            data.chunks[numChunks].iov_len = dataChunkSize;
            ++numChunks;
        }
    }

    data.numChunks = numChunks;

    return data;
}

static void
reservedSpaceAddChunk(ReservedSpace* reservedSpace, char* data, size_t size)
{
    assert(size > 0);

    assert(
        reservedSpace->numChunks <
        sizeof(reservedSpace->chunks) / sizeof(reservedSpace->chunks[0]));

    struct iovec* chunk = &reservedSpace->chunks[reservedSpace->numChunks];
    chunk->iov_base = data;
    chunk->iov_len = size;
    reservedSpace->totalSpaceReserved += size;
    ++reservedSpace->numChunks;
}

static void
copyDataIntoReservedSpace(char const* data, size_t const size, ReservedSpace const* reservedSpace)
{
    assert(reservedSpace->totalSpaceReserved >= size);

    char const* movingData = data;
    size_t sizeRemaining = size;

    for (int i = 0; i < reservedSpace->numChunks && sizeRemaining > 0; ++i)
    {
        struct iovec const* chunk = &reservedSpace->chunks[i];
        size_t const sizeToCopy = MIN(sizeRemaining, chunk->iov_len);
        memcpy(chunk->iov_base, movingData, sizeToCopy);
        movingData += sizeToCopy;
        sizeRemaining -= sizeToCopy;
    }
}

/**
 * Reserves up to maxSizeToAppend bytes in the buffer for appending to the existing data.
 *
 * This method may discard the existing data, calling the processDiscardedData callback,
 * if one was provided.
 */
static ReservedSpace
tailBufferReserveSpaceForAppending(
    TailBuffer* buffer, size_t maxSizeToReserve,
    void (*processDiscardedData)(char* data, size_t size, void* context),
    void* processDiscardedDataContext)
{
    assert(tailBufferCheckInvariants(buffer));

    ReservedSpace reservedSpace;
    memset(&reservedSpace, 0, sizeof(reservedSpace));

    {
        // The 1st free chunk would be located between the end of data and either the end of the
        // buffer or the beginning of the data, depending on whether the existing data wraps
        // around or not.

        size_t const freeChunkBeginOffset =
            (buffer->dataBeginOffset + buffer->dataSize) % buffer->bufferCapacity;

        size_t const freeChunkEndOffset =
            buffer->dataBeginOffset + buffer->dataSize == freeChunkBeginOffset
            ? buffer->bufferCapacity
            : buffer->dataBeginOffset;

        // Consider the edge case where the existing data wraps around, occupying the whole
        // buffer. In this case, freeChunkEndOffset gets set to buffer->dataBeginOffset,
        // which happens to be equal to freeChunkBeginOffset in such a case. So, freeChunkSize
        // ends up being 0, which is what we want.

        size_t const freeChunkSize = freeChunkEndOffset - freeChunkBeginOffset;
        size_t const sizeToReserve =
            MIN(freeChunkSize, maxSizeToReserve - reservedSpace.totalSpaceReserved);

        if (sizeToReserve > 0)
        {
            reservedSpaceAddChunk(
                &reservedSpace, buffer->bufferData + freeChunkBeginOffset, sizeToReserve);
        }
    }

    if (buffer->dataBeginOffset + buffer->dataSize <= buffer->bufferCapacity)
    {
        // The 2nd free chunk would be located from the beginning of the buffer and till the
        // beginning of the data, but only when the existing data doesn't wrap around.

        size_t const freeChunkSize = buffer->dataBeginOffset;
        size_t const sizeToReserve =
            MIN(freeChunkSize, maxSizeToReserve - reservedSpace.totalSpaceReserved);

        if (sizeToReserve > 0)
        {
            // As things stand now, this branch is unreachable. If would become reachable
            // if we implement some sort of trimFront() functionality.
            assert(!"Unreachable");

            reservedSpaceAddChunk(&reservedSpace, buffer->bufferData, sizeToReserve);
        }
    }

    // In case we were asked to reserve more space than the free space we have available,
    // we'll have to eat into our occupied data chunks, which we may have as many as 2.
    for (int i = 0; i < 2; ++i)
    {
        if (reservedSpace.totalSpaceReserved >= maxSizeToReserve)
        {
            assert(reservedSpace.totalSpaceReserved == maxSizeToReserve);
            break;
        }

        // The 1st data chunk is the one that starts at the beginning of the data and goes
        // till the end of the data or till the end of the buffer, whichever comes first.

        // The 2nd data chunk is the one that starts at the beginning of the buffer and
        // goes till the end of the data. However, if we discard the whole 1st data chunk
        // to make the space for the new data, then the 2nd one becomes the 1st one and
        // it would fit the definition of the 1st chunk, given above. If we don't discard the
        // whole 1st data chunk, then we won't try to reuse any part of the 2nd one. So, below
        // we only have the logic to trim or completely discard the 1st data chunk, and we
        // may apply that logic the 2nd time if necessary.

        size_t const dataChunkSize =
            MIN(buffer->dataSize, buffer->bufferCapacity - buffer->dataBeginOffset);

        if (dataChunkSize > 0)
        {
            char* dataChunkBegin = buffer->bufferData + buffer->dataBeginOffset;
            size_t const sizeToDiscard =
                MIN(dataChunkSize, maxSizeToReserve - reservedSpace.totalSpaceReserved);

            reservedSpaceAddChunk(&reservedSpace, dataChunkBegin, sizeToDiscard);

            buffer->dataBeginOffset += sizeToDiscard;
            buffer->dataBeginOffset %= buffer->bufferCapacity;
            buffer->dataSize -= sizeToDiscard;

            assert(tailBufferCheckInvariants(buffer));

            if (processDiscardedData)
            {
                processDiscardedData(dataChunkBegin, sizeToDiscard, processDiscardedDataContext);
            }
        }
    }

    return reservedSpace;
}

StreamStatus
tailBufferAppendFromFd(
    TailBuffer* buffer, int fd,
    void (*processDiscardedData)(char* data, size_t size, void* context),
    void* processDiscardedDataContext)
{
    assert(tailBufferCheckInvariants(buffer));

    int bytesAvailableForReading = 0;
    if (ioctl(fd, FIONREAD, &bytesAvailableForReading) < 0)
    {
        return STREAM_ERROR;
    }

    if (bytesAvailableForReading > 0)
    {
        ReservedSpace const reservedSpace = tailBufferReserveSpaceForAppending(
            buffer, bytesAvailableForReading, processDiscardedData, processDiscardedDataContext);

        assert(reservedSpace.totalSpaceReserved > 0);

        ssize_t const bytesRead = readv(fd, reservedSpace.chunks, reservedSpace.numChunks);
        if (bytesRead < 0)
        {
            return STREAM_ERROR;
        }
        else if (bytesRead == 0)
        {
            return STREAM_EOF;
        }
        else
        {
            buffer->dataSize += bytesRead;

            assert(tailBufferCheckInvariants(buffer));

            return STREAM_ALIVE;
        }
    }
    else
    {
        // The case where bytesAvailableForReading == 0 is tricky, as we still need to
        // differentiate between an EOF, an error and no data being available.
        // To achieve that, we try to read into a temporary buffer and should it succeed,
        // we call tailBufferReserveSpaceForAppending() and then copy the data from the
        // temporary buffer into the reserved space.

        char tempBuffer[4096];
        ssize_t const bytesRead =
            read(fd, tempBuffer, MIN(sizeof(tempBuffer), buffer->bufferCapacity));

        if (bytesRead < 0)
        {
            return STREAM_ERROR;
        }
        else if (bytesRead == 0)
        {
            return STREAM_EOF;
        }
        else
        {
            ReservedSpace const reservedSpace = tailBufferReserveSpaceForAppending(
                buffer, bytesRead, processDiscardedData, processDiscardedDataContext);

            assert(reservedSpace.totalSpaceReserved == bytesRead);

            copyDataIntoReservedSpace(tempBuffer, bytesRead, &reservedSpace);

            buffer->dataSize += bytesRead;

            assert(tailBufferCheckInvariants(buffer));

            return STREAM_ALIVE;
        }
    }
}
