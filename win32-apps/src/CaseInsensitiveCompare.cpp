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

#include "CaseInsensitiveCompare.h"

#include "ErrorString.h"
#include "WStringRuntimeError.h"

#include <windows.h>

int
caseInsensitiveCompare(wchar_t const* lhs, wchar_t const* rhs)
{
    int const res = CompareStringW(GetThreadLocale(), NORM_IGNORECASE, lhs, -1, rhs, -1);

    if (res == 0)
    {
        throw WStringRuntimeError(errorStringFromErrorCode(GetLastError()).get());
    }

    return res - 2;
}
