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

import 'package:dbus/dbus.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/dbus/org_freedesktop_screensaver.dart';
import 'package:winebar/services/running_wine_processes_tracker.dart';
import 'package:winebar/utils/app_info.dart';

abstract interface class ScreensaverInhibitionService {
  factory ScreensaverInhibitionService({
    required DBusClient dbusClient,
    required RunningWineProcessesTracker runningWineProcessesTracker,
  }) {
    return _ScreensaverInhibitionService(
      dbusClient: dbusClient,
      runningWineProcessesTracker: runningWineProcessesTracker,
    );
  }
}

class _ScreensaverInhibitionService implements ScreensaverInhibitionService {
  final logger = GetIt.I.get<Logger>();
  final RunningWineProcessesTracker runningWineProcessesTracker;
  final OrgFreedesktopScreenSaver screenSaver;
  int totalProcessesRunning = 0;
  int? inhibitionCookie;
  Future<void> lastEnableDisableOperationComplete = Future<void>.value();

  _ScreensaverInhibitionService({
    required DBusClient dbusClient,
    required this.runningWineProcessesTracker,
  }) : screenSaver = OrgFreedesktopScreenSaver(
         dbusClient,
         'org.freedesktop.ScreenSaver',
         DBusObjectPath('/org/freedesktop/ScreenSaver'),
       ) {
    runningWineProcessesTracker.addListener(_onProcessListUpdated);
  }

  void _onProcessListUpdated() {
    final int oldTotalProcessesRunning = totalProcessesRunning;
    totalProcessesRunning = runningWineProcessesTracker.totalRunningProcesses();

    if (oldTotalProcessesRunning == 0 && totalProcessesRunning != 0) {
      _disableScreenSaver();
    } else if (oldTotalProcessesRunning != 0 && totalProcessesRunning == 0) {
      _enableScreenSaver();
    }
  }

  void _disableScreenSaver() {
    lastEnableDisableOperationComplete = lastEnableDisableOperationComplete
        .then((_) async {
          logger.i('Disabling the screensaver');

          inhibitionCookie = await screenSaver.callInhibit(
            AppInfo.appName,
            'A Wine app (possibly fullscreen) is running',
          );
        })
        .catchError((e, stackTrace) {
          logger.e(
            'Failed to disable the screensaver',
            error: e,
            stackTrace: stackTrace,
          );
        });
  }

  void _enableScreenSaver() {
    final cookie = inhibitionCookie;
    if (cookie == null) {
      logger.i(
        "Can't re-enable the screensaver as the previous "
        "attempt to enable it failed",
      );
      return;
    }

    lastEnableDisableOperationComplete = lastEnableDisableOperationComplete
        .then((_) async {
          logger.i('Re-enabling the screensaver');

          await screenSaver.callUnInhibit(cookie);
          inhibitionCookie = null;
        })
        .catchError((e, stackTrace) {
          logger.e(
            'Failed to re-enable the screensaver',
            error: e,
            stackTrace: stackTrace,
          );
        });
  }
}
