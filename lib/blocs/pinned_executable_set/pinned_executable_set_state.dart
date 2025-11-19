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
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/models/pinned_executable_list_event.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';

import '../../models/pinned_executable.dart';
import '../../models/wine_prefix_dir_structure.dart';

@immutable
class PinnedExecutableSetState extends Equatable {
  /// Corresponds to [WinePrefixDirStructure.pinsDir].
  final String pinsDir;

  /// Naturally ordered by PinnedExecutable.compareTo().
  final List<PinnedExecutable> orderedPinnedExecutables;

  /// The event describing the change made to [orderedPinnedExecutables] by
  /// this particular update. As a general rule, any new instance of a state
  /// passed to emit() should discard the old value of this field.
  /// In fact, as soon as the UI layer had a chance to react to this
  /// field being set, it has to emit a new state with this field cleared,
  /// as otherwise a widget being rebuilt for an unrelated reason will
  /// cause a repeat reaction to the same event.
  final PinnedExecutableListEvent? pinnedExecutableListEvent;

  /// Pins are persistent in dictories which names are numbers. This member
  /// stores the largest of those number or 0 if nothing is persisted.
  final int largestPinNumber;

  const PinnedExecutableSetState._({
    required this.pinsDir,
    required this.orderedPinnedExecutables,
    required this.pinnedExecutableListEvent,
    required this.largestPinNumber,
  });

  @override
  List<Object?> get props => [
    pinsDir,
    orderedPinnedExecutables,
    pinnedExecutableListEvent,
    largestPinNumber,
  ];

  PinnedExecutableSetState copyWith({
    String? pinsDir,
    List<PinnedExecutable>? orderedPinnedExecutables,
    required ValueGetter<PinnedExecutableListEvent?>
    pinnedExecutableListEventGetter,
    int? largestPinNumber,
  }) {
    return PinnedExecutableSetState._(
      pinsDir: pinsDir ?? this.pinsDir,
      orderedPinnedExecutables:
          orderedPinnedExecutables ?? this.orderedPinnedExecutables,
      pinnedExecutableListEvent: pinnedExecutableListEventGetter(),
      largestPinNumber: largestPinNumber ?? this.largestPinNumber,
    );
  }

  static Future<PinnedExecutableSetState> loadFromDisk(String pinsDir) async {
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

    return PinnedExecutableSetState._(
      pinsDir: pinsDir,
      orderedPinnedExecutables: pinnedExecutables,
      pinnedExecutableListEvent: null,
      largestPinNumber: largestPinNumber,
    );
  }

  /// Asynchronously returns a new [PinnedExecutableSetState] with a new
  /// pinned executable added to the list of pinned executables at the correct
  /// position, which is determined by the order imposed by
  /// [PinnedExecutable.compareTo]. This method won't try to remove an
  /// existing pinned executable pointing to the same location on disk,
  /// should one exist.
  Future<PinnedExecutableSetState> copyWithAdditionalPinnedExecutable(
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

    final newOrderedPinnedExecutables = <PinnedExecutable>[];
    PinnedExecutableListEvent? newPinnedExecutableListEvent;
    bool newExecutableAdded = false;

    void addNewExecutable() {
      newPinnedExecutableListEvent = PinnedExecutableAddedEvent(
        pinnedExecutableIndex: newOrderedPinnedExecutables.length,
      );
      newOrderedPinnedExecutables.add(newExecutable);
      newExecutableAdded = true;
    }

    void addExistingExecutable(PinnedExecutable existingExecutable) {
      newOrderedPinnedExecutables.add(existingExecutable);
    }

    for (final existingExecutable in orderedPinnedExecutables) {
      if (newExecutableAdded) {
        addExistingExecutable(existingExecutable);
      } else {
        if (existingExecutable.compareTo(newExecutable) > 0) {
          // This existing executable should go after the new one, so
          // given that we haven't added the new executable yet, we
          // add it now, followed by the existing one.
          addNewExecutable();
        }
        addExistingExecutable(existingExecutable);
      }
    }

    if (!newExecutableAdded) {
      addNewExecutable();
    }

    return copyWith(
      orderedPinnedExecutables: newOrderedPinnedExecutables,
      pinnedExecutableListEventGetter: () => newPinnedExecutableListEvent,
      largestPinNumber: pinNumber,
    );
  }

  /// Asynchronously returns a new [PinnedExecutableSetState] with a single
  /// pinned executable matching the provided [withdowsPathToExecutable]
  /// removed. The paths are compared in a case-insensitive manner.
  /// If no pinned executable matches the provided path,
  /// [pinnedExecutableListEvent] is going to be null. This method won't try
  /// to match more than one existing pinned executable to the provided path.
  Future<PinnedExecutableSetState> copyWithPinnedExecutableRemoved({
    required String windowsPathToExecutable,
  }) async {
    final executableToRemoveLowerCasePath = windowsPathToExecutable
        .toLowerCase();

    final newOrderedPinnedExecutables = <PinnedExecutable>[];
    PinnedExecutableListEvent? newPinnedExecutableListEvent;

    for (final existingExecutable in orderedPinnedExecutables) {
      if (newPinnedExecutableListEvent != null ||
          existingExecutable.windowsPathToExecutable.toLowerCase() !=
              executableToRemoveLowerCasePath) {
        newOrderedPinnedExecutables.add(existingExecutable);
      } else {
        newPinnedExecutableListEvent = PinnedExecutableRemovedEvent(
          pinnedExecutableIndex: newOrderedPinnedExecutables.length,
          removedPinnedExecutable: existingExecutable,
        );
        await recursiveDeleteAndLogErrors(
          Directory(existingExecutable.pinDirectory),
        );
      }
    }

    return copyWith(
      orderedPinnedExecutables: newOrderedPinnedExecutables,
      pinnedExecutableListEventGetter: () => newPinnedExecutableListEvent,
      largestPinNumber: largestPinNumber,
    );
  }
}
