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

#include "OwnedTypes.h"

/**
 * Tries to extract an icon from an application associated with a particular document file.
 *
 * @param filePath A Windows (not Unix) file path to the document file in question.
 * @param iconResolution The returned icon shall have a resolution of
 *        iconResolution x iconResolution pixels, possibly as a result
 *        of rescaling.
 *
 * @return An HICON wrapped into an unique_ptr. If no application is associated with the
 *         given file, nullptr is returned. All other errors are reported through exceptions.
 *
 * @throw WStringException If anything else goes wrong.
 */
OwnedIcon iconFromAssociatedApplication(wchar_t const* filePath, int iconResolution);
