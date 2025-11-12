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

#include <string>

/**
 * Selects an RT_GROUP_ICON resource from the candidates it was given.
 */
class ResourceIconSelector
{
public:
    virtual ~ResourceIconSelector() = default;

    /**
     * Processes a candidate resource.
     *
     * @param nameOrId Either a symbolic name of an RT_GROUP_ICON resource or a resource id,
     *        encoded as a non-dereferenceable pointer by MAKEINTRESOURCE().
     *
     * @note The symbolic names passed to this function are only valid until this function
     *       returns. Therefore, implementations should use the ResourceNameHolder class
     *       when they need to save a candidate.
     *
     * The order of candidates is the same as what EnumResourceNamesW() produces.
     */
    virtual void processCandidate(wchar_t const* nameOrId) = 0;

    /**
     * Returns the selected candidate or nullptr, if no candidate was selected.
     */
    virtual wchar_t const* selectedResource() const = 0;

    /**
     * If selectedResource() returns nullptr, this method returns the reason explaining
     * why no resource was selected. Otherwise returns an arbitrary string.
     *
     * This message ends up in an exception thrown from iconFromPortableExecutable()
     * and other similar functions.
     */
    virtual std::wstring reasonForNoSelection() const = 0;
};
