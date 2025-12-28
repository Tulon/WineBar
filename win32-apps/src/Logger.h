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

#include <exception>
#include <format>
#include <string>
#include <utility>

class Logger
{
public:
    virtual ~Logger() = default;

    template<typename... Args>
    void writeFormatted(std::format_string<Args...> fmt, Args&&... args)
    {
        try
        {
            writeString(std::format(fmt, std::forward<Args>(args)...));
        }
        catch (std::exception const& e)
        {
            writeException(e);
        }
    }

    template<typename... Args>
    void writeFormatted(std::wformat_string<Args...> fmt, Args&&... args)
    {
        try
        {
            writeString(std::format(fmt, std::forward<Args>(args)...));
        }
        catch (std::exception const& e)
        {
            writeException(e);
        }
    }

    virtual void writeString(std::string const& str) = 0;

    virtual void writeString(std::wstring const& str) = 0;

protected:
    virtual void writeException(std::exception const& e) = 0;
};
