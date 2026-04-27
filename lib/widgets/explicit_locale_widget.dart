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
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:winebar/models/explicit_locale_state.dart';
import 'package:winebar/models/wine_locale.dart';
import 'package:winebar/utils/startup_data.dart';

class ExplicitLocaleWidget extends StatelessWidget {
  final bool enabled;
  final ExplicitLocaleState state;
  final void Function(ExplicitLocaleState newState) onStateChanged;

  const ExplicitLocaleWidget({
    super.key,
    required this.enabled,
    required this.state,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startupData = StartupData.instance;

    return InputDecorator(
      decoration: InputDecoration(
        enabled: enabled,
        label: const Text('Locale'),
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
                  value: state.useParticularLocale,
                  onChanged: !enabled
                      ? null
                      : (checked) => onStateChanged(
                          state.copyWith(useParticularLocale: checked == true),
                        ),
                ),
              ),
              Expanded(
                child: Text(
                  'Use a particular locale',
                  style: enabled ? null : TextStyle(color: theme.disabledColor),
                ),
              ),
            ],
          ),

          // The reason we don't use the built-in DropdownMenu class is that
          // it's very slow with as few elements as 1000.
          DropdownSearch<WineLocale>(
            enabled: enabled && state.useParticularLocale,
            filterFn: (locale, filter) =>
                locale.matchesLowerCaseSearchString(filter.toLowerCase()),
            items: (filter, loadProps) {
              assert(loadProps == null);

              // There is no need to apply the filter here, as filterFn
              // will get called anyway.
              return startupData.wineLocaleRepo.localesOrderedByDisplayString
                  .toList();
            },
            selectedItem: state.selectedLocale,
            onSelected: (selectedLocale) => onStateChanged(
              state.copyWith(selectedLocaleGetter: () => selectedLocale),
            ),
            itemAsString: (locale) => locale.displayString,
            compareFn: (item1, item2) => item1 == item2,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                autofocus: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                ),
              ),
            ),
          ),

          SelectableText(
            state.useParticularLocale
                ? 'This may help with text display in non-Unicode apps'
                : 'The system locale will be used by Windows apps',
            style: enabled ? null : TextStyle(color: theme.disabledColor),
          ),
        ],
      ),
    );
  }
}
