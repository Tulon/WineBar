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

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/exceptions/wine_command_failed_exception.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/models/suppressable_warning.dart';
import 'package:winebar/models/wine_arch_warning.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/utils/get_single_child_dir.dart';
import 'package:winebar/utils/prefix_descriptor.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';
import 'package:winebar/utils/wine_tasks.dart';

import '../../exceptions/prefix_already_exists_exception.dart';
import '../../models/wine_build.dart';
import '../../models/wine_build_source.dart';
import '../../models/wine_prefix.dart';
import '../../models/wine_release.dart';
import '../../services/download_and_extraction_service.dart';
import 'prefix_creation_state.dart';

class PrefixCreationBloc extends Cubit<PrefixCreationState> {
  final logger = GetIt.I.get<Logger>();
  final StartupData startupData;
  final Set<SuppressableWarning> warningsSuppressedAtBlocCreationTime;

  @protected
  final void Function(WinePrefix) onPrefixCreated;

  CancelableOperation<List<WineRelease>>? _ongoingReleaseLoadingOp;

  PrefixCreationBloc({required this.startupData, required this.onPrefixCreated})
    : warningsSuppressedAtBlocCreationTime = GetIt.I
          .get<AppSettingsService>()
          .settings
          .suppressedWarnings,
      super(PrefixCreationState.defaultState());

  void navigateToStep(PrefixCreationStep step) {
    emit(state.copyWith(currentStep: step));
  }

  void selectWineBuildSource(WineBuildSource? source) {
    final currentStep = PrefixCreationStep.selectWineBuildSource;
    final nextStep = source == null
        ? currentStep
        : PrefixCreationStep.selectWineRelease;
    assert(currentStep == state.currentStep);

    _setWineBuildSource(source, nextStep: nextStep, refresh: false);
  }

  void refreshWineBuilds() {
    const currentStep = PrefixCreationStep.selectWineRelease;
    final nextStep = currentStep;
    assert(currentStep == state.currentStep);
    assert(state.selectedBuildSource != null);

    _setWineBuildSource(
      state.selectedBuildSource,
      nextStep: nextStep,
      refresh: true,
    );
  }

  void _setWineBuildSource(
    WineBuildSource? source, {
    required PrefixCreationStep nextStep,
    required bool refresh,
  }) async {
    if (state.selectedBuildSource != source || refresh) {
      await _cancelOngoingReleaseLoadingOp();
    } else {
      // If the source hasn't changed and we are not refreshing,
      // the only thing we need to do is to advance the current step,
      // unless the source is null, in which case we don't have to do
      // anything at all. Note that given the source hasn't changed,
      // we don't modify maxAccessibleStep, which may be further than
      // nextStep.
      if (source != null) {
        emit(state.copyWith(currentStep: nextStep));
      }
      return;
    }

    // If a build can't support both win64 and wow64 modes, then wow64Preferred
    // will be null. Otherwise, it will be true on Intel hosts only, as wow64
    // currently doesn't work under emulation.
    final bool? wow64ModePreferred =
        source != null && source.buildsMaySupportBothWin64AndWow64Modes
        ? startupData.isIntelHost
        : null;

    final wow64ModePreferenceWarning = wineArchWarningToShowForDualModeBuild(
      startupData: startupData,
      wow64ModeSelected: wow64ModePreferred,
    );

    emit(
      state.copyWith(
        currentStep: nextStep,
        maxAccessibleStep: nextStep,
        wineBuildsFetchingInProgress: source != null,
        wineBuildsFetchingErrorMessageGetter: () => null,
        selectedBuildSourceGetter: () => source,
        wineReleasesToSelectFrom: const [],
        selectedWineReleaseGetter: () => null,
        wineBuildsToSelectFrom: const [],
        selectedWineBuildGetter: () => null,
        selectedWineBuildArchWarningGetter: () => null,
        selectedWineBuildArchWarningToBeSuppressed: false,
        wow64ModePreferredGetter: () => wow64ModePreferred,
        wow64ModePreferenceWarningGetter: () => wow64ModePreferenceWarning,
        wow64ModePreferenceWarningToBeSuppressed: false,
        prefixCreationStatus: PrefixCreationStatus.notStarted,
        prefixCreationFailureMessageGetter: () => null,
        prefixCreationFailedProcessResultGetter: () => null,
      ),
    );

    if (source == null) {
      return;
    }

    _ongoingReleaseLoadingOp = CancelableOperation.fromFuture(
      source.getAvailableReleases(refresh: refresh),
    );

    var wineReleasesToSelectFrom = <WineRelease>[];
    String? wineBuildsFetchingErrorMessage;

    try {
      wineReleasesToSelectFrom = await _ongoingReleaseLoadingOp!.value;
    } catch (e) {
      wineBuildsFetchingErrorMessage = e.toString();
    } finally {
      _ongoingReleaseLoadingOp = null;
      emit(
        state.copyWith(
          wineBuildsFetchingInProgress: false,
          wineBuildsFetchingErrorMessageGetter: () =>
              wineBuildsFetchingErrorMessage,
          wineReleasesToSelectFrom: wineReleasesToSelectFrom,
        ),
      );
    }
  }

