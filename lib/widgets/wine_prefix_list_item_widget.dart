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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:winebar/blocs/pinned_executable_set/pinned_executable_set_state.dart';
import 'package:winebar/blocs/prefix_cloning/prefix_cloning_bloc.dart';
import 'package:winebar/utils/l10n.dart';
import 'package:winebar/utils/maybe_tell_user_to_finish_running_apps.dart';
import 'package:winebar/widgets/prefix_cloning_dialog.dart';

import '../models/wine_prefix.dart';
import 'wine_prefix_page.dart';

class WinePrefixListItemWidget extends StatefulWidget {
  final WinePrefix prefix;
  final Future<PinnedExecutableSetState> Function() pinnedExecutablesLoader;

  const WinePrefixListItemWidget({
    super.key,
    required this.prefix,
    required this.pinnedExecutablesLoader,
  });

  @override
  State createState() => _WinePrefixListItemState();
}

class _WinePrefixListItemState extends State<WinePrefixListItemWidget> {
  late final String prefixName;

  @override
  void initState() {
    super.initState();

    prefixName = widget.prefix.descriptor.name;
  }

  @override
  Widget build(BuildContext context) {
    final prefix = widget.prefix;
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 3.0,
      child: ListenableBuilder(
        listenable: prefix,
        builder: (context, _) => ListTile(
          title: Text(prefix.descriptor.name, overflow: TextOverflow.ellipsis),
          enabled: prefix.status.mayEnter,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          leading: _buildPrefixMenuButton(context: context, prefix: prefix),
          trailing: prefix.hasRunningProcesses
              ? Tooltip(
                  // We could have displayed the number of apps
                  // running, but that number happens to be unreliable
                  // for reasons described in README.md.
                  message: L10n.current.appsAreRunningInThisPrefixTooltip,
                  child: Icon(
                    MdiIcons.hexagonMultiple,
                    color: theme.colorScheme.primary,
                  ),
                )
              : null,
          onTap: () => prefix.status.mayEnter
              ? _startNavigatingToPrefix(context: context, winePrefix: prefix)
              : null,
        ),
      ),
    );
  }

  Widget _buildPrefixMenuButton({
    required BuildContext context,
    required WinePrefix prefix,
  }) {
    final menuItems = <Widget>[];

    if (prefix.status.mayClone) {
      menuItems.add(
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

          leadingIcon: const Icon(Icons.copy),
          child: Text(L10n.current.cloneButtonLabel),
          onPressed: () => _maybeShowPrefixCloningConfirmationDialog(
            context: context,
            prefix: prefix,
          ),
        ),
      );
    }

    if (prefix.status.mayDelete) {
      menuItems.add(
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

          leadingIcon: const Icon(Icons.delete_outlined),
          child: Text(L10n.current.deleteButtonLabel),
          onPressed: () => _maybeShowPrefixDeletionConfirmationDialog(
            context: context,
            prefix: prefix,
          ),
        ),
      );
    }

    if (menuItems.isEmpty) {
      return IconButton(icon: Icon(prefix.status.menuIcon), onPressed: null);
    } else {
      return MenuAnchor(
        menuChildren: menuItems,
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                icon: Icon(prefix.status.menuIcon),
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
  }

  Future<void> _maybeShowPrefixCloningConfirmationDialog({
    required BuildContext context,
    required WinePrefix prefix,
  }) async {
    if (maybeTellUserToFinishRunningApps(
      context: context,
      appsRunningInThisPrefixAreAProblem: prefix,
    )) {
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => PrefixCloningBloc(onPrefixCloned: (_) {}),
          child: PrefixCloningDialog(prefixToClone: prefix),
        );
      },
    );
  }

  Future<void> _maybeShowPrefixDeletionConfirmationDialog({
    required BuildContext context,
    required WinePrefix prefix,
  }) async {
    if (maybeTellUserToFinishRunningApps(
      context: context,
      appsRunningInThisPrefixAreAProblem: prefix,
    )) {
      return;
    }

    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10n.current.prefixDeletionConfirmationDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(L10n.current.theFollowingPrefixIsAboutToBeDeleted),
              Text(
                prefix.descriptor.name,
                style: TextStyle(color: colorScheme.primary),
              ),
              const Text('\n'),
              Text(L10n.current.thisActionCantBeUndone),
            ],
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.delete_outlined),
              label: Text(L10n.current.deleteButtonLabel),
              onPressed: () {
                Navigator.of(context).pop();
                _startDeletingPrefixUnlessAppsAreRunningThere(
                  context: context,
                  prefix: prefix,
                );
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

  void _startDeletingPrefixUnlessAppsAreRunningThere({
    required BuildContext context,
    required WinePrefix prefix,
  }) {
    if (maybeTellUserToFinishRunningApps(
      context: context,
      appsRunningInThisPrefixAreAProblem: prefix,
    )) {
      return;
    }

    try {
      prefix.startDeleting();
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _startNavigatingToPrefix({
    required BuildContext context,
    required WinePrefix winePrefix,
  }) async {
    final pinnedExecutables = await widget.pinnedExecutablesLoader();

    if (context.mounted) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WinePrefixPage(
              prefix: winePrefix,
              initialPinnedExecutables: pinnedExecutables,
            ),
          ),
        ),
      );
    }
  }
}
