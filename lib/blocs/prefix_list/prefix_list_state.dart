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

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:winebar/models/prefix_list_event.dart';
import 'package:winebar/models/wine_prefix.dart';

@immutable
class PrefixListState extends Equatable {
  /// WinePrefix instances ordered naturally (by [WinePrefix.compareTo]).
  final List<WinePrefix> orderedPrefixes;

  /// The event describing the change made to [orderedPrefixes] by this
  /// particular update. As a general rule, any new instance of a state
  /// passed to emit() should discard the old value of this field.
  /// In fact, as soon as the UI layer had a chance to react to this
  /// field being set, it has to emit a new state with this field cleared,
  /// as otherwise a widget being rebuilt for an unrelated reason will
  /// cause a repeat reaction to the same event.
  final PrefixListEvent? prefixListEvent;

  const PrefixListState({
    required this.orderedPrefixes,
    required this.prefixListEvent,
  });

  PrefixListState.initialState({required List<WinePrefix> prefixes})
    : orderedPrefixes = prefixes,
      prefixListEvent = null {
    orderedPrefixes.sort();
  }

  @override
  List<Object?> get props => [orderedPrefixes, prefixListEvent];

  /// Creates a new instance of [PrefixListState] based on the current one.
  ///
  /// Note that [prefixListEventGetter] is a required parameter for reasons
  /// described in the API docs for [prefixListEvent].
  PrefixListState copyWith({
    List<WinePrefix>? orderedPrefixes,
    required ValueGetter<PrefixListEvent?> prefixListEventGetter,
  }) {
    return PrefixListState(
      orderedPrefixes: orderedPrefixes ?? this.orderedPrefixes,
      prefixListEvent: prefixListEventGetter(),
    );
  }

  /// Returns a new [PrefixListState] with a new prefix added to the
  /// list of prefixes at the correct position which is determined by
  /// [WinePrefix.compareTo]. This method won't try to remove an existing
  /// prefix at the same location on disk, should one exist.
  PrefixListState copyWithAdditionalPrefix(WinePrefix newPrefix) {
    final newOrderedPrefixes = <WinePrefix>[];
    PrefixListEvent? prefixListEvent;
    bool newPrefixAdded = false;

    void addNewPrefix() {
      prefixListEvent = PrefixAddedEvent(
        prefixIndex: newOrderedPrefixes.length,
      );
      newOrderedPrefixes.add(newPrefix);
      newPrefixAdded = true;
    }

    void addExistingPrefix(WinePrefix existingPrefix) {
      newOrderedPrefixes.add(existingPrefix);
    }

    for (final existingPrefix in orderedPrefixes) {
      if (newPrefixAdded) {
        addExistingPrefix(existingPrefix);
      } else {
        if (existingPrefix.compareTo(newPrefix) > 0) {
          // This existing prefix should go after the new one, so
          // given that we haven't added the new prefix yet, we
          // add it now, followed by the existing one.
          addNewPrefix();
        }
        addExistingPrefix(existingPrefix);
      }
    }

    if (!newPrefixAdded) {
      addNewPrefix();
    }

    return copyWith(
      orderedPrefixes: newOrderedPrefixes,
      prefixListEventGetter: () => prefixListEvent,
    );
  }

  /// Returns a new [PrefixListState] with the given prefix removed.
  /// The prefix directory itself isn't removed. This method won't try
  /// to match more than one existing prefix to the argument.
  PrefixListState copyWithPrefixRemoved({required String prefixOuterDir}) {
    final newOrderedPrefixes = <WinePrefix>[];
    PrefixListEvent? prefixListEvent;

    void maybeAddExistingPrefix(WinePrefix existingPrefix) {
      if (prefixListEvent != null ||
          existingPrefix.dirStructure.outerDir != prefixOuterDir) {
        newOrderedPrefixes.add(existingPrefix);
      } else {
        prefixListEvent = PrefixRemovedEvent(
          prefixIndex: newOrderedPrefixes.length,
          removedPrefix: existingPrefix,
        );
      }
    }

    for (final existingPrefix in orderedPrefixes) {
      maybeAddExistingPrefix(existingPrefix);
    }

    return copyWith(
      orderedPrefixes: newOrderedPrefixes,
      prefixListEventGetter: () => prefixListEvent,
    );
  }
}
