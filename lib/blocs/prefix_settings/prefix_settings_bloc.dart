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
import 'package:winebar/exceptions/wine_command_failed_exception.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/models/wine_arch_warning.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/app_settings_service.dart';
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
           startupData: startupData,
           hiDpiScale: prefix.descriptor.hiDpiScale,
           wow64ModePreferred: prefix.descriptor.wow64ModePreferred,
         ),
       );

  void setHiDpiScale(double scaleFactor) {
    emit(state.copyWith(hiDpiScaleGetter: () => scaleFactor));
  }

  void setWow64ModePreferred(bool wow64ModePreferred) {
    assert(state.wow64ModePreferred != null);

    if (state.wow64ModePreferred == wow64ModePreferred) {
      return;
    }

    final wow64ModePreferenceWarning = wineArchWarningToShowForDualModeBuild(
      startupData: startupData,
      wow64ModeSelected: wow64ModePreferred,
    );

    emit(
      state.copyWith(
        wow64ModePreferredGetter: () => wow64ModePreferred,
        wow64ModePreferenceWarningGetter: () => wow64ModePreferenceWarning,
        wow64ModePreferenceWarningToBeSuppressed: false,
      ),
    );
  }

  void setWow64ModePreferenceWarningToBeSuppressed(bool toBeSuppressed) {
    assert(state.wow64ModePreferred != null);

    if (state.wow64ModePreferenceWarningToBeSuppressed == toBeSuppressed) {
      return;
    }

    emit(
      state.copyWith(wow64ModePreferenceWarningToBeSuppressed: toBeSuppressed),
    );
  }

  void startUpdatingPrefix() {
    if (!_validate()) {
      return;
    }

    emit(
      state.copyWith(
        prefixUpdateStatus: PrefixUpdateStatus.inProgress,
        prefixUpdateFailureMessageGetter: () => null,
        prefixUpdateFailedProcessResultGetter: () => null,
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

      // Update the prefix. Eventually it will be passed to the
      // onPrefixUpdated() callback, but we also want the "wine reg"
      // command that runs under the hood of _applyHiDpiSettings()
      // below to take the current value of state.wow64ModePreferred
      // into account.
      prefix = prefix.copyWith(
        descriptor: prefix.descriptor.copyWith(
          hiDpiScaleGetter: () => state.hiDpiScale,
          wow64ModePreferredGetter: () => state.wow64ModePreferred,
        ),
      );

      await _applyHiDpiSettings(
        winePrefix: prefix,
        wineInstDescriptor: wineInstDescriptor,
        runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      );

      // Write a new prefox.json file.
      await File(
        prefix.dirStructure.prefixJsonFilePath,
      ).writeAsString(prefix.descriptor.toJsonString());

      // Maybe suppress the warning related to the wow64 preference toggle.
      final wow64PreferenceSuppressableWarning =
          state.wow64ModePreferenceWarning?.suppressableWarning;
      if (wow64PreferenceSuppressableWarning != null) {
        GetIt.I.get<AppSettingsService>().setWarningSuppressed(
          wow64PreferenceSuppressableWarning,
          suppressed: state.wow64ModePreferenceWarningToBeSuppressed,
        );
      }
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
      throw WineCommandFailedException(
        'The "wine reg" command failed',
        processResult: processResult,
      );
    }
  }

  void _processPrefixUpdated() {
    emit(
      state.copyWith(
        prefixUpdateStatus: PrefixUpdateStatus.succeeded,
        prefixUpdateFailureMessageGetter: () => null,
        prefixUpdateFailedProcessResultGetter: () => null,
      ),
    );

    onPrefixUpdated(prefix);
  }

  void _processPrefixUpdateFailure(Object error) {
    final processResult = error is WineCommandFailedException
        ? error.processResult
        : null;

    emit(
      state.copyWith(
        prefixUpdateStatus: PrefixUpdateStatus.failed,
        prefixUpdateFailureMessageGetter: () => error.toString(),
        prefixUpdateFailedProcessResultGetter: () => processResult,
      ),
    );
  }
}
