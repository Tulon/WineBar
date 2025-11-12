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

#include <utility>

template<typename CleanupFunc>
class ScopeCleanup
{
public:
    ScopeCleanup(ScopeCleanup const&) = delete;
    ScopeCleanup& operator=(ScopeCleanup const&) = delete;

    ScopeCleanup(CleanupFunc const& cleanupFunc, bool doCleanup = true)
        : mCleanupFunc(cleanupFunc)
        , mDoCleanup(doCleanup)
    {
    }

    ScopeCleanup(CleanupFunc&& cleanupFunc, bool doCleanup = true)
        : mCleanupFunc(std::move(cleanupFunc))
        , mDoCleanup(doCleanup)
    {
    }

    ~ScopeCleanup()
    {
        if (mDoCleanup)
        {
            mCleanupFunc();
        }
    }

    void cancelCleanup() { mDoCleanup = false; }

private:
    CleanupFunc mCleanupFunc;
    bool mDoCleanup;
};
