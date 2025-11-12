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

#include <windows.h>

#include <string>
#include <variant>

/**
 * This class exists in order to own a resource name such as those that can be passed to
 * FindResourceW(). Those names may be proper pointers to a wchar-based string or they
 * may be numeric IDs encoded as non-dereferenceable pointers. That makes storing them
 * tricky, which is what this class does.
 */
class ResourceNameHolder
{
public:
    explicit ResourceNameHolder(LPCWSTR resourceName);

    LPCWSTR get() const;

private:
    /**
     * The numeric IDs are stored as LPCWSTR (they don't need deallocation),
     * while the string-based ones are stored as std::wstring.
     */
    std::variant<LPCWSTR, std::wstring> mVariant;
};
