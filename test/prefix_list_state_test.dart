import 'package:flutter_test/flutter_test.dart';
import 'package:winebar/blocs/prefix_list/prefix_list_state.dart';
import 'package:winebar/models/prefix_list_event.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/utils/prefix_descriptor.dart';

WinePrefix _makePrefix({required String name, required String outerDir}) {
  return WinePrefix(
    dirStructure: WinePrefixDirStructure.fromOuterDir(outerDir),
    descriptor: PrefixDescriptor(name: name, relPathToWineInstall: '..'),
  );
}

void main() {
  test('Adding a prefix to an empty list', () {
    final initialState = PrefixListState.initialState(prefixes: []);

    final newPrefix = _makePrefix(name: 'New Prefix', outerDir: '/newPrefix');

    final newState = initialState.copyWithAdditionalPrefix(newPrefix);

    expect(newState.orderedPrefixes.length, 1);
    expect(newState.orderedPrefixes[0], newPrefix);

    expect(newState.prefixListEvent, PrefixAddedEvent(prefixIndex: 0));
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

    expect(newState.prefixListEvent, PrefixAddedEvent(prefixIndex: 1));
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
      PrefixRemovedEvent(prefixIndex: 1, removedPrefix: oldPrefix2),
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
