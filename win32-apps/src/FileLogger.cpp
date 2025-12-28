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

#include "FileLogger.h"

#include "ErrorString.h"
#include "ToUtf8.h"

#include <cstdio>
#include <limits>

FileLogger::FileLogger(wchar_t const* filePath)
{
    mFileHandle = CreateFileW(
        filePath, GENERIC_WRITE, FILE_SHARE_DELETE | FILE_SHARE_READ, nullptr, CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL, nullptr);

    if (mFileHandle == INVALID_HANDLE_VALUE)
    {
        fwprintf(
            stderr, L"Failed to open the log file %ls: %ls", filePath,
            errorStringFromErrorCode(GetLastError()).get());
    }
}

FileLogger::~FileLogger()
{
    if (mFileHandle != INVALID_HANDLE_VALUE)
    {
        CloseHandle(mFileHandle);
    }
}

void
FileLogger::writeString(std::string const& str)
{
    if (mFileHandle == INVALID_HANDLE_VALUE)
    {
        return;
    }

    char const* p = str.data();
    size_t bytesToBeWritten = str.size();
    DWORD bytesWritten = 0;

    auto writeChunk = [this, &p, &bytesToBeWritten, &bytesWritten]
    {
        size_t const maxChunkSize = std::numeric_limits<DWORD>::max();
        size_t const chunkSize = std::min<size_t>(bytesToBeWritten, maxChunkSize);
        return WriteFile(mFileHandle, p, static_cast<DWORD>(chunkSize), &bytesWritten, nullptr);
    };

    while (bytesToBeWritten > 0 && writeChunk())
    {
        if (bytesWritten >= bytesToBeWritten)
        {
            return;
        }

        p += bytesWritten;
        bytesToBeWritten -= bytesWritten;
    }
}

void
FileLogger::writeString(std::wstring const& str)
{
    if (mFileHandle != INVALID_HANDLE_VALUE)
    {
        writeString(toUtf8(str));
    }
}

void
FileLogger::writeException(std::exception const& e)
{
    if (mFileHandle != INVALID_HANDLE_VALUE)
    {
        writeString(std::format("\nFormat exception: {}\n", e.what()));
    }
}
