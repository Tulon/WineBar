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

import 'package:get_it/get_it.dart';
import 'package:winebar/models/donation_solicitation_state.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/services/running_wine_processes_tracker.dart';
import 'package:winebar/utils/startup_data.dart';

/// This class decides when to show the donation solicitation dialog.
///
/// The logic is simple: before the dialog is shown again or for the
/// first time, 30 days has to pass but also 30 hours of running
/// Windows apps.
///
/// That means, heavy users will see the dialog every 30 days while
/// light users will see it even more rarely.
class DonationSolicitationLogic {
  final AppSettingsService _appSettingsService;
  final RunningWineProcessesTracker _runningWineProcessesTracker;
  final _windowsAppsRunningStopwatch = Stopwatch();
  bool _appShuttingDown = false;

  DonationSolicitationLogic._({
    required AppSettingsService appSettingsService,
    required RunningWineProcessesTracker runningWineProcessesTracker,
  }) : _appSettingsService = appSettingsService,
       _runningWineProcessesTracker = runningWineProcessesTracker {
    runningWineProcessesTracker.addListener(_checkRunningWineProcesses);
  }

  /// Creates an instance of this class and registers it as a singleton.
  ///
  /// Note that this function may only be called after
  /// StartupData.asyncCreateAndRegisterInstance() is called.
  static void asyncCreateAndRegisterInstance({
    required RunningWineProcessesTracker runningWineProcessesTracker,
  }) {
    GetIt.I.registerSingletonAsync<DonationSolicitationLogic>(
      () async {
        return DonationSolicitationLogic._(
          appSettingsService: GetIt.I.get<AppSettingsService>(),
          runningWineProcessesTracker: runningWineProcessesTracker,
        );
      },
      // The AppSettingsService singleton is registered by StartupData,
      // so we wait on that one first.
      dependsOn: [StartupData],
    );
  }

  static DonationSolicitationLogic get instance {
    return GetIt.I.get<DonationSolicitationLogic>();
  }

  /// Determines whether it's time to show the donation solicitation dialog.
  ///
  /// If so, returns true and updates the state accordingly.
  bool maybeTriggerDonationSolicitation() {
    final int secondsPerHour = 60 * 60;
    final int secondsPerDay = secondsPerHour * 24;

    final state = _appSettingsService.settings.donationSolicitationState;

    if (state.secondsSinceLastSolicitation < 30 * secondsPerDay ||
        state.windowsAppsRunTimeSecSinceLastSolicitation <
            30 * secondsPerHour) {
      return false;
    }

    // Reset the state.
    _appSettingsService.setDonationSolicitationState(
      DonationSolicitationState.initialState(),
    );

    return true;
  }

  void onAppShuttingDown() {
    if (!_appShuttingDown) {
      _processNumberOfWineProcessesRunning(0);
      _appShuttingDown = true;
    }
  }

  void _checkRunningWineProcesses() {
    if (!_appShuttingDown) {
      _processNumberOfWineProcessesRunning(
        _runningWineProcessesTracker.totalRunningProcesses(),
      );
    }
  }

  void _processNumberOfWineProcessesRunning(int numWineProcessesRunning) {
    if (_windowsAppsRunningStopwatch.isRunning ==
        (numWineProcessesRunning != 0)) {
      // Nothing to do.
      return;
    }

    if (!_windowsAppsRunningStopwatch.isRunning) {
      _windowsAppsRunningStopwatch.start();
    } else {
      final int elapsedSeconds =
          _windowsAppsRunningStopwatch.elapsedMilliseconds ~/ 1000;

      _windowsAppsRunningStopwatch.stop();
      _windowsAppsRunningStopwatch.reset();

      final state = _appSettingsService.settings.donationSolicitationState;

      _appSettingsService.setDonationSolicitationState(
        state.copyWith(
          windowsAppsRunTimeSecSinceLastSolicitation:
              state.windowsAppsRunTimeSecSinceLastSolicitation + elapsedSeconds,
        ),
      );
    }
  }
}