  void selectWineRelease(WineRelease? release) {
    const currentStep = PrefixCreationStep.selectWineRelease;
    final nextStep = release == null
        ? currentStep
        : PrefixCreationStep.selectWineBuild;
    assert(currentStep == state.currentStep);

    if (state.selectedWineRelease == release) {
      // If the release hasn't changed, the only thing we need to do is to
      // advance the current step, unless the release is null, in which case
      // we don't have to do anything at all. Note that given the release
      // hasn't changed, we don't modify maxAccessibleStep, which may be
      // further than nextStep.
      if (release != null) {
        emit(state.copyWith(currentStep: nextStep));
      }
      return;
    }

    emit(
      state.copyWith(
        currentStep: nextStep,
        maxAccessibleStep: nextStep,
        selectedWineReleaseGetter: () => release,
        wineBuildsToSelectFrom: release?.builds ?? [],
        selectedWineBuildGetter: () => null,
        selectedWineBuildArchWarningGetter: () => null,
        selectedWineBuildArchWarningToBeSuppressed: false,
        prefixCreationStatus: PrefixCreationStatus.notStarted,
        prefixCreationFailureMessageGetter: () => null,
        prefixCreationFailedProcessResultGetter: () => null,
      ),
    );
  }

  void selectWineBuild(WineBuild? build) {
    const currentStep = PrefixCreationStep.selectWineBuild;
    assert(currentStep == state.currentStep);

    PrefixCreationStep nextStep = build == null
        ? currentStep
        : PrefixCreationStep.setOptions;

    final selectedWineBuildArchWarning = _wineArchWarningToShowForSelectedBuild(
      build,
    );

    if (selectedWineBuildArchWarning != null) {
      nextStep = currentStep;
    }

    if (state.selectedWineBuild == build &&
        selectedWineBuildArchWarning == null) {
      // If the build hasn't changed, the only thing we need to do is to
      // advance the current step, unless the build is null, in which case
      // we don't have to do anything at all. Note that given the build
      // hasn't changed, we don't modify maxAccessibleStep, which may be
      // further than nextStep.
      if (build != null) {
        emit(state.copyWith(currentStep: nextStep));
      }
      return;
    }

    emit(
      state.copyWith(
        currentStep: nextStep,
        maxAccessibleStep: nextStep,
        selectedWineBuildGetter: () => build,
        selectedWineBuildArchWarningGetter: () => selectedWineBuildArchWarning,
        selectedWineBuildArchWarningToBeSuppressed: false,
        prefixCreationStatus: PrefixCreationStatus.notStarted,
        prefixCreationFailureMessageGetter: () => null,
        prefixCreationFailedProcessResultGetter: () => null,
      ),
    );
  }

