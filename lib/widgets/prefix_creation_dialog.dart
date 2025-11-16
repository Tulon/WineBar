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
import 'package:winebar/utils/startup_data.dart';

import '../blocs/prefix_creation/prefix_creation_bloc.dart';
import '../blocs/prefix_creation/prefix_creation_state.dart';
import '../models/wine_prefix.dart';
import '../repositories/wine_build_source_repo.dart';
import 'error_message_widget.dart';

class PrefixCreationDialog extends StatelessWidget {
  final StartupData startupData;
  final void Function(WinePrefix) onPrefixCreated;

  const PrefixCreationDialog({
    super.key,
    required this.startupData,
    required this.onPrefixCreated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrefixCreationBloc(
        startupData: startupData,
        onPrefixCreated: onPrefixCreated,
      ),
      child: _PrefixCreationStatefulDialog(),
    );
  }
}

class _PrefixCreationStatefulDialog extends StatefulWidget {
  const _PrefixCreationStatefulDialog();

  @override
  State createState() => _PrefixCreationDialogState();
}

// The only reason we need a stateful widget here is to store the controllers
// that need disposing in it. Storing them in a BLoC is considered a bad
// design.
class _PrefixCreationDialogState extends State<_PrefixCreationStatefulDialog> {
  final pageController = PageController();
  final prefixNameController = TextEditingController();
  late final List<_PrefixCreationStep> _steps;

  _PrefixCreationDialogState() {
    _steps = [
      _WineBuildSourceSelectionStep(),
      _WineReleaseSelectionStep(),
      _WineBuildSelectionStep(),
      _WinePrefixOptionsStep(this),
    ];
  }

