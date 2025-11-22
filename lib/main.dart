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

import 'package:dbus/dbus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/screensaver_inhibition_service.dart';
import 'package:winebar/services/winetricks_download_service.dart';
import 'package:winebar/services/winetricks_download_service_impl.dart';

import 'repositories/wine_build_source_repo.dart';
import 'repositories/wine_build_source_repo_impl.dart';
import 'services/download_and_extraction_service.dart';
import 'services/download_and_extraction_service_impl.dart';
import 'widgets/top_level_widget.dart';

void main() {
  final logger = Logger();

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

  GetIt.I.registerSingleton<Logger>(logger);
  GetIt.I.registerSingleton<Dio>(dio);
  GetIt.I.registerSingleton<WineBuildSourceRepo>(
    WineBuildSourceRepoImpl(dio: dio),
  );
  GetIt.I.registerSingleton<DownloadAndExtractionService>(
    DownloadAndExtractionServiceImpl(dio: dio),
  );
  GetIt.I.registerSingleton<WinetricksDownloadService>(
    WinetricksDownloadServiceImpl(dio: dio),
  );
  GetIt.I.registerSingleton<RunningExecutablesRepo<PinnedExecutable>>(
    runningPinnedExecutablesRepo,
  );
  GetIt.I.registerSingleton<RunningExecutablesRepo<SpecialExecutableSlot>>(
    runningSpecialExecutablesRepo,
  );
  GetIt.I.registerSingleton<ScreensaverInhibitionService>(
    ScreensaverInhibitionService(
      dbusClient: dbusClient,
      runningExecutablesRepos: [
        runningPinnedExecutablesRepo,
        runningSpecialExecutablesRepo,
      ],
    ),
  );

  runApp(TopLevelWidget());
}
