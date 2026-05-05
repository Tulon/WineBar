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
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
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
    required WinePrefix prefix,
    required SlotType slot,
    required WineProcess wineProcess,
  });

  WineProcess? tryFindRunningProcess({
    required WinePrefix prefix,
    required SlotType slot,
  });

  int numProcessesRunningInPrefix(WinePrefix prefix);

  int totalRunningProcesses();
}

class _RunningExecutablesRepo<SlotType>
    with ChangeNotifier
    implements RunningExecutablesRepo<SlotType> {
  final runningProcessesByPrefix =
      <WinePrefix, _RunningProcessesInPrefix<SlotType>>{};

  @override
  void addRunningProcess({
    required WinePrefix prefix,
    required SlotType slot,
    required WineProcess wineProcess,
  }) {
    final runningProcessesInPrefix = runningProcessesByPrefix.putIfAbsent(
      prefix,
      () => _RunningProcessesInPrefix(),
    );

    runningProcessesInPrefix.addProcessAndNotifyPrefix(
      slot: slot,
      process: wineProcess,
      prefix: prefix,
    );

    notifyListeners();

    // Remove it when WineProcess has finished.
    unawaited(
      wineProcess.result.then((_) {}, onError: (_) {}).whenComplete(() {
        runningProcessesInPrefix.removeProcessAndNotifyPrefix(
          slot: slot,
          process: wineProcess,
          prefix: prefix,
        );
        if (runningProcessesInPrefix.isEmpty) {
          runningProcessesByPrefix.remove(prefix);
        }
        notifyListeners();
      }),
    );
  }

  @override
  WineProcess? tryFindRunningProcess({
    required WinePrefix prefix,
    required SlotType slot,
  }) {
    return runningProcessesByPrefix[prefix]?[slot];
  }

  @override
  int numProcessesRunningInPrefix(WinePrefix prefix) {
    return runningProcessesByPrefix[prefix]?.length ?? 0;
  }

  @override
  int totalRunningProcesses() {
    return runningProcessesByPrefix.entries.fold(
      0,
      (sum, entry) => sum + entry.value.length,
    );
  }
}

class _RunningProcessesInPrefix<SlotType> {
  final _map = <SlotType, WineProcess>{};

  bool get isEmpty => _map.isEmpty;

  int get length => _map.length;

  WineProcess? operator [](SlotType slot) => _map[slot];

  void addProcessAndNotifyPrefix({
    required SlotType slot,
    required WineProcess process,
    required WinePrefix prefix,
  }) {
    _map.update(slot, (oldProcess) {
      GetIt.I.get<Logger>().e(
        "More than one process is running in the same slot of the same "
        "prefix. That should never happen.",
      );
      return process;
    }, ifAbsent: () => process);

    prefix.onNewWineProcessRunning(process);
  }

  void removeProcessAndNotifyPrefix({
    required SlotType slot,
    required WineProcess process,
    required WinePrefix prefix,
  }) {
    final removedProcess = _map.remove(slot);
    if (removedProcess != null && removedProcess != process) {
      GetIt.I.get<Logger>().e(
        "The process has finished though the slot in question had a different "
        "process. That should never happen.",
      );

      // Put that different process back into the slot.
      _map[slot] = removedProcess;
    }

    prefix.onWineProcessFinished(process);
  }
}
