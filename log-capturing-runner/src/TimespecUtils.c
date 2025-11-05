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

bool
isZeroTimespec(struct timespec const time)
{
    return time.tv_sec == 0 && time.tv_nsec == 0;
}

int64_t
msecsFromTo(struct timespec const timeFrom, struct timespec const timeTo)
{
    static int64_t const million = 1000 * 1000;

    return (int64_t)(timeTo.tv_sec - timeFrom.tv_sec) * 1000 +
        (int64_t)(timeTo.tv_nsec - timeFrom.tv_nsec) / million;
}

static int64_t
divideByPositiveNumberRoundingTowardsNegativeInfinity(int64_t num, int64_t denom)
{
    int64_t quotient = num / denom;

    if (num % denom < 0)
    {
        --quotient;
    }

    return quotient;
}

/**
 * Ensures time->tv_nsec be in the range of [0, 1 000 000 000).
 */
static void
normalizeTimespec(struct timespec* time)
{
    static int64_t const billion = 1000 * 1000 * 1000;

    // May be a negative number.
    int64_t const excessiveSeconds =
        divideByPositiveNumberRoundingTowardsNegativeInfinity(time->tv_nsec, billion);

    time->tv_sec += excessiveSeconds;
    time->tv_nsec -= excessiveSeconds * billion;
}

struct timespec
timespecAddMsecs(struct timespec const time, int64_t const deltaMs)
{
    static int64_t const million = 1000 * 1000;

    struct timespec modifiedTime = time;
    modifiedTime.tv_sec += deltaMs / 1000;
    modifiedTime.tv_nsec += (deltaMs % 1000) * million;

    normalizeTimespec(&modifiedTime);

    return modifiedTime;
}

struct timespec
monotonicTimeNow()
{
    struct timespec time = {0, 0};
    clock_gettime(CLOCK_MONOTONIC, &time);
    return time;
}
