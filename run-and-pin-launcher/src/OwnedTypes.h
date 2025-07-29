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

#include <memory>
#include <type_traits>

using OwnedModule = std::unique_ptr<std::remove_pointer_t<HMODULE>, void (*)(HMODULE)>;

static inline auto const ownedModuleDeleter = [](HMODULE hModule)
{
    FreeModule(hModule);
};

inline OwnedModule
makeOwnedModule(HMODULE hModule = nullptr)
{
    return OwnedModule(hModule, ownedModuleDeleter);
}

using OwnedResourceData = std::unique_ptr<std::remove_pointer_t<HGLOBAL>, void (*)(HGLOBAL)>;

static inline auto const ownedResourceDataDeleter = [](HGLOBAL hRes)
{
    FreeResource(hRes);
};

inline OwnedResourceData
makeOwnedResourceData(HGLOBAL hRes = nullptr)
{
    return OwnedResourceData(hRes, ownedResourceDataDeleter);
}

using OwnedIcon = std::unique_ptr<std::remove_pointer_t<HICON>, void (*)(HICON)>;

static inline auto const ownedIconDeleter = [](HICON hIcon)
{
    DestroyIcon(hIcon);
};

inline OwnedIcon
makeOwnedIcon(HICON hIcon = nullptr)
{
    return OwnedIcon(hIcon, ownedIconDeleter);
}
