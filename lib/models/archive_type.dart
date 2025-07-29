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

enum ArchiveType {
  tarGz(tarCompressionOption: '--gzip'),
  tarBz2(tarCompressionOption: '--bzip2'),
  tarXz(tarCompressionOption: '--xz'),
  tarZstd(tarCompressionOption: '--zstd');

  const ArchiveType({required this.tarCompressionOption});

  final String tarCompressionOption;
}
