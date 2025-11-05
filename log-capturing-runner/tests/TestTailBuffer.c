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

#include <assert.h>
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

#include <cmocka.h>

static void
empty_tail_buffer_returns_empty_data(void** state)
{
    (void)state;

    int const capacity = 100;

    TailBuffer* buf = tailBufferNew(capacity);

    TailBufferData const data = tailBufferGetData(buf);
    assert_int_equal(data.numChunks, 0);

    tailBufferFree(buf);
}

static void
tail_buffer_adding_data_that_leaves_some_free_space(void** state)
{
    (void)state;

    int const capacity = 100;
    int const chunkSize = 50;

    TailBuffer* buf = tailBufferNew(capacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= chunkSize);

    int pipeFds[2];
    pipe(pipeFds);

    write(pipeFds[1], referenceData, chunkSize);

    // We don't have any existing data and we can read 50 bytes, given that we have 100
    // bytes of free space. So, a new chunk at [0, 50) is created.
    tailBufferAppendFromFd(buf, pipeFds[0], NULL, NULL);

    close(pipeFds[0]);
    close(pipeFds[1]);

    TailBufferData const data = tailBufferGetData(buf);
    assert_int_equal(data.numChunks, 1);

    // The [0, 50) chunk.
    assert_int_equal(data.chunks[0].iov_len, chunkSize);
    assert_memory_equal(data.chunks[0].iov_base, referenceData, chunkSize);

    tailBufferFree(buf);
}

static void
tail_buffer_adding_data_that_fills_an_empty_buffer_in_one_go(void** state)
{
    (void)state;

    int const capacity = 100;
    int const chunkSize = 100;

    TailBuffer* buf = tailBufferNew(capacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= chunkSize);

    int pipeFds[2];
    pipe(pipeFds);

    write(pipeFds[1], referenceData, chunkSize);

    // We don't have any existing data and we can read 100 bytes, which is
    // exactly the free space we've got. So a new chunk at [0, 100) is created.
    tailBufferAppendFromFd(buf, pipeFds[0], NULL, NULL);

    close(pipeFds[0]);
    close(pipeFds[1]);

    TailBufferData const data = tailBufferGetData(buf);
    assert_int_equal(data.numChunks, 1);

    // The [0, 100) chunk.
    assert_int_equal(data.chunks[0].iov_len, chunkSize);
    assert_memory_equal(data.chunks[0].iov_base, referenceData, chunkSize);

    tailBufferFree(buf);
}

static void
tail_buffer_adding_data_that_doesnt_cause_discarding_any_existing_data(void** state)
{
    (void)state;

    int const capacity = 100;
    int const firstChunkSize = 30;
    int const secondChunkSize = 70;

    TailBuffer* buf = tailBufferNew(capacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= firstChunkSize + secondChunkSize);

    int pipeFds[2];
    pipe(pipeFds);

    write(pipeFds[1], referenceData, firstChunkSize);

    // We have no data chunks, we have 100 bytes of free space and we can read 30 bytes.
    // As a result, a single chunk at [0, 30) is created.
    tailBufferAppendFromFd(buf, pipeFds[0], NULL, NULL);

    write(pipeFds[1], referenceData + firstChunkSize, secondChunkSize);

    // Now we can read another 70 bytes, which is exactly the free space we've got.
    // So, our only existing [0, 30) data chunk gets extended to [0, 100).
    tailBufferAppendFromFd(buf, pipeFds[0], NULL, NULL);

    close(pipeFds[0]);
    close(pipeFds[1]);

    TailBufferData const data = tailBufferGetData(buf);
    assert_int_equal(data.numChunks, 1);

    // The [0, 100) chunk.
    assert_int_equal(data.chunks[0].iov_len, firstChunkSize + secondChunkSize);
    assert_memory_equal(data.chunks[0].iov_base, referenceData, firstChunkSize + secondChunkSize);

    tailBufferFree(buf);
}

static void
process_discarded_data(char* data, size_t size, void* context)
{
    check_expected(size);
    check_expected(data);
}

