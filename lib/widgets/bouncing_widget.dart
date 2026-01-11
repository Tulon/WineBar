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

/// Make its child bounce up and down indefinitely.
class BouncingWidget extends StatefulWidget {
  final Widget child;
  final Duration singleBounceDuration;

  /// The maximum bounce height defined as a fraction of the child's height.
  final double maxRelativeBounceHeight;

  final bool transformHitTests;

  const BouncingWidget({
    super.key,
    required this.child,
    this.singleBounceDuration = const Duration(milliseconds: 600),
    this.maxRelativeBounceHeight = 0.15,
    this.transformHitTests = false,
  });

  @override
  State createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.singleBounceDuration,
      vsync: this,
    );

    _animation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.0,
          end: -widget.maxRelativeBounceHeight,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: -widget.maxRelativeBounceHeight,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(0.0, _animation.value),
          transformHitTests: widget.transformHitTests,
          child: widget.child,
        );
      },
    );
  }
}
