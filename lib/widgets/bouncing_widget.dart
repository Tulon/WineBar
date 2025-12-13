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
