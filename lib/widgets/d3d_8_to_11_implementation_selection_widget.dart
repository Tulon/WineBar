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

import 'package:boxy/padding.dart';
import 'package:flutter/material.dart';
import 'package:winebar/models/d3d_8_to_11_implementation.dart';

class D3d8To11ImplementationSelectionWidget extends StatelessWidget {
  final bool enabled;
  final bool useParticularImplementation;
  final void Function(bool) onUseParticularImplementationToggled;
  final D3d8To11Implementation selectedImplementation;
  final void Function(D3d8To11Implementation) onImplementationSelected;

  const D3d8To11ImplementationSelectionWidget({
    super.key,
    required this.enabled,
    required this.useParticularImplementation,
    required this.onUseParticularImplementationToggled,
    required this.selectedImplementation,
    required this.onImplementationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputDecorator(
      decoration: InputDecoration(
        enabled: enabled,
        label: const Text('Direct3D 8-11 implementation'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Row(
            children: [
              OverflowPadding(
                padding: EdgeInsetsDirectional.only(
                  start: -8.0,
                  top: -4.0,
                  bottom: -8.0,
                ),
                child: Checkbox(
                  side: BorderSide().copyWith(
                    color: enabled ? null : theme.disabledColor,
                    width: 2.0,
                  ),
                  activeColor: enabled ? null : theme.disabledColor,
                  value: useParticularImplementation,
                  onChanged: !enabled
                      ? null
                      : (checked) => onUseParticularImplementationToggled(
                          checked == true,
                        ),
                ),
              ),
              Expanded(
                child: Text(
                  'Use a particular Direct3D 8-11 implementation',
                  style: enabled ? null : TextStyle(color: theme.disabledColor),
                ),
              ),
            ],
          ),
          DropdownMenu<D3d8To11Implementation>(
            enabled: enabled && useParticularImplementation,
            expandedInsets: EdgeInsets.zero,
            initialSelection: selectedImplementation,

            // We don't want searching by text.
            requestFocusOnTap: false,

            onSelected: (impl) {
              if (impl != null) {
                onImplementationSelected(impl);
              }
            },
            dropdownMenuEntries: D3d8To11Implementation.values
                .map(
                  (impl) => DropdownMenuEntry<D3d8To11Implementation>(
                    value: impl,
                    label: impl.label,
                  ),
                )
                .toList(),
          ),
          SelectableText(
            useParticularImplementation
                ? selectedImplementation.explanationText
                : 'A default implementation for this particular Wine build will be used',
            style: enabled ? null : TextStyle(color: theme.disabledColor),
          ),
        ],
      ),
    );
  }
}
