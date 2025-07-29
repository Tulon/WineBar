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

import 'dart:async';

import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/services/wine_process_runner_service.dart';

enum SpecialExecutableSlot {
  customExecutable,
  runAndPinExecutable,
  winetricksExecutable,
}

abstract interface class RunningSpecialExecutablesRepo {
  factory RunningSpecialExecutablesRepo() {
    return _RunningSpecialExecutablesRepo();
  }

  void add({
    required WinePrefix prefix,
    required SpecialExecutableSlot executableSlot,
    required WineProcess wineProcess,
  });

  WineProcess? tryFind({
    required WinePrefix prefix,
    required SpecialExecutableSlot executableSlot,
  });
}

typedef _RunningExecutablesInPrefix = Map<SpecialExecutableSlot, WineProcess>;

class _RunningSpecialExecutablesRepo implements RunningSpecialExecutablesRepo {
  final runningExecutablesByPrefix =
      <WinePrefix, _RunningExecutablesInPrefix>{};

  @override
  void add({
    required WinePrefix prefix,
    required SpecialExecutableSlot executableSlot,
    required WineProcess wineProcess,
  }) {
    var runningExecutablesInPrefix = runningExecutablesByPrefix[prefix];
    if (runningExecutablesInPrefix == null) {
      runningExecutablesInPrefix = _RunningExecutablesInPrefix();
      runningExecutablesByPrefix[prefix] = runningExecutablesInPrefix;
    }

    runningExecutablesInPrefix[executableSlot] = wineProcess;

    // Remove it when WineProcess has finished.
    unawaited(
      wineProcess.result.whenComplete(() {
        runningExecutablesInPrefix!.remove(executableSlot);
        if (runningExecutablesInPrefix.isEmpty) {
          runningExecutablesByPrefix.remove(prefix);
        }
      }),
    );
  }

  @override
  WineProcess? tryFind({
    required WinePrefix prefix,
    required SpecialExecutableSlot executableSlot,
  }) {
    return runningExecutablesByPrefix[prefix]?[executableSlot];
  }
}
