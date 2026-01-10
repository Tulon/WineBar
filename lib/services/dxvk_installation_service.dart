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

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/exceptions/generic_exception.dart';
import 'package:winebar/models/dxvk_build.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/download_and_extraction_service.dart';
import 'package:winebar/utils/get_single_child_dir.dart';
import 'package:winebar/utils/local_storage_paths.dart';
import 'package:winebar/utils/recursive_delete_and_log_errors.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';
import 'package:winebar/utils/wine_tasks.dart';

abstract interface class DxvkInstallationService {
  /// Asynchronously returns a plan for installing DXVK onto a newly created
  /// or a pre-existing Wine prefix.
  ///
  /// A plan may be a no-op plan, where no actions are to be performed.
  /// That will be the case when [dxvkWanted] is set to false or when
  /// the Wine build in question is a GE Proton one, that bundles and
  /// automatically installs a DXVK build on its own.
  Future<DxvkInstallationPlan> buildDxvkInstallationPlan({
    required bool dxvkWanted,
    required LocalStoragePaths localStoragePaths,
    required WineInstallationDescriptor wineInstDescriptor,
  });

  factory DxvkInstallationService() {
    return _DxvkInstallationService();
  }
}

abstract interface class DxvkInstallationPlan {
  bool get needDownloadAndExtract;
  bool get needInstall;
  bool get needActivate;

  /// Downloads and extracts a DXVK build.
  ///
  /// When this function completes successfully, the
  ///
  /// If [needDownloadAndExtract] is false, the returned future will
  /// complete with an exception.
  ///
  /// The [tempExtractionDir] has to exist already and will be deleted
  /// by this function, whether or not it succeeds.
  ///
  /// If [cancelHookReceiver] is provided, it will be called before the
  /// download starts and passed a function that may be used to cancel
  /// the download and extraction operation.
  Future<DownloadAndExtractionOutcome> downloadAndExtract({
    required Directory tempExtractionDir,
    void Function(void Function() cancel)? cancelHookReceiver,
    DownloadAndExtractionProgressCallback? progressCallback,
  });

  /// Installs DXVK into the specified Wine prefix.
  ///
  /// If [needInstall] is false or if [downloadAndExtract] was prescribed
  /// but never called, the returned future will complete with an error.
  Future<void> install({required WinePrefixDirStructure prefixDirStructure});

  /// Activates the already-installed DXVK in the specified Wine prefix.
  ///
  /// If [needActivate] is false or if [downloadAndExtract] / [install]
  /// were prescribed but never called, the returned future will complete
  /// with an error.
  ///
  /// This function delegates to [WineTasks.setupDxvkDllOverrides].
  Future<void> activate({
    void Function(void Function() cancel)? cancelHookReceiver,
    required StartupData startupData,
    required WinePrefix winePrefix,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  });
}

class _DxvkInstallationService implements DxvkInstallationService {
  @override
  Future<DxvkInstallationPlan> buildDxvkInstallationPlan({
    required bool dxvkWanted,
    required LocalStoragePaths localStoragePaths,
    required WineInstallationDescriptor wineInstDescriptor,
  }) async {
    if (!dxvkWanted) {
      // The client doesn't even want DXVK to be installed.
      return _NoOpDxvkInstallationPlan();
    }

    if (wineInstDescriptor.hasBundledDxvk) {
      // A bundled DXVK is installed automatically, so we don't have
      // to do anything.
      return _NoOpDxvkInstallationPlan();
    }

    // Even if we've already installed DXVK into this prefix, it's best
    // to do that again. The DXVK installation package is going to be
    // cached, so installation is going to be pretty quick.
    const needInstall = true;

    // As for activating, we definitely need that.
    const needActivate = true;

    final dxvkBuild = DxvkBuild.recommendedBuild;

    final dxvkPackageDir = Directory(
      localStoragePaths.getDxvkPackageDir(dxvkBuild: dxvkBuild),
    );

    final needDownloadAndExtract = !await dxvkPackageDir.exists();

    return _DxvkInstallationPlan(
      needDownloadAndExtract: needDownloadAndExtract,
      needInstall: needInstall,
      needActivate: needActivate,
      wineInstDescriptor: wineInstDescriptor,
      dxvkBuild: dxvkBuild,
      dxvkPackageDir: dxvkPackageDir,
    );
  }
}

