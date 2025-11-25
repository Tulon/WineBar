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
import 'package:get_it/get_it.dart';
import 'package:winebar/blocs/prefix_list/prefix_list_state.dart';
import 'package:winebar/models/pinned_executable.dart';
import 'package:winebar/models/prefix_list_event.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/repositories/running_executables_repo.dart';

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
            body: _WinePrefixesList(startupData: startupData),
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
}

class _WinePrefixesList extends StatefulWidget {
  final StartupData startupData;

  const _WinePrefixesList({required this.startupData});

  @override
  State<_WinePrefixesList> createState() => _WinePrefixesListState();
}

class _WinePrefixesListState extends State<_WinePrefixesList> {
  final GlobalKey<AnimatedListState> _prefixListKey =
      GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrefixListBloc, PrefixListState>(
      listener: (context, state) => _reactToPrefixListChanges(state: state),
      child: _buildAnimatedList(context),
    );
  }

  Widget _buildAnimatedList(BuildContext context) {
    final state = BlocProvider.of<PrefixListBloc>(context).state;

    return AnimatedList.separated(
      key: _prefixListKey,
      initialItemCount: state.orderedPrefixes.length,
      itemBuilder: (context, index, animation) {
        // It's important to acquire the new state here, as it's subject
        // to change.
        final state = BlocProvider.of<PrefixListBloc>(context).state;
        final prefix = state.orderedPrefixes[index];
        return _buildPrefixWidget(
          prefix: prefix,
          animation: animation,
          removedPrefix: false,
        );
      },
      separatorBuilder: _buildListSeparator,
      removedSeparatorBuilder: _buildListSeparator,
    );
  }

  void _reactToPrefixListChanges({required PrefixListState state}) {
    final animatedListState = _prefixListKey.currentState!;

    const instantTransitionDuration = Duration.zero;
    const animatedTransitionDuration = Duration(milliseconds: 300);

    switch (state.prefixListEvent) {
      case PrefixAddedEvent evt:
        animatedListState.insertItem(
          evt.prefixIndex,
          duration: evt.animatedInsertion
              ? animatedTransitionDuration
              : instantTransitionDuration,
        );
      case PrefixRemovedEvent evt:
        animatedListState.removeItem(
          evt.prefixIndex,
          (context, animation) => _buildPrefixWidget(
            prefix: evt.removedPrefix,
            animation: animation,
            removedPrefix: true,
          ),
          duration: evt.animatedRemoval
              ? animatedTransitionDuration
              : instantTransitionDuration,
        );
      case null:
    }

    if (state.prefixListEvent != null) {
      // This prevents a repeat reaction to the same event, should a widget
      // be rebuilt for an unrelated reason.
      BlocProvider.of<PrefixListBloc>(context).clearPrefixListEvent();
    }
  }

  Widget _buildListSeparator(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: 0.0,
        child: Divider(height: 4.0),
      ),
    );
  }

  Widget _buildPrefixWidget({
    required WinePrefix prefix,
    required Animation<double> animation,
    required bool removedPrefix,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: 0.0,
        child: ListTile(
          title: Text(prefix.descriptor.name),
          enabled: !prefix.isBroken,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          leading: _buildPrefixMenuButton(
            context: context,
            prefix: prefix,
            removedPrefix: removedPrefix,
          ),
          onTap: () => prefix.isBroken || removedPrefix
              ? null
              : _startNavigatingToPrefix(
                  context: context,
                  startupData: widget.startupData,
                  winePrefix: prefix,
                ),
        ),
      ),
    );
  }

  Widget _buildPrefixMenuButton({
    required BuildContext context,
    required WinePrefix prefix,
    required bool removedPrefix,
  }) {
    if (removedPrefix) {
      return IconButton(icon: const Icon(Icons.more_vert), onPressed: null);
    }

    return MenuAnchor(
      menuChildren: <Widget>[
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

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
                Navigator.of(context).pop();
                _startDeletingPrefixUnlessAppsAreRunningThere(
                  context: context,
                  prefix: prefix,
                  bloc: bloc,
                );
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

  Future<void> _showUnableToDeletePrefixDialog({
    required BuildContext context,
    required WinePrefix prefix,
    required Widget body,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unable to delete prefix'),
          content: body,
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
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
    required PrefixListBloc bloc,
  }) {
    final runningPinnedExecutablesRepo = GetIt.I
        .get<RunningExecutablesRepo<PinnedExecutable>>();
    final runningSpecialExecutablesRepo = GetIt.I
        .get<RunningExecutablesRepo<SpecialExecutableSlot>>();

    final numPinnedExecutablesRunning = runningPinnedExecutablesRepo
        .numProcessesRunningInPrefix(prefix);
    final numSpecialExecutablesRunning = runningSpecialExecutablesRepo
        .numProcessesRunningInPrefix(prefix);

    if (numPinnedExecutablesRunning + numSpecialExecutablesRunning == 0) {
      bloc.startDeletingPrefix(prefix);
    } else {
      final colorScheme = Theme.of(context).colorScheme;

      final body = RichText(
        text: TextSpan(
          style: TextStyle(color: colorScheme.onSurface),
          children: [
            TextSpan(text: 'Failed to delete prefix '),
            TextSpan(
              text: prefix.descriptor.name,
              style: TextStyle(color: colorScheme.primary),
            ),
            TextSpan(text: ' as apps are still running there.'),
          ],
        ),
      );

      unawaited(
        _showUnableToDeletePrefixDialog(
          context: context,
          prefix: prefix,
          body: body,
        ),
      );
    }
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
              initialPrefix: winePrefix,
              initialPinnedExecutables: pinnedExecutables,
              onPrefixUpdated: (updatedPrefix) {
                bloc.updatePrefix(
                  oldPrefix: winePrefix,
                  updatedPrefix: updatedPrefix,
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
