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

  final List<PinnedExecutable> pinnedExecutablesOrderedByLabel;

  /// Pins are persistent in dictories which names are numbers. This member
  /// stores the largest of those number or 0 if nothing is persisted.
  final int largestPinNumber;

  const PinnedExecutableSet._({
    required this.pinsDir,
    required this.pinnedExecutablesOrderedByLabel,
    required this.largestPinNumber,
  });

  @override
  List<Object> get props => [
    pinsDir,
    pinnedExecutablesOrderedByLabel,
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
        }
      }
    }

    pinnedExecutables.sort((a, b) => a.label.compareTo(b.label));

    return PinnedExecutableSet._(
      pinsDir: pinsDir,
      pinnedExecutablesOrderedByLabel: pinnedExecutables,
      largestPinNumber: largestPinNumber,
    );
  }

  /// Returns a new PinnedExecutableSet with a new PinnedExecutable either
  /// added to the list or replacing and existing one having the same
  /// [PinnedExecutable.windowsPathToExecutable].
  Future<PinnedExecutableSet> copyWithAdditionalPinnedExecutable(
    PinnedExecutable newPinInTempPinDir,
  ) async {
    final pinNumber = largestPinNumber + 1;
    final pinDirectory = Directory(path.join(pinsDir, pinNumber.toString()));

    await pinDirectory.create(recursive: true);
    final newExecutable = await newPinInTempPinDir.copyToAnotherPinDirectory(
      pinDirectory.path,
    );

    final newExecutableLowerCaseLabel = newExecutable.label.toLowerCase();
    final newExecutableLowerCaseExecutablePath = newExecutable
        .windowsPathToExecutable
        .toLowerCase();

    final newPinnedExecutablesOrderedByLabel = <PinnedExecutable>[];
    bool newExecutableAdded = false;

    void addNewExecutable() {
      newPinnedExecutablesOrderedByLabel.add(newExecutable);
      newExecutableAdded = true;
    }

    Future<void> maybeAddExistingExecutable(
      PinnedExecutable existingExecutable,
    ) async {
      if (existingExecutable.windowsPathToExecutable.toLowerCase() !=
          newExecutableLowerCaseExecutablePath) {
        newPinnedExecutablesOrderedByLabel.add(existingExecutable);
      } else {
        await recursiveDeleteAndLogErrors(
          Directory(existingExecutable.pinDirectory),
        );
      }
    }

    for (final existingExecutable in pinnedExecutablesOrderedByLabel) {
      if (newExecutableAdded) {
        await maybeAddExistingExecutable(existingExecutable);
      } else {
        final int comp = existingExecutable.label.toLowerCase().compareTo(
          newExecutableLowerCaseLabel,
        );
        if (comp > 0) {
          addNewExecutable();
          await maybeAddExistingExecutable(existingExecutable);
        } else if (comp < 0) {
          await maybeAddExistingExecutable(existingExecutable);
        } else {
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
      pinnedExecutablesOrderedByLabel: newPinnedExecutablesOrderedByLabel,
      largestPinNumber: pinNumber,
    );
  }

  Future<PinnedExecutableSet> copyWithPinnedExecutableRemoved(
    PinnedExecutable executableToRemove,
  ) async {
    final executableToRemoveLowerCasePath = executableToRemove
        .windowsPathToExecutable
        .toLowerCase();

    final newPinnedExecutablesOrderedByLabel = <PinnedExecutable>[];

    for (final existingExecutable in pinnedExecutablesOrderedByLabel) {
      if (existingExecutable.windowsPathToExecutable.toLowerCase() !=
          executableToRemoveLowerCasePath) {
        newPinnedExecutablesOrderedByLabel.add(existingExecutable);
      } else {
        await recursiveDeleteAndLogErrors(
          Directory(existingExecutable.pinDirectory),
        );
      }
    }

    return PinnedExecutableSet._(
      pinsDir: pinsDir,
      pinnedExecutablesOrderedByLabel: newPinnedExecutablesOrderedByLabel,
      largestPinNumber: largestPinNumber,
    );
  }
}
