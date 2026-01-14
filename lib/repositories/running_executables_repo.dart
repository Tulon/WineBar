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

import 'package:flutter/foundation.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/services/wine_process_runner_service.dart';

/// Keeps track of processes of a certain category (defined by SlotType) that
/// are currently running.
///
/// The [ChangeNotifier] notifies its listeners whenever a process is added
/// or removed from the set of tracked processes. Processes are removed from
/// the set of tracked processes when they finish.
abstract interface class RunningExecutablesRepo<SlotType> with ChangeNotifier {
  factory RunningExecutablesRepo() {
    return _RunningExecutablesRepo<SlotType>();
  }

  void addRunningProcess({
    required WinePrefixId prefixId,
    required SlotType slot,
    required WineProcess wineProcess,
  });

  WineProcess? tryFindRunningProcess({
    required WinePrefixId prefixId,
    required SlotType slot,
  });

  int numProcessesRunningInPrefix(WinePrefixId prefixId);

  int totalRunningProcesses();
}

typedef _RunningExecutablesInPrefix<SlotType> = Map<SlotType, WineProcess>;

class _RunningExecutablesRepo<SlotType>
    with ChangeNotifier
    implements RunningExecutablesRepo<SlotType> {
  final runningExecutablesByPrefixId =
      <WinePrefixId, _RunningExecutablesInPrefix<SlotType>>{};

  @override
  void addRunningProcess({
    required WinePrefixId prefixId,
    required SlotType slot,
    required WineProcess wineProcess,
  }) {
    var runningExecutablesInPrefix = runningExecutablesByPrefixId[prefixId];
    if (runningExecutablesInPrefix == null) {
      runningExecutablesInPrefix = _RunningExecutablesInPrefix();
      runningExecutablesByPrefixId[prefixId] = runningExecutablesInPrefix;
    }

    runningExecutablesInPrefix[slot] = wineProcess;

    // Remove it when WineProcess has finished.
    unawaited(
      wineProcess.result.whenComplete(() {
        runningExecutablesInPrefix!.remove(slot);
        if (runningExecutablesInPrefix.isEmpty) {
          runningExecutablesByPrefixId.remove(prefixId);
        }
        notifyListeners();
      }),
    );

    notifyListeners();
  }

  @override
  WineProcess? tryFindRunningProcess({
    required WinePrefixId prefixId,
    required SlotType slot,
  }) {
    return runningExecutablesByPrefixId[prefixId]?[slot];
  }

  @override
  int numProcessesRunningInPrefix(WinePrefixId prefixId) {
    return runningExecutablesByPrefixId[prefixId]?.length ?? 0;
  }

  @override
  int totalRunningProcesses() {
    return runningExecutablesByPrefixId.entries.fold(
      0,
      (sum, entry) => sum + entry.value.length,
    );
  }
}
