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

#include "PrintHexEncodedByteArray.h"

#include <assert.h>

void
printHexEncodedByteArray(FILE* sink, unsigned char const* data, size_t dataSize)
{
    static char const hexChars[] = "0123456789abcdef";
    assert(sizeof(hexChars) == 16 + 1);

    size_t const bufSize = dataSize * 2;
    char buf[bufSize];

    for (size_t i = 0; i < dataSize; ++i)
    {
        size_t const byte = data[i];

        buf[i * 2] = hexChars[byte >> 4];
        buf[i * 2 + 1] = hexChars[byte & 0x0f];
    }

    fwrite(buf, 1, bufSize, sink);
}
