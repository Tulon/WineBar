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

/// May tell the user (via a SnackBar) to close the apps running in a
/// particular prefix or in all prefixes (it checks if the apps are
/// actually running there.
///
/// The [appsRunningInAnyPrefixAreAProblem] will often be set to
/// [StartupData.wineWillRunUnderMuvm], as the issues arising from
/// running multiple apps at the same time, as described in README.md,
/// apply even to apps running in different prefixes, when wine is
/// run under muvm.
///
/// Returns whether the user was told to finish the running apps.
bool maybeTellUserToFinishRunningApps({
  required BuildContext context,
  WinePrefix? appsRunningInThisPrefixAreAProblem,
  bool appsRunningInAnyPrefixAreAProblem = false,
}) {
  final runningWineProcessesTracker = GetIt.I
      .get<RunningWineProcessesTracker>();

  final totalRunningApps = runningWineProcessesTracker.totalRunningProcesses();
  final appsRunningInPrefix = appsRunningInThisPrefixAreAProblem == null
      ? null
      : runningWineProcessesTracker.numProcessesRunningInPrefix(
          appsRunningInThisPrefixAreAProblem,
        );

  String? message;

  if (appsRunningInAnyPrefixAreAProblem && totalRunningApps > 0) {
    message = 'Finish the apps running in all prefixes first';
  } else if (appsRunningInPrefix != null && appsRunningInPrefix > 0) {
    message = 'Finish the running apps first';
  }

  if (message == null) {
    return false;
  }

  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  return true;
}
