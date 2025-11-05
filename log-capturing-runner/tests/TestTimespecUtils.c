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

#include "TimespecUtils.h"

#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <time.h>

#include <cmocka.h>

static void
timespec_utils_zero_timespec_detected_correctly(void** state)
{
    (void)state;

    struct timespec const zeroTimespec = {0, 0};
    struct timespec const nonZeroTimespec1 = {0, 1};
    struct timespec const nonZeroTimespec2 = {1, 0};

    assert_true(isZeroTimespec(zeroTimespec));
    assert_false(isZeroTimespec(nonZeroTimespec1));
    assert_false(isZeroTimespec(nonZeroTimespec2));
}

static void
timespec_utils_test_msecsFromTo(void** state)
{
    (void)state;

    struct timespec const tenSecOneMsec = {10, 1000000};
    struct timespec const nineSecExactly = {9, 0};

    assert_int_equal(msecsFromTo(tenSecOneMsec, tenSecOneMsec), 0);
    assert_int_equal(msecsFromTo(nineSecExactly, tenSecOneMsec), 1001);
    assert_int_equal(msecsFromTo(tenSecOneMsec, nineSecExactly), -1001);
}

static void
timespec_utils_test_timespecAddMsecs(void** state)
{
    (void)state;

    struct timespec const tenSecOneMsec = {10, 1000 * 1000};

    struct timespec const tenSecExactly = timespecAddMsecs(tenSecOneMsec, -1);
    assert_int_equal(tenSecExactly.tv_sec, 10);
    assert_int_equal(tenSecExactly.tv_nsec, 0);

    struct timespec const twelveSecExactly = timespecAddMsecs(tenSecOneMsec, 1999);
    assert_int_equal(twelveSecExactly.tv_sec, 12);
    assert_int_equal(twelveSecExactly.tv_nsec, 0);

    struct timespec const eightSec500Msec = timespecAddMsecs(tenSecOneMsec, -1501);
    assert_int_equal(eightSec500Msec.tv_sec, 8);
    assert_int_equal(eightSec500Msec.tv_nsec, 500 * 1000 * 1000);
}

int
main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(timespec_utils_zero_timespec_detected_correctly),
        cmocka_unit_test(timespec_utils_test_msecsFromTo),
        cmocka_unit_test(timespec_utils_test_timespecAddMsecs),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
