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

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/exceptions/generic_exception.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/services/wine_process_runner_service.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';

import 'prefix_descriptor.dart';

enum WinePrefixStatus {
  operational,

  /// Indicates the prefix's directory exists on the file system but
  /// something is missing or broken in it, making the prefix unusable.
  /// The only thing a user can do with such a prefix is to delete it.
  broken,

  beingConstructed,
  beingDeleted,
}

typedef WinePrefixCreatedCallback = void Function(WinePrefix prefix);

/// A mutable class representing a wine prefix present on the file system.
///
/// A single instance of this class shall correspond to a single directory
/// in the file system.
///
/// The Comparable interface orders instances in display order.
///
/// This class notifies its listeners (via the ChangeNotifier mixin) whenever
/// any observable state of an instance is modified.
abstract interface class WinePrefix
    with ChangeNotifier
    implements Comparable<WinePrefix> {
  factory WinePrefix({
    required WinePrefixStatus status,
    required WinePrefixDirStructure dirStructure,
    required WinePrefixDescriptor descriptor,
  }) {
    return _WinePrefix(
      status: status,
      dirStructure: dirStructure,
      descriptor: descriptor,
    );
  }

  /// Creates a prefix with the status of [WinePrefixStatus.broken].
  factory WinePrefix.broken({required String outerDir}) {
    return _WinePrefix(
      status: WinePrefixStatus.broken,
      dirStructure: WinePrefixDirStructure.fromOuterDir(outerDir),
      descriptor: WinePrefixDescriptor.brokenPrefix(
        name: '${path.basename(outerDir)} (broken)',
      ),
    );
  }

  WinePrefixStatus get status;

  WinePrefixDirStructure get dirStructure;

  WinePrefixDescriptor get descriptor;

  void updateDescriptor(WinePrefixDescriptor newDescriptor);

  bool get hasRunningProcesses;

  void onNewWineProcessRunning(WineProcess process);

  void onWineProcessFinished(WineProcess process);

  void startDeleting();
}

class _WinePrefix with ChangeNotifier implements WinePrefix {
  @override
  WinePrefixStatus status;

  @override
  final WinePrefixDirStructure dirStructure;

  @override
  WinePrefixDescriptor descriptor;

  int _numProcessesRunning = 0;

  _WinePrefix({
    required this.status,
    required this.dirStructure,
    required this.descriptor,
  });

  /// Compares by [WinePrefixDescriptor.name] and then by [WinePrefixDirStructure.outerDir].
  @override
  int compareTo(WinePrefix other) {
    final nameComp = descriptor.name.compareTo(other.descriptor.name);
    if (nameComp != 0) {
      return nameComp;
    }

    return dirStructure.outerDir.compareTo(other.dirStructure.outerDir);
  }

  @override
  void updateDescriptor(WinePrefixDescriptor newDescriptor) {
    descriptor = newDescriptor;
    notifyListeners();
  }

  @override
  bool get hasRunningProcesses => _numProcessesRunning > 0;

  @override
  void onNewWineProcessRunning(WineProcess process) {
    ++_numProcessesRunning;
  }

  @override
  void onWineProcessFinished(WineProcess process) {
    --_numProcessesRunning;
  }

  @override
  void startDeleting() {
    switch (status) {
      case WinePrefixStatus.operational:
      case WinePrefixStatus.broken:
        break;
      case WinePrefixStatus.beingDeleted:
        return;
      case WinePrefixStatus.beingConstructed:
        throw GenericException(
          "Trying to delete a prefix that's still being constructed",
        );
    }

    status = WinePrefixStatus.beingDeleted;
    notifyListeners();

    unawaited(
      recursiveDeleteAndLogErrors(Directory(dirStructure.outerDir)).then((_) {
        GetIt.I.get<StartupData>().winePrefixRepo.removePrefix(this);
      }),
    );
  }
}
