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

class HiDpiScaleSelectionWidget extends StatelessWidget {
  final bool enabled;
  final double? initialScaleFactor;
  final void Function(double) onScaleFactorChanged;
  final bool requiredError;

  const HiDpiScaleSelectionWidget({
    super.key,
    required this.enabled,
    required this.initialScaleFactor,
    required this.onScaleFactorChanged,
    required this.requiredError,
  });

  @override
  Widget build(BuildContext context) {
    final stepScaleDelta = 0.5;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final roundedDevicePixelRatio =
        (devicePixelRatio / stepScaleDelta).round() * stepScaleDelta;

    bool isPerfectScale(double scale) {
      return scale == roundedDevicePixelRatio;
    }

    Widget? buildInfoWidget(double? selectedScale) {
      final textStyle = enabled
          ? null
          : TextStyle(color: Theme.of(context).disabledColor);

      if (selectedScale == null) {
        return null;
      } else if (selectedScale == 1.0) {
        if (roundedDevicePixelRatio > 1.0) {
          return Text(
            "This will make the text too small but won't break older fullscreen apps",
            style: textStyle,
          );
        } else {
          return Text(
            "This is the perfect scale for your display",
            style: textStyle,
          );
        }
      } else {
        if (selectedScale < roundedDevicePixelRatio) {
          return Text(
            "This will help with text being too small but will break older fullscreen apps",
            style: textStyle,
          );
        } else if (selectedScale == roundedDevicePixelRatio) {
          return Text(
            "This is the perfect scale for your display, though it will break older fullscreen apps",
            style: textStyle,
          );
        } else {
          return Text(
            "This may produce text that's too large",
            style: textStyle,
          );
        }
      }
    }

    Widget buildChoiceChip(int step) {
      final scale = 1.0 + step * stepScaleDelta;
      final selected = scale == initialScaleFactor;

      return ChoiceChip(
        label: Text('$scale'),
        avatar: !selected && isPerfectScale(scale) ? Icon(Icons.star) : null,
        selected: selected,
        onSelected: enabled
            ? (bool selected) {
                if (selected) {
                  onScaleFactorChanged(scale);
                }
              }
            : null,
      );
    }

    return InputDecorator(
      decoration: InputDecoration(
        enabled: enabled,
        label: const Text('HiDPI scale'),
        errorText: requiredError ? 'Please select' : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List<Widget>.generate(5, (int step) {
              return buildChoiceChip(step);
            }),
          ),
          ?buildInfoWidget(initialScaleFactor),
        ],
      ),
    );
  }
}
