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

import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/repositories/running_pinned_executables_repo.dart';
import 'package:winebar/services/wine_process_runner_service.dart';

typedef _RunningExecutablesInPrefix = Map<PinnedExecutable, WineProcess>;

class RunningPinnedExecutablesRepoImpl implements RunningPinnedExecutablesRepo {
  final runningExecutablesByPrefix =
      <WinePrefix, _RunningExecutablesInPrefix>{};

  @override
  void add({
    required WinePrefix prefix,
    required PinnedExecutable pinnedExecutable,
    required WineProcess wineProcess,
  }) {
    var runningExecutablesInPrefix = runningExecutablesByPrefix[prefix];
    if (runningExecutablesInPrefix == null) {
      runningExecutablesInPrefix = _RunningExecutablesInPrefix();
      runningExecutablesByPrefix[prefix] = runningExecutablesInPrefix;
    }

    runningExecutablesInPrefix[pinnedExecutable] = wineProcess;

    // Remove it when WineProcess has finished.
    unawaited(
      wineProcess.result.whenComplete(() {
        runningExecutablesInPrefix!.remove(pinnedExecutable);
        if (runningExecutablesInPrefix.isEmpty) {
          runningExecutablesByPrefix.remove(prefix);
        }
      }),
    );
  }

  @override
  WineProcess? tryFind({
    required WinePrefix prefix,
    required PinnedExecutable pinnedExecutable,
  }) {
    return runningExecutablesByPrefix[prefix]?[pinnedExecutable];
  }
}
