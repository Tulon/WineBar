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

#include <assert.h>
#include <fcntl.h>
#include <setjmp.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <cmocka.h>

static void
empty_head_buffer_returns_empty_data(void** state)
{
    (void)state;

    int const capacity = 100;

    HeadBuffer* buf = headBufferNew(capacity);

    HeadBufferData const data = headBufferGetData(buf);
    assert_uint_equal(data.size, 0);

    headBufferFree(buf);
}

static void
head_buffer_adding_data_that_leaves_some_free_space(void** state)
{
    (void)state;

    size_t const capacity = 100;
    size_t const chunkSize = 80;

    HeadBuffer* buf = headBufferNew(capacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= chunkSize);

    size_t const bytesWritten = headBufferAppend(buf, referenceData, chunkSize);

    HeadBufferData const data = headBufferGetData(buf);

    assert_uint_equal(bytesWritten, chunkSize);
    assert_uint_equal(data.size, chunkSize);
    assert_memory_equal(data.data, referenceData, chunkSize);

    headBufferFree(buf);
}

static void
head_buffer_adding_more_data_than_what_buffer_can_hold(void** state)
{
    (void)state;

    size_t const capacity = 100;
    size_t const chunkSize = 130;

    HeadBuffer* buf = headBufferNew(capacity);

    uint8_t referenceData[256];
    for (size_t i = 0; i < sizeof(referenceData); ++i)
    {
        referenceData[i] = i;
    }

    assert(sizeof(referenceData) >= chunkSize);

    size_t const bytesWritten = headBufferAppend(buf, referenceData, chunkSize);

    HeadBufferData const data = headBufferGetData(buf);

    assert_uint_equal(bytesWritten, capacity);
    assert_uint_equal(data.size, capacity);
    assert_memory_equal(data.data, referenceData, capacity);

    headBufferFree(buf);
}

int
main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(empty_head_buffer_returns_empty_data),
        cmocka_unit_test(head_buffer_adding_data_that_leaves_some_free_space),
        cmocka_unit_test(head_buffer_adding_more_data_than_what_buffer_can_hold),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
