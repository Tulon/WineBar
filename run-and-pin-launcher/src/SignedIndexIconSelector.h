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

#include "ResourceIconSelector.h"
#include "ResourceNameHolder.h"

#include <optional>

/**
 * This class selects an RT_GROUP_ICON resource based on the desired
 * signed index. The interpretation of the signed index is the same
 * as for the ExtractIcon() win32 function.
 */
class SignedIndexIconSelector : public ResourceIconSelector
{
public:
    /**
     * When signedIndex is non-negative, it's interpreted as a zero-based index
     * into RT_GROUP_ICON resource entries, in the order they are returned from
     * EnumResourceNamesW(), that is in the order of processCandidate() calls.
     *
     * When signedIndex is negative, its absolute value is interpreted as a
     * numeric ID of an RT_GROUP_ICON entry. That absolute value is then passed
     * to MAKEINTRESOURCE().
     */
    explicit SignedIndexIconSelector(int signedIndex);

    virtual void processCandidate(wchar_t const* nameOrId) override;

    virtual wchar_t const* selectedResource() const override;

    virtual std::wstring reasonForNoSelection() const override;

private:
    int mSignedIndex;
    int mCandidatesSeen = 0;
    std::optional<ResourceNameHolder> mSelectedResourceName;
};
