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

import 'package:flutter/foundation.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/repositories/running_executables_repo.dart';

/// Keeps track of the number of wine processes (of any type) that are
/// currently running either within a given prefix or across all prefixes.
///
/// The [ChangeNotifier] notifies its listeners whenever a process is added
/// or removed from the set of tracked processes. Processes are removed from
/// the set of tracked processes when they finish.
class RunningWineProcessesTracker with ChangeNotifier {
  /// These would be [RunningExecutableRepo] instances parametrized with
  /// different types.
  final List<RunningExecutablesRepo> typedRepos;

  RunningWineProcessesTracker(this.typedRepos) {
    for (final repo in typedRepos) {
      repo.addListener(notifyListeners);
    }
  }

  int numProcessesRunningInPrefix(WinePrefix prefix) {
    return typedRepos.fold(
      0,
      (sum, typedRepo) => sum + typedRepo.numProcessesRunningInPrefix(prefix),
    );
  }

  int totalRunningProcesses() {
    return typedRepos.fold(
      0,
      (sum, typedRepo) => sum + typedRepo.totalRunningProcesses(),
    );
  }
}