  WineArchWarning? _wineArchWarningToShowForSelectedBuild(
    WineBuild? selectedBuild,
  ) {
    WineArchWarning? warningToShow;

    void setWarningUnlessSuppressed(WineArchWarning warning) {
      // Q: Why are we checking the suppression state at the bloc creation
      //    time and not the current suppression state?
      // A: First of all, note the warning in question is suppressed when
      //    the 'Proceed Anyway' button is pressed on the wine build
      //    selection page. Now, consider the following sequence of events:
      //
      //    1. The user presses 'Proceed Anyway' and the warning is
      //       suppressed. The user is automatically taken to the next page.
      //    2. The user returns to the previous page. The user would expect
      //       the previous page to look exactly like when they left it,
      //       including the presense of the warning and the checkbox to
      //       suppress it in the future.
      //
      //    Checking the suppression state at the bloc creation time achieves
      //    the desired result.
      if (!warningsSuppressedAtBlocCreationTime.contains(
        warning.suppressableWarning,
      )) {
        warningToShow = warning;
      }
    }

    if (selectedBuild != null &&
        selectedBuild.hasWow64InName &&
        !startupData.isIntelHost) {
      setWarningUnlessSuppressed(WineArchWarning.wow64ModeUnderEmulation);
    } else if (selectedBuild != null &&
        !selectedBuild.hasWow64InName &&
        !state.selectedBuildSource!.buildsMaySupportBothWin64AndWow64Modes) {
      setWarningUnlessSuppressed(WineArchWarning.nonWow64ModesRequire32BitLibs);
    }

    return warningToShow;
  }

  void setSelectedWineBuildArchWarningToBeSuppressed(bool toBeSuppressed) {
    if (state.selectedWineBuildArchWarningToBeSuppressed == toBeSuppressed) {
      return;
    }

    emit(
      state.copyWith(
        selectedWineBuildArchWarningToBeSuppressed: toBeSuppressed,
      ),
    );
  }

  void proceedAnywayWithSelectedBuild() {
    const currentStep = PrefixCreationStep.selectWineBuild;
    assert(currentStep == state.currentStep);
    assert(state.selectedWineBuild != null);
    assert(state.selectedWineBuildArchWarning != null);

    final PrefixCreationStep nextStep = PrefixCreationStep.setOptions;

    emit(
      state.copyWith(
        currentStep: nextStep,
        maxAccessibleStep: laterPrefixCreatonStepOfTwo(
          nextStep,
          state.maxAccessibleStep,
        ),
        prefixCreationStatus: PrefixCreationStatus.notStarted,
        prefixCreationFailureMessageGetter: () => null,
        prefixCreationFailedProcessResultGetter: () => null,
      ),
    );

    // Maybe suppress the warning raised for the selected build.
    final selectedBuildSuppressableWarning =
        state.selectedWineBuildArchWarning?.suppressableWarning;
    if (selectedBuildSuppressableWarning != null) {
      GetIt.I.get<AppSettingsService>().setWarningSuppressed(
        selectedBuildSuppressableWarning,
        suppressed: state.selectedWineBuildArchWarningToBeSuppressed,
      );
    }
  }

  static final _validPrefixPattern = RegExp(
    r'^[\p{Letter}\p{Mark}\p{Number}\p{Punctuation} ]+$',
    unicode: true,
  );

  void setPrefixName(String prefixName) {
    String? errorMessage;

    if (prefixName.isEmpty) {
      errorMessage = "Prefix name can't be empty";
    } else if (!_validPrefixPattern.hasMatch(prefixName) ||
        prefixName.contains('/') ||
        prefixName.contains('\\')) {
      errorMessage = 'Illegal symbols present';
    }

    if (state.prefixName != prefixName ||
        state.prefixNameErrorMessage != errorMessage) {
      emit(
        state.copyWith(
          prefixName: prefixName,
          prefixNameErrorMessageGetter: () => errorMessage,
        ),
      );
    }
  }

