/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025-2026 Josif Arcimovic
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

#include <filesystem>
#include <string>

/**
 * Holds information about a file in the user's or the Public Desktop folder.
 *
 * The reason we can't use std::filesystem::directory_entry for this purpose
 * is that we want to capture the file's modification time at construction
 * point, not at the point when we need to access it.
 */
class FileOnDesktop
{
public:
    explicit FileOnDesktop(std::filesystem::directory_entry const& dirent)
        : mFilePath(dirent.path().wstring())
        , mFileName(dirent.path().filename().wstring())
        , mLastModifyTime(dirent.last_write_time())
    {
    }

    std::wstring const filePath() const { return mFilePath; }

    std::wstring const fileName() const { return mFileName; }

    std::filesystem::file_time_type lastModifyTime() const { return mLastModifyTime; }

private:
    std::wstring mFilePath;
    std::wstring mFileName;
    std::filesystem::file_time_type mLastModifyTime;
};
