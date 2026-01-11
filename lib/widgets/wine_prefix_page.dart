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

import 'package:boxy/padding.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:winebar/blocs/pinned_executable_set/pinned_executable_set_bloc.dart';
import 'package:winebar/blocs/special_executable/special_executable_bloc.dart';
import 'package:winebar/blocs/special_executable/special_executable_state.dart';
import 'package:winebar/models/pinned_executable_list_event.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/utils/maybe_tell_user_to_finish_running_apps.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/widgets/bouncing_widget.dart';
import 'package:winebar/widgets/pin_executable_button.dart';
import 'package:winebar/widgets/pinned_executable_widget.dart';
import 'package:winebar/widgets/prefix_settings_dialog.dart';
import 'package:winebar/widgets/run_process_chip.dart';

import '../blocs/pinned_executable_set/pinned_executable_set_state.dart';
import '../blocs/prefix_details/prefix_details_bloc.dart';
import '../blocs/prefix_details/prefix_details_state.dart';
import '../models/wine_prefix.dart';
import 'process_logs_view_widget.dart';

class WinePrefixPage extends StatelessWidget {
  final StartupData startupData;
  final void Function(WinePrefix) onPrefixUpdated;

  /// This member is used only to initialize the PrefixDetailsBloc.
  /// The wine prefix in the bloc may later change as a result of
  /// the user updating a prefix. The initial value won't change.
  final WinePrefix initialPrefix;

  /// This member is used only to initialize the PinnedExecutableSetBloc.
  /// The set of pinned executables may change later but this value
  /// won't change.
  final PinnedExecutableSetState initialPinnedExecutables;

