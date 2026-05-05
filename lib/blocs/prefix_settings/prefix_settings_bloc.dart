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

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:winebar/exceptions/wine_command_failed_exception.dart';
import 'package:winebar/models/d3d_8_to_11_implementation.dart';
import 'package:winebar/models/explicit_d3d_8_to_11_implementation_state.dart';
import 'package:winebar/models/explicit_locale_state.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/models/wine_arch_warning.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/services/dxvk_installation_service.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_tasks.dart';

import '../../models/wine_prefix.dart';
import 'prefix_settings_state.dart';

class PrefixSettingsBloc extends Cubit<PrefixSettingsState> {
  static const SpecialExecutableSlot _specialExecutableSlot =
      SpecialExecutableSlot.prefixUpdateTask;

  final logger = GetIt.I.get<Logger>();
  WinePrefix prefix;
  final void Function(WinePrefix) onPrefixUpdated;

  PrefixSettingsBloc({required this.prefix, required this.onPrefixUpdated})
    : super(
        PrefixSettingsState.initialState(
          hiDpiScale: prefix.descriptor.hiDpiScale,
          wow64ModePreferred: prefix.descriptor.wow64ModePreferred,
          d3d8To11Implementation: prefix.descriptor.d3d8To11Implementation,
          explicitLocale: GetIt.I.get<StartupData>().wineLocaleRepo.tryFind(
            posixName: prefix.descriptor.explicitLocalePosixName,
          ),
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

  void setExplicitD3d8To11ImplementationState(
    ExplicitD3d8To11ImplementationState d3dImplState,
  ) {
    if (state.explicitD3d8To11ImplementationState != d3dImplState) {
      emit(state.copyWith(explicitD3d8To11ImplementationState: d3dImplState));
    }
  }

  void setExplicitLocaleState(ExplicitLocaleState explicitLocaleState) {
    if (state.explicitLocaleState != explicitLocaleState) {
      emit(state.copyWith(explicitLocaleState: explicitLocaleState));
    }
  }

  void startUpdatingPrefix() {
    if (!_validate()) {
      return;
    }

    emit(
      state.copyWith(
        // We have to switch the state early, if only to disable the
        // 'Update Prefix' button.
        prefixUpdateStatus: PrefixUpdateStatus.starting,

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
    final startupData = StartupData.instance;
    final utilityService = GetIt.I.get<UtilityService>();
    final runningSpecialExecutablesRepo = GetIt.I
        .get<RunningExecutablesRepo<SpecialExecutableSlot>>();
    final dxvkInstallationService = GetIt.I.get<DxvkInstallationService>();

    final oldPrefixDescriptor = prefix.descriptor;

    final wineInstallDir = oldPrefixDescriptor.getAbsPathToWineInstall(
      toplevelDataDir: startupData.localStoragePaths.toplevelDataDir,
    );

    try {
      final wineInstDescriptor = await utilityService
          .wineInstallationDescriptorForWineInstallDir(wineInstallDir);

      final dxvkWanted =
          state
              .explicitD3d8To11ImplementationState
              .explicitlySelectedD3d8To11Implementation ==
          D3d8To11Implementation.dxvk;

      final dxvkInstallationPlan = await dxvkInstallationService
          .buildDxvkInstallationPlan(
            dxvkWanted: dxvkWanted,
            localStoragePaths: startupData.localStoragePaths,
            wineInstDescriptor: wineInstDescriptor,
          );

      if (dxvkInstallationPlan.needDownloadAndExtract) {
        emit(
          state.copyWith(
            prefixUpdateStatus: PrefixUpdateStatus.downloadingAndExtractingDxvk,
            prefixUpdateStepProgressGetter: () => null,
          ),
        );

        final dxvkExtractionTempDir = await Directory(
          startupData.localStoragePaths.tempDir,
        ).createTemp('dxvk-extraction-');

        await dxvkInstallationPlan.downloadAndExtract(
          tempExtractionDir: dxvkExtractionTempDir,
          progressCallback: _updateDownloadAndExtractionProgress,
        );
      }

      emit(
        state.copyWith(
          prefixUpdateStatus: PrefixUpdateStatus.updatingPrefix,
          prefixUpdateStepProgressGetter: () => null,
        ),
      );

      // Update the prefix early, as we want the "wine reg"
      // command that runs under the hood of _applyHiDpiSettings()
      // below to take the current value of state.wow64ModePreferred
      // into account. Should prefix creation fail, we restore the
      // original descriptor at the end of this method.
      prefix.updateDescriptor(
        oldPrefixDescriptor.copyWith(
          hiDpiScaleGetter: () => state.hiDpiScale,
          wow64ModePreferredGetter: () => state.wow64ModePreferred,
          d3d8To11ImplementationGetter: () => state
              .explicitD3d8To11ImplementationState
              .explicitlySelectedD3d8To11Implementation,
          explicitLocalePosixNameGetter: () =>
              state.explicitLocaleState.explicitLocalePosixName,
        ),
      );

      final wineTasks = WineTasks.instance;

      await wineTasks.setHiDpiScale(
        hiDpiScale: state.hiDpiScale!,
        winePrefix: prefix,
        wineInstDescriptor: wineInstDescriptor,
        runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
        specialExecutableSlot: _specialExecutableSlot,
      );

      if (dxvkInstallationPlan.needInstall) {
        await dxvkInstallationPlan.install(
          prefixDirStructure: prefix.dirStructure,
        );
      }

      if (dxvkInstallationPlan.needActivate) {
        await dxvkInstallationPlan.activate(
          startupData: startupData,
          winePrefix: prefix,
          runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
          specialExecutableSlot: _specialExecutableSlot,
        );
      }

      if (prefix.descriptor.d3d8To11Implementation !=
          D3d8To11Implementation.dxvk) {
        // Calling clearDxvkDllOverrides() is necessary when WineD3D is
        // now selected (not strictly necessary for GE Proton, but it will
        // undo the effects of installing DXVK through Winetricks).
        // As for the case of no particular D3D 8-11 implementation
        // being selected, we treat that as letting the given Wine build
        // use its default settings. So, for non GE Proton builds, it's
        // neccessary to call clearDxvkDllOverrides(), while for GE Proton
        // builds it doesn't hurt.
        await wineTasks.clearDxvkDllOverrides(
          startupData: startupData,
          winePrefix: prefix,
          wineInstDescriptor: wineInstDescriptor,
          runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
          specialExecutableSlot: _specialExecutableSlot,
        );
      }

      // Write a new prefix.json file.
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

      if (prefix.descriptor != oldPrefixDescriptor) {
        // Put back the original descriptor.
        prefix.updateDescriptor(oldPrefixDescriptor);
      }

      rethrow;
    }
  }

  void _updateDownloadAndExtractionProgress(int bytesRead, int? bytesTotal) {
    if (bytesTotal != null) {
      final progress = bytesRead / bytesTotal;
      emit(state.copyWith(prefixUpdateStepProgressGetter: () => progress));
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
