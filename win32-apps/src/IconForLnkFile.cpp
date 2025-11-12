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

#include "IconForLnkFile.h"

#include "DefaultIconSelector.h"
#include "ErrorString.h"
#include "IconFromPortableExecutable.h"
#include "IconFromPortableExecutableOrIcoFile.h"
#include "SignedIndexIconSelector.h"
#include "WStringRuntimeError.h"

#include <shlobj.h>
#include <windows.h>
#include <wrl/client.h>

#include <format>

using Microsoft::WRL::ComPtr;

OwnedIcon
iconForLnkFile(wchar_t const* filePath, int iconResolution)
{
    ComPtr<IShellLinkW> shellLink;
    HRESULT hr = CoCreateInstance(
        CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, IID_IShellLinkW,
        (void**)shellLink.GetAddressOf());
    if (FAILED(hr))
    {
        throw WStringRuntimeError(
            std::format(L"Could not create IShellLinkW: {}", errorStringFromErrorCode(hr).get()));
    }

    ComPtr<IPersistFile> persistFile;
    hr = shellLink.As(&persistFile);
    if (FAILED(hr))
    {
        throw WStringRuntimeError(
            std::format(L"Could not query IPersistFile: {}", errorStringFromErrorCode(hr).get()));
    }

    hr = persistFile->Load(filePath, STGM_READ);
    if (FAILED(hr))
    {
        throw WStringRuntimeError(
            std::format(L"Could not read .lnk: {}", errorStringFromErrorCode(hr).get()));
    }

    // Note that MAX_PATH is too small on Windows (defined to be 260).
    wchar_t tmpPathBuffer[4096];
    wchar_t targetPathBuffer[4096];

    int iconId = 0;
    hr = shellLink->GetIconLocation(tmpPathBuffer, sizeof(tmpPathBuffer), &iconId);
    if (SUCCEEDED(hr) && tmpPathBuffer[0])
    {
        if (auto r = ExpandEnvironmentStringsW(
                tmpPathBuffer, targetPathBuffer, sizeof(targetPathBuffer));
            r > 0 && r <= sizeof(targetPathBuffer))
        {
            SignedIndexIconSelector iconSelector(iconId);
            return iconFromPortableExecutableOrIcoFile(
                targetPathBuffer, iconSelector, iconResolution);
        }
    }

    hr = shellLink->GetPath(tmpPathBuffer, sizeof(tmpPathBuffer), nullptr, SLGP_RAWPATH);
    if (SUCCEEDED(hr) && tmpPathBuffer[0])
    {
        if (auto r = ExpandEnvironmentStringsW(
                tmpPathBuffer, targetPathBuffer, sizeof(targetPathBuffer));
            r > 0 && r <= sizeof(targetPathBuffer))
        {
            DefaultIconSelector iconSelector;
            return iconFromPortableExecutable(targetPathBuffer, iconSelector, iconResolution);
        }
    }

    LPITEMIDLIST idList = nullptr;
    hr = shellLink->GetIDList(&idList);
    if (SUCCEEDED(hr) && idList && SHGetPathFromIDListW(idList, targetPathBuffer))
    {
        DefaultIconSelector iconSelector;
        return iconFromPortableExecutable(targetPathBuffer, iconSelector, iconResolution);
    }

    throw WStringRuntimeError(
        std::format(L"Failed to get an icon from .lnk file {} for unknown reason", filePath));
}
