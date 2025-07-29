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

#include "EscapeAndQuoteJsonString.h"

#include <windows.h>

#include <iterator> // for std::size()

namespace
{

std::string
toUtf8(std::wstring_view wideString)
{
    int const sizeNeeded = WideCharToMultiByte(
        CP_UTF8, 0, wideString.data(), (int)wideString.size(), nullptr, 0, nullptr, nullptr);

    std::string utf8String(sizeNeeded, '\0');

    WideCharToMultiByte(
        CP_UTF8, 0, wideString.data(), (int)wideString.size(), utf8String.data(), sizeNeeded,
        nullptr, nullptr);

    return utf8String;
}

} // namespace

std::string
escapeAndQuoteJsonString(std::wstring_view wideString)
{
    std::string const utf8String = toUtf8(wideString);

    std::string quotedString;
    quotedString.reserve(utf8String.size() + 2);
    quotedString += '"';

    static char const hexChars[] = "0123456789ABCDEF";
    static_assert(std::size(hexChars) == 16 + 1);

    // Escaping according to RFC-8259

    for (unsigned char ch : utf8String)
    {
        switch (ch)
        {
        case 0x08: // backspace
            quotedString += '\\';
            quotedString += 'b';
            break;
        case 0x09: // horizontal tab
            quotedString += '\\';
            quotedString += 't';
            break;
        case 0x0A: // newline
            quotedString += '\\';
            quotedString += 'n';
            break;
        case 0x0C: // formfeed
            quotedString += '\\';
            quotedString += 'f';
            break;
        case 0x0D: // carriage return
            quotedString += '\\';
            quotedString += 'r';
            break;
        case 0x22: // quotation mark
            quotedString += '\\';
            quotedString += '\"';
            break;
        case 0x5C: // reverse solidus
            quotedString += '\\';
            quotedString += '\\';
            break;
        default:
            if (ch <= 0x1F)
            {
                quotedString += '\\';
                quotedString += 'u';
                quotedString += '0';
                quotedString += '0';
                quotedString += hexChars[(ch >> 4) & 0x0F];
                quotedString += hexChars[ch & 0x0F];
            }
            else
            {
                quotedString += ch;
            }
        }
    }

    quotedString += '"';

    return quotedString;
}
