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
import 'dart:math';

import 'package:flutter/material.dart';

/// This helper widget displays a button that scrolls a viewport to the top
/// or to the bottom, whichever target is further from the current scroll
/// position.
class ScrollTopBottomButton extends StatefulWidget {
  /// The scroll controller that defines the current scroll position.
  /// Note that this class doesn't take ownership of this controller
  /// and won't dispose it.
  final ScrollController scrollController;

  /// A user-provided callback that builds the button widget.
  /// If `scrollToBottom` is false, the button will be scrolling to the top.
  /// When a button is pressed, it has to call the `onPressed` callback.
  final Widget Function({
    required bool scrollToBottom,
    required VoidCallback onPressed,
  })
  childBuilder;

  const ScrollTopBottomButton({
    super.key,
    required this.scrollController,
    required this.childBuilder,
  });

  @override
  State createState() => _ScrollButtonDirectionState();
}

class _ScrollButtonDirectionState extends State<ScrollTopBottomButton> {
  late VoidCallback _scrollControllerListener;

  @override
  void initState() {
    super.initState();

    _scrollControllerListener = () => setState(() {
      // Just rebuild - no need to update any state.
    });

    widget.scrollController.addListener(_scrollControllerListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.scrollController.hasClients) {
      // Nothing is connected to the scroll controller yet.
      // We return an empty widget for now.
      return SizedBox.shrink();
    }

    final scrollController = widget.scrollController;

    final distanceToTop = max(
      0,
      scrollController.position.pixels -
          scrollController.position.minScrollExtent,
    );

    final distanceToBottom = max(
      0,
      scrollController.position.maxScrollExtent -
          scrollController.position.pixels,
    );

    if (max(distanceToTop, distanceToBottom) == 0) {
      // There is nowhere to scroll - return an empty widget then.
      return SizedBox.shrink();
    }

    final scrollToBottom = distanceToTop < distanceToBottom;

    return widget.childBuilder(
      scrollToBottom: scrollToBottom,
      onPressed: () => unawaited(
        scrollController.animateTo(
          scrollToBottom
              ? scrollController.position.maxScrollExtent
              : scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}
