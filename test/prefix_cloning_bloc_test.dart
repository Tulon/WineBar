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

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:process/process.dart';
import 'package:winebar/blocs/prefix_cloning/prefix_cloning_bloc.dart';
import 'package:winebar/blocs/prefix_cloning/prefix_cloning_state.dart';
import 'package:winebar/models/prefix_descriptor.dart';
import 'package:winebar/models/wine_prefix.dart';
import 'package:winebar/models/wine_prefix_dir_structure.dart';
import 'package:winebar/repositories/wine_prefix_repo.dart';
import 'package:winebar/utils/local_storage_paths.dart';
import 'package:winebar/utils/startup_data.dart';

@GenerateNiceMocks([
  MockSpec<StartupData>(),
  MockSpec<LocalStoragePaths>(),
  MockSpec<WinePrefixRepo>(),
  MockSpec<ProcessManager>(),
  MockSpec<IoOps>(),
  MockSpec<Directory>(),
  MockSpec<File>(),
])
import 'prefix_cloning_bloc_test.mocks.dart';

void main() {
  setUp(() => GetIt.I.reset());

  test('Prefix cloning logic is functional', () async {
    final toplevelDataDir = '/WineBarData';
    final sourcePrefixOuterDir = path.join(
      toplevelDataDir,
      'wine-prefixes/source-prefix',
    );
    final targetPrefixOuterDir = path.join(
      toplevelDataDir,
      'wine-prefixes/target-prefix',
    );
    final relPathToWineInstall = 'wine-installations/installation';
    final targetPrefixName = 'Target Prefix Name';
    final targetPrefixDirStructure = WinePrefixDirStructure.fromOuterDir(
      targetPrefixOuterDir,
    );

    final prefixToClone = WinePrefix(
      status: WinePrefixStatus.operational,
      dirStructure: WinePrefixDirStructure.fromOuterDir(sourcePrefixOuterDir),
      descriptor: WinePrefixDescriptor(
        name: 'Source Prefix',
        relPathToWineInstall: relPathToWineInstall,
        hiDpiScale: 1.0,
        wow64ModePreferred: null,
        d3d8To11Implementation: null,
        explicitLocalePosixName: null,
      ),
    );

    final startupData = MockStartupData();
    final localStoragePaths = MockLocalStoragePaths();
    final winePrefixRepo = MockWinePrefixRepo();
    final processManager = MockProcessManager();
    final ioOps = MockIoOps();
    final targetPrefixDirectory = MockDirectory();
    final targetPrefixJsonFile = MockFile();

    when(startupData.localStoragePaths).thenReturn(localStoragePaths);
    when(startupData.winePrefixRepo).thenReturn(winePrefixRepo);

    when(
      localStoragePaths.getWinePrefixDirStructure(prefixName: targetPrefixName),
    ).thenReturn(targetPrefixDirStructure);

    when(
      processManager.run(
        argThat(
          predicate(
            (List<Object> command) =>
                command.isNotEmpty && command.firstOrNull == 'cp',
          ),
        ),
      ),
    ).thenAnswer((_) async => ProcessResult(0, 0, '', ''));

    when(
      ioOps.createDirectory(targetPrefixOuterDir),
    ).thenReturn(targetPrefixDirectory);

    when(
      ioOps.createFile(targetPrefixDirStructure.prefixJsonFilePath),
    ).thenReturn(targetPrefixJsonFile);

    StartupData.registerMockInstance(startupData);
    GetIt.I.registerSingleton<Logger>(Logger());
    GetIt.I.registerSingleton<ProcessManager>(processManager);

    var prefixCloned = false;
    final bloc = PrefixCloningBloc(
      onPrefixCloned: (_) {
        prefixCloned = true;
      },
    );

    expect(bloc.state.readyToClone, isFalse);

    bloc.setTargetPrefixName(targetPrefixName);

    expect(bloc.state.readyToClone, isTrue);

    await IOOverrides.runZoned(
      () async {
        await bloc.clonePrefixAndHandleErrors(prefixToClone: prefixToClone);
      },
      createDirectory: ioOps.createDirectory,
      createFile: ioOps.createFile,
    );

    expect(bloc.state.prefixCloningStatus, PrefixCloningStatus.succeeded);
    expect(prefixCloned, isTrue);

    verify(ioOps.createFile(targetPrefixDirStructure.prefixJsonFilePath));

    verify(targetPrefixJsonFile.writeAsString(any));

    verify(
      winePrefixRepo.addPrefix(
        argThat(
          predicate(
            (WinePrefix prefix) => prefix.descriptor.name == targetPrefixName,
          ),
        ),
      ),
    );
  });
}

abstract interface class IoOps {
  Directory createDirectory(String path);

  File createFile(String path);
}
