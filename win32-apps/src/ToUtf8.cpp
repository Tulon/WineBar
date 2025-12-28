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

#include "ToUtf8.h"

#include <windows.h>

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
