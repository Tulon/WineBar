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

import 'package:flutter/material.dart';
import 'package:winebar/utils/l10n.dart';

class DonationSolicitationDialog extends StatelessWidget {
  const DonationSolicitationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: SizedBox(
              width: 600,
              child: SelectableText.rich(
                TextSpan(
                  style: theme.textTheme.bodyLarge,
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Center(
                          child: Image.asset('data/author.jpg', height: 171),
                        ),
                      ),
                    ),
                    TextSpan(text: '\n'),
                    TextSpan(text: L10n.current.donationSolicitationDialogText),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CloseButton(),
            ),
          ),
        ],
      ),
    );
  }
}
