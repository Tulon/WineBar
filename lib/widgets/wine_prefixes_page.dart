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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:simple_icons/simple_icons.dart';
import 'package:stream_listener_widget/stream_listener_widget.dart';
import 'package:winebar/blocs/pinned_executable_set/pinned_executable_set_state.dart';
import 'package:winebar/repositories/wine_prefix_repo.dart';
import 'package:winebar/utils/app_info.dart';
import 'package:winebar/utils/l10n.dart';
import 'package:winebar/utils/local_storage_paths.dart';
import 'package:winebar/utils/match_text_spans.dart';
import 'package:winebar/utils/maybe_tell_user_to_finish_running_apps.dart';
import 'package:winebar/utils/old_task_abandoning_worker.dart';
import 'package:winebar/utils/open_url.dart';
import 'package:winebar/widgets/gesture_recognizer_holder.dart';
import 'package:winebar/widgets/locale_selection_button.dart';
import 'package:winebar/widgets/wine_prefix_list_item_widget.dart';

import '../models/wine_prefix.dart';
import '../utils/startup_data.dart';
import 'prefix_creation_dialog.dart';

class WinePrefixesPage extends StatelessWidget {
  final void Function(Locale) onLocaleChanged;

  const WinePrefixesPage({super.key, required this.onLocaleChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildAppMenuButton(context),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(L10n.current.winePrefixesPageTitle),
        actions: [
          _buildDonationButton(context),
          SizedBox(width: 12.0),
          LocaleSelectionButton(onLocaleSelected: onLocaleChanged),
        ],
        actionsPadding: EdgeInsetsDirectional.only(end: 8.0),
      ),
      body: _WinePrefixesList(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(L10n.current.addWinePrefixButtonLabel),
        icon: const Icon(Icons.add),
        onPressed: () => _maybeShowPrefixCreationDialog(context),
      ),
    );
  }

  Widget _buildAppMenuButton(BuildContext context) {
    return MenuAnchor(
      menuChildren: <Widget>[
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

          leadingIcon: const Icon(Icons.info),
          child: Text(L10n.current.aboutButtonLabel),
          onPressed: () => _showAboutDialog(context),
        ),
      ],
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              icon: Icon(Icons.menu),
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

  Widget _buildDonationButton(BuildContext context) {
    return MenuAnchor(
      menuChildren: <Widget>[
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

          leadingIcon: const Icon(SimpleIcons.kofi),
          child: const Text('Ko-fi'),
          onPressed: () => openUrlAndLogErrors('https://ko-fi.com/tulon'),
        ),
        MenuItemButton(
          // See here: https://stackoverflow.com/a/78692532
          requestFocusOnHover: false,

          leadingIcon: const Icon(SimpleIcons.liberapay),
          child: const Text('Liberapay'),
          onPressed: () =>
              openUrlAndLogErrors('https://liberapay.com/Tulon/donate'),
        ),
      ],
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return ElevatedButton.icon(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              label: Text(L10n.current.donateButtonLabel),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurpleAccent,
              ),
            );
          },
    );
  }

  Future<void> _showAboutDialog(BuildContext context) async {
    final versionTxtFilePath = LocalStoragePaths.versionTxtFilePath;
    final rawVersionString = await File(
      versionTxtFilePath,
    ).readAsString().catchError((e) => '0.0.0');
    final versionString = 'v${rawVersionString.trim()}';

    if (!context.mounted) {
      return;
    }

    final licenseTapRecognizer = TapGestureRecognizer()
      ..onTap = () => openUrlAndLogErrors(
        'https://www.gnu.org/licenses/gpl-3.0-standalone.html',
      );

    final authorNameTapRecognizer = TapGestureRecognizer()
      ..onTap = () => openUrlAndLogErrors('https://tulon.github.io/about/');

    const linkStyle = TextStyle(
      decoration: TextDecoration.underline,
      color: Color(0xff1e88e5),
      decorationColor: Color(0xff1e88e5),
    );

    showAboutDialog(
      context: context,
      applicationName: AppInfo.appName,
      applicationVersion: versionString,
      applicationIcon: Image(
        width: 56,
        height: 56,
        image: AssetImage('packaging/resources/common/winebar.png'),
      ),
      children: [
        GestureRecognizerHolder(
          recognizers: [licenseTapRecognizer, authorNameTapRecognizer],
          child: SelectableText.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  children: matchTextSpans(
                    L10n.current.licenseInfoPattern('{{label}}'),
                    matchedBuilders: {
                      '{{label}}': (_) => TextSpan(
                        text: 'GPLv3',
                        recognizer: licenseTapRecognizer,
                        style: linkStyle,
                      ),
                    },
                    unmatchedBuilder: (text) => TextSpan(text: text),
                  ),
                ),
                TextSpan(text: '\n'),
                TextSpan(
                  children: matchTextSpans(
                    L10n.current.authorInfoPattern('{{label}}'),
                    matchedBuilders: {
                      '{{label}}': (_) => TextSpan(
                        text: 'Joseph Artsimovich',
                        recognizer: authorNameTapRecognizer,
                        style: linkStyle,
                      ),
                    },
                    unmatchedBuilder: (text) => TextSpan(text: text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _maybeShowPrefixCreationDialog(BuildContext context) {
    if (maybeTellUserToFinishRunningApps(
      context: context,
      appsRunningInAnyPrefixAreAProblem:
          StartupData.instance.wineWillRunUnderMuvm,
    )) {
      return;
    }

    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PrefixCreationDialog(onPrefixCreated: (prefix) {}),
      ),
    );
  }
}

class _WinePrefixesList extends StatefulWidget {
  @override
  State<_WinePrefixesList> createState() => _WinePrefixesListState();
}

class _WinePrefixesListState extends State<_WinePrefixesList> {
  late final WinePrefixRepo _winePrefixRepo;

  late final OldTaskAbandoningWorker<PinnedExecutableSetState>
  _pinnedExecutablesLoadingWorker;

  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    _winePrefixRepo = StartupData.instance.winePrefixRepo;

    _pinnedExecutablesLoadingWorker =
        OldTaskAbandoningWorker<PinnedExecutableSetState>();
  }

  @override
  void dispose() {
    unawaited(_pinnedExecutablesLoadingWorker.abandonOngoingTask());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamListener(
      listeners: [
        (_) => _winePrefixRepo.eventStream.listen(_handlePrefixRepoEvent),
      ],

      // We used to use AnimatedList.separated() here, but then I hit this bug:
      // https://github.com/flutter/flutter/issues/179029
      child: AnimatedList(
        key: _animatedListKey,
        initialItemCount: _winePrefixRepo.orderedPrefixes.length,
        itemBuilder: (context, index, animation) {
          final prefix = _winePrefixRepo.orderedPrefixes[index];
          return _buildAnimatedPrefixWidget(
            prefix: prefix,
            animation: animation,
          );
        },
      ),
    );
  }

  void _handlePrefixRepoEvent(WinePrefixRepoEvent event) {
    final animatedListState = _animatedListKey.currentState!;

    const instantTransitionDuration = Duration.zero;
    const animatedTransitionDuration = Duration(milliseconds: 300);

    switch (event) {
      case WinePrefixAddedEvent evt:
        animatedListState.insertItem(
          evt.newPrefixIndex,
          duration: evt.animatedInsertion
              ? animatedTransitionDuration
              : instantTransitionDuration,
        );
      case WinePrefixRemovedEvent evt:
        animatedListState.removeItem(
          evt.removedPrefixIndex,
          (context, animation) => _buildAnimatedPrefixWidget(
            prefix: evt.removedPrefix,
            animation: animation,
          ),
          duration: evt.animatedRemoval
              ? animatedTransitionDuration
              : instantTransitionDuration,
        );
    }
  }

  Widget _buildAnimatedPrefixWidget({
    required WinePrefix prefix,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: 0.0,
        child: WinePrefixListItemWidget(
          prefix: prefix,
          pinnedExecutablesLoader: () {
            return _pinnedExecutablesLoadingWorker
                .abandonOngoingAndStartNewTask(
                  () => PinnedExecutableSetState.loadFromDisk(
                    prefix.dirStructure.pinsDir,
                  ),
                );
          },
        ),
      ),
    );
  }
}