  void setHiDpiScale(double scaleFactor) {
    emit(state.copyWith(hiDpiScale: scaleFactor));
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

  void startCreatingPrefix() {
    assert(!state.prefixCreationStatus.isInProgress);

    emit(state.copyWith(prefixCreationFailureMessageGetter: () => null));

    unawaited(
      _createPrefix().then(
        (prefix) => _processPrefixCreated(prefix),
        onError: _processPrefixCreationFailure,
      ),
    );
  }

  Future<WinePrefix> _createPrefix() async {
    final prefixDirStructure = startupData.localStoragePaths
        .getWinePrefixDirStructure(prefixName: state.prefixName);

    if (await Directory(prefixDirStructure.outerDir).exists()) {
      throw PrefixAlreadyExistsException(prefixName: state.prefixName);
    }

    final wineInstallDir = Directory(
      startupData.localStoragePaths.getWineInstallDir(
        wineBuildSource: state.selectedBuildSource!,
        wineRelease: state.selectedWineRelease!,
        wineBuild: state.selectedWineBuild!,
      ),
    );

    final toplevelTempDir = Directory(startupData.localStoragePaths.tempDir);
    final prefixCreationTempDir = await toplevelTempDir.createTemp(
      'prefix-creation-',
    );

    try {
      if (!await wineInstallDir.exists()) {
        await _downloadAndUnpackSelectedWineBuild(
          wineInstallDir: wineInstallDir,
          prefixCreationTempDir: prefixCreationTempDir,
        );
      }

      emit(
        state.copyWith(
          prefixCreationStatus: PrefixCreationStatus.creatingWinePrefix,
          prefixCreationOperationProgressGetter: () => null,
          prefixCreationFailedProcessResultGetter: () => null,
        ),
      );

      final utilityService = GetIt.I.get<UtilityService>();

      final wineInstDescriptor = await utilityService
          .wineInstallationDescriptorForWineInstallDir(wineInstallDir.path);

      await Directory(prefixDirStructure.innerDir).create(recursive: true);

      final relWineInstallPath = path.relative(
        wineInstallDir.path,
        from: startupData.localStoragePaths.toplevelDataDir,
      );

      final prefixDescriptor = PrefixDescriptor(
        name: state.prefixName,
        relPathToWineInstall: relWineInstallPath,
        hiDpiScale: state.hiDpiScale,
        wow64ModePreferred: state.wow64ModePreferred,
      );

      final winePrefix = WinePrefix(
        dirStructure: prefixDirStructure,
        descriptor: prefixDescriptor,
      );

      final runningSpecialExecutablesRepo = GetIt.I
          .get<RunningExecutablesRepo<SpecialExecutableSlot>>();

      // Plain Wine installations (doesn't apply to Proton ones) show GUI
      // dialogs at prefix creation time. Ideally, we want our HiDPI settings
      // to apply to those dialogs as well. To set the HiDPI settings in a proper
      // way, we have to have a prefix already created, which creates a chicken
      // and egg situation. This method applies those settings in a hacky way,
      // without the need to hace a prefix already created. Below, we apply
      // them again the proper way, just in case.
      await _preApplyHiDpiSettings(
        wineInstDescriptor: wineInstDescriptor,
        prefixDirStructure: prefixDirStructure,
      );

      // Populate the prefix directory.
      await _initializeWinePrefix(
        winePrefix: winePrefix,
        wineInstDescriptor: wineInstDescriptor,
        runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      );

      // This time, apply the HiDPI settings the proper way.
      await _applyHiDpiSettings(
        winePrefix: winePrefix,
        wineInstDescriptor: wineInstDescriptor,
        runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      );

      // See the documentation for [WineInstallationDescriptor.needsHomeIsolation]
      // for more info.
      if (wineInstDescriptor.needsHomeIsolation) {
        await _isolateHome(
          wineInstDescriptor: wineInstDescriptor,
          prefixDirStructure: prefixDirStructure,
        );
      }

      await File(
        prefixDirStructure.prefixJsonFilePath,
      ).writeAsString(prefixDescriptor.toJsonString());

      // Maybe suppress the warning related to the wow64 preference toggle.
      final wow64PreferenceSuppressableWarning =
          state.wow64ModePreferenceWarning?.suppressableWarning;
      if (wow64PreferenceSuppressableWarning != null) {
        GetIt.I.get<AppSettingsService>().setWarningSuppressed(
          wow64PreferenceSuppressableWarning,
          suppressed: state.wow64ModePreferenceWarningToBeSuppressed,
        );
      }

      return winePrefix;
    } catch (e, stackTrace) {
      logger.e('Prefix creation failed', error: e, stackTrace: stackTrace);
      await recursiveDeleteAndLogErrors(Directory(prefixDirStructure.outerDir));
      rethrow;
    } finally {
      await recursiveDeleteAndLogErrors(prefixCreationTempDir);
    }
  }

  Future<void> _downloadAndUnpackSelectedWineBuild({
    required Directory wineInstallDir,
    required Directory prefixCreationTempDir,
  }) async {
    // We create the parent directory early, in case the download
    // fails for one reason or another, giving the user an opportunity
    // to download and unpack the archive manually.
    // This operation does nothing if the directory exists already.
    await wineInstallDir.parent.create(recursive: true);

    final extractionDir = await prefixCreationTempDir.createTemp(
      'wine-build-extraction-',
    );

    emit(
      state.copyWith(
        prefixCreationStatus:
            PrefixCreationStatus.downloadingAndExtractingWineBuild,
        prefixCreationOperationProgressGetter: () => null,
        prefixCreationFailedProcessResultGetter: () => null,
      ),
    );

    final downloadAndExtractionService = GetIt.I
        .get<DownloadAndExtractionService>();

    final downloadUrl = state.selectedWineBuild!.downloadUrl;

    final downloadAndExtractionProcess = await downloadAndExtractionService
        .startDownloadAndExtractionProcess(
          archiveUri: Uri.parse(downloadUrl),
          archiveType: state.selectedWineBuild!.archiveType,
          extractionDir: extractionDir.path,
          progressCallback: _updateDownloadAndExtractionProgress,
        );

    await downloadAndExtractionProcess.completionFuture;

    final singleChildDir = await getSingleChildDir(extractionDir);
    await (singleChildDir ?? extractionDir).rename(wineInstallDir.path);
  }

  void _updateDownloadAndExtractionProgress(int bytesRead, int? bytesTotal) {
    if (bytesTotal != null) {
      final progress = bytesRead / bytesTotal;
      emit(
        state.copyWith(prefixCreationOperationProgressGetter: () => progress),
      );
    }
  }

  Future<void> _initializeWinePrefix({
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
  }) async {
    final process = await startTaskOfPrefixInitialization(
      startupData: startupData,
      winePrefix: winePrefix,
      wineInstDescriptor: wineInstDescriptor,
      runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      specialExecutableSlot: SpecialExecutableSlot.prefixCreationTask,
    );

    final processResult = await process.result;

    if (processResult.exitCode != 0) {
      throw WineCommandFailedException(
        'The "wineboot -u" command failed',
        processResult: processResult,
      );
    }
  }

  /// The DPI of 96 corresponds to a scale of 1 in Windows.
  int get _logPixels => (state.hiDpiScale * 96).round();

  Future<void> _preApplyHiDpiSettings({
    required WineInstallationDescriptor wineInstDescriptor,
    required WinePrefixDirStructure prefixDirStructure,
  }) async {
    // Below we apply the HiDPI settings in a hacky way that doesn't require
    // having a prefix already created. We put a hand-crafted user.reg file
    // where Wine would create one by itself. That way, Wine thinks we are
    // upgrading an existing prefix and applies the settings from that .reg
    // file to the GUI dialogs it shows at startup.

    if (state.hiDpiScale == 1.0) {
      // That's the default so we can skip this step and avoid an extra
      // 'Wine is upating this prefix' dialog that way.
      return;
    }

    final logPixelsHex = _logPixels.toRadixString(16).padLeft(8, '0');

    final initialUserRegContents =
        'WINE REGISTRY Version 2\n'
        '\n'
        '[Control Panel\\\\Desktop]\n'
        '"LogPixels"=dword:$logPixelsHex"';

    final innermostPrefixDir = wineInstDescriptor.getInnermostPrefixDir(
      prefixDirStructure: prefixDirStructure,
    );

    await Directory(innermostPrefixDir).create(recursive: true);

    await File(
      path.join(innermostPrefixDir, 'user.reg'),
    ).writeAsString(initialUserRegContents);
  }

  Future<void> _applyHiDpiSettings({
    required WinePrefix winePrefix,
    required WineInstallationDescriptor wineInstDescriptor,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
  }) async {
    final process = await startTaskOfSettingHiDpiScale(
      hiDpiScale: state.hiDpiScale,
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

  Future<void> _isolateHome({
    required WineInstallationDescriptor wineInstDescriptor,
    required WinePrefixDirStructure prefixDirStructure,
  }) async {
    // In principle, we could use the winetricks isolate_home command, but:
    //
    // 1. What if winetricks fails to download?
    // 2. That command turns out to be quite slow under muvm.
    //
    // So, we do this task manually.

    void logIsolationIncompleteError(Object error, StackTrace stackTrace) {
      logger.e(
        'Error while isolating the home directory. '
        'Isolation may be incomplete as a result.',
        error: error,
        stackTrace: stackTrace,
      );
    }

    final homeDir = startupData.localStoragePaths.homeDir;
    final prefixDir = wineInstDescriptor.getInnermostPrefixDir(
      prefixDirStructure: prefixDirStructure,
    );

    final linksToTurnIntoDirs = <Link>[];

    final streamOfEntities = Directory(
      prefixDir,
    ).list(recursive: true, followLinks: false);

    await for (final entity in streamOfEntities) {
      try {
        if (entity is Link) {
          final linkTarget = await entity.target();
          if (!path.isWithin(prefixDir, linkTarget)) {
            if (path.isWithin(homeDir, linkTarget)) {
              final linkTargetType = await FileSystemEntity.type(linkTarget);
              if (linkTargetType == FileSystemEntityType.directory) {
                linksToTurnIntoDirs.add(entity);
              }
            }
          }
        }
      } catch (e, stackTrace) {
        logIsolationIncompleteError(e, stackTrace);
      }
    }

    for (final link in linksToTurnIntoDirs) {
      try {
        await link.delete();
        await Directory(link.path).create();
      } catch (e, stackTrace) {
        logIsolationIncompleteError(e, stackTrace);
      }
    }
  }

  void _processPrefixCreated(WinePrefix prefix) {
    emit(
      state.copyWith(
        prefixCreationStatus: PrefixCreationStatus.succeeded,
        prefixCreationFailureMessageGetter: () => null,
        prefixCreationFailedProcessResultGetter: () => null,
      ),
    );

    onPrefixCreated(prefix);
  }

  void _processPrefixCreationFailure(Object error) {
    final processResult = error is WineCommandFailedException
        ? error.processResult
        : null;

    emit(
      state.copyWith(
        prefixCreationStatus: PrefixCreationStatus.failed,
        prefixCreationFailureMessageGetter: () => error.toString(),
        prefixCreationFailedProcessResultGetter: () => processResult,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _cancelOngoingReleaseLoadingOp();
    return super.close();
  }

  Future<void> _cancelOngoingReleaseLoadingOp() async {
    if (_ongoingReleaseLoadingOp != null) {
      await _ongoingReleaseLoadingOp!.cancel();
      _ongoingReleaseLoadingOp = null;
    }
  }
}
