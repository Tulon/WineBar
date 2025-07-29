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

import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;

  const ErrorMessageWidget({
    super.key,
    required this.text,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // The Column is necessary to prevent the SelectableText widget from
    // occupying all the available vertical space, should it be under
    // a Column -> Expanded.
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.error),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SelectableText(
            text,
            style: TextStyle(color: colorScheme.error, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