abstract mixin class _DxvkInstallationPlanValidator {
  bool get needDownloadAndExtract;
  bool get needInstall;
  bool get needActivate;

  bool get downloadAndExtractionFinishedSuccessfully;
  bool get installFinishedSuccessfully;

  @protected
  Never throwDownloadAndExtractionNotAllowedError() {
    throw GenericException(
      '[DxvkInstallationPlan] downloadAndExtract() called despite '
      'needDownloadAndExtract being false',
    );
  }

  @protected
  Never throwInstallationNotAllowedError() {
    throw GenericException(
      '[DxvkInstallationPlan] install() called despite '
      'needInstall being false',
    );
  }

  @protected
  Never throwActivationNotAllowedError() {
    throw GenericException(
      '[DxvkInstallationPlan] activate() called despite '
      'needActivate being false',
    );
  }

  @protected
  void verifyDownloadAndExtractionAllowedNow() {
    if (!needDownloadAndExtract) {
      throwDownloadAndExtractionNotAllowedError();
    }
  }

  @protected
  void verifyInstallationAllowedNow() {
    if (!needInstall) {
      throwInstallationNotAllowedError();
    }

    _verifyDownloadAndExtractionDependencySatisfiedBeforeInstallation();
  }

  @protected
  void verifyActivationAllowedNow() {
    if (!needActivate) {
      throwActivationNotAllowedError();
    }

    _verifyInstallationDependencySatisfiedBeforeActivation();
  }

  void _verifyDownloadAndExtractionDependencySatisfiedBeforeInstallation() {
    if (needDownloadAndExtract && !downloadAndExtractionFinishedSuccessfully) {
      throw GenericException(
        '[DxvkInstallationPlan] install() called before '
        'downloadAndExtract() was called or before it finished successfully',
      );
    }
  }

  void _verifyInstallationDependencySatisfiedBeforeActivation() {
    if (needInstall && !installFinishedSuccessfully) {
      throw GenericException(
        '[DxvkInstallationPlan] activate() called before '
        'install() was called or before it finished successfully',
      );
    }
  }
}

class _NoOpDxvkInstallationPlan extends DxvkInstallationPlan
    with _DxvkInstallationPlanValidator {
  @override
  bool get needDownloadAndExtract => false;

  @override
  bool get needInstall => false;

  @override
  bool get needActivate => false;

  @override
  bool get downloadAndExtractionFinishedSuccessfully => false;

  @override
  bool get installFinishedSuccessfully => false;

  @override
  Future<DownloadAndExtractionOutcome> downloadAndExtract({
    required Directory tempExtractionDir,
    void Function(void Function() cancel)? cancelHookReceiver,
    DownloadAndExtractionProgressCallback? progressCallback,
  }) async {
    throwDownloadAndExtractionNotAllowedError();
  }

  @override
  Future<void> install({
    required WinePrefixDirStructure prefixDirStructure,
  }) async {
    throwInstallationNotAllowedError();
  }

  @override
  Future<void> activate({
    void Function(void Function() cancel)? cancelHookReceiver,
    required StartupData startupData,
    required WinePrefix winePrefix,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  }) async {
    throwActivationNotAllowedError();
  }
}

