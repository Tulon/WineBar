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

#include <windows.h>

#include <memory>

using ErrorStringPtr = std::unique_ptr<wchar_t const, void (*)(wchar_t const*)>;

/**
 * Converts an std::wstring into an ErrorStringPtr.
 *
 * This function may throw in out-of-memory situations.
 */
ErrorStringPtr errorStringFromWString(std::wstring const& wstring);

/**
 * Converts the error code (either HRESULT or the code returned from GetLastError())
 * into a wide string, wrapped into a unique_ptr.
 *
 * If anything goes wrong, some error string is still returned.
 * This function doesn't throw exceptions.
 */
ErrorStringPtr errorStringFromErrorCode(DWORD errorCode) noexcept;
