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

#include "WriteIconToPng.h"

#include "ScopeCleanup.h"
#include "WStringRuntimeError.h"

#include <gdiplus.h>
#include <windows.h>

#include <cstring>
#include <format>
#include <optional>

using namespace Gdiplus;

namespace
{

std::optional<CLSID>
findEncoderClsid(wchar_t const* format)
{
    UINT num = 0;  // number of image encoders
    UINT size = 0; // size of the image encoder array in bytes

    if (GetImageEncodersSize(&num, &size) != Ok || size == 0)
    {
        return std::nullopt;
    }

    ImageCodecInfo* imageCodecs = (ImageCodecInfo*)malloc(size);
    if (!imageCodecs)
    {
        return std::nullopt;
    }

    ScopeCleanup const imageCodecsCleanup([imageCodecs] { free(imageCodecs); });

    if (GetImageEncoders(num, size, imageCodecs) != Ok)
    {
        return std::nullopt;
    }

    for (UINT i = 0; i < num; ++i)
    {
        if (wcscmp(imageCodecs[i].MimeType, format) == 0)
        {
            return imageCodecs[i].Clsid;
        }
    }

    return std::nullopt;
}

} // namespace

void
writeIconToPng(HICON hIcon, wchar_t const* outputPngPath)
{
    Status status;

    // Initialize GDI+
    GdiplusStartupInput gdiplusStartupInput{};
    ULONG_PTR gdiplusToken;
    status = GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, nullptr);
    if (status != Status::Ok)
    {
        throw WStringRuntimeError(std::format(L"GdiplusStartup() failed ({})", (int)status));
    }

    ScopeCleanup const gdiplusCleanup([gdiplusToken] { GdiplusShutdown(gdiplusToken); });

    wchar_t const* imageFormat = L"image/png";
    auto const clsid = findEncoderClsid(imageFormat);
    if (!clsid)
    {
        throw WStringRuntimeError(
            std::format(L"Failed to find an image encoder for {}", imageFormat));
    }

    // Create a GDI+ Bitmap from the HICON
    Bitmap image(hIcon);

    // Save the Bitmap to a file
    status = image.Save(outputPngPath, &*clsid, nullptr);
    if (status != Status::Ok)
    {
        throw WStringRuntimeError(std::format(L"Failed to save the image to {}", outputPngPath));
    }
}
