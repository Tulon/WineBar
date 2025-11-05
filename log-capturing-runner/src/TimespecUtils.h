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

#include <stdbool.h>
#include <stdint.h>
#include <time.h>

/**
 * Returns true if time.tv_sec == 0 && time.tv_nsec == 0.
 */
bool isZeroTimespec(struct timespec time);

/**
 * Computes the number of milliseconds between @p timeFrom and @p timeTo.
 *
 * The returned value may be negative.
 */
int64_t msecsFromTo(struct timespec timeFrom, struct timespec timeTo);

/**
 * Adds or subtracts the given number of milliseconds to a timespec value.
 */
struct timespec timespecAddMsecs(struct timespec time, int64_t deltaMs);

/**
 * A convenience wrapper around glock_getttime(CLOCK_MONOTONIC).
 */
struct timespec monotonicTimeNow();
