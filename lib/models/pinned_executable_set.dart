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

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';

import 'pinned_executable.dart';
import 'wine_prefix_dir_structure.dart';

@immutable
class PinnedExecutableSet extends Equatable {
  /// Corresponds to [WinePrefixDirStructure.pinsDir].
  final String pinsDir;

  /// Naturally ordered by PinnedExecutable.compareTo().
  final List<PinnedExecutable> orderedPinnedExecutables;

  /// Pins are persistent in dictories which names are numbers. This member
  /// stores the largest of those number or 0 if nothing is persisted.
  final int largestPinNumber;

  const PinnedExecutableSet._({
    required this.pinsDir,
    required this.orderedPinnedExecutables,
    required this.largestPinNumber,
  });

  @override
  List<Object> get props => [
    pinsDir,
    orderedPinnedExecutables,
    largestPinNumber,
  ];

  static Future<PinnedExecutableSet> loadFromDisk(String pinsDir) async {
    final logger = GetIt.I.get<Logger>();

    final lowerCaseWindowsExecutablePathsSeen = <String>{};
    final pinnedExecutables = <PinnedExecutable>[];

    int largestPinNumber = 0;

    final pinsDirectory = Directory(pinsDir);
    await pinsDirectory.create(
      recursive: true,
    ); // Just in case it doesn't exist.

    await for (final entry in pinsDirectory.list()) {
      final pinNumber = int.tryParse(path.basename(entry.path));
      if (pinNumber != null && pinNumber > largestPinNumber) {
        largestPinNumber = pinNumber;
      }

      if (entry is Directory) {
        try {
          final pinnedExecutable = await PinnedExecutable.loadFromPinDirectory(
            entry.path,
          );

          final lowerCaseWindowsExecutablePath = pinnedExecutable
              .windowsPathToExecutable
              .toLowerCase();

          if (lowerCaseWindowsExecutablePathsSeen.contains(
            lowerCaseWindowsExecutablePath,
          )) {
            logger.w(
              'Duplicate pinned item found at ${entry.path}. Removing it.',
            );
            // We do want to remove the pin directory in such a case, not
            // merely skip it. That's because should the user unpin the executable
            // we've already added, the skipped one will appear again, causing
            // confusion.
            await recursiveDeleteAndLogErrors(entry);
            continue;
          }

          lowerCaseWindowsExecutablePathsSeen.add(
            lowerCaseWindowsExecutablePath,
          );

          pinnedExecutables.add(pinnedExecutable);
        } catch (e, stackTrace) {
          logger.e(
            'Failed to load a pinned executable from ${entry.path}',
            error: e,
            stackTrace: stackTrace,
          );
          // We choose not to remove such a directory, as who knows: maybe we
          // are trying to load pinned executables created by a newer version
          // of the app with an older version?
        }
      }
    }

    pinnedExecutables.sort();

    return PinnedExecutableSet._(
      pinsDir: pinsDir,
      orderedPinnedExecutables: pinnedExecutables,
      largestPinNumber: largestPinNumber,
    );
  }

  /// Returns a new PinnedExecutableSet with a new PinnedExecutable either
  /// added to the list or replacing and existing one.
  Future<PinnedExecutableSet> copyWithAdditionalPinnedExecutable(
    PinnedExecutable newPinInTempPinDir,
  ) async {
    final pinNumber = largestPinNumber + 1;
    final pinDirectory = Directory(path.join(pinsDir, pinNumber.toString()));

    await pinDirectory.create(recursive: true);
    final newExecutable = await newPinInTempPinDir.copyToAnotherPinDirectory(
      pinDirectory.path,
    );

    await recursiveDeleteAndLogErrors(
      Directory(newPinInTempPinDir.pinDirectory),
    );

    final newExecutableLowerCaseExecutablePath = newExecutable
        .windowsPathToExecutable
        .toLowerCase();

    final newOrderedPinnedExecutables = <PinnedExecutable>[];
    bool newExecutableAdded = false;

    void addNewExecutable() {
      newOrderedPinnedExecutables.add(newExecutable);
      newExecutableAdded = true;
    }

    Future<void> maybeAddExistingExecutable(
      PinnedExecutable existingExecutable,
    ) async {
      if (existingExecutable.windowsPathToExecutable.toLowerCase() !=
          newExecutableLowerCaseExecutablePath) {
        newOrderedPinnedExecutables.add(existingExecutable);
      } else {
        // The existing executable is the same as the new one, so we
        // delete the pin directory and don't add this pin to the list.
        await recursiveDeleteAndLogErrors(
          Directory(existingExecutable.pinDirectory),
        );
      }
    }

    for (final existingExecutable in orderedPinnedExecutables) {
      if (newExecutableAdded) {
        await maybeAddExistingExecutable(existingExecutable);
      } else {
        final int comp = existingExecutable.compareTo(newExecutable);
        if (comp > 0) {
          // This existing executable should go after the new one, so
          // given that we haven't added the new executable yet, we
          // add it now, followed by the existing one.
          addNewExecutable();
          await maybeAddExistingExecutable(existingExecutable);
        } else if (comp < 0) {
          // This existing executable should go before the new one,
          // so we just add it to the list.
          await maybeAddExistingExecutable(existingExecutable);
        } else {
          // The new and the existing executables are indistinguishable
          // from the perspective of sorting order. We try to add them both,
          // though maybeAddExistingExecutable() is expected to detect the
          // existing executable is the same as the new one and will delete
          // the old pin instead of adding it to the list.
          await maybeAddExistingExecutable(existingExecutable);
          addNewExecutable();
        }
      }
    }

    if (!newExecutableAdded) {
      addNewExecutable();
    }

    return PinnedExecutableSet._(
      pinsDir: pinsDir,
      orderedPinnedExecutables: newOrderedPinnedExecutables,
      largestPinNumber: pinNumber,
    );
  }

  Future<PinnedExecutableSet> copyWithPinnedExecutableRemoved(
    PinnedExecutable executableToRemove,
  ) async {
    final executableToRemoveLowerCasePath = executableToRemove
        .windowsPathToExecutable
        .toLowerCase();

    final newOrderedPinnedExecutables = <PinnedExecutable>[];

    for (final existingExecutable in orderedPinnedExecutables) {
      if (existingExecutable.windowsPathToExecutable.toLowerCase() !=
          executableToRemoveLowerCasePath) {
        newOrderedPinnedExecutables.add(existingExecutable);
      } else {
        await recursiveDeleteAndLogErrors(
          Directory(existingExecutable.pinDirectory),
        );
      }
    }

    return PinnedExecutableSet._(
      pinsDir: pinsDir,
      orderedPinnedExecutables: newOrderedPinnedExecutables,
      largestPinNumber: largestPinNumber,
    );
  }
}
