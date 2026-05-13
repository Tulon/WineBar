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
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/blocs/prefix_cloning/prefix_cloning_bloc.dart';
import 'package:winebar/blocs/prefix_cloning/prefix_cloning_state.dart';
import 'package:winebar/models/prefix_descriptor.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/widgets/prefix_cloning_dialog.dart';

@GenerateNiceMocks([
  MockSpec<PrefixCloningBloc>(),
  MockSpec<NavigatorObserver>(),
])
import 'prefix_cloning_dialog_test.mocks.dart';

void main() {
  setUp(() => GetIt.I.reset());
  testWidgets('Prefix cloning UI is functional', (tester) async {
    await tester.binding.setSurfaceSize(Size(1280, 720));

    final toplevelDataDir = '/WineBarData';
    final prefixOuterDir = path.join(toplevelDataDir, 'wine-prefixes/prefix');
    final relPathToWineInstall = 'wine-installations/installation';
    final targetPrefixName = 'Target Prefix Name';

    var prefixCloningState = PrefixCloningState.defaultState();
    final prefixCloningStateStreamController =
        StreamController<PrefixCloningState>.broadcast();
    final prefixCloningBloc = MockPrefixCloningBloc();
    final navigatorObserver = MockNavigatorObserver();

    when(prefixCloningBloc.state).thenReturn(prefixCloningState);

    when(
      prefixCloningBloc.stream,
    ).thenAnswer((_) => prefixCloningStateStreamController.stream);

    when(prefixCloningBloc.setTargetPrefixName(targetPrefixName)).thenAnswer((
      _,
    ) {
      prefixCloningState = prefixCloningState.copyWith(
        targetPrefixName: targetPrefixName,
      );
      prefixCloningStateStreamController.add(prefixCloningState);
    });

    final prefixToClone = WinePrefix(
      status: WinePrefixStatus.operational,
      dirStructure: WinePrefixDirStructure.fromOuterDir(prefixOuterDir),
      descriptor: WinePrefixDescriptor(
        name: 'Source Prefix',
        relPathToWineInstall: relPathToWineInstall,
        hiDpiScale: 1.0,
        wow64ModePreferred: null,
        d3d8To11Implementation: null,
        explicitLocalePosixName: null,
      ),
    );

    await tester.pumpWidget(
      TestWidget(
        prefixToClone: prefixToClone,
        prefixCloningBloc: prefixCloningBloc,
        navigatorObserver: navigatorObserver,
      ),
    );

    final targetPrefixNameFieldFinder = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        final decoration = widget.decoration;
        return decoration?.hintText == 'Target prefix name';
      }
      return false;
    });
    expect(targetPrefixNameFieldFinder, findsOneWidget);

    await tester.enterText(targetPrefixNameFieldFinder, targetPrefixName);
    await tester.pumpAndSettle();

    expect(prefixCloningState.readyToClone, isTrue);

    final clonePrefixButtonFinder = find.text('Clone');
    expect(clonePrefixButtonFinder, findsOneWidget);

    await tester.tap(clonePrefixButtonFinder);
    await tester.pumpAndSettle();

    verify(
      prefixCloningBloc.clonePrefixAndHandleErrors(
        prefixToClone: prefixToClone,
      ),
    );

    prefixCloningState = prefixCloningState.copyWith(
      prefixCloningStatus: PrefixCloningStatus.succeeded,
    );
    prefixCloningStateStreamController.add(prefixCloningState);

    await tester.pumpAndSettle();
    verify(navigatorObserver.didPop(any, any));
  });
}

class TestWidget extends StatelessWidget {
  final WinePrefix prefixToClone;
  final PrefixCloningBloc prefixCloningBloc;
  final NavigatorObserver navigatorObserver;

  const TestWidget({
    super.key,
    required this.prefixToClone,
    required this.prefixCloningBloc,
    required this.navigatorObserver,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [navigatorObserver],
      home: BlocProvider<PrefixCloningBloc>.value(
        value: prefixCloningBloc,
        child: PrefixCloningDialog(prefixToClone: prefixToClone),
      ),
    );
  }
}
