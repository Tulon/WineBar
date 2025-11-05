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

#include "FdSetNonblockFlag.h"

#include <assert.h>
#include <fcntl.h>
#include <setjmp.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

#include <cmocka.h>

static void
empty_head_tail_buffer_returns_empty_data(void** state)
{
    (void)state;

    int const headBufferCapacity = 50;
    int const tailBufferCapacity = 50;

    HeadTailBuffer* buf = headTailBufferNew(headBufferCapacity, tailBufferCapacity);

    HeadTailBufferData const data = headTailBufferGetData(buf);
    assert_uint_equal(data.headBufferData.size, 0);
    assert_int_equal(data.tailBufferData.numChunks, 0);

    headTailBufferFree(buf);
}

static void
head_tail_buffer_adding_data_that_leaves_no_gap(void** state)
{
    (void)state;

    size_t const headBufferCapacity = 40;
    size_t const tailBufferCapacity = 60;
    size_t const chunkSize = 100;

    HeadTailBuffer* buf = headTailBufferNew(headBufferCapacity, tailBufferCapacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= chunkSize);

    int pipeFds[2];
    pipe(pipeFds);

    fdSetNonblockFlag(pipeFds[0], true);

    write(pipeFds[1], referenceData, chunkSize);

    for (;;)
    {
        StreamStatus const status = headTailBufferAppendFromFd(buf, pipeFds[0]);
        if (status != STREAM_ALIVE)
        {
            break;
        }
    }

    close(pipeFds[0]);
    close(pipeFds[1]);

    HeadTailBufferData const data = headTailBufferGetData(buf);

    assert_uint_equal(data.headBufferData.size, headBufferCapacity);
    assert_memory_equal(data.headBufferData.data, referenceData, headBufferCapacity);

    // First, the tail buffer will read 60 bytes out of 100, as 60 is its capacity.
    // That will create a chunk at [0, 60). Then, it will trim that chunk to [40, 60),
    // in order to reserve the space for another 40 bytes. Then it will create another
    // chunk at [0, 40) to hold the newly read 40 bytes.

    assert_int_equal(data.tailBufferData.numChunks, 2);

    assert_uint_equal(data.tailBufferData.chunks[0].iov_len, 20);
    assert_memory_equal(data.tailBufferData.chunks[0].iov_base, referenceData + 40, 20);

    assert_uint_equal(data.tailBufferData.chunks[1].iov_len, 40);
    assert_memory_equal(data.tailBufferData.chunks[1].iov_base, referenceData + 60, 40);

    assert_uint_equal(data.bytesDiscarded, 0);

    headTailBufferFree(buf);
}

static void
head_tail_buffer_adding_data_that_leaves_a_gap(void** state)
{
    (void)state;

    size_t const headBufferCapacity = 40;
    size_t const tailBufferCapacity = 30;
    size_t const chunkSize = 100;

    HeadTailBuffer* buf = headTailBufferNew(headBufferCapacity, tailBufferCapacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= chunkSize);

    int pipeFds[2];
    pipe(pipeFds);

    fdSetNonblockFlag(pipeFds[0], true);

    write(pipeFds[1], referenceData, chunkSize);

    for (;;)
    {
        StreamStatus const status = headTailBufferAppendFromFd(buf, pipeFds[0]);
        if (status != STREAM_ALIVE)
        {
            break;
        }
    }

    close(pipeFds[0]);
    close(pipeFds[1]);

    HeadTailBufferData const data = headTailBufferGetData(buf);

    assert_uint_equal(data.headBufferData.size, headBufferCapacity);
    assert_memory_equal(data.headBufferData.data, referenceData, headBufferCapacity);

    // The tail buffer will read a 30 byte (its capacity) chunk 3 times. The first two
    // it will completely discard (feeding the data to the head buffer) to make space
    // for the new data, and the last one it will trim to [10, 30), in order to read
    // the remaining 10 bytes. Then, another chunk at [0, 10) will be created to hold
    // the newly read data.

    assert_int_equal(data.tailBufferData.numChunks, 2);

    assert_uint_equal(data.tailBufferData.chunks[0].iov_len, 20);
    assert_memory_equal(data.tailBufferData.chunks[0].iov_base, referenceData + 70, 20);

    assert_uint_equal(data.tailBufferData.chunks[1].iov_len, 10);
    assert_memory_equal(data.tailBufferData.chunks[1].iov_base, referenceData + 90, 10);

    assert_uint_equal(data.bytesDiscarded, chunkSize - headBufferCapacity - tailBufferCapacity);

    headTailBufferFree(buf);
}

int
main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(empty_head_tail_buffer_returns_empty_data),
        cmocka_unit_test(head_tail_buffer_adding_data_that_leaves_no_gap),
        cmocka_unit_test(head_tail_buffer_adding_data_that_leaves_a_gap),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
