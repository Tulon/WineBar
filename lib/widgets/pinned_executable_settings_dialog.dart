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

import 'package:boxy/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:winebar/blocs/pinned_executable_settings/pinned_executable_settings_bloc.dart';
import 'package:winebar/blocs/pinned_executable_settings/pinned_executable_settings_state.dart';
import 'package:winebar/models/gpu_info.dart';
import 'package:winebar/models/pinned_executable.dart';

class PinnedExecutableSettingsDialog extends StatelessWidget {
  final PinnedExecutable pinnedExecutable;
  final void Function(PinnedExecutable) onPinnedExecutableUpdated;

  const PinnedExecutableSettingsDialog({
    super.key,
    required this.pinnedExecutable,
    required this.onPinnedExecutableUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder<List<GpuInfo>>(
        future: GetIt.I.getAsync<List<GpuInfo>>(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the list of available GPUs is loading, we show a
            //loading screen.
            return Center(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: CircularProgressIndicator(strokeWidth: 7.0),
              ),
            );
          } else {
            return _buildDialogContent(
              context,
              availableGpus: snapshot.data ?? [],
            );
          }
        },
      ),
    );
  }

  Widget _buildDialogContent(
    BuildContext context, {
    required List<GpuInfo> availableGpus,
  }) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) {
        return PinnedExecutableSettingsBloc(
          settings: pinnedExecutable.settings,
          availableGpus: availableGpus,
        );
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child:
              BlocBuilder<
                PinnedExecutableSettingsBloc,
                PinnedExecutableSettingsState
              >(
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
                                      TextSpan(
                                        text: pinnedExecutable.label,
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
                            CloseButton(),
                          ],
                        ),
                        _buildGpuSelectionWidget(
                          context: context,
                          state: state,
                          availableGpus: availableGpus,
                        ),
                        _buildSaveButton(context: context, state: state),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  Widget _buildGpuSelectionWidget({
    required BuildContext context,
    required PinnedExecutableSettingsState state,
    required List<GpuInfo> availableGpus,
  }) {
    final theme = Theme.of(context);
    final bloc = BlocProvider.of<PinnedExecutableSettingsBloc>(context);
    final maySelectGpu = availableGpus.isNotEmpty;

    final useParticularGpuWidget = Row(
      children: [
        OverflowPadding(
          padding: EdgeInsetsDirectional.only(
            start: -8.0,
            top: -4.0,
            bottom: -8.0,
          ),
          child: Checkbox(
            side: BorderSide().copyWith(
              color: maySelectGpu ? null : theme.disabledColor,
              width: 2.0,
            ),
            activeColor: maySelectGpu ? null : theme.disabledColor,
            value: maySelectGpu && state.isParticularGpuToBeUsed,
            onChanged: (checked) {
              if (maySelectGpu) {
                bloc.setParticularGpuToBeUsed(checked == true);
              }
            },
          ),
        ),
        const Text('Use a particular GPU'),
      ],
    );

    return InputDecorator(
      decoration: InputDecoration(
        label: const Text('GPU selection'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          maySelectGpu
              ? useParticularGpuWidget
              : Tooltip(
                  message: 'Failed to get the list of available GPUs',
                  child: useParticularGpuWidget,
                ),
          DropdownMenu<GpuInfo>(
            expandedInsets: EdgeInsets.zero,
            enabled: maySelectGpu && state.isParticularGpuToBeUsed,
            initialSelection: state.selectedGpu,

            // We don't want searching by text.
            requestFocusOnTap: false,

            onSelected: (gpuInfo) {
              bloc.setSelectedGpu(gpuInfo);
            },
            dropdownMenuEntries: availableGpus
                .map(
                  (gpuInfo) => DropdownMenuEntry<GpuInfo>(
                    value: gpuInfo,
                    label: gpuInfo.name,
                  ),
                )
                .toList(),
          ),
          if (state.isParticularGpuToBeUsed)
            const SelectableText(
              "Note that this feature doesn't work in all scenarios.",
            ),
        ],
      ),
    );
  }

  Widget _buildSaveButton({
    required BuildContext context,
    required PinnedExecutableSettingsState state,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          onPinnedExecutableUpdated(
            pinnedExecutable.copyWith(settings: state.toSettings()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: Text(
          'Save',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
