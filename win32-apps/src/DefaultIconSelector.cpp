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

#include "DefaultIconSelector.h"

#include "CaseInsensitiveCompare.h"

#include <windows.h>

void
DefaultIconSelector::processCandidate(wchar_t const* nameOrId)
{
    if (!mBestCandidate.has_value())
    {
        mBestCandidate.emplace(nameOrId);
        return;
    }

    if (!IS_INTRESOURCE(mBestCandidate->get()))
    {
        if (!IS_INTRESOURCE(nameOrId))
        {
            if (caseInsensitiveCompare(nameOrId, mBestCandidate->get()) < 0)
            {
                // Lexicographically preceding ids win.
                mBestCandidate.emplace(nameOrId);
                return;
            }
        }

        // If nameOrId is a numeric id, we do nothing, as numeric ids always
        // lose to symbolic ones.
    }
    else
    {
        // The best candidate is a numeric one.

        if (!IS_INTRESOURCE(nameOrId))
        {
            // A symbolic resource name always bets a numeric one.
            mBestCandidate.emplace(nameOrId);
            return;
        }
        else
        {
            // What MAKEINTRESOURCEW() does is just convert a 16-bit word to a pointer.
            // Therefore, comparing pointers compares the numeric resource ids.
            if (nameOrId < mBestCandidate->get())
            {
                mBestCandidate.emplace(nameOrId);
                return;
            }
        }
    }
}

wchar_t const*
DefaultIconSelector::selectedResource() const
{
    return mBestCandidate ? mBestCandidate->get() : nullptr;
}

std::wstring
DefaultIconSelector::reasonForNoSelection() const
{
    return L"No icons were available";
}
