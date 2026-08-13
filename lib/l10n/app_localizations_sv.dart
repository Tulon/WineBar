// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'Tillhandahåller standard-, Staging-, TkG- och Proton-Wine-byggnader.';

  @override
  String get geProtonWineSourceDescription =>
      'Tillhandahåller Proton-byggnader med DXVK / VK3D inkluderade. Rekommenderas för spel och andra applikationer i helskärmsläge.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Bekräftelse av avpinnande av app';

  @override
  String get createWinePrefixDialogTitle => 'Skapa ett Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Klona Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Bekräftelse av borttagning av prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Sökväg otillgänglig från Wine';

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
    return '$pinnedExecutableLabel Inställningar';
  }

  @override
  String get processLogsTitle => 'Processloggar';

  @override
  String licenseInfoPattern(String license) {
    return 'Licens: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Författare: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Kopieringsprocessen misslyckades med status $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'DXVK-paketet saknar undermappen x32 eller x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Misslyckades med att förbereda winetricks-skriptet:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Mappen $toplevelDataDir finns men togs inte för att tillhöra denna app.\nVänligen byt namn på den eller flytta den till papperskorgen och starta sedan om appen.';
  }

  @override
  String get extractionFailedMessage => 'Extraktion misslyckades';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" finns redan';
  }

  @override
  String get unknownErrorMessage => 'Okänt fel';

  @override
  String get criticalErrorCaption => 'Kritiskt fel';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Inga loggar fångades från denna process';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix uppdaterad';

  @override
  String get pinnedAppUpdatedMessage => 'Fäst program uppdaterat';

  @override
  String get moreDetailsLink => 'Mer detaljer.';

  @override
  String get wow64ModeSection => 'WOW64-läge';

  @override
  String get useWow64ModeIfAvailable =>
      'Använd WOW64-läget om det finns tillgängligt';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 implementation';

  @override
  String get useParticularD3D8To11Impl =>
      'Använd en specifik Direct3D 8-11 implementation';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'En standardimplementation för denna specifika Wine-version kommer att användas';

  @override
  String get windowsLocale => 'Lokal';

  @override
  String get useParticularWindowsLocale => 'Använd en specifik lokal';

  @override
  String get dontShowThisWarningAgain => 'Visa inte denna varning igen';

  @override
  String get nameForTheNewPrefixHintText => 'Namn för den nya wine‑prefixen';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Detta kan hjälpa till med textvisning i icke‑Unicode‑program';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Systemets lokal kommer att användas av Windows‑program';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Detta gör texten för liten men bryter inte äldre helskärmsprogram';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Detta är den perfekta skalningen för din skärm';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Detta hjälper med att texten blir för liten men bryter äldre helskärmsappar';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Detta är den perfekta skalningen för din skärm, men det bryter äldre helskärmsappar';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Detta kan producera text som är för stor';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Denna prefix är i ett tillstånd där den inte kan raderas';

  @override
  String get hiDpiScaleLabel => 'HiDPI-skalning';

  @override
  String get pleaseSelect => 'Välj';

  @override
  String get appsAreRunningInThisPrefixTooltip => 'Program körs i denna prefix';

  @override
  String get refreshWineReleasesTooltip => 'Uppdatera wine-utgåvor';

  @override
  String get prefixSettingsTooltip => 'Prefixinställningar';

  @override
  String get killProcessTooltip => 'Avsluta process';

  @override
  String get scrollToBottomTooltip => 'Scrolla till botten';

  @override
  String get scrollToTopTooltip => 'Scrolla till toppen';

  @override
  String get viewLogsTooltip => 'Visa loggar';

  @override
  String get viewLogsLink => 'Visa loggar.';

  @override
  String get useParticularGPU => 'Använd en specifik GPU';

  @override
  String get gpuSelection => 'GPU-val';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Misslyckades med att hämta listan över tillgängliga GPU:er';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Observera att denna funktion inte fungerar i alla scenarier';

  @override
  String get addWinePrefixButtonLabel => 'Lägg till Wine Prefix';

  @override
  String get aboutButtonLabel => 'Om';

  @override
  String get donateButtonLabel => 'Donera';

  @override
  String get unpinButtonLabel => 'Avfäst';

  @override
  String get deleteButtonLabel => 'Ta bort';

  @override
  String get createWinePrefixButtonLabel => 'Skapa Wine Prefix';

  @override
  String get startingButtonLabel => 'Startar ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Laddar ner och extraherar ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Laddar ner och extraherar DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Skapar Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Uppdatera Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Uppdaterar Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Klon';

  @override
  String get cloningButtonLabel => 'Klonar …';

  @override
  String get pinExecutableButtonLabel => 'Fäst körbar';

  @override
  String get proceedAnywayButtonLabel => 'Fortsätt ändå';

  @override
  String get runExecutableButtonLabel => 'Kör körbar';

  @override
  String get runInstallerButtonLabel => 'Kör installationsprogram';

  @override
  String get settingsMenuItem => 'Inställningar';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Följande app är på väg att lossas:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Följande prefix är på väg att raderas:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Följande sökväg är otillgänglig från Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'En sökväg kan vara otillgänglig från Wine eftersom hela Wine Bar eller bara Wine körs i en virtuell maskin (på Apple silicon Macs) eller i ett Snap / Flatpak-sandlåda.';

  @override
  String get solutionHeading => 'Lösning';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Kopiera den aktuella mappen någonstans under din hemkatalog.';

  @override
  String get thisActionCantBeUndone => 'Denna åtgärd kan inte ångras!';

  @override
  String get selectWineBuildProviderStepName => 'Välj wine build provider';

  @override
  String get selectWineReleaseStepName => 'Välj wine release';

  @override
  String get selectWineBuildStepName => 'Välj wine build';

  @override
  String get setOptionsStepName => 'Ställ in alternativ';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'En WOW64-byggnad har valts. Dessa är kända för att ha problem under emulering. Förvänta dig en trasig installation.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Denna byggnad kräver att 32‑bitarsbibliotek finns på ditt system. Om du redan har dem kan du ignorera denna varning. Annars installera Wine från din distributions arkiv (vilket kommer att ta med de 32‑bitarsbiblioteken) eller välj alternativt en WOW64-byggnad från listan ovan om en sådan finns.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'WOW64‑läget under emulering är känt för att ha problem. Förvänta dig en trasig installation.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Att inte använda WOW64‑läget kräver att 32‑bitarsbibliotek finns på ditt system. Om du redan har dem kan du ignorera denna varning. Annars installera Wine från din distributions arkiv, vilket kommer att ta med de 32‑bitarsbiblioteken.';

  @override
  String get windowsExecutablesFilterName => 'Windows‑exekverbara filer';

  @override
  String get dxvkOptionExplanation =>
      'En nyare och snabbare implementation från Proton';

  @override
  String get wineD3DOptionExplanation =>
      'En mogen implementation från Wine. Att använda vid problem med DXVK.';

  @override
  String get screensaverDisableReason => 'En Wine-app (möjligen helskärm) körs';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Hashen för den nedladdade winetricks‑skriptet matchar inte den förväntade.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Nerladdad fil: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Förväntad SHA256‑hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Verklig SHA256‑hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Avsluta apparna som körs i alla prefixes först';

  @override
  String get finishTheRunningAppsFirst => 'Avsluta de körande apparna först';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Detta system saknar hårdvaruvirtualiseringsfunktioner (/dev/kvm saknas) som krävs för att köra Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar på ARM64 behöver läs- och skrivåtkomst till /dev/kvm. Vanliga appar har normalt sådan åtkomst, men inte Snaps. För att ge sådan åtkomst kör följande kommando från kommandoraden:\n\n$kvmConnectCommand\n\nDärefter starta om Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Detta system behöver muvm / FEX för att kunna köra Windows-appar. Snap-versionen av Wine Bar har muvm inbyggt. Annars, installera det med \"sudo dnf install muvm fex-emu\" eller liknande';

  @override
  String get prefixNameCantBeEmpty => 'Prefixnamn får inte vara tomt';

  @override
  String get illegalSymbolsPresent => 'Otillåtna symboler finns';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Detta Wine prefix innehåller ingen winetricks-skript och det har inte heller ett externt skript tillhandahållits.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Misslyckades med att hitta wine / wineserver-exekverbara';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Misslyckades med att hitta wine / wineserver-exekverbara för att köra winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Kommandot \"$command\" misslyckades';
  }
}
