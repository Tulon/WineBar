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

#include "ResourceNameHolder.h"

ResourceNameHolder::ResourceNameHolder(LPCWSTR resourceName)
{
    if (IS_INTRESOURCE(resourceName))
    {
        mVariant.emplace<LPCWSTR>(resourceName);
    }
    else
    {
        mVariant.emplace<std::wstring>(resourceName);
    }
}

LPCWSTR
ResourceNameHolder::get() const
{
    struct Visitor
    {
        LPCWSTR operator()(LPCWSTR numericId) const { return numericId; }

        LPCWSTR operator()(std::wstring const& stringId) const { return stringId.c_str(); }
    };

    return std::visit(Visitor(), mVariant);
}