  @override
  void initState() {
    prefixNameController.addListener(
      () => BlocProvider.of<PrefixCreationBloc>(
        context,
      ).setPrefixName(prefixNameController.text.trim()),
    );

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    prefixNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: MultiBlocListener(
          listeners: [
            BlocListener<PrefixCreationBloc, PrefixCreationState>(
              listener: (context, state) => pageController.animateToPage(
                state.currentStep.index,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              listenWhen: (previous, current) {
                return previous.currentStep != current.currentStep;
              },
            ),
            BlocListener<PrefixCreationBloc, PrefixCreationState>(
              listener: (context, state) => Navigator.pop(context),
              listenWhen: (previous, current) {
                return current.prefixCreationStatus ==
                        PrefixCreationStatus.succeeded &&
                    previous.prefixCreationStatus !=
                        current.prefixCreationStatus;
              },
            ),
          ],
          child: BlocBuilder<PrefixCreationBloc, PrefixCreationState>(
            builder: (context, state) => _buildMainWidget(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context, PrefixCreationState state) {
    final theme = Theme.of(context);
    final bloc = BlocProvider.of<PrefixCreationBloc>(context);

    return Column(
      spacing: 16.0,
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Create a Wine Prefix',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            ),
            if (!state.prefixCreationStatus.isInProgress) CloseButton(),
          ],
        ),
        Expanded(
          child: Row(
            spacing: 8.0,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 300,
                    child: ListView.builder(
                      itemCount: _steps.length,
                      itemBuilder: (context, index) =>
                          _steps[index].buildStatusWidget(
                            context: context,
                            bloc: bloc,
                            state: state,
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {},
                  itemCount: _steps.length,
                  itemBuilder: (context, index) => _steps[index].buildStepPage(
                    context: context,
                    bloc: bloc,
                    state: state,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

abstract class _PrefixCreationStep {
  PrefixCreationStep get step;
  String get title;

  List<Widget> buildPageTitleTrailingWidgets({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    return [];
  }

  Widget buildStepPageContent({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  });

  Widget buildStatusWidget({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    return ListTile(
      enabled:
          !state.prefixCreationStatus.isInProgress &&
          step.index <= state.maxAccessibleStep.index,
      selected: step == state.currentStep,
      title: Text(title),
      leading: Icon(
        state.prefixCreationStatus.isInProgress ||
                step.index < state.maxAccessibleStep.index
            ? Icons.check_circle_outline_outlined
            : Icons.circle_outlined,
      ),
      onTap: () => bloc.navigateToStep(step),
    );
  }

  Widget buildStepPage({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8.0,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: textTheme.titleLarge)),
                ...buildPageTitleTrailingWidgets(
                  context: context,
                  bloc: bloc,
                  state: state,
                ),
              ],
            ),
            Divider(height: 16.0),
            Expanded(
              child: buildStepPageContent(
                context: context,
                bloc: bloc,
                state: state,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WineBuildSourceSelectionStep extends _PrefixCreationStep {
  @override
  final PrefixCreationStep step = PrefixCreationStep.selectWineBuildSource;

  @override
  final String title = 'Select wine build provider';

  @override
  Widget buildStepPageContent({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    final sources = GetIt.I.get<WineBuildSourceRepo>().sources;

    return ListView(
      children: sources
          .map<Widget>(
            (source) => ListTile(
              leading: CircleAvatar(child: Text(source.circleAvatarText)),
              title: Text(source.label),
              onTap: () {
                bloc.selectWineBuildSource(source);
              },
              selected: state.selectedBuildSource == source,
              trailing: state.selectedBuildSource == source
                  ? const Icon(Icons.radio_button_checked)
                  : null,
            ),
          )
          .toList(),
    );
  }
}

class _WineReleaseSelectionStep extends _PrefixCreationStep {
  @override
  final PrefixCreationStep step = PrefixCreationStep.selectWineRelease;

  @override
  final String title = 'Select wine release';

  @override
  List<Widget> buildPageTitleTrailingWidgets({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    return [
      IndexedStack(
        index: state.wineBuildsFetchingInProgress ? 1 : 0,
        alignment: Alignment.center,
        children: [
          OverflowPadding(
            // We apply a negative padding in order to keep
            // the step title height the same for all steps.
            // Without that, the IconButton would force a
            // taller page title for this particular step.
            padding: EdgeInsets.all(-8.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh wine releases',
              onPressed: bloc.refreshWineBuilds,
            ),
          ),
          SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              padding: EdgeInsets.all(4.0),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget buildStepPageContent({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    if (state.wineBuildsFetchingErrorMessage != null) {
      return ErrorMessageWidget(
        text: state.wineBuildsFetchingErrorMessage!,
        width: double.infinity,
      );
    } else {
      return ListView(
        children: state.wineReleasesToSelectFrom
            .map<Widget>(
              (release) => ListTile(
                title: Text(release.releaseName),
                onTap: () {
                  bloc.selectWineRelease(release);
                },
                selected: state.selectedWineRelease == release,
                trailing: state.selectedWineRelease == release
                    ? const Icon(Icons.radio_button_checked)
                    : null,
              ),
            )
            .toList(),
      );
    }
  }
}

class _WineBuildSelectionStep extends _PrefixCreationStep {
  @override
  final PrefixCreationStep step = PrefixCreationStep.selectWineBuild;

  @override
  final String title = 'Select wine build';

  @override
  Widget buildStepPageContent({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    return ListView(
      children: state.wineBuildsToSelectFrom
          .map<Widget>(
            (build) => ListTile(
              title: Text(build.archiveFileName),
              onTap: () {
                bloc.selectWineBuild(build);
              },
              selected: state.selectedWineBuild == build,
              trailing: state.selectedWineBuild == build
                  ? const Icon(Icons.radio_button_checked)
                  : null,
            ),
          )
          .toList(),
    );
  }
}

class _WinePrefixOptionsStep extends _PrefixCreationStep {
  @override
  final PrefixCreationStep step = PrefixCreationStep.setOptions;

  @override
  final String title = 'Set options';

  final _PrefixCreationDialogState widgetState;

  _WinePrefixOptionsStep(this.widgetState);

  @override
  Widget buildStepPageContent({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    final theme = Theme.of(context);

    String getPrefixCreationButtonText() {
      switch (state.prefixCreationStatus) {
        case PrefixCreationStatus.notStarted:
        case PrefixCreationStatus.failed:
        case PrefixCreationStatus.succeeded:
          return 'Create Prefix';
        case PrefixCreationStatus.downloadingAndExtractingWineBuild:
          return 'Downloading and Extracting ...';
        case PrefixCreationStatus.creatingWinePrefix:
          return 'Creating Wine Prefix ...';
      }
    }

    final mayInitiatePrefixCreation =
        state.prefixName.isNotEmpty &&
        state.prefixNameErrorMessage == null &&
        !state.prefixCreationStatus.isInProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16.0,
      children: [
        TextField(
          enabled: !state.prefixCreationStatus.isInProgress,
          controller: widgetState.prefixNameController,
          onSubmitted: mayInitiatePrefixCreation
              ? (_) => bloc.startCreatingPrefix()
              : null,
          decoration: InputDecoration(
            hintText: 'Enter a name for the prefix',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.create_new_folder),
            errorText: state.prefixNameErrorMessage,
          ),
        ),
        _buildHiDpiControls(context: context, bloc: bloc, state: state),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: mayInitiatePrefixCreation
                ? () => bloc.startCreatingPrefix()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              disabledBackgroundColor: state.prefixCreationStatus.isInProgress
                  ? theme.colorScheme.primary
                  : null,
              disabledForegroundColor: state.prefixCreationStatus.isInProgress
                  ? theme.colorScheme.onPrimary
                  : null,
            ),
            icon: state.prefixCreationStatus.isInProgress
                ? AspectRatio(
                    aspectRatio: 1.0,
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.onPrimary,
                      backgroundColor: theme.colorScheme.onPrimary.withAlpha(
                        100,
                      ),
                      strokeWidth: 3.0,
                      padding: EdgeInsets.all(12.0),
                      value: state.prefixCreationStatus.isInProgress
                          ? state.prefixCreationOperationProgress
                          : null,
                    ),
                  )
                : const Icon(Icons.add_circle),
            label: Text(
              getPrefixCreationButtonText(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (state.prefixCreationFailureMessage != null)
          ErrorMessageWidget(
            text: state.prefixCreationFailureMessage!,
            width: double.infinity,
          ),
      ],
    );
  }

  Widget _buildHiDpiControls({
    required BuildContext context,
    required PrefixCreationBloc bloc,
    required PrefixCreationState state,
  }) {
    final stepScaleDelta = 0.5;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final roundedDevicePixelRatio =
        (devicePixelRatio / stepScaleDelta).round() * stepScaleDelta;

    bool isPerfectScale(double scale) {
      return scale == roundedDevicePixelRatio;
    }

    Widget? buildHelperWidget(double selectedScale) {
      if (selectedScale == 1.0) {
        if (roundedDevicePixelRatio > 1.0) {
          return const Text(
            "This will make the text too small but won't break older fullscreen apps",
          );
        } else {
          return const Text("This is the perfect scale for your display");
        }
      } else {
        if (selectedScale < roundedDevicePixelRatio) {
          return const Text(
            "This will help with text being too small but will break older fullscreen apps",
          );
        } else if (selectedScale == roundedDevicePixelRatio) {
          return const Text(
            "This is the perfect scale for your display, though it will break older fullscreen apps",
          );
        } else {
          return const Text("This may produce text that's too large");
        }
      }
    }

    Widget buildChoiceChip(int step) {
      final scale = 1.0 + step * stepScaleDelta;
      final selected = scale == state.hiDpiScale;

      return ChoiceChip(
        label: Text('$scale'),
        avatar: !selected && isPerfectScale(scale) ? Icon(Icons.star) : null,
        selected: selected,
        onSelected: state.prefixCreationStatus.isInProgress
            ? null
            : (bool selected) {
                if (selected) {
                  bloc.setHiDpiScale(scale);
                }
              },
      );
    }

    return InputDecorator(
      decoration: InputDecoration(
        label: const Text('HiDPI scale'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        helper: buildHelperWidget(state.hiDpiScale),
      ),
      child: Wrap(
        spacing: 8.0,
        children: List<Widget>.generate(5, (int step) {
          return buildChoiceChip(step);
        }),
      ),
    );
  }
}
