import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:winebar/models/archive_type.dart';
import 'package:winebar/models/settings_json_file.dart';
import 'package:winebar/models/wine_build.dart';
import 'package:winebar/models/wine_build_source.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_release.dart';
import 'package:winebar/repositories/wine_build_source_repo.dart';
import 'package:winebar/services/app_settings_service.dart';
import 'package:winebar/utils/app_info.dart';
import 'package:winebar/utils/startup_data.dart';
import 'package:winebar/widgets/prefix_creation_dialog.dart';

@GenerateNiceMocks([
  MockSpec<AppSettingsService>(),
  MockSpec<StartupData>(),
  MockSpec<WineBuildSourceRepo>(),
  MockSpec<WineBuildSource>(),
  MockSpec<WineRelease>(),
  MockSpec<WineBuild>(),
])
import 'prefix_creation_dialog_test.mocks.dart';

void main() {
  testWidgets('WOW64 Wine builds produce a warning under emulation', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(Size(1280, 720));

    final wineBuildSourceLabel = 'Fake Build Source';
    final wineReleaseName = 'Fake Release';
    final wineArchiveName = 'something.tar.gz';

    final appSettingsService = MockAppSettingsService();
    final startupData = MockStartupData();
    final wineBuildSource = MockWineBuildSource();
    final wineBuildSourceRepo = MockWineBuildSourceRepo();
    final wineRelease = MockWineRelease();
    final wineBuild = MockWineBuild();

    final settingsJsonFile = SettingsJsonFile(
      appPackageId: AppInfo.appPackageId,
      suppressedWarnings: {},
    );

    when(appSettingsService.settings).thenReturn(settingsJsonFile);

    when(startupData.isIntelHost).thenReturn(false);

    when(wineBuildSourceRepo.sources).thenReturn([wineBuildSource]);
    when(wineBuildSource.label).thenReturn(wineBuildSourceLabel);
    when(wineBuildSource.recommended).thenReturn(false);

    when(
      wineBuildSource.getAvailableReleases(),
    ).thenAnswer((_) => Future.value([wineRelease]));

    when(wineRelease.releaseName).thenReturn(wineReleaseName);
    when(wineRelease.builds).thenReturn([wineBuild]);

    when(wineBuild.archiveFileName).thenReturn(wineArchiveName);
    when(wineBuild.archiveType).thenReturn(ArchiveType.tarGz);
    when(wineBuild.hasWow64InName).thenReturn(true);

    GetIt.I.registerSingleton<Logger>(Logger());
    GetIt.I.registerSingleton<AppSettingsService>(appSettingsService);
    GetIt.I.registerSingleton<WineBuildSourceRepo>(wineBuildSourceRepo);

    await tester.pumpWidget(
      TestWidget(startupData: startupData, onPrefixCreated: (prefix) {}),
    );

    await tester.tap(find.text(wineBuildSourceLabel));

    await tester.pumpAndSettle();

    await tester.tap(find.text(wineReleaseName));

    await tester.pumpAndSettle();

    await tester.tap(find.text(wineArchiveName));

    await tester.pumpAndSettle();

    await tester.tap(find.text('Proceed Anyway'));

    await tester.pumpAndSettle();

    expect(find.text('Create Prefix'), findsOneWidget);
  });
}

class TestWidget extends StatelessWidget {
  final StartupData startupData;
  final void Function(WinePrefix) onPrefixCreated;

  const TestWidget({
    super.key,
    required this.startupData,
    required this.onPrefixCreated,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrefixCreationDialog(
        startupData: startupData,
        onPrefixCreated: onPrefixCreated,
      ),
    );
  }
}
