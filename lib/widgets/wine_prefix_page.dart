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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/blocs/pinned_executable/pinned_executable_bloc.dart';
import 'package:winebar/blocs/pinned_executable/pinned_executable_state.dart';
import 'package:winebar/blocs/special_executable/special_executable_bloc.dart';
import 'package:winebar/blocs/special_executable/special_executable_state.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/repositories/running_pinned_executables_repo.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_installation_descriptor.dart';
import 'package:winebar/widgets/pin_executable_button.dart';
import 'package:winebar/widgets/run_process_chip.dart';

import '../blocs/prefix_details/prefix_details_bloc.dart';
import '../blocs/prefix_details/prefix_details_state.dart';
import '../models/pinned_executable_set.dart';
import '../models/wine_prefix.dart';
import '../widgets/process_output_widget.dart';

class WinePrefixPage extends StatelessWidget {
  final runningPinnedExecutablesRepo = GetIt.I
      .get<RunningPinnedExecutablesRepo>();
  final StartupData startupData;
  final WinePrefix winePrefix;
  final PinnedExecutableSet initialPinnedExecutables;

  WinePrefixPage({
    super.key,
    required this.startupData,
    required this.winePrefix,
    required this.initialPinnedExecutables,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider<PrefixDetailsBloc>(
          create: (context) => PrefixDetailsBloc(
            PrefixDetailsState.initialState(
              pinnedExecutables: initialPinnedExecutables,
            ),
            startupData: startupData,
          ),
        ),
        BlocProvider<CustomExecutableBloc>(
          create: (context) => CustomExecutableBloc(
            startupData: startupData,
            winePrefix: winePrefix,
          ),
        ),
        BlocProvider<RunAndPinExecutableBloc>(
          create: (context) => RunAndPinExecutableBloc(
            startupData: startupData,
            winePrefix: winePrefix,
            processExecutablePinnedInTempDir: (executablePinnedInTempDir) =>
                BlocProvider.of<PrefixDetailsBloc>(
                  context,
                ).pinExecutable(executablePinnedInTempDir),
          ),
        ),
        BlocProvider<WinetricksExecutableBloc>(
          create: (context) => WinetricksExecutableBloc(
            startupData: startupData,
            winePrefix: winePrefix,
          ),
        ),
      ],
      child: BlocBuilder<PrefixDetailsBloc, PrefixDetailsState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  backgroundColor: colorScheme.inversePrimary,
                  title: Text('Wine Prefix: ${winePrefix.descriptor.name}'),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildCentralWidget(
                        context: context,
                        state: state,
                        colorScheme: colorScheme,
                      ),
                    ),
                    _buildBottomPanel(colorScheme: colorScheme),
                  ],
                ),
                floatingActionButton: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_buildPinExecutableButton(), SizedBox(height: 50)],
                ),
              ),
              if (state.fileSelectionInProgress)
                // Blocks all interactions.
                ModalBarrier(
                  dismissible: false,
                  color: colorScheme.surface.withAlpha(128),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCentralWidget({
    required BuildContext context,
    required PrefixDetailsState state,
    required ColorScheme colorScheme,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: _buildPinnedExecutableWidgets(
            context: context,
            state: state,
            colorScheme: colorScheme,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel({required ColorScheme colorScheme}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.centerLeft,
      color: colorScheme.surfaceContainerHigh,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          BlocBuilder<CustomExecutableBloc, SpecialExecutableState>(
            builder: (context, state) =>
                _buildRunCustomExecutableChip(context, state),
          ),
          BlocBuilder<RunAndPinExecutableBloc, SpecialExecutableState>(
            builder: (context, state) =>
                _buildRunAndPinExecutableChip(context, state),
          ),
          BlocBuilder<WinetricksExecutableBloc, SpecialExecutableState>(
            builder: (context, state) =>
                _buildWinetricksGuiChip(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildPinExecutableButton() {
    Widget buildButton(BuildContext context, SpecialExecutableState state) {
      final bloc = BlocProvider.of<PinExecutableBloc>(context);

      return PinExecutableButton(
        specialExecutableState: state,
        onPrimaryButtonPressed: () => _selectSpecialExecutableToRun(
          context: context,
          specialExecutableBloc: bloc,
        ),
        onKillProcessPressed: () => bloc.killProcessIfRunning(),
        onViewProcessOutputPressed: () =>
            _viewProcessOutput(context: context, specialExecutableState: state),
      );
    }

    return BlocProvider(
      create: (context) => PinExecutableBloc(
        startupData: startupData,
        winePrefix: winePrefix,
        processExecutablePinnedInTempDir: (executablePinnedInTempDir) =>
            BlocProvider.of<PrefixDetailsBloc>(
              context,
            ).pinExecutable(executablePinnedInTempDir),
      ),
      child: BlocBuilder<PinExecutableBloc, SpecialExecutableState>(
        builder: (context, state) => buildButton(context, state),
      ),
    );
  }

  List<Widget> _buildPinnedExecutableWidgets({
    required BuildContext context,
    required PrefixDetailsState state,
    required ColorScheme colorScheme,
  }) {
    final widgets = <Widget>[];

    final newItemsIter = _PinnedExecutablesIter(
      state.pinnedExecutables.pinnedExecutablesOrderedByLabel,
    );

    final oldItemsIter = _PinnedExecutablesIter(
      state.oldPinnedExecutables?.pinnedExecutablesOrderedByLabel ??
          Iterable<PinnedExecutable>.empty(),
    );

    final haveOldSet = state.oldPinnedExecutables != null;

    void addItem(
      PinnedExecutable pinnedExecutable, {
      required bool presentInOldSet,
      required bool presentInNewSet,
    }) {
      _PinnedItemStatus itemStatus = _PinnedItemStatus.normal;
      if (!presentInOldSet && haveOldSet) {
        itemStatus = _PinnedItemStatus.justAdded;
      } else if (!presentInNewSet) {
        itemStatus = _PinnedItemStatus.justRemoved;
      }

      widgets.add(
        _buildPinnedExecutableWidget(
          context: context,
          pinnedExecutable: pinnedExecutable,
          colorScheme: colorScheme,
          itemStatus: itemStatus,
        ),
      );
    }

    // Below is essentially the merge part of merge sort.

    while (newItemsIter.element != null && oldItemsIter.element != null) {
      final newItem = newItemsIter.element!;
      final oldItem = oldItemsIter.element!;
      final comp = newItem.compareTo(oldItem);
      if (comp < 0) {
        addItem(newItem, presentInOldSet: false, presentInNewSet: true);
        newItemsIter.next();
      } else if (comp > 0) {
        addItem(oldItem, presentInOldSet: true, presentInNewSet: false);
        oldItemsIter.next();
      } else {
        addItem(newItem, presentInOldSet: true, presentInNewSet: true);
        oldItemsIter.next();
        newItemsIter.next();
      }
    }

    while (newItemsIter.element != null) {
      final newItem = newItemsIter.element!;
      addItem(newItem, presentInOldSet: false, presentInNewSet: true);
      newItemsIter.next();
    }

    while (oldItemsIter.element != null) {
      final oldItem = oldItemsIter.element!;
      addItem(oldItem, presentInOldSet: true, presentInNewSet: false);
      oldItemsIter.next();
    }

    return widgets;
  }

  Widget _buildPinnedExecutableWidget({
    required BuildContext context,
    required PinnedExecutable pinnedExecutable,
    required ColorScheme colorScheme,
    required _PinnedItemStatus itemStatus,
  }) {
    Widget buildWidgetTree(BuildContext context, PinnedExecutableState state) {
      final bloc = BlocProvider.of<PinnedExecutableBloc>(context);

      final String? imageFilePath = pinnedExecutable.hasIcon
          ? path.join(pinnedExecutable.pinDirectory, 'icon.png')
          : null;

      final widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => bloc.setMouseOver(true),
        onExit: (_) => bloc.setMouseOver(false),
        child: GestureDetector(
          onTap: () => itemStatus == _PinnedItemStatus.normal
              ? bloc.launchPinnedExecutable()
              : null,
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
                          width: 128.0,
                          height: 128.0,
                        )
                      : Icon(
                          key: ValueKey(_PinnedItemElement.iconPlaceholder),
                          MdiIcons.applicationOutline,
                          color: colorScheme.primary,
                          size: 128.0,
                        ),
                  if (state.mouseOver &&
                      !state.isRunning &&
                      itemStatus == _PinnedItemStatus.normal)
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
                  if (state.isRunning && itemStatus == _PinnedItemStatus.normal)
                    Positioned(
                      key: ValueKey(_PinnedItemElement.killProcessAction),
                      bottom: 0.0,
                      right: 0.0,
                      child: IconButton(
                        icon: Icon(MdiIcons.close),
                        style: ButtonStyle(
                          iconColor: WidgetStateProperty.resolveWith<Color?>((
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
              SizedBox(height: 4.0), // Space between image and text
              SizedBox(
                width: 128.0, // Set a fixed width for the text to elide
                child: Tooltip(
                  message: pinnedExecutable.label,
                  child: Text(
                    pinnedExecutable.label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      switch (itemStatus) {
        case _PinnedItemStatus.normal:
          return widget;
        case _PinnedItemStatus.justAdded:
          return widget
              .animate(
                onComplete: (_) {
                  BlocProvider.of<PrefixDetailsBloc>(
                    context,
                  ).forgetOldPinnedExecutables();
                },
              )
              .fadeIn()
              .scale();
        case _PinnedItemStatus.justRemoved:
          return widget
              .animate(
                onComplete: (_) {
                  BlocProvider.of<PrefixDetailsBloc>(
                    context,
                  ).forgetOldPinnedExecutables();
                },
              )
              .fadeOut()
              .scaleXY(end: ScaleEffect.defaultScale);
      }
    }

    return BlocProvider(
      create: (context) => PinnedExecutableBloc(
        startupData: startupData,
        winePrefix: winePrefix,
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
    final bloc = BlocProvider.of<PrefixDetailsBloc>(context);

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

  Widget _buildRunAndPinExecutableChip(
    BuildContext context,
    SpecialExecutableState state,
  ) {
    final specialExecutableBloc = BlocProvider.of<RunAndPinExecutableBloc>(
      context,
    );

    return RunProcessChip(
      primaryButtonIcon: Icon(MdiIcons.pin),
      primaryButtonLabel: const Text('Run & Pin Executable'),
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
    final prefixDetailsBloc = BlocProvider.of<PrefixDetailsBloc>(context);
    prefixDetailsBloc.setFileSelectionInProgress(true);

    FilePickerResult? filePickerResult;

    try {
      WineInstallationDescriptor wineInstDesc =
          await WineInstallationDescriptor.forWineInstallDir(
            winePrefix.descriptor.getAbsPathToWineInstall(
              toplevelDataDir: startupData.localStoragePaths.toplevelDataDir,
            ),
          );

      filePickerResult = await FilePicker.platform.pickFiles(
        initialDirectory: wineInstDesc.getInnermostPrefixDir(
          prefixDirStructure: winePrefix.dirStructure,
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

class _PinnedExecutablesIter {
  final Iterator<PinnedExecutable> _it;
  PinnedExecutable? element;

  _PinnedExecutablesIter(Iterable<PinnedExecutable> iterable)
    : _it = iterable.iterator {
    next();
  }

  void next() {
    if (_it.moveNext()) {
      element = _it.current;
    } else {
      element = null;
    }
  }
}

enum _PinnedItemStatus { normal, justAdded, justRemoved }

enum _PinnedItemElement {
  icon,
  iconPlaceholder,
  unpinAction,
  killProcessAction,
}

enum _PinButtonElement { icon, killProcessButton, viewLogsButton }
