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

#include <windows.h>

/**
 * Enumerates the RC_GROUP_ICON resources in the given module and feeds
 * them to @p selector.
 *
 * The selected icon group (if any) will be accessible as @p selector.selectedResource().
 *
 * Should @p selector.processCandidate() throw, this function stops the iteration and
 * re-throws that exception.
 */
void pickIconGroupResource(HMODULE module, ResourceIconSelector& selector);
