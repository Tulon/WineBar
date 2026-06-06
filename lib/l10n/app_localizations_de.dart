// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get kronekWineSourceDescription =>
      'Stellt die Standard-, Staging-, TkG- und Proton-Wine-Builds bereit.';

  @override
  String get geProtonWineSourceDescription =>
      'Stellt Proton-Builds mit DXVK / VK3D bereit. Empfohlen für Spiele und andere Vollbildanwendungen.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Entfernen der App-Anheftung bestätigen';

  @override
  String get createWinePrefixDialogTitle => 'Ein Wine Prefix erstellen';

  @override
  String get cloneWinePrefixDialogTitle => 'Wine Prefix klonen';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Löschbestätigung des Prefixes';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Pfad ist von Wine nicht zugänglich';

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
    return '$pinnedExecutableLabel Einstellungen';
  }

  @override
  String get processLogsTitle => 'Prozessprotokolle';

  @override
  String licenseInfoPattern(String license) {
    return 'Lizenz: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autor: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Der Kopiervorgang schlug mit Status $exitCode fehl';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'Das DXVK-Paket fehlt das Unterverzeichnis x32 oder x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Konnte das winetricks-Skript nicht vorbereiten:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Ordner $toplevelDataDir existiert, wurde aber nicht als zu dieser App gehörend erkannt.\nBitte benennen Sie ihn um oder verschieben Sie ihn in den Papierkorb und starten Sie die App anschließend neu.';
  }

  @override
  String get extractionFailedMessage => 'Extraktion fehlgeschlagen';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" existiert bereits';
  }

  @override
  String get unknownErrorMessage => 'Unbekannter Fehler';

  @override
  String get criticalErrorCaption => 'Kritischer Fehler';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Es wurden keine Protokolle von diesem Prozess erfasst';

  @override
  String get winePrefixUpdatedMessage => 'Wine Prefix aktualisiert';

  @override
  String get pinnedAppUpdatedMessage => 'Angeheftete App aktualisiert';

  @override
  String get moreDetailsLink => 'Mehr Details.';

  @override
  String get wow64ModeSection => 'WOW64-Modus';

  @override
  String get useWow64ModeIfAvailable =>
      'WOW64-Modus verwenden, falls verfügbar';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 Implementierung';

  @override
  String get useParticularD3D8To11Impl =>
      'Eine bestimmte Direct3D 8-11 Implementierung verwenden';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Eine Standardimplementierung für dieses spezielle Wine-Build wird verwendet';

  @override
  String get windowsLocale => 'Sprache';

  @override
  String get useParticularWindowsLocale => 'Eine bestimmte Sprache verwenden';

  @override
  String get dontShowThisWarningAgain =>
      'Dieses Warnsignal nicht mehr anzeigen';

  @override
  String get nameForTheNewPrefixHintText => 'Name für das neue Wine-Prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Dies kann bei der Anzeige von Text in Nicht-Unicode-Programmen helfen';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Die Systemsprache wird von Windows-Programmen verwendet';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Dies wird den Text zu klein machen, aber ältere Vollbildanwendungen nicht brechen';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Dies ist die perfekte Skalierung für Ihren Bildschirm';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Dies hilft, wenn der Text zu klein ist, kann aber ältere Vollbildanwendungen beeinträchtigen';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Dies ist die perfekte Skalierung für Ihren Bildschirm, aber ältere Vollbildanwendungen werden beeinträchtigt';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Dies kann zu großem Text führen';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Dieses Prefix befindet sich in einem Zustand, in dem es nicht gelöscht werden kann';

  @override
  String get hiDpiScaleLabel => 'HiDPI-Skalierung';

  @override
  String get pleaseSelect => 'Bitte auswählen';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Apps laufen in diesem Prefix';

  @override
  String get refreshWineReleasesTooltip => 'Wine-Versionen aktualisieren';

  @override
  String get prefixSettingsTooltip => 'Prefix-Einstellungen';

  @override
  String get killProcessTooltip => 'Prozess beenden';

  @override
  String get scrollToBottomTooltip => 'Nach unten scrollen';

  @override
  String get scrollToTopTooltip => 'Nach oben scrollen';

  @override
  String get viewLogsTooltip => 'Protokolle anzeigen';

  @override
  String get viewLogsLink => 'Protokolle anzeigen.';

  @override
  String get useParticularGPU => 'Eine bestimmte GPU verwenden';

  @override
  String get gpuSelection => 'GPU-Auswahl';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Liste der verfügbaren GPUs konnte nicht abgerufen werden';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Beachten Sie, dass diese Funktion nicht in allen Szenarien funktioniert';

  @override
  String get addWinePrefixButtonLabel => 'Wine Prefix hinzufügen';

  @override
  String get aboutButtonLabel => 'Info';

  @override
  String get donateButtonLabel => 'Spenden';

  @override
  String get unpinButtonLabel => 'Lösen';

  @override
  String get deleteButtonLabel => 'Löschen';

  @override
  String get createWinePrefixButtonLabel => 'Wine Prefix erstellen';

  @override
  String get startingButtonLabel => 'Starte ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Herunterladen und Entpacken ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Herunterladen und Entpacken von DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Erstelle Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Wine Prefix aktualisieren';

  @override
  String get updatingWinePrefixButtonLabel => 'Wine Prefix wird aktualisiert …';

  @override
  String get cloneButtonLabel => 'Klonen';

  @override
  String get cloningButtonLabel => 'Klonen …';

  @override
  String get pinExecutableButtonLabel => 'Ausführbare Datei anheften';

  @override
  String get proceedAnywayButtonLabel => 'Trotzdem fortfahren';

  @override
  String get runExecutableButtonLabel => 'Ausführbare Datei starten';

  @override
  String get runInstallerButtonLabel => 'Installationsprogramm starten';

  @override
  String get settingsMenuItem => 'Einstellungen';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Die folgende App wird gerade abgehängt:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Der folgende Prefix wird gerade gelöscht:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Der folgende Pfad ist von Wine aus nicht zugänglich:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Ein Pfad kann von Wine aus nicht zugänglich sein, weil die gesamte Wine Bar oder nur Wine in einer virtuellen Maschine (auf Apple‑Silicon‑Macs) läuft oder sich in einem Snap / Flatpak-Sandbox befindet.';

  @override
  String get solutionHeading => 'Lösung';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Kopieren Sie den betreffenden Ordner an einen Ort unter Ihrem Home-Verzeichnis.';

  @override
  String get thisActionCantBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden!';

  @override
  String get selectWineBuildProviderStepName =>
      'Wählen Sie den Wine-Build-Anbieter';

  @override
  String get selectWineReleaseStepName => 'Wählen Sie die Wine-Version';

  @override
  String get selectWineBuildStepName => 'Wählen Sie den Wine-Build';

  @override
  String get setOptionsStepName => 'Optionen festlegen';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Ein WOW64-Build wurde ausgewählt. Diese sind bekannt dafür, unter Emulation Probleme zu haben. Erwarten Sie eine fehlerhafte Installation.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Dieser Build erfordert, dass 32‑bitige Bibliotheken auf Ihrem System vorhanden sind. Wenn Sie diese bereits haben, können Sie diese Warnung ignorieren. Andernfalls installieren Sie Wine aus dem Repository Ihrer Distribution (was die 32‑bitigen Bibliotheken mitbringt) oder wählen Sie alternativ einen WOW64-Build aus der obigen Liste, falls einer verfügbar ist.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'Der WOW64-Modus unter Emulation ist bekannt dafür, Probleme zu haben. Erwarten Sie eine fehlerhafte Installation.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Die Nichtverwendung des WOW64-Modus erfordert, dass 32‑bitige Bibliotheken auf Ihrem System vorhanden sind. Wenn Sie diese bereits haben, können Sie diese Warnung ignorieren. Andernfalls installieren Sie Wine aus dem Repository Ihrer Distribution, das die 32‑bitigen Bibliotheken mitbringt.';

  @override
  String get windowsExecutablesFilterName => 'Windows‑Ausführbare Dateien';

  @override
  String get dxvkOptionExplanation =>
      'Eine neuere und schnellere Implementierung von Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Eine ausgereifte Implementierung von Wine. Zu verwenden, wenn Probleme mit DXVK auftreten.';

  @override
  String get screensaverDisableReason =>
      'Eine Wine-Anwendung (möglicherweise im Vollbild) läuft';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Der Hash des heruntergeladenen winetricks-Skripts stimmt nicht mit dem erwarteten überein.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Heruntergeladene Datei: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Erwarteter SHA256-Hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Tatsächlicher SHA256-Hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Beenden Sie zunächst die Anwendungen, die in allen Prefixes laufen';

  @override
  String get finishTheRunningAppsFirst =>
      'Beenden Sie zunächst die laufenden Anwendungen';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Dieses System verfügt nicht über die Hardware-Virtualisierungsfunktionen (/dev/kvm fehlt), die zum Ausführen von Wine Bar erforderlich sind.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar auf ARM64 benötigt Lese- und Schreibzugriff auf /dev/kvm. Normale Anwendungen haben normalerweise solchen Zugriff, Snap-Anwendungen jedoch nicht. Um diesen Zugriff zu gewähren, führen Sie den folgenden Befehl in der Befehlszeile aus:\n\n$kvmConnectCommand\n\nAnschließend starten Sie Wine Bar neu.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Dieses System benötigt muvm / FEX, um Windows-Apps ausführen zu können. Die Snap-Version von Wine Bar enthält muvm bereits. Andernfalls installieren Sie es bitte mit \"sudo dnf install muvm fex-emu\" oder einer ähnlichen Anweisung.';

  @override
  String get prefixNameCantBeEmpty => 'Der Präfixname darf nicht leer sein';

  @override
  String get illegalSymbolsPresent => 'Ungültige Symbole vorhanden';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Dieser Wine-Präfix enthält kein winetricks-Skript und es wurde auch kein externes Skript bereitgestellt.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Fehler beim Auffinden der wine / wineserver-Programme';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Fehler beim Auffinden der wine / wineserver-Programme für die Ausführung von winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Der Befehl \"$command\" ist fehlgeschlagen';
  }
}
