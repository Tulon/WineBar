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

#include "PrintQuotedAndEscapedJsonString.h"

#include <assert.h>
#include <stddef.h>

void
printQuotedAndEscapedJsonString(FILE* sink, char const* str)
{
    static char const hexChars[] = "0123456789ABCDEF";
    assert(sizeof(hexChars) == 16 + 1);

    fputc('"', sink);

    // Escaping according to RFC-8259

    for (size_t i = 0; str[i]; ++i)
    {
        unsigned char const ch = str[i];
        switch (ch)
        {
        case 0x08: // backspace
            fprintf(sink, "\\b");
            break;
        case 0x09: // horizontal tab
            fprintf(sink, "\\t");
            break;
        case 0x0A: // newline
            fprintf(sink, "\\n");
            break;
        case 0x0C: // formfeed
            fprintf(sink, "\\f");
            break;
        case 0x0D: // carriage return
            fprintf(sink, "\\r");
            break;
        case 0x22: // quotation mark
            fprintf(sink, "\\\"");
            break;
        case 0x5C: // reverse solidus
            fprintf(sink, "\\\\");
            break;
        default:
            if (ch <= 0x1F)
            {
                fprintf(stdout, "\\u%04x", (unsigned)ch);
            }
            else
            {
                fputc(ch, sink);
            }
        }
    }

    fputc('"', sink);
}
