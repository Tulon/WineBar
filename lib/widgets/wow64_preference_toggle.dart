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
import 'package:winebar/models/wine_arch_warning.dart';
import 'package:winebar/widgets/warning_widget.dart';

class Wow64PreferenceToggle extends StatelessWidget {
  final bool enabled;
  final bool wow64ModePreferred;
  final void Function(bool wow64Preferred) onWow64ModePreferredToggled;
  final WineArchWarning? warningToShow;
  final bool isWarningToBeSuppressed;
  final void Function(bool toBeSuppressed) onWarningToBeSuppressedToggled;

  const Wow64PreferenceToggle({
    super.key,
    required this.enabled,
    required this.wow64ModePreferred,
    required this.onWow64ModePreferredToggled,
    required this.warningToShow,
    required this.isWarningToBeSuppressed,
    required this.onWarningToBeSuppressedToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputDecorator(
      decoration: InputDecoration(
        enabled: enabled,
        label: const Text('WOW64 mode'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        spacing: 8.0,
        children: [
          Row(
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Use the WOW64 mode if available',
                style: enabled ? null : TextStyle(color: theme.disabledColor),
              ),
              Switch(
                value: wow64ModePreferred,
                onChanged: enabled ? onWow64ModePreferredToggled : null,
              ),
            ],
          ),
          ?_maybeBuildWarningWidget(context),
        ],
      ),
    );
  }

  Widget? _maybeBuildWarningWidget(BuildContext context) {
    final warning = warningToShow;

    if (warning == null) {
      return null;
    }

    final theme = Theme.of(context);
    final textStyle = TextStyle(
      color: enabled ? theme.colorScheme.error : theme.disabledColor,
    );

    switch (warning) {
      case WineArchWarning.wow64ModeUnderEmulation:
        return _buildWarningWidget(
          warning: warning,
          warningContent: SelectableText(
            'The WOW64 mode under emulation is known to have issues. '
            'Expect a broken installation.',
            key: ValueKey(warning),
            style: textStyle,
          ),
        );
      case WineArchWarning.nonWow64ModesRequire32BitLibs:
        return _buildWarningWidget(
          warning: warning,
          warningContent: SelectableText(
            'Not using the WOW64 mode will require 32-bit libraries to be '
            'present on your system. If you have them already, you can '
            'ignore this warning. Otherwise, install Wine from your '
            "distro's repository, which will bring in those 32-bit "
            'libraries.',
            key: ValueKey(warning),
            style: textStyle,
          ),
        );
    }
  }

  Widget _buildWarningWidget({
    required WineArchWarning warning,
    required Widget warningContent,
  }) {
    if (warning.suppressableWarning == null) {
      return WarningWidget(enabled: enabled, topWidget: warningContent);
    } else {
      return WarningWidget.withSuppressionOption(
        enabled: enabled,
        topWidget: warningContent,
        isWarningToBeSuppressed: isWarningToBeSuppressed,
        onWarningToBeSuppressedToggled: onWarningToBeSuppressedToggled,
      );
    }
  }
}