  const WinePrefixPage({
    super.key,
    required this.startupData,
    required this.onPrefixUpdated,
    required this.initialPrefix,
    required this.initialPinnedExecutables,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider<PrefixDetailsBloc>(
          create: (context) => PrefixDetailsBloc(prefix: initialPrefix),
        ),
        BlocProvider<PinnedExecutableSetBloc>(
          create: (context) => PinnedExecutableSetBloc(
            initialState: initialPinnedExecutables,
            startupData: startupData,
          ),
        ),
      ],
      child: BlocBuilder<PrefixDetailsBloc, PrefixDetailsState>(
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<CustomExecutableBloc>(
                // We provide a key in order to force the bloc to be recreated
                // when the prefix is modified.
                key: ValueKey(state.prefix),

                create: (context) => CustomExecutableBloc(
                  startupData: startupData,
                  winePrefix: state.prefix,
                ),
              ),
              BlocProvider<RunInstallerBloc>(
                // We provide a key in order to force the bloc to be recreated
                // when the prefix is modified.
                key: ValueKey(state.prefix),

                create: (context) => RunInstallerBloc(
                  startupData: startupData,
                  winePrefix: state.prefix,
                  processExecutablePinnedInTempDir:
                      (executablePinnedInTempDir) =>
                          BlocProvider.of<PinnedExecutableSetBloc>(
                            context,
                          ).pinExecutable(executablePinnedInTempDir),
                ),
              ),
              BlocProvider<WinecfgExecutableBloc>(
                // We provide a key in order to force the bloc to be recreated
                // when the prefix is modified.
                key: ValueKey(state.prefix),

                create: (context) => WinecfgExecutableBloc(
                  startupData: startupData,
                  winePrefix: state.prefix,
                ),
              ),
              BlocProvider<WinetricksExecutableBloc>(
                // We provide a key in order to force the bloc to be recreated
                // when the prefix is modified.
                key: ValueKey(state.prefix),

                create: (context) => WinetricksExecutableBloc(
                  startupData: startupData,
                  winePrefix: state.prefix,
                ),
              ),
            ],
            child: Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: colorScheme.inversePrimary,
                    title: Text(
                      'Wine Prefix: ${state.prefix.descriptor.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  body: _PinnedExecutablesGridWidget(
                    startupData: startupData,
                    winePrefix: state.prefix,
                  ),
                  bottomNavigationBar: _buildBottomPanel(
                    context: context,
                    state: state,
                    colorScheme: colorScheme,
                  ),
                  floatingActionButton: _buildPinExecutableButton(
                    prefix: state.prefix,
                  ),
                ),
                if (state.fileSelectionInProgress)
                  // Blocks all interactions.
                  ModalBarrier(
                    dismissible: false,
                    color: Colors
                        .black54, // Default barrier color for showDialog()
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomPanel({
    required BuildContext context,
    required PrefixDetailsState state,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: colorScheme.surfaceContainerHigh,
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                BlocBuilder<CustomExecutableBloc, SpecialExecutableState>(
                  builder: (context, state) =>
                      _buildRunCustomExecutableChip(context, state),
                ),
                BlocBuilder<RunInstallerBloc, SpecialExecutableState>(
                  builder: (context, state) =>
                      _buildRunInstallerChip(context, state),
                ),
                BlocBuilder<WinecfgExecutableBloc, SpecialExecutableState>(
                  builder: (context, state) =>
                      _buildWinecfgChip(context, state),
                ),
                BlocBuilder<WinetricksExecutableBloc, SpecialExecutableState>(
                  builder: (context, state) =>
                      _buildWinetricksGuiChip(context, state),
                ),
              ],
            ),
          ),
          OverflowPadding(
            // We apply a negative padding in order to avoid
            // enlarging the bottom panel.
            padding: EdgeInsets.symmetric(vertical: -8.0),
            child: IconButton.filledTonal(
              icon: Icon(MdiIcons.cogs),
              tooltip: 'Prefix settings',
              onPressed: () {
                _maybeShowPrefixSettingsDialog(context: context, state: state);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _maybeShowPrefixSettingsDialog({
    required BuildContext context,
    required PrefixDetailsState state,
  }) {
    final prefixDetailsBloc = BlocProvider.of<PrefixDetailsBloc>(context);

    if (maybeTellUserToFinishRunningApps(
      context: context,
      appsRunningInThisPrefixAreAProblem: state.prefix,
      appsRunningInAnyPrefixAreAProblem: startupData.wineWillRunUnderMuvm,
    )) {
      return;
    }

    void showPrefixUpdatedSnackBar() {
      const snackBar = SnackBar(content: Text('Wine prefix updated'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PrefixSettingsDialog(
          startupData: startupData,
          prefix: state.prefix,
          onPrefixUpdated: (prefix) {
            prefixDetailsBloc.updatePrefix(prefix);
            showPrefixUpdatedSnackBar();
            onPrefixUpdated(prefix);
          },
        ),
      ),
    );
  }

  Widget _buildPinExecutableButton({required WinePrefix prefix}) {
    Widget buildButton(BuildContext context, SpecialExecutableState state) {
      final bloc = BlocProvider.of<PinExecutableBloc>(context);

      void maybeSelectExecutableToPin() {
        if (maybeTellUserToFinishRunningApps(
          context: context,
          appsRunningInThisPrefixAreAProblem: prefix,
          appsRunningInAnyPrefixAreAProblem: startupData.wineWillRunUnderMuvm,
        )) {
          return;
        }

        unawaited(
          _selectSpecialExecutableToRun(
            context: context,
            specialExecutableBloc: bloc,
          ),
        );
      }

      return PinExecutableButton(
        specialExecutableState: state,
        onPrimaryButtonPressed: () => maybeSelectExecutableToPin(),
        onKillProcessPressed: () => bloc.killProcessIfRunning(),
        onViewLogsPressed: () =>
            _viewProcessLogs(context: context, specialExecutableState: state),
      );
    }

    return BlocProvider(
      // We provide a key in order to force the bloc to be recreated
      // when the prefix is modified.
      key: ValueKey(prefix),

      create: (context) => PinExecutableBloc(
        startupData: startupData,
        winePrefix: prefix,
        processExecutablePinnedInTempDir: (executablePinnedInTempDir) =>
            BlocProvider.of<PinnedExecutableSetBloc>(
              context,
            ).pinExecutable(executablePinnedInTempDir),
      ),
      child: BlocBuilder<PinExecutableBloc, SpecialExecutableState>(
        builder: (context, state) => buildButton(context, state),
      ),
    );
  }

  Widget _buildRunCustomExecutableChip(
    BuildContext context,
    SpecialExecutableState state,
  ) {
    final specialExecutableBloc = BlocProvider.of<CustomExecutableBloc>(
      context,
    );

    final icon = Icon(MdiIcons.rocketLaunch);

    return RunProcessChip(
      primaryButtonIcon: state.isRunning ? BouncingWidget(child: icon) : icon,
      primaryButtonLabel: const Text('Run Executable'),
      specialExecutableState: state,
      onPrimaryButtonPressed: () => _selectSpecialExecutableToRun(
        context: context,
        specialExecutableBloc: specialExecutableBloc,
      ),
      onKillProcessPressed: () => specialExecutableBloc.killProcessIfRunning(),
      onViewLogsPressed: () =>
          _viewProcessLogs(context: context, specialExecutableState: state),
    );
  }

  Widget _buildRunInstallerChip(
    BuildContext context,
    SpecialExecutableState state,
  ) {
    final specialExecutableBloc = BlocProvider.of<RunInstallerBloc>(context);

    final icon = Icon(MdiIcons.packageVariantClosedPlus);

    return RunProcessChip(
      primaryButtonIcon: state.isRunning ? BouncingWidget(child: icon) : icon,
      primaryButtonLabel: const Text('Run Installer'),
      specialExecutableState: state,
      onPrimaryButtonPressed: () => _selectSpecialExecutableToRun(
        context: context,
        specialExecutableBloc: specialExecutableBloc,
      ),
      onKillProcessPressed: () => specialExecutableBloc.killProcessIfRunning(),
      onViewLogsPressed: () =>
          _viewProcessLogs(context: context, specialExecutableState: state),
    );
  }

  Widget _buildWinecfgChip(BuildContext context, SpecialExecutableState state) {
    final specialExecutableBloc = BlocProvider.of<WinecfgExecutableBloc>(
      context,
    );

    final icon = Icon(MdiIcons.cog);

    return RunProcessChip(
      primaryButtonIcon: state.isRunning ? BouncingWidget(child: icon) : icon,
      primaryButtonLabel: const Text('Winecfg'),
      specialExecutableState: state,
      onPrimaryButtonPressed: () =>
          specialExecutableBloc.startProcess(['winecfg.exe']),
      onKillProcessPressed: () => specialExecutableBloc.killProcessIfRunning(),
      onViewLogsPressed: () =>
          _viewProcessLogs(context: context, specialExecutableState: state),
    );
  }

  Widget _buildWinetricksGuiChip(
    BuildContext context,
    SpecialExecutableState state,
  ) {
    final specialExecutableBloc = BlocProvider.of<WinetricksExecutableBloc>(
      context,
    );

    final icon = Icon(MdiIcons.hammerScrewdriver);

    return RunProcessChip(
      primaryButtonIcon: state.isRunning ? BouncingWidget(child: icon) : icon,
      primaryButtonLabel: const Text('Winetricks GUI'),
      specialExecutableState: state,
      onPrimaryButtonPressed: () =>
          specialExecutableBloc.startProcess(['--gui']),
      onKillProcessPressed: () => specialExecutableBloc.killProcessIfRunning(),
      onViewLogsPressed: () =>
          _viewProcessLogs(context: context, specialExecutableState: state),
    );
  }

  Future<void> _selectSpecialExecutableToRun({
    required BuildContext context,
    required SpecialExecutableBloc specialExecutableBloc,
  }) async {
    final utilityService = GetIt.I.get<UtilityService>();

    final prefixDetailsBloc = BlocProvider.of<PrefixDetailsBloc>(context);
    prefixDetailsBloc.setFileSelectionInProgress(true);

    FilePickerResult? filePickerResult;

    try {
      final WinePrefix prefix = prefixDetailsBloc.state.prefix;

      final wineInstDesc = await utilityService
          .wineInstallationDescriptorForWineInstallDir(
            prefix.descriptor.getAbsPathToWineInstall(
              toplevelDataDir: startupData.localStoragePaths.toplevelDataDir,
            ),
          );

      filePickerResult = await FilePicker.platform.pickFiles(
        initialDirectory: wineInstDesc.getInnermostPrefixDir(
          prefixDirStructure: prefix.dirStructure,
        ),
        type: FileType.custom,
        allowedExtensions: ['exe', 'msi', 'lnk'],

        // This doesn't work in Linux unfortunately, so we use a ModalBarrier
        // widget to block interactions while the file selection in in progress.
        lockParentWindow: true,
      );
    } finally {
      prefixDetailsBloc.setFileSelectionInProgress(false);
    }

    if (filePickerResult != null) {
      String filePath = filePickerResult.files.single.path!;
      specialExecutableBloc.startProcess([filePath]);
    }
  }

  void _viewProcessLogs({
    required BuildContext context,
    required SpecialExecutableState specialExecutableState,
  }) {
    final processLogs = specialExecutableState.processLogs;

    if (processLogs != null) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProcessLogsViewWidget(processLogs: processLogs),
          ),
        ),
      );
    }
  }
}

