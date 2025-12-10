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

import 'package:boxy/padding.dart';
import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  final bool enabled;
  final Widget topWidget;
  final Widget? bottomWidget;

  /// If we are told to display a warning suppression checkbox, then both
  /// [isWarningToBeSuppressed] and [onWarningToBeSuppressedToggled] are
  /// non-null. Otherwise, they are both null.
  final bool? isWarningToBeSuppressed;

  final void Function(bool suppressed)? onWarningToBeSuppressedToggled;

  const WarningWidget({
    super.key,
    this.enabled = true,
    required this.topWidget,
    this.bottomWidget,
  }) : isWarningToBeSuppressed = null,
       onWarningToBeSuppressedToggled = null;

  const WarningWidget.withSuppressionOption({
    super.key,
    this.enabled = true,
    required this.topWidget,
    this.bottomWidget,
    required bool this.isWarningToBeSuppressed,
    required void Function(bool suppressed) this.onWarningToBeSuppressedToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = enabled ? theme.colorScheme.error : theme.disabledColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: BoxBorder.all(color: borderColor, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8.0,
        children: [
          topWidget,
          if (onWarningToBeSuppressedToggled != null)
            _buildWarningSuppressionCheckbox(context),
          ?bottomWidget,
        ],
      ),
    );
  }

  Widget _buildWarningSuppressionCheckbox(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        OverflowPadding(
          padding: EdgeInsetsDirectional.only(
            start: -8.0,
            top: -8.0,
            bottom: -8.0,
          ),
          child: Checkbox(
            side: BorderSide().copyWith(
              color: enabled ? null : theme.disabledColor,
              width: 2.0,
            ),
            activeColor: enabled ? null : theme.disabledColor,
            value: isWarningToBeSuppressed,
            onChanged: (checked) =>
                enabled ? onWarningToBeSuppressedToggled!(checked!) : null,
          ),
        ),
        Text(
          "Don't show this warning again",
          style: enabled ? null : TextStyle(color: theme.disabledColor),
        ),
      ],
    );
  }
}
