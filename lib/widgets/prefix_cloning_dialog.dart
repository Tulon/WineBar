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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:winebar/blocs/prefix_cloning/prefix_cloning_bloc.dart';
import 'package:winebar/blocs/prefix_cloning/prefix_cloning_state.dart';
import 'package:winebar/models/process_log.dart';
import 'package:winebar/utils/app_info.dart';
import 'package:winebar/utils/tappable_link.dart';
import 'package:winebar/widgets/process_logs_view_widget.dart';

import '../models/wine_prefix.dart';
import 'error_message_widget.dart';

/// A widget meant to be used with [showDialog] that facilitates
/// cloning one prefix into a newly created one.
///
/// This widget needs [PrefixCloningBloc] to be available via
/// `BlocProvider.of<PrefixCloningBloc>(context)`.
class PrefixCloningDialog extends StatelessWidget {
  final WinePrefix prefixToClone;

  const PrefixCloningDialog({super.key, required this.prefixToClone});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrefixCloningBloc, PrefixCloningState>(
      listener: (context, state) => Navigator.pop(context),
      listenWhen: (previous, current) {
        return current.prefixCloningStatus == PrefixCloningStatus.succeeded &&
            previous.prefixCloningStatus != current.prefixCloningStatus;
      },
      child: BlocBuilder<PrefixCloningBloc, PrefixCloningState>(
        builder: (context, state) =>
            _buildDialogWidget(context: context, state: state),
      ),
    );
  }

  Widget _buildDialogWidget({
    required BuildContext context,
    required PrefixCloningState state,
  }) {
    final bloc = BlocProvider.of<PrefixCloningBloc>(context);
    final theme = Theme.of(context);

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: SizedBox(
            width: 600,
            child: Column(
              spacing: 16.0,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Clone Wine Prefix',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    if (state.prefixCloningStatus !=
                        PrefixCloningStatus.inProgress)
                      CloseButton(),
                  ],
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(prefixToClone.descriptor.name),
                ),
                Icon(
                  MdiIcons.arrowDownBoldOutline,
                  color: theme.colorScheme.primary,
                ),
                TextFormField(
                  autofocus: true,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(
                      AppInfo.maxCharsInPrefixName,
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Target prefix name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (name) => bloc.setTargetPrefixName(name.trim()),
                  onFieldSubmitted: (_) {
                    if (state.readyToClone) {
                      unawaited(
                        bloc.clonePrefixAndHandleErrors(
                          prefixToClone: prefixToClone,
                        ),
                      );
                    }
                  },
                ),
                if (state.prefixCloningFailureMessage != null)
                  ErrorMessageWidget(
                    width: double.infinity,
                    text: state.prefixCloningFailureMessage!,
                    trailingLink: state.prefixCloningFailedProcessLogs.isEmpty
                        ? null
                        : TappableLink(
                            linkText: 'View Logs.',
                            onTapped: () => _showProcessLogs(
                              context: context,
                              logs: state.prefixCloningFailedProcessLogs,
                            ),
                          ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: state.readyToClone
                        ? () => bloc.clonePrefixAndHandleErrors(
                            prefixToClone: prefixToClone,
                          )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      disabledBackgroundColor:
                          state.prefixCloningStatus ==
                              PrefixCloningStatus.inProgress
                          ? theme.colorScheme.primary
                          : null,
                      disabledForegroundColor:
                          state.prefixCloningStatus ==
                              PrefixCloningStatus.inProgress
                          ? theme.colorScheme.onPrimary
                          : null,
                    ),
                    icon:
                        state.prefixCloningStatus ==
                            PrefixCloningStatus.inProgress
                        ? AspectRatio(
                            aspectRatio: 1.0,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              backgroundColor: theme.colorScheme.onPrimary
                                  .withAlpha(100),
                              strokeWidth: 3.0,
                              padding: EdgeInsets.all(12.0),
                            ),
                          )
                        : const Icon(Icons.copy),
                    label: Text(
                      state.prefixCloningStatus ==
                              PrefixCloningStatus.inProgress
                          ? 'Cloning ...'
                          : 'Clone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProcessLogs({
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