class _PinnedExecutablesGridWidget extends StatefulWidget {
  final StartupData startupData;
  final WinePrefix winePrefix;

  const _PinnedExecutablesGridWidget({
    required this.startupData,
    required this.winePrefix,
  });

  @override
  State<_PinnedExecutablesGridWidget> createState() => _PinnedAppsGridState();
}

class _PinnedAppsGridState extends State<_PinnedExecutablesGridWidget> {
  final GlobalKey<AnimatedGridState> _animatedGridKey =
      GlobalKey<AnimatedGridState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PinnedExecutableSetBloc, PinnedExecutableSetState>(
      listener: (context, state) => _reactToPrefixListChanges(state: state),
      child: _buildAnimatedGrid(context),
    );
  }

  Widget _buildAnimatedGrid(BuildContext context) {
    final state = BlocProvider.of<PinnedExecutableSetBloc>(context).state;

    return AnimatedGrid(
      key: _animatedGridKey,
      padding: EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: PinnedExecutableWidget.maxHeight,
        maxCrossAxisExtent: PinnedExecutableWidget.fixedWidth,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
      initialItemCount: state.orderedPinnedExecutables.length,
      itemBuilder: (context, index, animation) {
        // It's important to acquire the new state here, as it's subject
        // to change.
        final bloc = BlocProvider.of<PinnedExecutableSetBloc>(context);
        final state = bloc.state;
        final pinnedExecutable = state.orderedPinnedExecutables[index];

        return PinnedExecutableWidget(
          pinnedExecutable: pinnedExecutable,
          onPinnedExecutableUpdated: (pinnedExecutable) async {
            await bloc.updatePinnedExecutable(pinnedExecutable);

            if (context.mounted) {
              final snackBar = SnackBar(content: Text('Pinned app updated'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          winePrefix: widget.winePrefix,
          startupData: widget.startupData,
          removed: false,
          animation: animation,
        );
      },
    );
  }

  void _reactToPrefixListChanges({required PinnedExecutableSetState state}) {
    final animatedGridState = _animatedGridKey.currentState!;

    const instantTransitionDuration = Duration.zero;
    const animatedTransitionDuration = Duration(milliseconds: 300);

    switch (state.pinnedExecutableListEvent) {
      case PinnedExecutableAddedEvent evt:
        animatedGridState.insertItem(
          evt.pinnedExecutableIndex,
          duration: evt.animatedInsertion
              ? animatedTransitionDuration
              : instantTransitionDuration,
        );
      case PinnedExecutableRemovedEvent evt:
        animatedGridState.removeItem(
          evt.pinnedExecutableIndex,
          (context, animation) => PinnedExecutableWidget(
            pinnedExecutable: evt.removedPinnedExecutable,
            onPinnedExecutableUpdated: (_) {},
            winePrefix: widget.winePrefix,
            startupData: widget.startupData,
            removed: true,
            animation: animation,
          ),
          duration: evt.animatedRemoval
              ? animatedTransitionDuration
              : instantTransitionDuration,
        );
      case null:
    }

    if (state.pinnedExecutableListEvent != null) {
      // This prevents a repeat reaction to the same event, should a widget
      // be rebuilt for an unrelated reason.
      BlocProvider.of<PinnedExecutableSetBloc>(
        context,
      ).clearPinnedExecutanleListEvent();
    }
  }
}
