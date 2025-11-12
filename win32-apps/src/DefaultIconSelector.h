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
 * This class selects an RT_GROUP_ICON resource based on the heuristic
 * algorithm mentioned in [1]:
 *
 * @li Choose the alphabetically first named group icon, if available.
 * @li Else, choose the group icon with the numerically lowest identifier.
 *
 * [1]: https://devblogs.microsoft.com/oldnewthing/20250423-00/?p=111106
 */
class DefaultIconSelector : public ResourceIconSelector
{
public:
    virtual void processCandidate(wchar_t const* nameOrId) override;

    virtual wchar_t const* selectedResource() const override;

    virtual std::wstring reasonForNoSelection() const override;

private:
    std::optional<ResourceNameHolder> mBestCandidate;
};
