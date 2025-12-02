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
  tarGz(
    tarCompressionOption: '--gzip',
    lowerCaseExtensions: ['.tar.gz', '.tgz'],
  ),
  tarBz2(
    tarCompressionOption: '--bzip2',
    lowerCaseExtensions: ['.tar.bz2', '.tbz2'],
  ),
  tarXz(tarCompressionOption: '--xz', lowerCaseExtensions: ['.tar.xz', '.txz']),
  tarZstd(
    tarCompressionOption: '--zstd',
    lowerCaseExtensions: ['.tar.zst', '.tzst'],
  );

  final String tarCompressionOption;
  final List<String> lowerCaseExtensions;

  const ArchiveType({
    required this.tarCompressionOption,
    required this.lowerCaseExtensions,
  });

  static ArchiveType? fromFileNameOrFilePath(String fileName) {
    final lowerCaseFileName = fileName.toLowerCase();

    bool extensionMatches(String lowerCaseExtension) {
      return lowerCaseFileName.endsWith(lowerCaseExtension);
    }

    for (final entry in values) {
      if (entry.lowerCaseExtensions.any(extensionMatches)) {
        return entry;
      }
    }
    return null;
  }
}
