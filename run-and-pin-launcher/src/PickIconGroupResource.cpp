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

#include "PickIconGroupResource.h"

#include "ErrorString.h"
#include "WStringRuntimeError.h"

#include <exception>
#include <format>

namespace
{

struct Context
{
    ResourceIconSelector& mSelector;
    std::exception_ptr mException;

    explicit Context(ResourceIconSelector& selector)
        : mSelector(selector)
    {
    }
};

BOOL CALLBACK
processResource(HMODULE /*hModule*/, LPCWSTR /*lpType*/, LPWSTR lpName, LONG_PTR lParam)
{
    auto& context = *reinterpret_cast<Context*>(lParam);

    try
    {
        context.mSelector.processCandidate(lpName);
    }
    catch (...)
    {
        context.mException = std::current_exception();
        return FALSE; // Stop iteration.
    }

    return TRUE; // Continue iteration.
}

} // namespace

void
pickIconGroupResource(HMODULE module, ResourceIconSelector& selector)
{
    Context context(selector);

    if (!EnumResourceNamesW(module, RT_GROUP_ICON, processResource, (LONG_PTR)&context))
    {
        // This may mean an error or it may mean the file didn't have any resources
        // of the requested type. We do want to throw an error in the former case
        // but not in the second.
        if (auto const errorCode = GetLastError(); errorCode != ERROR_SUCCESS)
        {
            throw WStringRuntimeError(
                std::format(
                    L"EnumResourceNamesW() failed: {}", errorStringFromErrorCode(errorCode).get()));
        }
    }

    if (context.mException)
    {
        std::rethrow_exception(context.mException);
    }
}
