// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'Biedt de standaard, Staging, TkG en Proton Wine builds.';

  @override
  String get geProtonWineSourceDescription =>
      'Biedt Proton builds met DXVK / VK3D inbegrepen. Aanbevolen voor games en andere fullscreen apps.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'App loskoppelen bevestigen';

  @override
  String get createWinePrefixDialogTitle => 'Maak een Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Kloon Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Prefix verwijderen bevestigen';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Pad onbereikbaar vanuit Wine';

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
    return '$pinnedExecutableLabel Instellingen';
  }

  @override
  String get processLogsTitle => 'Proceslogboeken';

  @override
  String licenseInfoPattern(String license) {
    return 'Licentie: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Auteur: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Het kopieerproces is mislukt met status $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'Het DXVK-pakket mist de x32 of x64 submap';

  @override
  String get failedToPrepareWinetricksScript =>
      'Kon het winetricks-script niet voorbereiden:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Map $toplevelDataDir bestaat, maar werd niet herkend als behorende tot deze app.\nHernoem het of verplaats het naar de Prullenbak en start vervolgens de app opnieuw.';
  }

  @override
  String get extractionFailedMessage => 'Uitpakken mislukt';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" bestaat al';
  }

  @override
  String get unknownErrorMessage => 'Onbekende fout';

  @override
  String get criticalErrorCaption => 'Kritieke fout';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Er zijn geen logs vastgelegd van dit proces';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix bijgewerkt';

  @override
  String get pinnedAppUpdatedMessage => 'Gepinde app bijgewerkt';

  @override
  String get moreDetailsLink => 'Meer details.';

  @override
  String get wow64ModeSection => 'WOW64-modus';

  @override
  String get useWow64ModeIfAvailable =>
      'Gebruik de WOW64-modus indien beschikbaar';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 implementatie';

  @override
  String get useParticularD3D8To11Impl =>
      'Gebruik een specifieke Direct3D 8-11 implementatie';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Een standaardimplementatie voor deze specifieke Wine-build zal worden gebruikt';

  @override
  String get windowsLocale => 'Locatie';

  @override
  String get useParticularWindowsLocale => 'Gebruik een specifieke locatie';

  @override
  String get dontShowThisWarningAgain => 'Laat dit waarschuwing niet meer zien';

  @override
  String get nameForTheNewPrefixHintText => 'Naam voor de nieuwe wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Dit kan helpen bij het weergeven van tekst in niet-Unicode-apps';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'De systeemlocatie zal worden gebruikt door Windows-apps';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Dit maakt de tekst te klein, maar breekt oudere volledig scherm-apps niet';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Dit is de perfecte schaal voor uw scherm';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Dit helpt bij te klein tekst, maar breekt oudere volledig scherm-apps';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Dit is de perfecte schaal voor uw scherm, maar het breekt oudere volledig scherm-apps';

  @override
  String get thisWillProduceTextThatsTooLarge => 'Dit kan tekst te groot maken';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Deze prefix staat in een toestand waarin het niet kan worden verwijderd';

  @override
  String get hiDpiScaleLabel => 'HiDPI-schaal';

  @override
  String get pleaseSelect => 'Kies alstublieft';

  @override
  String get appsAreRunningInThisPrefixTooltip => 'Apps draaien in deze prefix';

  @override
  String get refreshWineReleasesTooltip => 'Vernieuw wine releases';

  @override
  String get prefixSettingsTooltip => 'Prefix instellingen';

  @override
  String get killProcessTooltip => 'Proces beëindigen';

  @override
  String get scrollToBottomTooltip => 'Naar beneden scrollen';

  @override
  String get scrollToTopTooltip => 'Naar boven scrollen';

  @override
  String get viewLogsTooltip => 'Logboeken bekijken';

  @override
  String get viewLogsLink => 'Logboeken bekijken.';

  @override
  String get useParticularGPU => 'Gebruik een specifieke GPU';

  @override
  String get gpuSelection => 'GPU selectie';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Kon de lijst met beschikbare GPU\'s niet ophalen';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Let op dat deze functie niet in alle scenario\'s werkt';

  @override
  String get addWinePrefixButtonLabel => 'Wine Prefix toevoegen';

  @override
  String get aboutButtonLabel => 'Over';

  @override
  String get donateButtonLabel => 'Doneer';

  @override
  String get unpinButtonLabel => 'Ontkoppelen';

  @override
  String get deleteButtonLabel => 'Verwijderen';

  @override
  String get createWinePrefixButtonLabel => 'Wine Prefix aanmaken';

  @override
  String get startingButtonLabel => 'Starten …';

  @override
  String get downloadingAndExtractingButtonLabel => 'Downloaden en uitpakken …';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Downloaden en uitpakken DXVK …';

  @override
  String get creatingWinePrefixButtonLabel => 'Wine Prefix aanmaken …';

  @override
  String get updateWinePrefixButtonLabel => 'Wine Prefix bijwerken';

  @override
  String get updatingWinePrefixButtonLabel => 'Wine Prefix bijwerken …';

  @override
  String get cloneButtonLabel => 'Klonen';

  @override
  String get cloningButtonLabel => 'Klonen …';

  @override
  String get pinExecutableButtonLabel => 'Koppel uitvoerbaar';

  @override
  String get proceedAnywayButtonLabel => 'Doorgaan';

  @override
  String get runExecutableButtonLabel => 'Voer uitvoerbaar uit';

  @override
  String get runInstallerButtonLabel => 'Voer installatie uit';

  @override
  String get settingsMenuItem => 'Instellingen';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'De volgende app staat op het punt losgekoppeld te worden:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'De volgende prefix staat op het punt verwijderd te worden:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Het volgende pad is onbereikbaar vanuit Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Een pad kan onbereikbaar zijn vanuit Wine omdat de hele Wine Bar of alleen Wine draait in een virtuele machine (op Apple silicon Macs) of in een Snap / Flatpak sandbox.';

  @override
  String get solutionHeading => 'Oplossing';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Kopieer de betreffende map ergens onder je thuismap.';

  @override
  String get thisActionCantBeUndone =>
      'Deze actie kan niet ongedaan worden gemaakt!';

  @override
  String get selectWineBuildProviderStepName => 'Selecteer wine build provider';

  @override
  String get selectWineReleaseStepName => 'Selecteer wine release';

  @override
  String get selectWineBuildStepName => 'Selecteer wine build';

  @override
  String get setOptionsStepName => 'Opties instellen';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Een WOW64-build is geselecteerd. Deze zijn bekend met problemen onder emulatie. Verwacht een gebroken installatie.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Deze build vereist dat 32‑bit bibliotheken op uw systeem aanwezig zijn. Als u ze al heeft, kunt u deze waarschuwing negeren. Anders installeert u Wine vanuit de repository van uw distributie (wat die 32‑bit bibliotheken meebrengt) of kiest u een WOW64-build uit de bovenstaande lijst als die beschikbaar is.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'De WOW64‑modus onder emulatie is bekend met problemen. Verwacht een gebroken installatie.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Het niet gebruiken van de WOW64‑modus vereist dat 32‑bit bibliotheken op uw systeem aanwezig zijn. Als u ze al heeft, kunt u deze waarschuwing negeren. Anders installeert u Wine vanuit de repository van uw distributie, die die 32‑bit bibliotheken meebrengt.';

  @override
  String get windowsExecutablesFilterName => 'Windows‑uitvoerbare bestanden';

  @override
  String get dxvkOptionExplanation =>
      'Een nieuwere en snellere implementatie van Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Een volwassen implementatie van Wine. Te gebruiken bij problemen met DXVK.';

  @override
  String get screensaverDisableReason =>
      'Een Wine-app (mogelijk volledig scherm) is actief';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'De hash van het gedownloade winetricks-script komt niet overeen met de verwachte.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Gedownloade bestand: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Verwachte SHA256-hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Werkelijke SHA256-hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Sluit eerst de apps die in alle prefixes draaien';

  @override
  String get finishTheRunningAppsFirst => 'Sluit eerst de draaiende apps';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Dit systeem mist de hardware virtualisatie mogelijkheden (/dev/kvm ontbreekt) die nodig zijn om Wine Bar te draaien.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar op ARM64 heeft lees- en schrijfrechten nodig voor /dev/kvm. Gewone apps hebben normaal gesproken die rechten, maar Snaps niet. Om die toegang te verlenen, voer het volgende commando uit in de terminal:\n\n$kvmConnectCommand\n\nVervolgens herstart je Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Dit systeem heeft muvm / FEX nodig om Windows apps te kunnen draaien. De Snap versie van Wine Bar bevat muvm ingebouwd. Anders, installeer het met \"sudo dnf install muvm fex-emu\" of iets dergelijks';

  @override
  String get prefixNameCantBeEmpty => 'Prefixnaam mag niet leeg zijn';

  @override
  String get illegalSymbolsPresent => 'Ongeldige symbolen aanwezig';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Deze Wine prefix bevat geen winetricks script en er is ook geen extern script beschikbaar.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Kon de wine / wineserver-executables niet vinden';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Kon de wine / wineserver-executables voor het uitvoeren van winetricks niet vinden';

  @override
  String specificCommandHasFailed(String command) {
    return 'De \"$command\"-opdracht is mislukt';
  }
}
