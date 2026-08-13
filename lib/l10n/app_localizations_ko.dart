// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      '안녕하세요. 저는 Wine Bar의 저자입니다.\n\n저는 2025년 여름에 이 프로젝트를 시작했습니다. 그 이후로 많은 노력을 기울여 왔습니다. 오늘날 Wine Bar는 제가 개인적으로 필요로 하는 모든 기능을 이미 제공합니다. 완벽하다고 말할 수는 없지만, 제 요구가 겸손하기 때문에 그만큼 완벽하지 않습니다. 이는 제가 필요한 시간과 에너지를 정당화할 수 있을 때만 계속 작업을 진행할 수 있다는 뜻입니다.\n\n개발을 지속하기 위해 여러분의 지원을 요청합니다. 기부는 Wine Bar에 대한 시간과 지속적인 작업 비용을 충당하는 데 도움이 되며, 제가 계속해서 개발할 수 있는 이유를 제공합니다. 또는 Dart/Flutter에 익숙한 개발자라면 개발 작업에 참여해 보세요.\n\n이 메시지는 기부 여부와 관계없이 가끔씩 표시될 수 있음을 알려드립니다. Wine Bar는 누가 기부했는지 추적하지 않기 때문입니다.\n\n이해해 주셔서 감사합니다.';

  @override
  String get kronekWineSourceDescription =>
      '표준, Staging, TkG 및 Proton Wine 빌드를 제공합니다.';

  @override
  String get geProtonWineSourceDescription =>
      'DXVK / VK3D가 포함된 Proton 빌드를 제공합니다. 게임 및 기타 전체 화면 앱에 권장됩니다.';

  @override
  String get appUnpinningConfirmationDialogTitle => '앱 고정 해제 확인';

  @override
  String get createWinePrefixDialogTitle => 'Wine Prefix 만들기';

  @override
  String get cloneWinePrefixDialogTitle => 'Wine Prefix 복제';

  @override
  String get prefixDeletionConfirmationDialogTitle => 'Prefix 삭제 확인';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'Wine에서 접근할 수 없는 경로';

  @override
  String get winePrefixesPageTitle => 'Wine Prefixes';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'Wine Prefix: $prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'Wine Prefix $prefixName Settings';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel 설정';
  }

  @override
  String get processLogsTitle => '프로세스 로그';

  @override
  String licenseInfoPattern(String license) {
    return '라이선스: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return '저자: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return '복사 프로세스가 상태 $exitCode로 실패했습니다';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'DXVK 패키지에 x32 또는 x64 하위 디렉터리가 없습니다';

  @override
  String get failedToPrepareWinetricksScript => 'winetricks 스크립트 준비에 실패했습니다:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return '폴더 $toplevelDataDir이(가) 존재하지만 이 앱에 속한 것으로 인식되지 않았습니다.\n폴더를 이름 바꾸거나 휴지통으로 옮긴 뒤 앱을 다시 시작하세요.';
  }

  @override
  String get extractionFailedMessage => '추출에 실패했습니다';

  @override
  String prefixAlreadyExists(String prefixName) {
    return '프리픽스 \"$prefixName\"이(가) 이미 존재합니다';
  }

  @override
  String get unknownErrorMessage => '알 수 없는 오류';

  @override
  String get criticalErrorCaption => '치명적 오류';

  @override
  String get noLogsWereCapturedFromThisProcess => '이 프로세스에서 로그를 캡처하지 못했습니다';

  @override
  String get winePrefixUpdatedMessage => 'Wine 프리픽스가 업데이트되었습니다';

  @override
  String get pinnedAppUpdatedMessage => '고정된 앱이 업데이트되었습니다';

  @override
  String get moreDetailsLink => '자세히 보기.';

  @override
  String get wow64ModeSection => 'WOW64 모드';

  @override
  String get useWow64ModeIfAvailable => '가능하면 WOW64 모드를 사용하세요';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 구현';

  @override
  String get useParticularD3D8To11Impl => '특정 Direct3D 8-11 구현을 사용하세요';

  @override
  String get defaultD3D8To11ImplWillBeUsed => '이 특정 Wine 빌드에 대한 기본 구현이 사용됩니다';

  @override
  String get windowsLocale => '로케일';

  @override
  String get useParticularWindowsLocale => '특정 로케일 사용';

  @override
  String get dontShowThisWarningAgain => '이 경고를 다시 표시하지 않음';

  @override
  String get nameForTheNewPrefixHintText => '새 Wine prefix의 이름';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      '이 설정은 비-유니코드 앱에서 텍스트 표시를 개선할 수 있습니다';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      '시스템 로케일이 Windows 앱에 사용됩니다';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      '이 설정은 텍스트를 너무 작게 만들지만, 이전 전체 화면 앱을 깨뜨리지 않습니다';

  @override
  String get thisIsThePrefectScaleForYourDisplay => '이 스케일은 디스플레이에 완벽합니다';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      '텍스트가 너무 작아지는 것을 방지하지만, 오래된 전체 화면 앱은 깨집니다';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      '이 스케일은 디스플레이에 완벽하지만, 오래된 전체 화면 앱은 깨집니다';

  @override
  String get thisWillProduceTextThatsTooLarge => '텍스트가 너무 커질 수 있습니다';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      '이 프리픽스는 삭제할 수 없는 상태에 있습니다';

  @override
  String get hiDpiScaleLabel => 'HiDPI 스케일';

  @override
  String get pleaseSelect => '선택하세요';

  @override
  String get appsAreRunningInThisPrefixTooltip => '이 프리픽스에서 앱이 실행 중입니다';

  @override
  String get refreshWineReleasesTooltip => '와인 릴리스 새로 고침';

  @override
  String get prefixSettingsTooltip => '프리픽스 설정';

  @override
  String get killProcessTooltip => '프로세스 종료';

  @override
  String get scrollToBottomTooltip => '아래로 스크롤';

  @override
  String get scrollToTopTooltip => '위로 스크롤';

  @override
  String get viewLogsTooltip => '로그 보기';

  @override
  String get viewLogsLink => '로그 보기.';

  @override
  String get useParticularGPU => '특정 GPU 사용';

  @override
  String get gpuSelection => 'GPU 선택';

  @override
  String get failedToGetTheListOfAvailableGPUs => '사용 가능한 GPU 목록을 가져오지 못했습니다';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      '이 기능은 모든 상황에서 작동하지 않을 수 있습니다';

  @override
  String get addWinePrefixButtonLabel => 'Wine Prefix 추가';

  @override
  String get aboutButtonLabel => '정보';

  @override
  String get donateButtonLabel => '기부';

  @override
  String get unpinButtonLabel => '고정 해제';

  @override
  String get deleteButtonLabel => '삭제';

  @override
  String get createWinePrefixButtonLabel => 'Wine Prefix 만들기';

  @override
  String get startingButtonLabel => '시작 중 ...';

  @override
  String get downloadingAndExtractingButtonLabel => '다운로드 및 추출 중 ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel => 'DXVK 다운로드 및 추출 중 ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Wine Prefix 만들기 중 ...';

  @override
  String get updateWinePrefixButtonLabel => 'Wine Prefix 업데이트';

  @override
  String get updatingWinePrefixButtonLabel => 'Wine Prefix 업데이트 중 ...';

  @override
  String get cloneButtonLabel => '복제';

  @override
  String get cloningButtonLabel => '복제 중 ...';

  @override
  String get pinExecutableButtonLabel => '실행 파일 고정';

  @override
  String get proceedAnywayButtonLabel => '그럼에도 진행';

  @override
  String get runExecutableButtonLabel => '실행 파일 실행';

  @override
  String get runInstallerButtonLabel => '설치 프로그램 실행';

  @override
  String get settingsMenuItem => '설정';

  @override
  String get theFollowingAppIsAboutToBeUnpinned => '다음 앱이 고정 해제될 예정입니다:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted => '다음 prefix가 삭제될 예정입니다:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      '다음 경로는 Wine에서 접근할 수 없습니다:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      '경로가 Wine에서 접근 불가능할 수 있는 이유는 전체 Wine Bar 또는 단지 Wine이 가상 머신(Apple silicon Mac에서)이나 Snap / Flatpak 샌드박스에서 실행 중이기 때문입니다.';

  @override
  String get solutionHeading => '해결책';

  @override
  String get pathInaccessibleFromWineSolution =>
      '문제가 되는 폴더를 홈 디렉터리 아래의 다른 위치에 복사하세요.';

  @override
  String get thisActionCantBeUndone => '이 작업은 되돌릴 수 없습니다!';

  @override
  String get selectWineBuildProviderStepName => 'wine 빌드 제공자 선택';

  @override
  String get selectWineReleaseStepName => 'wine 릴리스 선택';

  @override
  String get selectWineBuildStepName => 'wine 빌드 선택';

  @override
  String get setOptionsStepName => '옵션 설정';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'WOW64 빌드가 선택되었습니다. 이 빌드는 에뮬레이션에서 문제가 발생하는 것으로 알려져 있습니다. 설치가 깨질 수 있으니 주의하세요.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      '이 빌드는 시스템에 32‑비트 라이브러리가 설치되어 있어야 합니다. 이미 설치돼 있다면 이 경고를 무시해도 됩니다. 그렇지 않다면 배포판 저장소에서 Wine을 설치(32‑비트 라이브러리 포함)하거나, 사용 가능한 경우 위 목록에서 WOW64 빌드를 선택하세요.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      '에뮬레이션에서 WOW64 모드는 문제가 있는 것으로 알려져 있습니다. 설치가 깨질 수 있으니 주의하세요.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'WOW64 모드를 사용하지 않으면 시스템에 32‑비트 라이브러리가 설치돼 있어야 합니다. 이미 설치돼 있다면 이 경고를 무시해도 됩니다. 그렇지 않다면 배포판 저장소에서 Wine을 설치(32‑비트 라이브러리 포함)하세요.';

  @override
  String get windowsExecutablesFilterName => 'Windows 실행 파일';

  @override
  String get dxvkOptionExplanation => 'Proton에서 제공하는 최신 및 빠른 구현';

  @override
  String get wineD3DOptionExplanation =>
      'Wine에서 제공하는 성숙한 구현. DXVK에 문제가 있을 때 사용';

  @override
  String get screensaverDisableReason => 'Wine 앱(전체 화면일 수 있음)이 실행 중입니다';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      '다운로드된 winetricks 스크립트의 해시가 예상값과 일치하지 않습니다.';

  @override
  String downloadedFile(String downloadedFile) {
    return '다운로드된 파일: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return '예상 SHA256 해시: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return '실제 SHA256 해시: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      '모든 프리픽스에서 실행 중인 앱을 먼저 종료하세요';

  @override
  String get finishTheRunningAppsFirst => '현재 프리픽스에서 실행 중인 앱을 먼저 종료하세요';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      '이 시스템은 Wine Bar를 실행하는 데 필요한 하드웨어 가상화 기능(/dev/kvm이 없음)을 갖추고 있지 않습니다.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar on ARM64는 /dev/kvm에 읽기-쓰기 접근 권한이 필요합니다. 일반 앱은 보통 이러한 접근 권한을 갖지만 Snap에서는 그렇지 않습니다. 해당 접근 권한을 부여하려면 명령줄에서 다음 명령을 실행하십시오:\n\n$kvmConnectCommand\n\n그런 다음 Wine Bar를 재시작하세요.';
  }

  @override
  String get muvmIsNeededButMissing =>
      '이 시스템은 Windows 앱을 실행하려면 muvm / FEX가 필요합니다. Wine Bar의 Snap 버전은 muvm을 내장하고 있습니다. 그렇지 않다면 \"sudo dnf install muvm fex-emu\" 또는 유사한 명령으로 설치하십시오.';

  @override
  String get prefixNameCantBeEmpty => '프리픽스 이름은 비워 둘 수 없습니다';

  @override
  String get illegalSymbolsPresent => '허용되지 않은 기호가 포함되었습니다';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      '이 Wine 프리픽스는 winetricks 스크립트를 번들링하지 않았으며 외부 스크립트도 제공되지 않았습니다.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'wine / wineserver 실행 파일을 찾지 못했습니다';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'winetricks 실행을 위한 wine / wineserver 실행 파일을 찾지 못했습니다';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\" 명령이 실패했습니다';
  }
}
