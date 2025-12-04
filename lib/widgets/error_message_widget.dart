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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatefulWidget {
  final String text;
  final double? width;
  final double? height;
  final void Function()? onViewLogsPressed;

  const ErrorMessageWidget({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.onViewLogsPressed,
  });

  @override
  State<ErrorMessageWidget> createState() => _ErrorMessageWidgetState();
}

class _ErrorMessageWidgetState extends State<ErrorMessageWidget> {
  late TapGestureRecognizer _viewLogsTapRecognizer;

  @override
  void initState() {
    super.initState();
    _viewLogsTapRecognizer = TapGestureRecognizer()
      ..onTap = widget.onViewLogsPressed;
  }

  @override
  void dispose() {
    _viewLogsTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String? adaptedText;
    if (widget.onViewLogsPressed != null &&
        widget.text.isNotEmpty &&
        !widget.text.endsWith('.')) {
      adaptedText = '${widget.text}. ';
    } else {
      adaptedText = '${widget.text} ';
    }

    const linkStyle = TextStyle(
      decoration: TextDecoration.underline,
      color: Color(0xff1e88e5),
      decorationColor: Color(0xff1e88e5),
    );

    // The Column is necessary to prevent the SelectableText widget from
    // occupying all the available vertical space, should it be under
    // a Column -> Expanded.
    return Column(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.error),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SelectableText.rich(
            TextSpan(
              style: TextStyle(color: colorScheme.error, fontSize: 16),
              children: [
                TextSpan(text: adaptedText),
                if (widget.onViewLogsPressed != null)
                  TextSpan(
                    text: 'View Logs.',
                    style: linkStyle,
                    recognizer: _viewLogsTapRecognizer,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
