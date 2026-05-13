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

/// @docImport 'package:winebar/utils/local_storage_paths.dart';
library;

import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/prefix_descriptor.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';

abstract interface class WinePrefixRepo {
  /// To be used in tests. In other cases, use WinePrefixRepo.loadFromDisk().
  factory WinePrefixRepo.empty() {
    return _WinePrefixRepo(orderedPrefixes: []);
  }

  List<WinePrefix> get orderedPrefixes;

  /// The stream that reports changes to [orderedPrefixes]. This stream is a
  /// synchronous broadcast one. The synchronicity is necessary for stream
  /// listeners to have a consistent view of [orderedPrefixes] when we emit
  /// several events in a row.
  ///
  /// Don't use StreamBuilder to listen to this stream, as that one is
  /// asynchronous by itself and it may issue fewer rebuilds than the number of
  /// received events.
  Stream<WinePrefixRepoEvent> get eventStream;

  /// Adds a new prefix to the list and then emits the [WinePrefixAddedEvent].
  ///
  /// When calling this method, the outer directory of a prefix has to exist
  /// already. The directory structure below it doesn't necessarily have to
  /// exist or be finalized. For instance, when cloning a prefix, you first
  /// create the outer directory for it, then you call this method, and then
  /// you asynchronously copy the files from the source prefix into the
  /// destination one.
  void addPrefix(WinePrefix newPrefix);

  /// Removes a prefix from the list and then emits the
  /// [WinePrefixRemovedEvent].
  ///
  /// This method is to be called when the prefix has already been removed
  /// from disk.
  void removePrefix(WinePrefix prefixToRemove);

  /// Loads the wine prefixes from a directory.
  ///
  /// If the directory doesn't exist, it's created and an empty repository
  /// is constructed.
  ///
  /// The [winePrefixesDir] argument corresponds to
  /// [LocalStoragePaths.winePrefixesDir].
  static Future<WinePrefixRepo> loadFromDisk({
    required String winePrefixesDir,
  }) async {
    final winePrefixes = <WinePrefix>[];
    final prefixesDir = Directory(winePrefixesDir);

    // Does nothing if the directory exists already.
    await prefixesDir.create();

    await for (final entity in prefixesDir.list()) {
      if (entity is Directory) {
        await _loadWinePrefixFromOuterDir(
          winePrefixOuterDir: entity,
          sink: winePrefixes,
        );
      }
    }

    winePrefixes.sort();

    return _WinePrefixRepo(orderedPrefixes: winePrefixes);
  }

  static Future<void> _loadWinePrefixFromOuterDir({
    required Directory winePrefixOuterDir,
    required List<WinePrefix> sink,
  }) async {
    final prefixDirStructure = WinePrefixDirStructure.fromOuterDir(
      winePrefixOuterDir.path,
    );

    try {
      final prefixJsonFileContents = await File(
        prefixDirStructure.prefixJsonFilePath,
      ).readAsString();

      final prefixDescriptor = WinePrefixDescriptor.fromJsonString(
        prefixJsonFileContents,
      );

      final prefix = WinePrefix(
        status: WinePrefixStatus.operational,
        dirStructure: prefixDirStructure,
        descriptor: prefixDescriptor,
      );

      sink.add(prefix);
    } catch (e, stackTrace) {
      final logger = GetIt.I.get<Logger>();
      logger.w(
        'Found a broken wine prefix at "${winePrefixOuterDir.path}',
        error: e,
        stackTrace: stackTrace,
      );

      // We add broken prefixes to the list anyway, to give the user the opportunity
      // to delete them manually.
      sink.add(WinePrefix.broken(outerDir: winePrefixOuterDir.path));
    }
  }
}

class _WinePrefixRepo implements WinePrefixRepo {
  @override
  final List<WinePrefix> orderedPrefixes;

  @override
  Stream<WinePrefixRepoEvent> get eventStream => _streamController.stream;

  /// Note that `sync: true` needs to be passed because updatePrefix() emits
  /// 2 events in a row, modifying [orderedPrefixes] in between. The handlers
  /// of those events will end up accessing [orderedPrefixes] and will expect
  /// it to be consistent with the event they are trying to handle. Therefore,
  /// we can't queue up these events and handle them later.
  final _streamController = StreamController<WinePrefixRepoEvent>.broadcast(
    sync: true,
  );

  _WinePrefixRepo({required this.orderedPrefixes});

  @override
  void addPrefix(WinePrefix newPrefix) {
    for (final entry in orderedPrefixes.asMap().entries) {
      final existingPrefixIndex = entry.key;
      final existingPrefix = entry.value;

      if (existingPrefix.compareTo(newPrefix) > 0) {
        // This existing prefix should go after the new one, so
        // given that we haven't added the new prefix yet, we've
        // found the place to insert the new prefix.
        orderedPrefixes.insert(existingPrefixIndex, newPrefix);
        _streamController.add(
          WinePrefixAddedEvent(
            newPrefix: newPrefix,
            newPrefixIndex: existingPrefixIndex,
            animatedInsertion: true,
          ),
        );
        return;
      }
    }

    // Add to the end of the list.
    orderedPrefixes.add(newPrefix);
    _streamController.add(
      WinePrefixAddedEvent(
        newPrefix: newPrefix,
        newPrefixIndex: orderedPrefixes.length - 1,
        animatedInsertion: true,
      ),
    );
  }

  @override
  void removePrefix(WinePrefix prefixToRemove) {
    for (final entry in orderedPrefixes.asMap().entries) {
      final existingPrefixIndex = entry.key;
      final existingPrefix = entry.value;
      if (existingPrefix == prefixToRemove) {
        orderedPrefixes.removeAt(existingPrefixIndex);
        _streamController.add(
          WinePrefixRemovedEvent(
            removedPrefix: prefixToRemove,
            removedPrefixIndex: existingPrefixIndex,
            animatedRemoval: true,
          ),
        );
        return;
      }
    }

    GetIt.I.get<Logger>().e(
      'Tried to remove prefix "${prefixToRemove.descriptor.name}" '
      "but it wasn't there",
    );
  }
}

sealed class WinePrefixRepoEvent {}

class WinePrefixAddedEvent implements WinePrefixRepoEvent {
  final WinePrefix newPrefix;
  final int newPrefixIndex;
  final bool animatedInsertion;

  WinePrefixAddedEvent({
    required this.newPrefix,
    required this.newPrefixIndex,
    required this.animatedInsertion,
  });
}

class WinePrefixRemovedEvent implements WinePrefixRepoEvent {
  final WinePrefix removedPrefix;
  final int removedPrefixIndex;
  final bool animatedRemoval;

  WinePrefixRemovedEvent({
    required this.removedPrefix,
    required this.removedPrefixIndex,
    required this.animatedRemoval,
  });
}
