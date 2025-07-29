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

#include "IconFromIcoFile.h"

#include "ErrorString.h"
#include "ScopeCleanup.h"
#include "WStringRuntimeError.h"

#include <windows.h>

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <format>

namespace
{

#pragma pack(push, 1)

// From here:
// https://learn.microsoft.com/en-us/previous-versions/ms997538(v=msdn.10)?redirectedfrom=MSDN
struct ICONDIR
{
    WORD idReserved; // Reserved (must be 0)
    WORD idType;     // Resource Type (1 for icons)
    WORD idCount;    // How many images?
};

// From the space place as the above one.
struct ICONDIRENTRY
{
    BYTE bWidth;         // Width, in pixels, of the image
    BYTE bHeight;        // Height, in pixels, of the image
    BYTE bColorCount;    // Number of colors in image (0 if >=8bpp)
    BYTE bReserved;      // Reserved ( must be 0)
    WORD wPlanes;        // Color Planes
    WORD wBitCount;      // Bits per pixel
    DWORD dwBytesInRes;  // How many bytes in this resource?
    DWORD dwImageOffset; // Where in the file is this image?
};

#pragma pack(pop)

// The above structures assume little-endianness. Normally, we would need
// to convert them to host-endianness, but even Windows on ARM is
// little-endian, so we don't bother.

bool
isBetterEntryThan(
    ICONDIRENTRY const& candidate, ICONDIRENTRY const& reference, int desiredResolution)
{
    auto const readDim = [](BYTE dim)
    {
        return dim == 0 ? 256 : int(dim);
    };

    int const candidateWidth = readDim(candidate.bWidth);
    int const candidateHeight = readDim(candidate.bHeight);
    auto const [minCandidateDim, maxCandidateDim] = std::minmax(candidateWidth, candidateHeight);

    int const referenceWidth = readDim(reference.bWidth);
    int const referenceHeight = readDim(reference.bHeight);
    auto const [minReferenceDim, maxReferenceDim] = std::minmax(referenceWidth, referenceHeight);

    if (minReferenceDim < desiredResolution)
    {
        // If the reference image is smaller than desired, any bigger one is better.
        return minCandidateDim > minReferenceDim;
    }
    else
    {
        // If the reference image is large enough, a smaller image that's still
        // as large as the desired is even better.
        return minCandidateDim >= desiredResolution && maxCandidateDim < maxReferenceDim;
    }
}

void
throwIcoFormatError()
{
    throw WStringRuntimeError(L"ICO format error");
}

OwnedIcon
extractIconFromLoadedIcoFile(
    uint8_t const* const data, uint64_t const dataSize, wchar_t const* filePath, int iconResolution)
{

    if (dataSize < sizeof(ICONDIR))
    {
        throwIcoFormatError();
    }

    ICONDIR const* icondir = reinterpret_cast<ICONDIR const*>(data);
    if (icondir->idReserved != 0 || icondir->idType != 1)
    {
        throwIcoFormatError();
    }

    if (dataSize < sizeof(ICONDIR) + icondir->idCount * sizeof(ICONDIRENTRY))
    {
        throwIcoFormatError();
    }

    ICONDIRENTRY const* bestEntry = nullptr;

    size_t const numEntries = icondir->idCount;
    ICONDIRENTRY const* entries = reinterpret_cast<ICONDIRENTRY const*>(data + sizeof(ICONDIR));
    for (size_t i = 0; i < numEntries; ++i)
    {
        ICONDIRENTRY const& entry = entries[i];
        if (!bestEntry || isBetterEntryThan(entry, *bestEntry, iconResolution))
        {
            bestEntry = &entry;
        }
    }

    if (!bestEntry)
    {
        throw WStringRuntimeError(
            std::format(L"File {} doesn't have a single image inside", filePath));
    }

    if (dataSize < size_t(bestEntry->dwImageOffset) + size_t(bestEntry->dwBytesInRes))
    {
        throwIcoFormatError();
    }

    auto const* imageData = data + bestEntry->dwImageOffset;
    auto const imageDataSize = bestEntry->dwBytesInRes;

    const HICON hIcon = CreateIconFromResourceEx(
        (PBYTE)imageData, imageDataSize,
        TRUE,       // Loading an icon, not a cursor.
        0x00030000, // Icon data format version.
        iconResolution, iconResolution, LR_DEFAULTCOLOR);
    if (!hIcon)
    {
        throw WStringRuntimeError(
            std::format(
                L"CreateIconFromResourceEx() failed: {}",
                errorStringFromErrorCode(GetLastError()).get()));
    }

    return makeOwnedIcon(hIcon);
}

} // namespace

OwnedIcon
iconFromIcoFile(wchar_t const* filePath, int iconResolution)
{
    HANDLE const hFile = CreateFile(
        filePath, GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,
        nullptr);

    if (hFile == INVALID_HANDLE_VALUE)
    {
        throw WStringRuntimeError(
            std::format(
                L"Failed to open file {} for reading: {}", filePath,
                errorStringFromErrorCode(GetLastError()).get()));
    }

    ScopeCleanup hFileCleanup([hFile] { CloseHandle(hFile); });

    HANDLE const hMapping = CreateFileMapping(
        hFile, nullptr, PAGE_READONLY,

        // These two parameters being zeros tell the system to use the actual file size.
        0, 0,

        nullptr);

    if (!hMapping)
    {
        throw WStringRuntimeError(
            std::format(
                L"CreateFileMapping() failed on file {}: {}", filePath,
                errorStringFromErrorCode(GetLastError()).get()));
    }

    ScopeCleanup hMappingCleanup([hMapping] { CloseHandle(hMapping); });

    LARGE_INTEGER fileSize{};
    if (!GetFileSizeEx(hMapping, &fileSize))
    {
        throw WStringRuntimeError(
            std::format(
                L"GetFileSizeEx() failed on file {}: {}", filePath,
                errorStringFromErrorCode(GetLastError()).get()));
    }

    void const* const pView = MapViewOfFile(hMapping, FILE_MAP_READ, 0, 0, 0);

    if (!pView)
    {
        throw WStringRuntimeError(
            std::format(
                L"MapViewOfFile() failed on file {}: {}", filePath,
                errorStringFromErrorCode(GetLastError()).get()));
    }

    ScopeCleanup pViewCleanup([pView] { UnmapViewOfFile(pView); });

    return extractIconFromLoadedIcoFile(
        (uint8_t const*)pView, fileSize.QuadPart, filePath, iconResolution);
}
