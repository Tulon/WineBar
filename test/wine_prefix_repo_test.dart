/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025-2026 Josif Arcimovic
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

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/prefix_descriptor.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/repositories/wine_prefix_repo.dart';

WinePrefix _makePrefix({required String name, required String outerDir}) {
  return WinePrefix(
    dirStructure: WinePrefixDirStructure.fromOuterDir(outerDir),
    descriptor: WinePrefixDescriptor(
      name: name,
      relPathToWineInstall: '..',
      hiDpiScale: null,
      wow64ModePreferred: null,
      d3d8To11Implementation: null,
      explicitLocalePosixName: null,
    ),
  );
}

void main() {
  GetIt.I.registerSingleton<Logger>(Logger(level: Level.off));

  test('Adding a prefix to an empty repo', () async {
    final repo = WinePrefixRepo.empty();

    final newPrefix = _makePrefix(name: 'New Prefix', outerDir: '/newPrefix');

    final eventMatchingCompletion = expectLater(
      repo.eventStream,
      emitsInOrder([
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == newPrefix && e.newPrefixIndex == 0,
        ),
      ]),
    );

    repo.addPrefix(newPrefix);

    expect(repo.orderedPrefixes.length, 1);
    expect(repo.orderedPrefixes[0], newPrefix);

    await eventMatchingCompletion;
  });

  test('Adding a prefix between 2 existing ones', () async {
    final repo = WinePrefixRepo.empty();

    final oldPrefix1 = _makePrefix(name: 'Prefix 1', outerDir: '/prefix1');
    final newPrefix2 = _makePrefix(name: 'Prefix 2', outerDir: '/prefix2');
    final oldPrefix3 = _makePrefix(name: 'Prefix 3', outerDir: '/prefix3');

    final eventMatchingCompletion = expectLater(
      repo.eventStream,
      emitsInOrder([
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == oldPrefix1 && e.newPrefixIndex == 0,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == oldPrefix3 && e.newPrefixIndex == 1,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == newPrefix2 && e.newPrefixIndex == 1,
        ),
      ]),
    );

    repo.addPrefix(oldPrefix1);
    repo.addPrefix(oldPrefix3);
    repo.addPrefix(newPrefix2);

    expect(repo.orderedPrefixes.length, 3);
    expect(repo.orderedPrefixes[0], oldPrefix1);
    expect(repo.orderedPrefixes[1], newPrefix2);
    expect(repo.orderedPrefixes[2], oldPrefix3);

    await eventMatchingCompletion;
  });

  test('Removing the middle prefix', () async {
    final repo = WinePrefixRepo.empty();

    final oldPrefix1 = _makePrefix(name: 'Prefix 1', outerDir: '/prefix1');
    final oldPrefix2 = _makePrefix(name: 'Prefix 2', outerDir: '/prefix2');
    final oldPrefix3 = _makePrefix(name: 'Prefix 3', outerDir: '/prefix3');

    final eventMatchingCompletion = expectLater(
      repo.eventStream,
      emitsInOrder([
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == oldPrefix1 && e.newPrefixIndex == 0,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == oldPrefix2 && e.newPrefixIndex == 1,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == oldPrefix3 && e.newPrefixIndex == 2,
        ),
        predicate<WinePrefixRemovedEvent>(
          (e) => e.removedPrefix == oldPrefix2 && e.removedPrefixIndex == 1,
        ),
      ]),
    );

    repo.addPrefix(oldPrefix1);
    repo.addPrefix(oldPrefix2);
    repo.addPrefix(oldPrefix3);

    repo.removePrefix(oldPrefix2);

    expect(repo.orderedPrefixes.length, 2);
    expect(repo.orderedPrefixes[0], oldPrefix1);
    expect(repo.orderedPrefixes[1], oldPrefix3);

    await eventMatchingCompletion;
  });

  test('Removing a non-existing prefix', () async {
    final repo = WinePrefixRepo.empty();

    final oldPrefix1 = _makePrefix(name: 'Prefix 1', outerDir: '/prefix1');
    final oldPrefix2 = _makePrefix(name: 'Prefix 2', outerDir: '/prefix2');
    final nonExistingPrefix = _makePrefix(
      name: 'Prefix 3',
      outerDir: '/prefix3',
    );

    final eventMatchingCompletion = expectLater(
      repo.eventStream,
      emitsInOrder([
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == oldPrefix1 && e.newPrefixIndex == 0,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == oldPrefix2 && e.newPrefixIndex == 1,
        ),
      ]),
    );

    repo.addPrefix(oldPrefix1);
    repo.addPrefix(oldPrefix2);
    repo.removePrefix(nonExistingPrefix);

    expect(repo.orderedPrefixes.length, 2);
    expect(repo.orderedPrefixes[0], oldPrefix1);
    expect(repo.orderedPrefixes[1], oldPrefix2);

    await eventMatchingCompletion;
  });

  test('Updating a prefix in the middle', () async {
    final repo = WinePrefixRepo.empty();

    final prefixNotToBeUpdated1 = _makePrefix(
      name: 'Prefix 1',
      outerDir: '/prefix1',
    );
    final prefixToBeUpdated = _makePrefix(
      name: 'Prefix 2',
      outerDir: '/prefix2',
    );
    final prefixNotToBeUpdated2 = _makePrefix(
      name: 'Prefix 3',
      outerDir: '/prefix3',
    );
    final prefixToUpateWith = _makePrefix(
      name: 'Prefix 2 (updated)',
      outerDir: '/prefix2 (updated)',
    );

    final eventMatchingCompletion = expectLater(
      repo.eventStream,
      emitsInOrder([
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == prefixNotToBeUpdated1 && e.newPrefixIndex == 0,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == prefixToBeUpdated && e.newPrefixIndex == 1,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == prefixNotToBeUpdated2 && e.newPrefixIndex == 2,
        ),
        predicate<WinePrefixRemovedEvent>(
          (e) =>
              e.removedPrefix == prefixToBeUpdated && e.removedPrefixIndex == 1,
        ),
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == prefixToUpateWith && e.newPrefixIndex == 1,
        ),
      ]),
    );

    repo.addPrefix(prefixNotToBeUpdated1);
    repo.addPrefix(prefixToBeUpdated);
    repo.addPrefix(prefixNotToBeUpdated2);
    repo.updatePrefix(
      oldPrefix: prefixToBeUpdated,
      updatedPrefix: prefixToUpateWith,
    );

    expect(repo.orderedPrefixes.length, 3);
    expect(repo.orderedPrefixes[0], prefixNotToBeUpdated1);
    expect(repo.orderedPrefixes[1], prefixToUpateWith);
    expect(repo.orderedPrefixes[2], prefixNotToBeUpdated2);

    await eventMatchingCompletion;
  });

  test('Updating a non-existing prefix', () async {
    final repo = WinePrefixRepo.empty();

    final existingPrefix = _makePrefix(name: 'Prefix 1', outerDir: '/prefix1');
    final nonExistingPrefix = _makePrefix(
      name: 'Prefix 2',
      outerDir: '/prefix2',
    );
    final prefixToUpateWith = _makePrefix(
      name: 'Prefix 2 (updated)',
      outerDir: '/prefix2 (updated)',
    );

    final eventMatchingCompletion = expectLater(
      repo.eventStream,
      emitsInOrder([
        predicate<WinePrefixAddedEvent>(
          (e) => e.newPrefix == existingPrefix && e.newPrefixIndex == 0,
        ),
      ]),
    );

    repo.addPrefix(existingPrefix);
    repo.updatePrefix(
      oldPrefix: nonExistingPrefix,
      updatedPrefix: prefixToUpateWith,
    );

    expect(repo.orderedPrefixes.length, 1);
    expect(repo.orderedPrefixes[0], existingPrefix);

    await eventMatchingCompletion;
  });
}
