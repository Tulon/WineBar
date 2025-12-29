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

#include "DetectAddedOrUpdatedFilesOnDesktop.h"

#include "FileOnDesktop.h"

#include <algorithm>
#include <compare>
#include <iterator>

namespace
{

bool
filesBeforeAfter(FileOnDesktop const& before, FileOnDesktop const& after)
{
    auto const nameComp = before.fileName() <=> after.fileName();
    if (nameComp != std::strong_ordering::equal)
    {
        return nameComp == std::strong_ordering::less;
    }

    auto const pathComp = before.filePath() <=> after.filePath();
    if (pathComp != std::strong_ordering::equal)
    {
        return pathComp == std::strong_ordering::less;
    }

    // We want newer files to be before the older ones.
    return before.lastModifyTime() > after.lastModifyTime();
}

bool
fileNamesEqual(FileOnDesktop const& lhs, FileOnDesktop const& rhs)
{
    return lhs.fileName() == rhs.fileName();
}

} // namespace

std::vector<FileOnDesktop>
detectAddedOrUpdatedFilesOnDesktop(
    std::vector<FileOnDesktop> oldFiles, std::vector<FileOnDesktop> newFiles, bool removeDuplicates)
{
    std::sort(oldFiles.begin(), oldFiles.end(), &filesBeforeAfter);
    std::sort(newFiles.begin(), newFiles.end(), &filesBeforeAfter);

    std::vector<FileOnDesktop> newOrUpdatedFiles;
    newOrUpdatedFiles.reserve(oldFiles.size() + newFiles.size());
    std::set_difference(
        newFiles.begin(), newFiles.end(), oldFiles.begin(), oldFiles.end(),
        std::back_inserter(newOrUpdatedFiles), &filesBeforeAfter);

    if (removeDuplicates)
    {
        newOrUpdatedFiles.erase(
            std::unique(newOrUpdatedFiles.begin(), newOrUpdatedFiles.end(), &fileNamesEqual),
            newOrUpdatedFiles.end());
    }

    return newOrUpdatedFiles;
}
