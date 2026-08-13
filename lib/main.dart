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

import 'dart:ui';

import 'package:dbus/dbus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:process/process.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winebar/models/gpu_info.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/dxvk_installation_service.dart';
import 'package:winebar/services/running_wine_processes_tracker.dart';
import 'package:winebar/services/screensaver_inhibition_service.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/services/winetricks_download_service.dart';
import 'package:winebar/services/winetricks_download_service_impl.dart';
import 'package:winebar/utils/donation_solicitation_logic.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_tasks.dart';

import 'repositories/wine_build_source_repo.dart';
import 'services/download_and_extraction_service.dart';
import 'services/download_and_extraction_service_impl.dart';
import 'widgets/top_level_widget.dart';

void main() async {
  bool productionMode = true;
  assert(() {
    // Asserts are disabled in production mode, so this code will never run.
    productionMode = false;
    return true;
  }());

  final logOutputs = <LogOutput>[];

  if (productionMode) {
    // In production mode, we log to files. This kind of logging doesn't block
    // the UI thread.
    final appCacheDir = await getApplicationCacheDirectory();
    final logDir = path.join(appCacheDir.path, 'logs');

    logOutputs.add(
      AdvancedFileOutput(
        path: logDir,
        overrideExisting: true,
        writeImmediately: [Level.fatal],
      ),
    );
  } else {
    // In development mode, we log to console.
    logOutputs.add(ConsoleOutput());
  }

  final logger = Logger(
    // ProductionFilter outputs logs in both production and debug modes,
    // while DevelopmentFilter only outputs them in debug mode.
    filter: ProductionFilter(),

    printer: PrettyPrinter(
      lineLength: productionMode ? 80 : 120,
      colors: !productionMode,
      noBoxingByDefault: productionMode,
    ),

    output: MultiOutput(logOutputs),
  );

  // It would be tempting to pass httpClientAdapter = Http2Adapter(...)
  // here. Unfortunately, it turns out to be quite buggy. Getting the list
  // Github releases simply fails and large downloads fail to complete.
  final dio = Dio()
    ..options.connectTimeout = Duration(seconds: 5)
    ..options.receiveTimeout = Duration(seconds: 5)
    ..options.sendTimeout = Duration(seconds: 5);

  final dbusClient = DBusClient.session();

  final runningPinnedExecutablesRepo =
      RunningExecutablesRepo<PinnedExecutable>();

  final runningSpecialExecutablesRepo =
      RunningExecutablesRepo<SpecialExecutableSlot>();

  final runningWineProcessesTracker = RunningWineProcessesTracker([
    runningPinnedExecutablesRepo,
    runningSpecialExecutablesRepo,
  ]);

  final sharedPreferencesAsync = SharedPreferencesAsync();

  GetIt.I.registerSingleton<Logger>(logger);
  GetIt.I.registerSingleton<SharedPreferencesAsync>(sharedPreferencesAsync);
  GetIt.I.registerSingleton<ProcessManager>(LocalProcessManager());
  GetIt.I.registerSingleton<Dio>(dio);
  GetIt.I.registerSingleton<UtilityService>(UtilityService());
  GetIt.I.registerSingleton<WineBuildSourceRepo>(WineBuildSourceRepo(dio: dio));
  GetIt.I.registerSingleton<DownloadAndExtractionService>(
    DownloadAndExtractionServiceImpl(dio: dio),
  );
  GetIt.I.registerSingleton<WinetricksDownloadService>(
    WinetricksDownloadServiceImpl(dio: dio),
  );
  GetIt.I.registerSingleton<DxvkInstallationService>(DxvkInstallationService());
  GetIt.I.registerSingleton<RunningExecutablesRepo<PinnedExecutable>>(
    runningPinnedExecutablesRepo,
  );
  GetIt.I.registerSingleton<RunningExecutablesRepo<SpecialExecutableSlot>>(
    runningSpecialExecutablesRepo,
  );
  GetIt.I.registerSingleton<RunningWineProcessesTracker>(
    runningWineProcessesTracker,
  );
  GetIt.I.registerSingleton<ScreensaverInhibitionService>(
    ScreensaverInhibitionService(
      dbusClient: dbusClient,
      runningWineProcessesTracker: runningWineProcessesTracker,
    ),
  );
  GetIt.I.registerSingletonAsync<List<GpuInfo>>(
    GpuInfo.loadListOfAvailableGpus,
  );

  WineTasks.createAndRegisterInstance();
  StartupData.asyncCreateAndRegisterInstance();

  // This must be called after StartupData.asyncCreateAndRegisterInstance()
  DonationSolicitationLogic.asyncCreateAndRegisterInstance(
    runningWineProcessesTracker: runningWineProcessesTracker,
  );

  runApp(TopLevelWidget());

  // This has to be called after runApp().
  AppLifecycleListener(
    onExitRequested: () async {
      DonationSolicitationLogic.instance.onAppShuttingDown();
      return AppExitResponse.exit;
    },
  );
}
