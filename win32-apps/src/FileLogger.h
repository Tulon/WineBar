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

#include "Logger.h"

#include <exception>
#include <string>
#include <utility>

#include <windows.h>

/**
 * Writes formatted output to a UTF-8 encoded file.
 */
class FileLogger : public Logger
{
public:
    /**
     * Opens a new file for writing, recreating the existing one, if any.
     *
     * Should a file fail to open, prints a message to stderr and becomes
     * a no-op logger.
     */
    FileLogger(wchar_t const* filePath);

    ~FileLogger();

    FileLogger(FileLogger const&) = delete;

    FileLogger& operator=(FileLogger const&) = delete;

    virtual void writeString(std::string const& str) override;

protected:
    virtual void writeString(std::wstring const& str) override;

    virtual void writeException(std::exception const& e) override;

private:
    HANDLE mFileHandle = INVALID_HANDLE_VALUE;
};
