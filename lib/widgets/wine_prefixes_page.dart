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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/prefix_list/prefix_list_bloc.dart';
import '../models/wine_prefix.dart';
import '../utils/startup_data.dart';
import 'prefix_creation_dialog.dart';
import 'wine_prefix_page.dart';

class WinePrefixesPage extends StatelessWidget {
  final StartupData startupData;

  const WinePrefixesPage({super.key, required this.startupData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrefixListBloc>(
      create: (context) => PrefixListBloc(startupData.winePrefixes),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text('Wine Prefixes'),
            ),
            body: BlocBuilder<PrefixListBloc, List<WinePrefix>>(
              builder: (context, prefixes) {
                return ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: prefixes.map((prefix) {
                      return ListTile(
                        title: Text(prefix.descriptor.name),
                        enabled: !prefix.isBroken,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        leading: _buildPrefixMenuButton(
                          context: context,
                          prefix: prefix,
                        ),
                        onTap: () => prefix.isBroken
                            ? null
                            : _startNavigatingToPrefix(
                                context: context,
                                startupData: startupData,
                                winePrefix: prefix,
                              ),
                      );
                    }).toList(),
                  ).toList(),
                );
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: const Text('Add Wine Prefix'),
              icon: const Icon(Icons.add),
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => PrefixCreationDialog(
                  startupData: startupData,
                  onPrefixCreated: (prefix) {
                    BlocProvider.of<PrefixListBloc>(context).addPrefix(prefix);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrefixMenuButton({
    required BuildContext context,
    required WinePrefix prefix,
  }) {
    return MenuAnchor(
      menuChildren: <Widget>[
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete_outlined),
          child: const Text('Delete'),
          onPressed: () =>
              _showDeletionConfirmationDialog(context: context, prefix: prefix),
        ),
      ],
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              icon: Icon(Icons.more_vert),
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

  Future<void> _showDeletionConfirmationDialog({
    required BuildContext context,
    required WinePrefix prefix,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = BlocProvider.of<PrefixListBloc>(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Prefix deletion confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('The following prefix is about to be deleted:'),
              Text(
                prefix.descriptor.name,
                style: TextStyle(color: colorScheme.primary),
              ),
              const Text("This action can't be undone!"),
            ],
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.delete_outlined),
              label: const Text('Delete'),
              onPressed: () {
                bloc.startDeletingPrefix(prefix);
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

  static void _startNavigatingToPrefix({
    required BuildContext context,
    required StartupData startupData,
    required WinePrefix winePrefix,
  }) async {
    final bloc = BlocProvider.of<PrefixListBloc>(context);
    final pinnedExecutables = await bloc.startLoadingPinnedExecutablesFor(
      winePrefix,
    );

    if (context.mounted && pinnedExecutables != null) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WinePrefixPage(
              startupData: startupData,
              winePrefix: winePrefix,
              initialPinnedExecutables: pinnedExecutables,
            ),
          ),
        ),
      );
    }
  }
}
