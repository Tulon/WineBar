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

import '../blocs/process_output_view/process_output_view_bloc.dart';
import '../blocs/process_output_view/process_output_view_state.dart';
import '../models/process_output.dart';

class ProcessOutputWidget extends StatelessWidget {
  @protected
  final ProcessOutput processOutput;

  const ProcessOutputWidget({super.key, required this.processOutput});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => ProcessOutputViewBloc(processOutput: processOutput),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.inversePrimary,
          title: const Text('Process Output'),
          actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
          actions: [
            BlocBuilder<ProcessOutputViewBloc, ProcessOutputViewState>(
              builder: (context, state) {
                return SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: state.processOutput.logs
                      .asMap()
                      .entries
                      .map(
                        (entry) => ButtonSegment<int>(
                          value: entry.key,
                          label: Text(entry.value.name),
                        ),
                      )
                      .toList(),
                  selected: {?state.selectedLogIndex},
                  onSelectionChanged: (Set<int> selection) {
                    final firstElement = selection.firstOrNull;
                    if (firstElement != null) {
                      BlocProvider.of<ProcessOutputViewBloc>(
                        context,
                      ).setSelectedLogIndex(firstElement);
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProcessOutputViewBloc, ProcessOutputViewState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: IndexedStack(
                      sizing: StackFit.expand,
                      index:
                          state.selectedLogIndex ??
                          state.processOutput.logs.length,
                      children: [
                        ...state.processOutput.logs.map(
                          (log) => SelectableText(
                            log.content,
                            style: TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                        Center(
                          child: Text(
                            'No logs were captured from this process',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
