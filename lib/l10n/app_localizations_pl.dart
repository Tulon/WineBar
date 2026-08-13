// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Cześć. Jestem autorem Wine Bar.\n\nRozpocząłem pracę nad projektem latem 2025. Od tego czasu włożyłem w niego dużo wysiłku. Dziś Wine Bar robi już wszystko, czego potrzebuję osobiście. Nie oznacza to, że jest idealny – po prostu moje potrzeby są skromne. Oznacza to, że mogę kontynuować pracę nad nim tylko wtedy, gdy będę mógł uzasadnić czas i energię, które wymaga.\n\nAby rozwój mógł się kontynuować, proszę o wsparcie. Darowizny pomagają pokryć czas i bieżącą pracę nad Wine Bar, dając mi powód do dalszego rozwoju. Alternatywnie, jeśli jesteś programistą komfortowym w Dart/Flutter, rozważ dołączenie do zespołu deweloperskiego.\n\nProszę zauważyć, że ta wiadomość będzie pojawiać się od czasu do czasu nawet jeśli nie dokonasz darowizny, ponieważ Wine Bar nie śledzi, kto przekazał, a kto nie.\n\nDziękuję za zrozumienie.';

  @override
  String get kronekWineSourceDescription =>
      'Zapewnia standardowe, Staging, TkG i Proton Wine builds.';

  @override
  String get geProtonWineSourceDescription =>
      'Zapewnia buildy Proton z DXVK / VK3D wbudowanymi. Zalecane dla gier i innych aplikacji pełnoekranowych.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Potwierdzenie odpięcia aplikacji';

  @override
  String get createWinePrefixDialogTitle => 'Utwórz Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Klonuj Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Potwierdzenie usunięcia Prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Ścieżka niedostępna z Wine';

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
    return '$pinnedExecutableLabel Ustawienia';
  }

  @override
  String get processLogsTitle => 'Dzienniki procesu';

  @override
  String licenseInfoPattern(String license) {
    return 'Licencja: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autor: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Proces kopiowania zakończył się niepowodzeniem z kodem wyjścia $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'Pakiet DXVK nie zawiera podkatalogu x32 lub x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Nie udało się przygotować skryptu winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Folder $toplevelDataDir istnieje, ale nie został rozpoznany jako należący do tej aplikacji.\nProszę go zmienić nazwę lub przenieść do Kosza, a następnie uruchomić aplikację ponownie.';
  }

  @override
  String get extractionFailedMessage => 'Rozpakowywanie nie powiodło się';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" już istnieje';
  }

  @override
  String get unknownErrorMessage => 'Nieznany błąd';

  @override
  String get criticalErrorCaption => 'Błąd krytyczny';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Nie zarejestrowano logów z tego procesu';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix zaktualizowany';

  @override
  String get pinnedAppUpdatedMessage => 'Zaktualizowano przypiętą aplikację';

  @override
  String get moreDetailsLink => 'Więcej szczegółów.';

  @override
  String get wow64ModeSection => 'Tryb WOW64';

  @override
  String get useWow64ModeIfAvailable => 'Użyj trybu WOW64, jeśli dostępny';

  @override
  String get d3D8To11Implementation => 'Implementacja Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Użyj konkretnej implementacji Direct3D 8-11';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Użyta zostanie domyślna implementacja dla tej konkretnej wersji Wine';

  @override
  String get windowsLocale => 'Język';

  @override
  String get useParticularWindowsLocale => 'Użyj konkretnego języka';

  @override
  String get dontShowThisWarningAgain =>
      'Nie pokazuj tego ostrzeżenia ponownie';

  @override
  String get nameForTheNewPrefixHintText => 'Nazwa nowego wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Może to pomóc przy wyświetlaniu tekstu w aplikacjach nie-Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Język systemowy będzie używany przez aplikacje Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Spowoduje to, że tekst będzie zbyt mały, ale nie zepsuje starszych aplikacji w trybie pełnoekranowym';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'To jest idealna skala dla Twojego wyświetlacza';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'To pomoże przy zbyt małym tekście, ale spowoduje problemy w starszych aplikacjach pełnoekranowych';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'To jest idealna skala dla Twojego wyświetlacza, choć spowoduje problemy w starszych aplikacjach pełnoekranowych';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'To może spowodować zbyt duży tekst';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Ten prefiks jest w stanie, który uniemożliwia jego usunięcie';

  @override
  String get hiDpiScaleLabel => 'Skala HiDPI';

  @override
  String get pleaseSelect => 'Proszę wybrać';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Aplikacje działają w tym prefiksie';

  @override
  String get refreshWineReleasesTooltip => 'Odśwież wydania Wine';

  @override
  String get prefixSettingsTooltip => 'Ustawienia prefiksu';

  @override
  String get killProcessTooltip => 'Zabij proces';

  @override
  String get scrollToBottomTooltip => 'Przewiń na dół';

  @override
  String get scrollToTopTooltip => 'Przewiń na górę';

  @override
  String get viewLogsTooltip => 'Zobacz logi';

  @override
  String get viewLogsLink => 'Zobacz logi.';

  @override
  String get useParticularGPU => 'Użyj konkretnego GPU';

  @override
  String get gpuSelection => 'Wybór GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Nie udało się pobrać listy dostępnych GPU';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Zauważ, że ta funkcja nie działa we wszystkich scenariuszach';

  @override
  String get addWinePrefixButtonLabel => 'Dodaj Wine Prefix';

  @override
  String get aboutButtonLabel => 'O programie';

  @override
  String get donateButtonLabel => 'Wesprzyj';

  @override
  String get unpinButtonLabel => 'Odepnij';

  @override
  String get deleteButtonLabel => 'Usuń';

  @override
  String get createWinePrefixButtonLabel => 'Utwórz Wine Prefix';

  @override
  String get startingButtonLabel => 'Rozpoczynanie ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Pobieranie i rozpakowywanie ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Pobieranie i rozpakowywanie DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Tworzenie Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Aktualizuj Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Aktualizowanie Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'Klonuj';

  @override
  String get cloningButtonLabel => 'Klonowanie ...';

  @override
  String get pinExecutableButtonLabel => 'Przypnij plik wykonywalny';

  @override
  String get proceedAnywayButtonLabel => 'Kontynuuj mimo wszystko';

  @override
  String get runExecutableButtonLabel => 'Uruchom plik wykonywalny';

  @override
  String get runInstallerButtonLabel => 'Uruchom instalator';

  @override
  String get settingsMenuItem => 'Ustawienia';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Następująca aplikacja ma zostać odpięta:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Następujący prefix ma zostać usunięty:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Następująca ścieżka jest niedostępna z poziomu Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Ścieżka może być niedostępna z Wine, ponieważ cały Wine Bar lub tylko Wine działa w maszynie wirtualnej (na Macach z Apple silicon) albo w sandboxie Snap / Flatpak.';

  @override
  String get solutionHeading => 'Rozwiązanie';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Skopiuj wskazany folder gdzieś pod swoim katalogiem domowym.';

  @override
  String get thisActionCantBeUndone => 'Ta akcja nie może zostać cofnięta!';

  @override
  String get selectWineBuildProviderStepName => 'Wybierz dostawcę builda Wine';

  @override
  String get selectWineReleaseStepName => 'Wybierz wydanie Wine';

  @override
  String get selectWineBuildStepName => 'Wybierz build Wine';

  @override
  String get setOptionsStepName => 'Ustaw opcje';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Wybrano wersję WOW64. Słynie, że ma problemy podczas emulacji. Oczekuj uszkodzonej instalacji.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Ta wersja wymaga obecności bibliotek 32‑bitowych w systemie. Jeśli już je masz, możesz zignorować to ostrzeżenie. W przeciwnym razie zainstaluj Wine ze źródła swojego dystrybucji (co dostarczy te biblioteki 32‑bitowe) lub wybierz wersję WOW64 z listy powyżej, jeśli jest dostępna.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'Tryb WOW64 w emulacji jest znany z problemów. Oczekuj uszkodzonej instalacji.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Nie używanie trybu WOW64 wymaga obecności bibliotek 32‑bitowych w systemie. Jeśli już je masz, możesz zignorować to ostrzeżenie. W przeciwnym razie zainstaluj Wine ze źródła swojego dystrybucji, co dostarczy te biblioteki 32‑bitowe.';

  @override
  String get windowsExecutablesFilterName => 'Pliki wykonywalne Windows';

  @override
  String get dxvkOptionExplanation => 'Nowa i szybsza implementacja z Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Dojrzała implementacja z Wine. Do użycia w przypadku problemów z DXVK.';

  @override
  String get screensaverDisableReason =>
      'Uruchomiona jest aplikacja Wine (prawdopodobnie w trybie pełnoekranowym)';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Hash pobranego skryptu winetricks nie zgadza się z oczekiwanym.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Pobrany plik: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Oczekiwany hash SHA256: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Rzeczywisty hash SHA256: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Najpierw zakończ aplikacje działające we wszystkich prefiksach';

  @override
  String get finishTheRunningAppsFirst =>
      'Najpierw zakończ uruchomione aplikacje';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Ten system nie posiada wymaganego sprzętowego wirtualizowania (/dev/kvm jest brakujący), które jest potrzebne do uruchomienia Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar na ARM64 wymaga dostępu do /dev/kvm z uprawnieniami odczytu i zapisu. Zwykłe aplikacje zazwyczaj mają takie uprawnienia, ale Snapy nie. Aby przyznać taki dostęp, uruchom następujące polecenie w terminalu:\n\n$kvmConnectCommand\n\nNastępnie uruchom ponownie Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Ten system potrzebuje muvm / FEX, aby uruchomić aplikacje Windows. Wersja Snap Wine Bar ma muvm wbudowane. W przeciwnym razie zainstaluj go poleceniem \"sudo dnf install muvm fex-emu\" lub podobnym.';

  @override
  String get prefixNameCantBeEmpty => 'Nazwa prefiksu nie może być pusta';

  @override
  String get illegalSymbolsPresent => 'Obecne nieprawidłowe symbole';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Ten prefiks Wine nie zawiera skryptu winetricks, ani nie został dostarczony zewnętrzny.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Nie udało się odnaleźć plików wykonywalnych wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Nie udało się odnaleźć plików wykonywalnych wine / wineserver do uruchomienia winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Polecenie \"$command\" się nie powiodło';
  }
}
