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

import 'package:boxy/padding.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/blocs/pinned_executable/pinned_executable_bloc.dart';
import 'package:winebar/blocs/pinned_executable/pinned_executable_state.dart';
import 'package:winebar/blocs/pinned_executable_set/pinned_executable_set_bloc.dart';
import 'package:winebar/blocs/special_executable/special_executable_bloc.dart';
import 'package:winebar/blocs/special_executable/special_executable_state.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/pinned_executable_list_event.dart';
import 'package:winebar/services/running_wine_processes_tracker.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/utils/maybe_tell_user_to_finish_running_apps.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/widgets/pin_executable_button.dart';
import 'package:winebar/widgets/prefix_settings_dialog.dart';
import 'package:winebar/widgets/run_process_chip.dart';

import '../blocs/pinned_executable_set/pinned_executable_set_state.dart';
import '../blocs/prefix_details/prefix_details_bloc.dart';
import '../blocs/prefix_details/prefix_details_state.dart';
import '../models/wine_prefix.dart';
import '../widgets/process_output_widget.dart';

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
                create: (context) => CustomExecutableBloc(
                  startupData: startupData,
                  winePrefix: state.prefix,
                ),
              ),
              BlocProvider<RunInstallerBloc>(
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
              BlocProvider<WinetricksExecutableBloc>(
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
        onViewProcessOutputPressed: () =>
            _viewProcessOutput(context: context, specialExecutableState: state),
      );
    }

    return BlocProvider(
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

    return RunProcessChip(
      primaryButtonIcon: Icon(MdiIcons.rocketLaunch),
      primaryButtonLabel: const Text('Run Executable'),
      specialExecutableState: state,
      onPrimaryButtonPressed: () => _selectSpecialExecutableToRun(
        context: context,
        specialExecutableBloc: specialExecutableBloc,
      ),
      onKillProcessPressed: () => specialExecutableBloc.killProcessIfRunning(),
      onViewProcessOutputPressed: () =>
          _viewProcessOutput(context: context, specialExecutableState: state),
    );
  }

  Widget _buildRunInstallerChip(
    BuildContext context,
    SpecialExecutableState state,
  ) {
    final specialExecutableBloc = BlocProvider.of<RunInstallerBloc>(context);

    return RunProcessChip(
      primaryButtonIcon: Icon(MdiIcons.packageVariantClosedPlus),
      primaryButtonLabel: const Text('Run Installer'),
      specialExecutableState: state,
      onPrimaryButtonPressed: () => _selectSpecialExecutableToRun(
        context: context,
        specialExecutableBloc: specialExecutableBloc,
      ),
      onKillProcessPressed: () => specialExecutableBloc.killProcessIfRunning(),
      onViewProcessOutputPressed: () =>
          _viewProcessOutput(context: context, specialExecutableState: state),
    );
  }

  Widget _buildWinetricksGuiChip(
    BuildContext context,
    SpecialExecutableState state,
  ) {
    final specialExecutableBloc = BlocProvider.of<WinetricksExecutableBloc>(
      context,
    );

    return RunProcessChip(
      primaryButtonIcon: Icon(MdiIcons.hammerScrewdriver),
      primaryButtonLabel: const Text('Winetricks GUI'),
      specialExecutableState: state,
      onPrimaryButtonPressed: () =>
          specialExecutableBloc.startProcess(['--gui']),
      onKillProcessPressed: () => specialExecutableBloc.killProcessIfRunning(),
      onViewProcessOutputPressed: () =>
          _viewProcessOutput(context: context, specialExecutableState: state),
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

  void _viewProcessOutput({
    required BuildContext context,
    required SpecialExecutableState specialExecutableState,
  }) {
    final processOutput = specialExecutableState.processOutput;

    if (processOutput != null) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProcessOutputWidget(processOutput: processOutput),
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

  static const double _iconDim = 128.0;
  static const double _tileWidth = _iconDim;
  static const double _spaceBetweenIconAndText = 4.0;

  static const double _textFontSize = 14.0;
  static const int _maxTextLines = 2;

  /// This number is a result of trial and error. It's roughly how high our
  /// _maxTextLines at _textFontSize are going to be. If our guesstimate
  /// is lower than the real figure (which we can't know for sure), the text
  /// will be scaled to fit into this height. If our guesstimage is too high,
  /// there will be higher than intended gap between rows.
  static const double _maxTextHeight = 42.0;

  static const double _maxTileHeight =
      _iconDim + _spaceBetweenIconAndText + _maxTextHeight;

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
        mainAxisExtent: _maxTileHeight,
        maxCrossAxisExtent: _tileWidth,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      initialItemCount: state.orderedPinnedExecutables.length,
      itemBuilder: (context, index, animation) {
        // It's important to acquire the new state here, as it's subject
        // to change.
        final state = BlocProvider.of<PinnedExecutableSetBloc>(context).state;
        final pinnedExecutable = state.orderedPinnedExecutables[index];
        return _buildPinnedExecutableWidget(
          pinnedExecutable: pinnedExecutable,
          animation: animation,
          removedPinnedExecutable: false,
        );
      },
    );
  }

  void _reactToPrefixListChanges({required PinnedExecutableSetState state}) {
    final animatedGridState = _animatedGridKey.currentState!;

    switch (state.pinnedExecutableListEvent) {
      case PinnedExecutableAddedEvent evt:
        animatedGridState.insertItem(evt.pinnedExecutableIndex);
      case PinnedExecutableRemovedEvent evt:
        animatedGridState.removeItem(
          evt.pinnedExecutableIndex,
          (context, animation) => _buildPinnedExecutableWidget(
            pinnedExecutable: evt.removedPinnedExecutable,
            animation: animation,
            removedPinnedExecutable: true,
          ),
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

  Widget _buildPinnedExecutableWidget({
    required PinnedExecutable pinnedExecutable,
    required Animation<double> animation,
    required bool removedPinnedExecutable,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget buildWidgetTree(BuildContext context, PinnedExecutableState state) {
      final bloc = BlocProvider.of<PinnedExecutableBloc>(context);

      final String? imageFilePath = pinnedExecutable.hasIcon
          ? path.join(pinnedExecutable.pinDirectory, 'icon.png')
          : null;

      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => bloc.setMouseOver(true),
            onExit: (_) => bloc.setMouseOver(false),
            child: GestureDetector(
              onTap: () => removedPinnedExecutable
                  ? null
                  : bloc.launchPinnedExecutable(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      imageFilePath != null
                          ? Image.file(
                              key: ValueKey(_PinnedItemElement.icon),
                              File(imageFilePath),
                              isAntiAlias: true,
                              width: _iconDim,
                              height: _iconDim,
                            )
                          : Icon(
                              key: ValueKey(_PinnedItemElement.iconPlaceholder),
                              MdiIcons.applicationOutline,
                              color: colorScheme.primary,
                              size: _iconDim,
                            ),
                      if (state.mouseOver &&
                          !state.isRunning &&
                          !removedPinnedExecutable)
                        Positioned(
                          key: ValueKey(_PinnedItemElement.unpinAction),
                          top: 0.0,
                          right: 0.0,
                          child: IconButton(
                            icon: Icon(MdiIcons.pinOff),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                            tooltip: 'Unpin',
                            onPressed: () {
                              unawaited(
                                _showUnpinConfirmationDialog(
                                  context: context,
                                  pinnedExecutable: pinnedExecutable,
                                ),
                              );
                            },
                          ),
                        ),
                      if (state.isRunning && !removedPinnedExecutable)
                        Positioned(
                          key: ValueKey(_PinnedItemElement.killProcessAction),
                          bottom: 0.0,
                          right: 0.0,
                          child: IconButton(
                            icon: Icon(MdiIcons.close),
                            style: ButtonStyle(
                              iconColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors.white;
                                    } else {
                                      return Colors.grey.shade900;
                                    }
                                  }),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors.red.shade900;
                                    } else {
                                      return Colors.yellow.shade700;
                                    }
                                  }),
                            ),
                            tooltip: 'Kill process',
                            onPressed: () => bloc.killProcessIfRunning(),
                          ),
                        ),
                    ],
                  ),

                  // Space between image and text
                  SizedBox(height: _spaceBetweenIconAndText),

                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: _maxTextHeight),
                    child: FittedBox(
                      // If the text exceeds _maxTextHeight (the maxHeight
                      // constraint set by our parent), we scale it down.
                      // To prevent the text from getting scaled down because
                      // it's too wide, we apply a maxWidth constraint below.
                      fit: BoxFit.scaleDown,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: _tileWidth),
                        child: Tooltip(
                          message: pinnedExecutable.label,
                          child: Text(
                            pinnedExecutable.label,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: _maxTextLines,
                            softWrap: true,
                            style: TextStyle(fontSize: _textFontSize),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => PinnedExecutableBloc(
        startupData: widget.startupData,
        winePrefix: widget.winePrefix,
        pinnedExecutable: pinnedExecutable,
      ),
      child: BlocBuilder<PinnedExecutableBloc, PinnedExecutableState>(
        builder: (context, state) => buildWidgetTree(context, state),
      ),
    );
  }

  Future<void> _showUnpinConfirmationDialog({
    required BuildContext context,
    required PinnedExecutable pinnedExecutable,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = BlocProvider.of<PinnedExecutableSetBloc>(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('App unpinning confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('The following app is about to be unpinned:'),
              Text(
                pinnedExecutable.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(MdiIcons.pinOff),
              label: const Text('Unpin'),
              onPressed: () {
                bloc.initiateUnpinningExecutable(pinnedExecutable);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

enum _PinnedItemElement {
  icon,
  iconPlaceholder,
  unpinAction,
  killProcessAction,
}
