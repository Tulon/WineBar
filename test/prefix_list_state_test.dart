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
import 'package:winebar/blocs/prefix_list/prefix_list_state.dart';
import 'package:winebar/models/prefix_descriptor.dart';
import 'package:winebar/models/prefix_list_event.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';

WinePrefix _makePrefix({required String name, required String outerDir}) {
  return WinePrefix(
    dirStructure: WinePrefixDirStructure.fromOuterDir(outerDir),
    descriptor: WinePrefixDescriptor(
      name: name,
      relPathToWineInstall: '..',
      hiDpiScale: null,
      wow64ModePreferred: null,
      d3d8To11Implementation: null,
    ),
  );
}

void main() {
  test('Adding a prefix to an empty list', () {
    final initialState = PrefixListState.initialState(prefixes: []);

    final newPrefix = _makePrefix(name: 'New Prefix', outerDir: '/newPrefix');

    final newState = initialState.copyWithAdditionalPrefix(newPrefix);

    expect(newState.orderedPrefixes.length, 1);
    expect(newState.orderedPrefixes[0], newPrefix);

    expect(
      newState.prefixListEvent,
      PrefixAddedEvent(prefixIndex: 0, animatedInsertion: true),
    );
  });

  test('Adding a prefix between 2 existing ones', () {
    final oldPrefix1 = _makePrefix(name: 'Prefix 1', outerDir: '/prefix1');
    final newPrefix2 = _makePrefix(name: 'Prefix 2', outerDir: '/prefix2');
    final oldPrefix3 = _makePrefix(name: 'Prefix 3', outerDir: '/prefix3');

    final initialState = PrefixListState.initialState(
      prefixes: [oldPrefix1, oldPrefix3],
    );

    final newState = initialState.copyWithAdditionalPrefix(newPrefix2);

    expect(newState.orderedPrefixes.length, 3);
    expect(newState.orderedPrefixes[0], oldPrefix1);
    expect(newState.orderedPrefixes[1], newPrefix2);
    expect(newState.orderedPrefixes[2], oldPrefix3);

    expect(
      newState.prefixListEvent,
      PrefixAddedEvent(prefixIndex: 1, animatedInsertion: true),
    );
  });

  test('Removing the middle prefix', () {
    final oldPrefix1 = _makePrefix(name: 'Prefix 1', outerDir: '/prefix1');
    final oldPrefix2 = _makePrefix(name: 'Prefix 2', outerDir: '/prefix2');
    final oldPrefix3 = _makePrefix(name: 'Prefix 3', outerDir: '/prefix3');

    final initialState = PrefixListState.initialState(
      prefixes: [oldPrefix1, oldPrefix2, oldPrefix3],
    );

    final newState = initialState.copyWithPrefixRemoved(
      prefixOuterDir: '/prefix2',
    );

    expect(newState.orderedPrefixes.length, 2);
    expect(newState.orderedPrefixes[0], oldPrefix1);
    expect(newState.orderedPrefixes[1], oldPrefix3);

    expect(
      newState.prefixListEvent,
      PrefixRemovedEvent(
        prefixIndex: 1,
        removedPrefix: oldPrefix2,
        animatedRemoval: true,
      ),
    );
  });

  test('Removing a non-existing prefix', () {
    final oldPrefix1 = _makePrefix(name: 'Prefix 1', outerDir: '/prefix1');
    final oldPrefix2 = _makePrefix(name: 'Prefix 2', outerDir: '/prefix2');

    final initialState = PrefixListState.initialState(
      prefixes: [oldPrefix1, oldPrefix2],
    );

    final newState = initialState.copyWithPrefixRemoved(
      prefixOuterDir: '/prefix3',
    );

    expect(newState.orderedPrefixes.length, 2);
    expect(newState.orderedPrefixes[0], oldPrefix1);
    expect(newState.orderedPrefixes[1], oldPrefix2);

    expect(newState.prefixListEvent, null);
  });
}
