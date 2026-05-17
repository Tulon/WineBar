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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/blocs/pinned_executable/pinned_executable_bloc.dart';
import 'package:winebar/blocs/pinned_executable/pinned_executable_state.dart';
import 'package:winebar/blocs/pinned_executable_set/pinned_executable_set_bloc.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/utils/l10n.dart';
import 'package:winebar/widgets/pinned_executable_settings_dialog.dart';

import '../models/wine_prefix.dart';

class PinnedExecutableWidget extends StatefulWidget {
  static const double _iconDim = 128.0;
  static const double _spaceBetweenIconAndText = 4.0;

  static const double _textFontSize = 14.0;
  static const int _maxTextLines = 2;

  /// This number is a result of trial and error. It's roughly how high our
  /// _maxTextLines of text at _textFontSize are going to be. If our
  /// guesstimate ends up being lower than the real figure (which we can't
  /// know for sure), the text will be scaled to fit into this height.
  /// If our guesstimage ends up being is too high there will be a higher than
  /// intended gap between rows of pinned executables - not a big deal either
  /// way.
  static const double _maxTextHeight = 42.0;

  static const double fixedWidth = _iconDim;

  static const double maxHeight =
      _iconDim + _spaceBetweenIconAndText + _maxTextHeight;

  final PinnedExecutable pinnedExecutable;
  final void Function(PinnedExecutable) onPinnedExecutableUpdated;
  final WinePrefix winePrefix;

  /// Indicates whether the pinned executable in question has already
  /// been removed. A widget for a removed pinned stays in the tree
  /// while the removal animation is played.
  final bool removed;

  final Animation<double> animation;

  const PinnedExecutableWidget({
    super.key,
    required this.pinnedExecutable,
    required this.onPinnedExecutableUpdated,
    required this.winePrefix,
    required this.removed,
    required this.animation,
  });

  @override
  State<PinnedExecutableWidget> createState() => _PinnedExecutableWidgetState();
}

