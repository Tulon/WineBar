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

#include "CommandLineBuilder.h"

#include <cstddef>

void
CommandLineBuilder::addArg(std::wstring_view const& arg)
{
    if (!mCommandLine.empty())
    {
        // Add a space between arguments.
        mCommandLine.push_back(L' ');
    }

    if (!arg.empty() && arg.find_first_of(L" \t\n\v\"") == arg.npos)
    {
        // No quoting is necessary.
        mCommandLine.append(arg);
    }
    else
    {
        addQuotedArg(arg);
    }
}

void
CommandLineBuilder::addQuotedArg(std::wstring_view const& arg)
{
    // Based on the pseudo-code from here: https://stackoverflow.com/a/47469792

    mCommandLine.push_back(L'"');

    auto const end = arg.end();

    for (auto it = arg.begin();; ++it)
    {
        size_t numBackslashesInRow = 0;

        // Skip but count the backslashes.
        while (it != end && *it == L'\\')
        {
            ++it;
            ++numBackslashesInRow;
        }

        if (it == end)
        {
            // Escape the backslashes.
            mCommandLine.append(numBackslashesInRow * 2, L'\\');
            break;
        }
        else if (*it == L'"')
        {
            // Escape the backslashes as well as the quote symbol.
            mCommandLine.append(numBackslashesInRow * 2 + 1, L'\\');
            mCommandLine.push_back(*it);
        }
        else
        {
            // Don't escape the backslashes.
            mCommandLine.append(numBackslashesInRow, L'\\');
            mCommandLine.push_back(*it);
        }
    }

    mCommandLine.push_back(L'"');
}
