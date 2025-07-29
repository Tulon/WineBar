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

#include "ErrorString.h"

#include <windows.h>

#include <cstring>
#include <format>

ErrorStringPtr
errorStringFromWString(std::wstring const& wstring)
{
    auto const bufSize = wstring.size() + 1;
    wchar_t* buf = new wchar_t[bufSize];

    memcpy(buf, wstring.data(), sizeof(*buf) * bufSize);

    return ErrorStringPtr(buf, [](wchar_t const* buf) { delete[] buf; });
}

ErrorStringPtr
errorStringFromErrorCode(DWORD errorCode) noexcept
{
    LPWSTR errorString = nullptr;

    if (FormatMessageW(
            FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM |
                FORMAT_MESSAGE_IGNORE_INSERTS,
            nullptr, errorCode, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPWSTR)&errorString, 0,
            nullptr) != 0)
    {
        return ErrorStringPtr(
            errorString, [](wchar_t const* buf) { LocalFree(const_cast<wchar_t*>(buf)); });
    }

    try
    {
        return errorStringFromWString(std::format(L"Unknown error 0x{:X})", errorCode));
    }
    catch (...)
    {
        return ErrorStringPtr(L"Out of memory", [](wchar_t const*) {});
    }
}