class _PinnedExecutableWidgetState extends State<PinnedExecutableWidget> {
  // This one doesn't need to be disposed.
  final MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget buildWidgetTree(BuildContext context, PinnedExecutableState state) {
      final bloc = BlocProvider.of<PinnedExecutableBloc>(context);

      final String? imageFilePath = widget.pinnedExecutable.hasIcon
          ? path.join(widget.pinnedExecutable.pinDirectory, 'icon.png')
          : null;

      return FadeTransition(
        opacity: widget.animation,
        child: ScaleTransition(
          scale: widget.animation,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => bloc.setMouseOver(true),
            onExit: (_) => bloc.setMouseOver(false),
            child: GestureDetector(
              onTap: () =>
                  widget.removed ? null : bloc.launchPinnedExecutable(),
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
                              width: PinnedExecutableWidget._iconDim,
                              height: PinnedExecutableWidget._iconDim,
                            )
                          : Icon(
                              key: ValueKey(_PinnedItemElement.iconPlaceholder),
                              MdiIcons.applicationOutline,
                              color: colorScheme.primary,
                              size: PinnedExecutableWidget._iconDim,
                            ),
                      if (!widget.removed &&
                          !state.isRunning &&
                          (state.isMouseOver || state.isContextMenuOpen))
                        Positioned(
                          key: ValueKey(_PinnedItemElement.settingsAction),
                          top: 0.0,
                          right: 0.0,
                          child: _buildPinnedExecutableMenuButton(
                            context: context,
                            bloc: bloc,
                          ),
                        ),
                      if (!widget.removed && state.isRunning)
                        Positioned(
                          key: ValueKey(_PinnedItemElement.killProcessAction),
                          bottom: 0.0,
                          right: 0.0,
                          child: _buildKillProcessButton(
                            context: context,
                            bloc: bloc,
                          ),
                        ),
                    ],
                  ),

                  SizedBox(
                    height: PinnedExecutableWidget._spaceBetweenIconAndText,
                  ),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: PinnedExecutableWidget._maxTextHeight,
                    ),
                    child: FittedBox(
                      // If the text exceeds maxTextHeight (the maxHeight
                      // constraint set by our parent), we scale it down.
                      // To prevent the text from getting scaled down because
                      // it's too wide, we apply a maxWidth constraint below.
                      fit: BoxFit.scaleDown,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: PinnedExecutableWidget.fixedWidth,
                        ),
                        child: Tooltip(
                          message: widget.pinnedExecutable.label,
                          child: Text(
                            widget.pinnedExecutable.label,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: PinnedExecutableWidget._maxTextLines,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: PinnedExecutableWidget._textFontSize,
                            ),
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
      // The thing is, re-creating the BlocProvider doesn't re-create the
      // bloc [1], unless you force that to happen [2]. Here, we force it
      // to be re-created when the pinnedExecutable or the winePrefix change.
      // The need to match the pinnedExecutable is obvious, especially at
      // a point where a new pinned executable is added. The winePrefix
      // has to be matched because it carries important information used for
      // running Wine apps. Some of that information may change at runtime
      // (the WOW64 preference for GE Proton builds comes to mind).
      // [1]: https://github.com/felangel/bloc/issues/1223#issuecomment-635577618
      // [2]: https://github.com/felangel/bloc/issues/1223#issuecomment-1999875271
      key: ValueKey((widget.pinnedExecutable, widget.winePrefix)),

      create: (context) => PinnedExecutableBloc(
        winePrefix: widget.winePrefix,
        pinnedExecutable: widget.pinnedExecutable,
        isContextMenuOpen: menuController.isOpen,
      ),
      child: BlocBuilder<PinnedExecutableBloc, PinnedExecutableState>(
        builder: (context, state) => buildWidgetTree(context, state),
      ),
    );
  }

  Widget _buildPinnedExecutableMenuButton({
    required BuildContext context,
    required PinnedExecutableBloc bloc,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return MenuAnchor(
      controller: menuController,
      onOpen: () => bloc.setContextMenuOpen(true),
      onClose: () => bloc.setContextMenuOpen(false),
      menuChildren: <Widget>[
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

          leadingIcon: Icon(MdiIcons.pinOff),
          child: Text(L10n.current.unpinButtonLabel),
          onPressed: () {
            unawaited(_showUnpinConfirmationDialog(context: context));
          },
        ),
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

          leadingIcon: Icon(MdiIcons.cogs),
          child: Text(L10n.current.settingsMenuItem),
          onPressed: () {
            unawaited(_showPinnedExecutableSettingsDialog(context: context));
          },
        ),
      ],
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              icon: Icon(Icons.more_vert),
              style: IconButton.styleFrom(
                side: BorderSide(),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            );
          },
    );
  }

  Widget _buildKillProcessButton({
    required BuildContext context,
    required PinnedExecutableBloc bloc,
  }) {
    return IconButton(
      icon: Icon(MdiIcons.close),
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith<BorderSide?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return BorderSide.none;
          } else {
            return BorderSide(color: Colors.grey.shade900);
          }
        }),
        iconColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.white;
          } else {
            return Colors.grey.shade900;
          }
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((
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
    );
  }

  Future<void> _showUnpinConfirmationDialog({
    required BuildContext context,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final executableSetBloc = BlocProvider.of<PinnedExecutableSetBloc>(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10n.current.appUnpinningConfirmationDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(L10n.current.theFollowingAppIsAboutToBeUnpinned),
              Text(
                widget.pinnedExecutable.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(MdiIcons.pinOff),
              label: Text(L10n.current.unpinButtonLabel),
              onPressed: () {
                executableSetBloc.initiateUnpinningExecutable(
                  widget.pinnedExecutable,
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPinnedExecutableSettingsDialog({
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PinnedExecutableSettingsDialog(
          pinnedExecutable: widget.pinnedExecutable,
          onPinnedExecutableUpdated: widget.onPinnedExecutableUpdated,
        );
      },
    );
  }
}

enum _PinnedItemElement {
  icon,
  iconPlaceholder,
  settingsAction,
  killProcessAction,
}
