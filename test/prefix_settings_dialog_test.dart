import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:winebar/models/prefix_descriptor.dart';
import 'package:winebar/models/special_executable_slot.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/repositories/running_executables_repo.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/services/dxvk_installation_service.dart';
import 'package:winebar/services/utility_service.dart';
import 'package:winebar/utils/local_storage_paths.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/utils/wine_tasks.dart';
import 'package:winebar/widgets/prefix_settings_dialog.dart';

@GenerateNiceMocks([
  MockSpec<AppSettingsService>(),
  MockSpec<DxvkInstallationService>(),
  MockSpec<DxvkInstallationPlan>(),
  MockSpec<UpdatedPrefixReceiver>(),
  MockSpec<UtilityService>(),
  MockSpec<StartupData>(),
  MockSpec<LocalStoragePaths>(),
  MockSpec<IoOps>(),
  MockSpec<File>(),
  MockSpec<RunningExecutablesRepo>(),
  MockSpec<WineTasks>(),
])
import 'prefix_settings_dialog_test.mocks.dart';

void main() {
  testWidgets('HiDpiScale gets picked up and updataed', (tester) async {
    await tester.binding.setSurfaceSize(Size(1280, 720));

    final toplevelDataDir = '/WineBarData';
    final prefixOuterDir = path.join(toplevelDataDir, 'wine-prefixes/prefix');
    final prefixJsonFilePath = path.join(prefixOuterDir, 'prefix.json');
    final relPathToWineInstall = 'wine-installations/installation';

    final appSettingsService = MockAppSettingsService();
    final dxvkInstallationService = MockDxvkInstallationService();
    final dxvkInstallationPlan = MockDxvkInstallationPlan();
    final updatedPrefixReceiver = MockUpdatedPrefixReceiver();
    final utilityService = MockUtilityService();
    final startupData = MockStartupData();
    final localStoragePaths = MockLocalStoragePaths();
    final wineTasks = MockWineTasks();

    final runningSpecialExecutablesRepo =
        MockRunningExecutablesRepo<SpecialExecutableSlot>();

    final ioOps = MockIoOps();
    final prefixJsonFile = MockFile();

    when(startupData.localStoragePaths).thenReturn(localStoragePaths);

    when(localStoragePaths.toplevelDataDir).thenReturn(toplevelDataDir);

    when(
      dxvkInstallationService.buildDxvkInstallationPlan(
        dxvkWanted: anyNamed('dxvkWanted'),
        localStoragePaths: anyNamed('localStoragePaths'),
        wineInstDescriptor: anyNamed('wineInstDescriptor'),
      ),
    ).thenAnswer((_) async => dxvkInstallationPlan);

    when(dxvkInstallationPlan.needDownloadAndExtract).thenReturn(false);
    when(dxvkInstallationPlan.needInstall).thenReturn(false);
    when(dxvkInstallationPlan.needActivate).thenReturn(false);

    when(ioOps.createFile(prefixJsonFilePath)).thenReturn(prefixJsonFile);

    when(
      prefixJsonFile.writeAsString(any),
    ).thenAnswer((_) async => prefixJsonFile);

    WineTasks.registerSingletonInstance(wineTasks);
    GetIt.I.registerSingleton<Logger>(Logger());
    GetIt.I.registerSingleton<AppSettingsService>(appSettingsService);
    GetIt.I.registerSingleton<UtilityService>(utilityService);
    GetIt.I.registerSingleton<DxvkInstallationService>(dxvkInstallationService);
    GetIt.I.registerSingleton<RunningExecutablesRepo<SpecialExecutableSlot>>(
      runningSpecialExecutablesRepo,
    );

    final prefix = WinePrefix(
      dirStructure: WinePrefixDirStructure.fromOuterDir(prefixOuterDir),
      descriptor: WinePrefixDescriptor(
        name: 'Prefix',
        relPathToWineInstall: relPathToWineInstall,
        hiDpiScale: 1.5, // The value to be picked up.
        wow64ModePreferred: null,
        d3d8To11Implementation: null,
      ),
    );

    await tester.pumpWidget(
      TestWidget(
        startupData: startupData,
        prefix: prefix,
        onPrefixUpdated: updatedPrefixReceiver.handleUpdatedPrefix,
      ),
    );

    final scale15ChipFinder = find.byWidgetPredicate(
      (widget) => widget is ChoiceChip && (widget.label as Text).data == "1.5",
      description: 'ChoiceChip with the text of "1.5"',
    );

    expect(scale15ChipFinder, findsOneWidget);

    final scale15Chip = tester.widget<ChoiceChip>(scale15ChipFinder);

    expect(scale15Chip.selected, isTrue);

    final scale10ChipFinder = find.byWidgetPredicate(
      (widget) => widget is ChoiceChip && (widget.label as Text).data == "2.0",
      description: 'ChoiceChip with the text of "2.0"',
    );

    expect(scale10ChipFinder, findsOneWidget);

    await tester.tap(scale10ChipFinder);

    await tester.pumpAndSettle();

    await IOOverrides.runZoned(() async {
      await tester.tap(find.text('Update Wine Prefix'));

      await tester.pumpAndSettle();
    }, createFile: ioOps.createFile);

    verify(ioOps.createFile(prefixJsonFilePath));

    final updatedPrefixJsonString = verify(
      prefixJsonFile.writeAsString(captureAny),
    ).captured.single;

    final updatedPrefix =
        verify(
              updatedPrefixReceiver.handleUpdatedPrefix(captureAny),
            ).captured.single
            as WinePrefix;

    expect(updatedPrefix.descriptor.hiDpiScale, 2.0);
    expect(updatedPrefixJsonString, updatedPrefix.descriptor.toJsonString());
  });
}

abstract interface class UpdatedPrefixReceiver {
  void handleUpdatedPrefix(WinePrefix updatedPrefix);
}

abstract interface class IoOps {
  File createFile(String path);
}

class TestWidget extends StatelessWidget {
  final StartupData startupData;
  final WinePrefix prefix;
  final void Function(WinePrefix) onPrefixUpdated;

  const TestWidget({
    super.key,
    required this.startupData,
    required this.prefix,
    required this.onPrefixUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrefixSettingsDialog(
        startupData: startupData,
        prefix: prefix,
        onPrefixUpdated: onPrefixUpdated,
      ),
    );
  }
}