static void
tail_buffer_adding_data_that_eats_into_the_1st_existing_chunk(void** state)
{
    (void)state;

    int const capacity = 100;
    int const firstChunkSize = 70;
    int const secondChunkSize = 50;

    TailBuffer* buf = tailBufferNew(capacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= firstChunkSize + secondChunkSize);

    int pipeFds[2];
    pipe(pipeFds);

    write(pipeFds[1], referenceData, firstChunkSize);

    // We have no data chunks, we have 100 bytes of free space and we can read 70 bytes.
    // As a result, a single data chunk of [0, 70) is created.
    tailBufferAppendFromFd(buf, pipeFds[0], NULL, NULL);

    write(pipeFds[1], referenceData + firstChunkSize, secondChunkSize);

    // Now we can read another 50 bytes, while we only have 30 bytes
    // of free space. So, our only data chunk gets trimmed to [20, 70)
    // and then extended to [20, 100). An extra chunk at [0, 20) is created.
    expect_value(process_discarded_data, size, 20);
    expect_memory(process_discarded_data, data, referenceData, 20);
    tailBufferAppendFromFd(buf, pipeFds[0], &process_discarded_data, NULL);

    close(pipeFds[0]);
    close(pipeFds[1]);

    TailBufferData const data = tailBufferGetData(buf);
    assert_int_equal(data.numChunks, 2);

    // The [20, 100) chunk.
    assert_int_equal(data.chunks[0].iov_len, 80);
    assert_memory_equal(data.chunks[0].iov_base, referenceData + 20, 80);

    // The [0, 20) chunk.
    assert_int_equal(data.chunks[1].iov_len, 20);
    assert_memory_equal(data.chunks[1].iov_base, referenceData + 100, 20);

    tailBufferFree(buf);
}

static void
tail_buffer_adding_data_that_eats_into_both_existing_chunks(void** state)
{
    (void)state;

    int const capacity = 100;
    int const firstChunkSize = 70;
    int const secondChunkSize = 50;
    int const thirdChunkSize = 90;

    TailBuffer* buf = tailBufferNew(capacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= firstChunkSize + secondChunkSize + thirdChunkSize);

    int pipeFds[2];
    pipe(pipeFds);

    write(pipeFds[1], referenceData, firstChunkSize);

    // We have no data chunks, we have 100 bytes of free space and we can read 70 bytes.
    // As a result, a single data chunk at [0, 70) is created.
    tailBufferAppendFromFd(buf, pipeFds[0], NULL, NULL);

    write(pipeFds[1], referenceData + firstChunkSize, secondChunkSize);

    // Now we can read another 50 bytes, while we only have 30 bytes
    // of free space. So, our only data chunk gets trimmed to [20, 70)
    // and then extended to [20, 100). An extra chunk at [0, 20) is created.
    tailBufferAppendFromFd(buf, pipeFds[0], NULL, NULL);

    write(pipeFds[1], referenceData + firstChunkSize + secondChunkSize, thirdChunkSize);

    // Now we can read another 90 bytes. The 1st chunk at [20, 100) gets completely
    // discarded and the 2nd chunk at [0, 20) gets trimmed to [10, 20) and then
    // extended to [10, 100) to accomodate the first 80 of 90 bytes we are to read.
    // Then, another chunk at [0, 10) is created to accomodate the remaining 10 bytes.
    expect_value(process_discarded_data, size, 80);
    expect_memory(process_discarded_data, data, referenceData + 20, 80);
    expect_value(process_discarded_data, size, 10);
    expect_memory(process_discarded_data, data, referenceData + 100, 10);
    tailBufferAppendFromFd(buf, pipeFds[0], &process_discarded_data, NULL);

    close(pipeFds[0]);
    close(pipeFds[1]);

    TailBufferData const data = tailBufferGetData(buf);
    assert_int_equal(data.numChunks, 2);

    // The [10, 100) chunk.
    assert_int_equal(data.chunks[0].iov_len, 90);
    assert_memory_equal(data.chunks[0].iov_base, referenceData + 110, 90);

    // The [0, 10) chunk.
    assert_int_equal(data.chunks[1].iov_len, 10);
    assert_memory_equal(data.chunks[1].iov_base, referenceData + 200, 10);

    tailBufferFree(buf);
}

int
main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(empty_tail_buffer_returns_empty_data),
        cmocka_unit_test(tail_buffer_adding_data_that_leaves_some_free_space),
        cmocka_unit_test(tail_buffer_adding_data_that_fills_an_empty_buffer_in_one_go),
        cmocka_unit_test(tail_buffer_adding_data_that_doesnt_cause_discarding_any_existing_data),
        cmocka_unit_test(tail_buffer_adding_data_that_eats_into_the_1st_existing_chunk),
        cmocka_unit_test(tail_buffer_adding_data_that_eats_into_both_existing_chunks),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
