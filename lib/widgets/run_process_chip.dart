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
import 'package:winebar/blocs/special_executable/special_executable_state.dart';

class RunProcessChip extends StatelessWidget {
  static const double auxButtonIconSize = 18.0;
  static const double chipExtraSpaceForAuxButton = 22.0;
  final Widget? primaryButtonIcon;
  final Widget primaryButtonLabel;
  final SpecialExecutableState specialExecutableState;
  final void Function()? onPrimaryButtonPressed;
  final void Function()? onKillProcessPressed;
  final void Function()? onViewProcessOutputPressed;

  const RunProcessChip({
    super.key,
    required this.primaryButtonIcon,
    required this.primaryButtonLabel,
    required this.specialExecutableState,
    this.onPrimaryButtonPressed,
    this.onKillProcessPressed,
    this.onViewProcessOutputPressed,
  });

  @override
  Widget build(BuildContext context) {
    double extraSpace = 0.0;
    if (specialExecutableState.isRunning ||
        specialExecutableState.processOutput != null) {
      extraSpace = chipExtraSpaceForAuxButton;
    }

    return Stack(
      alignment: AlignmentGeometry.directional(1.0, 0.0),
      children: [
        ActionChip(
          avatar: primaryButtonIcon,
          label: primaryButtonLabel,
          labelPadding: EdgeInsetsDirectional.only(end: extraSpace),
          onPressed: onPrimaryButtonPressed,
        ),
        ?maybeBuildAuxButton(context),
      ],
    );
  }

  Widget? maybeBuildAuxButton(BuildContext context) {
    int stackIndex = 0;
    if (specialExecutableState.isRunning) {
      stackIndex = 0; // The "Kill process" page.
    } else if (specialExecutableState.processOutput != null) {
      stackIndex = 1; // The "View process output" page.
    } else {
      return null; // No aux button needed.
    }

    return SizedBox(
      width: 32.0,
      height: 32.0,
      child: IndexedStack(
        index: stackIndex,
        children: [
          IconButton(
            onPressed: onKillProcessPressed,
            tooltip: 'Kill process',
            icon: Icon(Icons.cancel_outlined),
            iconSize: auxButtonIconSize,
            padding: EdgeInsets.zero,
            style: _buttonStyleWithHoverColor(Colors.red),
          ),
          IconButton(
            onPressed: onViewProcessOutputPressed,
            tooltip: 'View process output',
            icon: Icon(Icons.article),
            iconSize: auxButtonIconSize,
            padding: EdgeInsets.zero,
            style: _buttonStyleWithHoverColor(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyleWithHoverColor(Color hoverColor) {
    return ButtonStyle(
      iconColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return hoverColor;
        }
        return null;
      }),
    );
  }
}
