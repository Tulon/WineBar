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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/widgets/error_message_widget.dart';
import 'package:winebar/widgets/hi_dpi_scale_selection_widget.dart';

import '../blocs/prefix_settings/prefix_settings_bloc.dart';
import '../blocs/prefix_settings/prefix_settings_state.dart';
import '../models/wine_prefix.dart';

class PrefixSettingsDialog extends StatelessWidget {
  final StartupData startupData;
  final WinePrefix prefix;
  final void Function(WinePrefix) onPrefixUpdated;

  const PrefixSettingsDialog({
    super.key,
    required this.startupData,
    required this.prefix,
    required this.onPrefixUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => PrefixSettingsBloc(
        startupData: startupData,
        prefix: prefix,
        onPrefixUpdated: onPrefixUpdated,
      ),
      child: BlocListener<PrefixSettingsBloc, PrefixSettingsState>(
        listener: (context, state) => Navigator.pop(context),
        listenWhen: (previous, current) {
          return current.prefixUpdateStatus == PrefixUpdateStatus.succeeded &&
              previous.prefixUpdateStatus != current.prefixUpdateStatus;
        },
        child: Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<PrefixSettingsBloc, PrefixSettingsState>(
                builder: (context, state) {
                  return SizedBox(
                    width: 600,
                    child: Column(
                      spacing: 16.0,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: theme.textTheme.headlineSmall,
                                    children: [
                                      TextSpan(text: 'Wine Prefix '),
                                      TextSpan(
                                        text: prefix.descriptor.name,
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      TextSpan(text: ' Settings '),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (state.prefixUpdateStatus !=
                                PrefixUpdateStatus.inProgress)
                              CloseButton(),
                          ],
                        ),
                        HiDpiScaleSelectionWidget(
                          initialScaleFactor: state.hiDpiScale,
                          onScaleFactorChanged:
                              state.prefixUpdateStatus ==
                                  PrefixUpdateStatus.inProgress
                              ? null
                              : (hiDpiScale) {
                                  BlocProvider.of<PrefixSettingsBloc>(
                                    context,
                                  ).setHiDpiScale(hiDpiScale);
                                },
                          requiredError:
                              state.prefixUpdateStatus ==
                                  PrefixUpdateStatus.validationFailed &&
                              state.hiDpiScale == null,
                        ),
                        _buildUpdatePrefixButton(context, state),
                        if (state.prefixUpdateFailureMessage != null)
                          ErrorMessageWidget(
                            text: state.prefixUpdateFailureMessage!,
                            width: double.infinity,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdatePrefixButton(
    BuildContext context,
    PrefixSettingsState state,
  ) {
    final theme = Theme.of(context);

    String getButtonText() {
      switch (state.prefixUpdateStatus) {
        case PrefixUpdateStatus.notStarted:
        case PrefixUpdateStatus.validationFailed:
        case PrefixUpdateStatus.failed:
        case PrefixUpdateStatus.succeeded:
          return 'Update Wine Prefix';
        case PrefixUpdateStatus.inProgress:
          return 'Updating Wine Prefix ...';
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: state.prefixUpdateStatus == PrefixUpdateStatus.inProgress
            ? null
            : BlocProvider.of<PrefixSettingsBloc>(context).startUpdatingPrefix,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor:
              state.prefixUpdateStatus == PrefixUpdateStatus.inProgress
              ? theme.colorScheme.primary
              : null,
          disabledForegroundColor:
              state.prefixUpdateStatus == PrefixUpdateStatus.inProgress
              ? theme.colorScheme.onPrimary
              : null,
        ),
        icon: state.prefixUpdateStatus == PrefixUpdateStatus.inProgress
            ? AspectRatio(
                aspectRatio: 1.0,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.onPrimary,
                  backgroundColor: theme.colorScheme.onPrimary.withAlpha(100),
                  strokeWidth: 3.0,
                  padding: EdgeInsets.all(12.0),
                ),
              )
            : null,
        label: Text(
          getButtonText(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
