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
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/exceptions/generic_exception.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';
import 'package:winebar/utils/wine_tasks.dart';

import '../../models/wine_prefix.dart';
import 'prefix_settings_state.dart';

class PrefixSettingsBloc extends Cubit<PrefixSettingsState> {
  final logger = GetIt.I.get<Logger>();
  final StartupData startupData;
  WinePrefix prefix;
  final void Function(WinePrefix) onPrefixUpdated;

  PrefixSettingsBloc({
    required this.startupData,
    required this.prefix,
    required this.onPrefixUpdated,
  }) : super(
         PrefixSettingsState.initialState(
           hiDpiScale: prefix.descriptor.hiDpiScale,
         ),
       );

  void setHiDpiScale(double scaleFactor) {
    emit(state.copyWith(hiDpiScaleGetter: () => scaleFactor));
  }

  void startUpdatingPrefix() {
    if (!_validate()) {
      return;
    }

    emit(
      state.copyWith(
        prefixUpdateStatus: PrefixUpdateStatus.inProgress,
        prefixUpdateFailureMessageGetter: () => null,
      ),
    );

    unawaited(
      _updatePrefix().then(
        (_) => _processPrefixUpdated(),
        onError: _processPrefixUpdateFailure,
      ),
    );
  }

  bool _validate() {
    if (state.hiDpiScale == null) {
      emit(
        state.copyWith(prefixUpdateStatus: PrefixUpdateStatus.validationFailed),
      );
      return false;
    }

    return true;
  }

  Future<void> _updatePrefix() async {
    final utilityService = GetIt.I.get<UtilityService>();
    final runningSpecialExecutablesRepo = GetIt.I
        .get<RunningExecutablesRepo<SpecialExecutableSlot>>();

    final wineInstallDir = prefix.descriptor.getAbsPathToWineInstall(
      toplevelDataDir: startupData.localStoragePaths.toplevelDataDir,
    );

    try {
      final wineInstDescriptor = await utilityService
          .wineInstallationDescriptorForWineInstallDir(wineInstallDir);

      await _applyHiDpiSettings(
        winePrefix: prefix,
        wineInstDescriptor: wineInstDescriptor,
        runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      );

      // Update the prefix. It will be passed to the onPrefixUpdated() callback.
      prefix = prefix.copyWith(
        descriptor: prefix.descriptor.copyWith(
          hiDpiScaleGetter: () => state.hiDpiScale,
        ),
      );

      // Write a new prefox.json file.
      await File(
        prefix.dirStructure.prefixJsonFilePath,
      ).writeAsString(prefix.descriptor.toJsonString());
    } catch (e, stackTrace) {
      logger.e('Updating prefix failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> _applyHiDpiSettings({
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
  }) async {
    final process = await startTaskOfSettingHiDpiScale(
      hiDpiScale: state.hiDpiScale!,
      startupData: startupData,
      winePrefix: winePrefix,
      wineInstDescriptor: wineInstDescriptor,
      runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      specialExecutableSlot: SpecialExecutableSlot.prefixCreationTask,
    );

    final processResult = await process.result;

    if (processResult.exitCode != 0) {
      throw GenericException(
        'The wine reg command exited with status '
        '${processResult.exitCode}',
      );
    }
  }

  void _processPrefixUpdated() {
    emit(
      state.copyWith(
        prefixUpdateStatus: PrefixUpdateStatus.succeeded,
        prefixUpdateFailureMessageGetter: () => null,
      ),
    );

    onPrefixUpdated(prefix);
  }

  void _processPrefixUpdateFailure(Object error) {
    emit(
      state.copyWith(
        prefixUpdateStatus: PrefixUpdateStatus.failed,
        prefixUpdateFailureMessageGetter: () => error.toString(),
      ),
    );
  }
}