class _DxvkInstallationPlan extends DxvkInstallationPlan
    with _DxvkInstallationPlanValidator {
  @override
  final bool needDownloadAndExtract;

  @override
  final bool needInstall;

  @override
  final bool needActivate;

  @override
  bool downloadAndExtractionFinishedSuccessfully = false;

  @override
  bool installFinishedSuccessfully = false;

  final WineInstallationDescriptor wineInstDescriptor;
  final DxvkBuild dxvkBuild;
  final Directory dxvkPackageDir;

  _DxvkInstallationPlan({
    required this.needDownloadAndExtract,
    required this.needInstall,
    required this.needActivate,
    required this.wineInstDescriptor,
    required this.dxvkBuild,
    required this.dxvkPackageDir,
  });

  @override
  Future<DownloadAndExtractionOutcome> downloadAndExtract({
    required Directory tempExtractionDir,
    void Function(void Function() cancel)? cancelHookReceiver,
    DownloadAndExtractionProgressCallback? progressCallback,
  }) async {
    try {
      verifyDownloadAndExtractionAllowedNow();

      final downloadAndExtractionService = GetIt.I
          .get<DownloadAndExtractionService>();

      final downloadAndExtractionProcess = await downloadAndExtractionService
          .startDownloadAndExtractionProcess(
            archiveUri: Uri.parse(dxvkBuild.downloadUrl),
            archiveType: dxvkBuild.archiveType,
            extractionDir: tempExtractionDir.path,
            progressCallback: progressCallback,
          );

      if (cancelHookReceiver != null) {
        cancelHookReceiver(downloadAndExtractionProcess.cancel);
      }

      final downloadAndExtractionOutcome =
          await downloadAndExtractionProcess.completionFuture;

      switch (downloadAndExtractionOutcome) {
        case DownloadAndExtractionOutcome.succeeded:
          final singleChildDir = await getSingleChildDir(tempExtractionDir);
          await (singleChildDir ?? tempExtractionDir).rename(
            dxvkPackageDir.path,
          );
          downloadAndExtractionFinishedSuccessfully = true;
        case DownloadAndExtractionOutcome.cancelled:
          break;
      }

      return downloadAndExtractionOutcome;
    } finally {
      await recursiveDeleteAndLogErrors(tempExtractionDir);
    }
  }

  @override
  Future<void> install({
    required WinePrefixDirStructure prefixDirStructure,
  }) async {
    verifyInstallationAllowedNow();

    final dxvkX32Dir = Directory(path.join(dxvkPackageDir.path, 'x32'));
    final dxvkX64Dir = Directory(path.join(dxvkPackageDir.path, 'x64'));

    if (!await dxvkX32Dir.exists() || !await dxvkX64Dir.exists()) {
      // The package is broken. Let's remove it from persistent storage then.
      // Otherwise, this error will keep repeating.
      await recursiveDeleteAndLogErrors(dxvkPackageDir);

      throw GenericException(
        'The DXVK package is missing the x32 or x64 subdirectory',
      );
    }

    final prefixDir = wineInstDescriptor.getInnermostPrefixDir(
      prefixDirStructure: prefixDirStructure,
    );
    final prefixWindowsDir = path.join(prefixDir, 'drive_c', 'windows');
    final prefixSystem32Dir = Directory(
      path.join(prefixWindowsDir, 'system32'),
    );
    final prefixSyswow64Dir = Directory(
      path.join(prefixWindowsDir, 'syswow64'),
    );

    Future<void> copyFilesFromTo(Directory from, Directory to) async {
      await for (final entity in from.list()) {
        if (entity is File) {
          await entity.copy(path.join(to.path, path.basename(entity.path)));
        }
      }
    }

    if (await prefixSyswow64Dir.exists()) {
      // We have a 64-bit wine prefix.
      await copyFilesFromTo(dxvkX64Dir, prefixSystem32Dir);
      await copyFilesFromTo(dxvkX32Dir, prefixSyswow64Dir);
    } else {
      // We have a 32-bit wine prefix.
      await copyFilesFromTo(dxvkX32Dir, prefixSystem32Dir);
    }

    installFinishedSuccessfully = true;
  }

  @override
  Future<void> activate({
    void Function(void Function() cancel)? cancelHookReceiver,
    required StartupData startupData,
    required WinePrefix winePrefix,
    required RunningExecutablesRepo<SpecialExecutableSlot>
    runningSpecialExecutablesRepo,
    required SpecialExecutableSlot specialExecutableSlot,
  }) async {
    verifyActivationAllowedNow();

    return WineTasks.instance.setupDxvkDllOverrides(
      startupData: startupData,
      winePrefix: winePrefix,
      wineInstDescriptor: wineInstDescriptor,
      runningSpecialExecutablesRepo: runningSpecialExecutablesRepo,
      specialExecutableSlot: specialExecutableSlot,
    );
  }
}
