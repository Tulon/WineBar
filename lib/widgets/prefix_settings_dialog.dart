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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winebar/models/process_log.dart';
import 'package:winebar/utils/tappable_link.dart';
import 'package:winebar/widgets/d3d_8_to_11_implementation_selection_widget.dart';
import 'package:winebar/widgets/error_message_widget.dart';
import 'package:winebar/widgets/hi_dpi_scale_selection_widget.dart';
import 'package:winebar/widgets/process_logs_view_widget.dart';
import 'package:winebar/widgets/wow64_preference_toggle.dart';

import '../blocs/prefix_settings/prefix_settings_bloc.dart';
import '../blocs/prefix_settings/prefix_settings_state.dart';
import '../models/wine_prefix.dart';

class PrefixSettingsDialog extends StatelessWidget {
  final WinePrefix prefix;
  final void Function(WinePrefix) onPrefixUpdated;

  const PrefixSettingsDialog({
    super.key,
    required this.prefix,
    required this.onPrefixUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PrefixSettingsBloc(prefix: prefix, onPrefixUpdated: onPrefixUpdated),
      child: BlocListener<PrefixSettingsBloc, PrefixSettingsState>(
        listener: (context, state) => Navigator.pop(context),
        listenWhen: (previous, current) {
          return current.prefixUpdateStatus == PrefixUpdateStatus.succeeded &&
              previous.prefixUpdateStatus != current.prefixUpdateStatus;
        },
        child: _buildDialogWidget(context),
      ),
    );
  }

  Dialog _buildDialogWidget(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<PrefixSettingsBloc, PrefixSettingsState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<PrefixSettingsBloc>(context);

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
                                  TextSpan(text: ' Settings'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (!state.prefixUpdateStatus.isInProgress)
                          CloseButton(),
                      ],
                    ),
                    HiDpiScaleSelectionWidget(
                      enabled: !state.prefixUpdateStatus.isInProgress,
                      initialScaleFactor: state.hiDpiScale,
                      onScaleFactorChanged: (hiDpiScale) {
                        bloc.setHiDpiScale(hiDpiScale);
                      },
                      requiredError:
                          state.prefixUpdateStatus ==
                              PrefixUpdateStatus.validationFailed &&
                          state.hiDpiScale == null,
                    ),
                    ?_maybeBuildWow64PreferenceToggle(context, state),
                    D3d8To11ImplementationSelectionWidget(
                      enabled: !state.prefixUpdateStatus.isInProgress,
                      useParticularImplementation:
                          state.useParticularD3d8To11Implementation,
                      onUseParticularImplementationToggled:
                          bloc.setUseParticularD3d8To11Implementation,
                      selectedImplementation:
                          state.selectedD3d8To11Implementation,
                      onImplementationSelected:
                          bloc.setSelectedD3d8To11Implementation,
                    ),
                    _buildUpdatePrefixButton(context, state),
                    if (state.prefixUpdateFailureMessage != null)
                      ErrorMessageWidget(
                        width: double.infinity,
                        text: state.prefixUpdateFailureMessage!,
                        trailingLink:
                            state.prefixUpdateFailedProcessResult == null
                            ? null
                            : TappableLink(
                                linkText: 'View Logs.',
                                onTapped: () => _showWineProcessLogs(
                                  context: context,
                                  logs: state
                                      .prefixUpdateFailedProcessResult!
                                      .logs,
                                ),
                              ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget? _maybeBuildWow64PreferenceToggle(
    BuildContext context,
    PrefixSettingsState state,
  ) {
    final wow64ModePreferred = state.wow64ModePreferred;
    if (wow64ModePreferred == null) {
      return null;
    }

    final bloc = BlocProvider.of<PrefixSettingsBloc>(context);

    return Wow64PreferenceToggle(
      enabled: !state.prefixUpdateStatus.isInProgress,
      wow64ModePreferred: state.wow64ModePreferred!,
      onWow64ModePreferredToggled: bloc.setWow64ModePreferred,
      warningToShow: state.wow64ModePreferenceWarning,
      isWarningToBeSuppressed: state.wow64ModePreferenceWarningToBeSuppressed,
      onWarningToBeSuppressedToggled:
          bloc.setWow64ModePreferenceWarningToBeSuppressed,
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
        case PrefixUpdateStatus.starting:
          return 'Starting ...';
        case PrefixUpdateStatus.downloadingAndExtractingDxvk:
          return 'Downloading and Extracting DXVK ...';
        case PrefixUpdateStatus.updatingPrefix:
          return 'Updating Wine Prefix ...';
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: state.prefixUpdateStatus.isInProgress
            ? null
            : BlocProvider.of<PrefixSettingsBloc>(context).startUpdatingPrefix,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: state.prefixUpdateStatus.isInProgress
              ? theme.colorScheme.primary
              : null,
          disabledForegroundColor: state.prefixUpdateStatus.isInProgress
              ? theme.colorScheme.onPrimary
              : null,
        ),
        icon: state.prefixUpdateStatus.isInProgress
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

  void _showWineProcessLogs({
    required BuildContext context,
    required List<ProcessLog> logs,
  }) {
    unawaited(
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProcessLogsViewWidget(processLogs: logs),
        ),
      ),
    );
  }
}
