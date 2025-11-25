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

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/services/running_wine_processes_tracker.dart';

/// If there are apps running in the given prefix, tell the user (via a
/// SnackBar) to finish them first. If the wine processes are run under
/// muvm, tells the user to finish any apps running in any prefix, if
/// any are running.
///
/// If [prefix] is null, then we only check for situations requiring
/// the user to finish the apps running in all prefixes.
///
/// Returns whether the user was told to finish the running apps.
bool maybeTellUserToFinishRunningApps({
  required BuildContext context,
  required WinePrefix? prefix,
  required bool wineWillRunUnderMuvm,
}) {
  final runningWineProcessTracker = GetIt.I.get<RunningWineProcessesTracker>();

  if (wineWillRunUnderMuvm &&
      runningWineProcessTracker.totalRunningProcesses() > 0) {
    // Under muvm, running more that one wine process even across different
    // prefixes leads to issues. In particural, we would only acknowledge
    // the process as finished when *all* such processes finish. In the
    // context of a prefix creation or prefix settings dialogs, which are
    // modal and which run wine processes of their own, such a situation
    // would lead to a hang.
    const snackBar = SnackBar(
      content: Text('Finish the apps running in all prefixes first'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return true;
  } else if (prefix != null &&
      runningWineProcessTracker.numProcessesRunningInPrefix(prefix) > 0) {
    const snackBar = SnackBar(content: Text('Finish the running apps first'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return true;
  } else {
    return false;
  }
}
