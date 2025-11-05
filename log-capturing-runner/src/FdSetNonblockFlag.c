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

#include "FdSetNonblockFlag.h"

#include <fcntl.h>
#include <unistd.h>

bool
fdSetNonblockFlag(int fd, bool flagValue)
{
    int const currentFlags = fcntl(fd, F_GETFL, 0);
    if (currentFlags == -1)
    {
        return false;
    }

    int newFlags = currentFlags;
    if (flagValue)
    {
        newFlags |= O_NONBLOCK;
    }
    else
    {
        newFlags &= ~O_NONBLOCK;
    }

    if (fcntl(fd, F_SETFL, newFlags) == -1)
    {
        return false;
    }

    return true;
}
