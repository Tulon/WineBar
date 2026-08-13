// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'Gir standard, Staging, TkG og Proton Wine-versjoner.';

  @override
  String get geProtonWineSourceDescription =>
      'Gir Proton-versjoner med DXVK / VK3D inkludert. Anbefalt for spill og andre fullskjerm-apper.';

  @override
  String get appUnpinningConfirmationDialogTitle => 'Bekreft avknytning av app';

  @override
  String get createWinePrefixDialogTitle => 'Opprett en Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Klon Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Bekreft sletting av prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Sti utilgjengelig fra Wine';

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
    return '$pinnedExecutableLabel Settings';
  }

  @override
  String get processLogsTitle => 'Process Logs';

  @override
  String licenseInfoPattern(String license) {
    return 'License: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Author: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'The copying process failed with status $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'The DXVK package is missing the x32 or x64 subdirectory';

  @override
  String get failedToPrepareWinetricksScript =>
      'Failed to prepare the winetricks script:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Folder $toplevelDataDir exists but wasn\'t recognized as belonging to this app.\nPlease rename it or move it to Trash and then restart the app.';
  }

  @override
  String get extractionFailedMessage => 'Extraction failed';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" finnes allerede';
  }

  @override
  String get unknownErrorMessage => 'Ukjent feil';

  @override
  String get criticalErrorCaption => 'Kritisk feil';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Ingen logger ble fanget fra denne prosessen';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix oppdatert';

  @override
  String get pinnedAppUpdatedMessage => 'Festet app oppdatert';

  @override
  String get moreDetailsLink => 'Flere detaljer.';

  @override
  String get wow64ModeSection => 'WOW64-modus';

  @override
  String get useWow64ModeIfAvailable => 'Bruk WOW64-modus hvis tilgjengelig';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 implementasjon';

  @override
  String get useParticularD3D8To11Impl =>
      'Bruk en bestemt Direct3D 8-11 implementasjon';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'En standardimplementering for denne Wine-versjonen vil bli brukt';

  @override
  String get windowsLocale => 'Språk';

  @override
  String get useParticularWindowsLocale => 'Bruk et bestemt språk';

  @override
  String get dontShowThisWarningAgain => 'Ikke vis denne advarselen igjen';

  @override
  String get nameForTheNewPrefixHintText => 'Navn på den nye wine prefixen';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Dette kan hjelpe med tekstvisning i ikke-Unicode-apper';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Systemspråket vil bli brukt av Windows-apper';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Dette vil gjøre teksten for liten, men bryter ikke eldre fullskjerm-apper';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Dette er den perfekte skalaen for skjermen din';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Dette vil hjelpe med at teksten blir for liten, men det vil bryte eldre fullskjerm-apper';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Dette er den perfekte skalaen for skjermen din, men det vil bryte eldre fullskjerm-apper';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Dette kan produsere tekst som er for stor';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Denne prefiksen er i en tilstand der den ikke kan slettes';

  @override
  String get hiDpiScaleLabel => 'HiDPI-skala';

  @override
  String get pleaseSelect => 'Vennligst velg';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Apper kjører i denne prefiks';

  @override
  String get refreshWineReleasesTooltip => 'Oppdater wine-utgivelser';

  @override
  String get prefixSettingsTooltip => 'Prefiksinnstillinger';

  @override
  String get killProcessTooltip => 'Avslutt prosess';

  @override
  String get scrollToBottomTooltip => 'Rull nedover';

  @override
  String get scrollToTopTooltip => 'Rull oppover';

  @override
  String get viewLogsTooltip => 'Vis logger';

  @override
  String get viewLogsLink => 'Vis logger.';

  @override
  String get useParticularGPU => 'Bruk et bestemt GPU';

  @override
  String get gpuSelection => 'GPU‑valg';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Kunne ikke hente listen over tilgjengelige GPU‑er';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Merk at denne funksjonen ikke fungerer i alle scenarier';

  @override
  String get addWinePrefixButtonLabel => 'Legg til Wine Prefix';

  @override
  String get aboutButtonLabel => 'Om';

  @override
  String get donateButtonLabel => 'Donér';

  @override
  String get unpinButtonLabel => 'Fjern fest';

  @override
  String get deleteButtonLabel => 'Slett';

  @override
  String get createWinePrefixButtonLabel => 'Opprett Wine Prefix';

  @override
  String get startingButtonLabel => 'Starter …';

  @override
  String get downloadingAndExtractingButtonLabel => 'Laster ned og pakker ut …';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Laster ned og pakker ut DXVK …';

  @override
  String get creatingWinePrefixButtonLabel => 'Oppretter Wine Prefix …';

  @override
  String get updateWinePrefixButtonLabel => 'Oppdater Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Oppdaterer Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Klon';

  @override
  String get cloningButtonLabel => 'Kloner …';

  @override
  String get pinExecutableButtonLabel => 'Fest kjørbar';

  @override
  String get proceedAnywayButtonLabel => 'Fortsett allikevel';

  @override
  String get runExecutableButtonLabel => 'Kjør kjørbar';

  @override
  String get runInstallerButtonLabel => 'Kjør installasjonsprogram';

  @override
  String get settingsMenuItem => 'Innstillinger';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Følgende app er i ferd med å bli avfestet:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Følgende prefix er i ferd med å bli slettet:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Følgende sti er utilgjengelig fra Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'En sti kan være utilgjengelig fra Wine fordi hele Wine Bar eller bare Wine kjører i en virtuell maskin (på Apple silicon Macs) eller i et Snap / Flatpak-sandbox.';

  @override
  String get solutionHeading => 'Løsning';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Kopier mappen i spørsmålet et sted under hjemkatalogen din.';

  @override
  String get thisActionCantBeUndone => 'Denne handlingen kan ikke angres!';

  @override
  String get selectWineBuildProviderStepName => 'Velg wine build provider';

  @override
  String get selectWineReleaseStepName => 'Velg wine release';

  @override
  String get selectWineBuildStepName => 'Velg wine build';

  @override
  String get setOptionsStepName => 'Sett innstillinger';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'En WOW64‑bygning ble valgt. Disse er kjent for å ha problemer under emulering. Forvent en ødelagt installasjon.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Denne bygningen krever at 32‑bit-biblioteker er installert på systemet ditt. Hvis du allerede har dem, kan du ignorere denne advarselen. Ellers installer Wine fra distribusjonens pakkebrønn (som vil installere de 32‑bit-bibliotekene) eller velg en WOW64‑bygning fra listen over hvis en er tilgjengelig.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'WOW64‑modus under emulering er kjent for å ha problemer. Forvent en ødelagt installasjon.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Å ikke bruke WOW64‑modus vil kreve at 32‑bit-biblioteker er installert på systemet ditt. Hvis du allerede har dem, kan du ignorere denne advarselen. Ellers installer Wine fra distribusjonens pakkebrønn, som vil installere de 32‑bit-bibliotekene.';

  @override
  String get windowsExecutablesFilterName => 'Windows‑kjørbare filer';

  @override
  String get dxvkOptionExplanation =>
      'En nyere og raskere implementering fra Proton';

  @override
  String get wineD3DOptionExplanation =>
      'En moden implementering fra Wine. Brukes ved problemer med DXVK.';

  @override
  String get screensaverDisableReason =>
      'En Wine-app (muligens fullskjerm) kjører';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Hash‑verdien til den nedlastede winetricks‑skriptet stemmer ikke overens med forventet verdi.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Nedlastet fil: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Forventet SHA256‑hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Faktisk SHA256‑hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Fullfør appene som kjører i alle prefiks først';

  @override
  String get finishTheRunningAppsFirst => 'Fullfør de kjørende appene først';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Dette systemet mangler maskinvarevirtualiseringsfunksjoner (/dev/kvm er ikke tilgjengelig) som kreves for å kjøre Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar på ARM64 trenger lese-skrive-tilgang til /dev/kvm. Vanlige apper har vanligvis slik tilgang, men ikke Snaps. For å gi slik tilgang, kjør følgende kommando fra kommandolinjen:\n\n$kvmConnectCommand\n\nDeretter, start Wine Bar på nytt.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Dette systemet trenger muvm / FEX for å kunne kjøre Windows-apper. Snap-versjonen av Wine Bar har muvm innebygd. Ellers, installer det ved å bruke \"sudo dnf install muvm fex-emu\" eller lignende';

  @override
  String get prefixNameCantBeEmpty => 'Prefiksnavn kan ikke være tomt';

  @override
  String get illegalSymbolsPresent => 'Ugyldige symboler funnet';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Denne Wine-prefiksen inkluderer ikke et winetricks-skript, og det ble heller ikke levert et eksternt.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Kunne ikke finne wine / wineserver‑eksekverbare filer';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Kunne ikke finne wine / wineserver‑eksekverbare filer for å kjøre winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Kommandoen \"$command\" feilet';
  }
}
