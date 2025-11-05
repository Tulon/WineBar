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

List<String> commandLineToWineArgs(List<String> commandLine) {
  if (commandLine.isEmpty) {
    return [];
  }

  final executable = commandLine.first;

  if (executable.toLowerCase().endsWith('.exe')) {
    return [...commandLine];
  } else {
    // It's tempting to add the '/wait' argument here, to make start.exe wait
    // till it's child has finished, but ultimately that doesn't maater, as
    // "wine" itself doesn't wait for the process it creates to finish.
    return ['start', if (executable.startsWith('/')) '/unix', ...commandLine];
  }
}
