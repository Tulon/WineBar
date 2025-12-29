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

#include "FileOnDesktop.h"

#include <vector>

/**
 * Finds the files present in @p newFiles but not in @o oldFiles or those that are present in both,
 * but are newer in @p newFiles.
 *
 * @param oldFiles The list of files on the desktop before some operation.
 * @param newFiles The list of files on the desktop after that operation.
 * @param removeDuplicates If set to true, removes the files with identical file names
 *        residing in different directories. That may be helpful, as @p oldFiles
 *        and @p newFiles normally come from enumerateFilesOnDesktop(), which includes
 *        the files both in the user's Dekstop folder and in the Public Desktop one.
 *
 * @throw WStringException If anything goes wrong.
 *
 * @see enumerateFilesOnDesktop().
 */
std::vector<FileOnDesktop> detectAddedOrUpdatedFilesOnDesktop(
    std::vector<FileOnDesktop> oldFiles, std::vector<FileOnDesktop> newFiles,
    bool removeDuplicates);
