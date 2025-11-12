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

#include "SignedIndexIconSelector.h"

#include <windows.h>

SignedIndexIconSelector::SignedIndexIconSelector(int signedIndex)
    : mSignedIndex(signedIndex)
{
}

void
SignedIndexIconSelector::processCandidate(wchar_t const* nameOrId)
{
    if (mSignedIndex >= 0)
    {
        if (mCandidatesSeen == mSignedIndex)
        {
            mSelectedResourceName.emplace(nameOrId);
        }
    }
    else
    {
        if (IS_INTRESOURCE(nameOrId) && MAKEINTRESOURCEW(-mSignedIndex) == nameOrId)
        {
            mSelectedResourceName.emplace(nameOrId);
        }
    }
}

wchar_t const*
SignedIndexIconSelector::selectedResource() const
{
    return mSelectedResourceName ? mSelectedResourceName->get() : nullptr;
}

std::wstring
SignedIndexIconSelector::reasonForNoSelection() const
{
    if (mCandidatesSeen == 0)
    {
        return L"No icons were available";
    }
    else
    {
        return L"A specific icon was requested but it couldn't be found";
    }
}
