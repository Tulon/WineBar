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
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:winebar/blocs/special_executable/special_executable_state.dart';

class PinExecutableButton extends StatelessWidget {
  final SpecialExecutableState specialExecutableState;
  final void Function()? onPrimaryButtonPressed;
  final void Function()? onKillProcessPressed;
  final void Function()? onViewProcessOutputPressed;

  const PinExecutableButton({
    super.key,
    required this.specialExecutableState,
    this.onPrimaryButtonPressed,
    this.onKillProcessPressed,
    this.onViewProcessOutputPressed,
  });

  @override
  Widget build(BuildContext context) {
    final auxButton = _maybeBuildAuxButton(context);

    return Stack(
      alignment: AlignmentGeometry.directional(1.0, 0.0),
      children: [
        FloatingActionButton.extended(
          extendedPadding: EdgeInsetsDirectional.only(
            start: 20.0,
            end: auxButton == null ? 20.0 : 10.0,
          ),
          label: Row(
            spacing: 4.0,
            mainAxisSize: MainAxisSize.min,
            children: [const Text('Pin Executable'), ?auxButton],
          ),
          icon: Icon(MdiIcons.pin),
          onPressed: specialExecutableState.isRunning
              ? null
              : onPrimaryButtonPressed,
        ),
      ],
    );
  }

  Widget? _maybeBuildAuxButton(BuildContext context) {
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
            padding: EdgeInsets.zero,
            style: _buttonStyleWithHoverColor(Colors.red),
          ),
          IconButton(
            onPressed: onViewProcessOutputPressed,
            tooltip: 'View process output',
            icon: Icon(Icons.article),
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
