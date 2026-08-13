// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'Fornisce le build standard, Staging, TkG e Proton di Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Fornisce le build Proton con DXVK / VK3D incluse. Raccomandato per giochi e altre app a schermo intero.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Conferma annullamento ancoraggio app';

  @override
  String get createWinePrefixDialogTitle => 'Crea un Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Clona Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Conferma cancellazione Prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Percorso non accessibile da Wine';

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
    return '$pinnedExecutableLabel Impostazioni';
  }

  @override
  String get processLogsTitle => 'Log del processo';

  @override
  String licenseInfoPattern(String license) {
    return 'Licenza: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autore: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Il processo di copia è fallito con stato $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'Il pacchetto DXVK manca della sottocartella x32 o x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Impossibile preparare lo script winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'La cartella $toplevelDataDir esiste ma non è stata riconosciuta come appartenente a questa app.\nRinominala o spostala nel Cestino e poi riavvia l\'app.';
  }

  @override
  String get extractionFailedMessage => 'Estrazione fallita';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Il prefisso \"$prefixName\" esiste già';
  }

  @override
  String get unknownErrorMessage => 'Errore sconosciuto';

  @override
  String get criticalErrorCaption => 'Errore critico';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Non sono stati catturati log da questo processo';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix aggiornato';

  @override
  String get pinnedAppUpdatedMessage => 'Applicazione ancorata aggiornata';

  @override
  String get moreDetailsLink => 'Altri dettagli.';

  @override
  String get wow64ModeSection => 'Modalità WOW64';

  @override
  String get useWow64ModeIfAvailable => 'Usa la modalità WOW64 se disponibile';

  @override
  String get d3D8To11Implementation => 'Implementazione Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Usa una particolare implementazione Direct3D 8-11';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Per questa versione di Wine verrà usata un\'implementazione predefinita';

  @override
  String get windowsLocale => 'Località';

  @override
  String get useParticularWindowsLocale => 'Usa una località specifica';

  @override
  String get dontShowThisWarningAgain => 'Non mostrare più questo avviso';

  @override
  String get nameForTheNewPrefixHintText => 'Nome per il nuovo Wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Questo può aiutare con l\'visualizzazione del testo in app non-Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'La località di sistema verrà usata dalle app Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Questo renderà il testo troppo piccolo ma non romperà le vecchie app a schermo intero';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Questa è la scala perfetta per il tuo schermo';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Questo aiuterà a evitare che il testo sia troppo piccolo, ma interromperà le vecchie app in modalità schermo intero';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Questa è la scala perfetta per il tuo schermo, ma interromperà le vecchie app in modalità schermo intero';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Questo può produrre un testo troppo grande';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Questo prefisso è in uno stato in cui non può essere eliminato';

  @override
  String get hiDpiScaleLabel => 'Scala HiDPI';

  @override
  String get pleaseSelect => 'Seleziona';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Le app sono in esecuzione in questo prefix';

  @override
  String get refreshWineReleasesTooltip => 'Aggiorna le release di wine';

  @override
  String get prefixSettingsTooltip => 'Impostazioni del prefix';

  @override
  String get killProcessTooltip => 'Termina processo';

  @override
  String get scrollToBottomTooltip => 'Scorri verso il basso';

  @override
  String get scrollToTopTooltip => 'Scorri verso l\'alto';

  @override
  String get viewLogsTooltip => 'Visualizza log';

  @override
  String get viewLogsLink => 'Visualizza log.';

  @override
  String get useParticularGPU => 'Usa una GPU specifica';

  @override
  String get gpuSelection => 'Selezione GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Impossibile ottenere l\'elenco delle GPU disponibili';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Nota che questa funzionalità non funziona in tutti gli scenari';

  @override
  String get addWinePrefixButtonLabel => 'Aggiungi Wine Prefix';

  @override
  String get aboutButtonLabel => 'Informazioni';

  @override
  String get donateButtonLabel => 'Donare';

  @override
  String get unpinButtonLabel => 'Scollega';

  @override
  String get deleteButtonLabel => 'Elimina';

  @override
  String get createWinePrefixButtonLabel => 'Crea Wine Prefix';

  @override
  String get startingButtonLabel => 'Avvio ...';

  @override
  String get downloadingAndExtractingButtonLabel => 'Download e estrazione ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Download e estrazione DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Creazione Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Aggiorna Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Aggiornamento Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Clona';

  @override
  String get cloningButtonLabel => 'Clonazione …';

  @override
  String get pinExecutableButtonLabel => 'Ancorare Eseguibile';

  @override
  String get proceedAnywayButtonLabel => 'Procedi comunque';

  @override
  String get runExecutableButtonLabel => 'Esegui Eseguibile';

  @override
  String get runInstallerButtonLabel => 'Esegui Installatore';

  @override
  String get settingsMenuItem => 'Impostazioni';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'L\'app seguente sta per essere scollegata:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Il seguente prefix è sul punto di essere eliminato:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Il percorso seguente è inaccessibile da Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Un percorso potrebbe non essere accessibile da Wine perché l\'intero Wine Bar o solo Wine è in esecuzione in una macchina virtuale (su Mac Apple silicon) o in un sandbox Snap / Flatpak.';

  @override
  String get solutionHeading => 'Soluzione';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Copia la cartella in questione da qualche parte sotto il tuo home directory.';

  @override
  String get thisActionCantBeUndone =>
      'Questa azione non può essere annullata!';

  @override
  String get selectWineBuildProviderStepName =>
      'Seleziona provider di build Wine';

  @override
  String get selectWineReleaseStepName => 'Seleziona rilascio Wine';

  @override
  String get selectWineBuildStepName => 'Seleziona build Wine';

  @override
  String get setOptionsStepName => 'Imposta opzioni';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'È stato selezionato un build WOW64. Si sa che presenta problemi sotto emulazione. Aspettatevi un\'installazione danneggiata.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Questo build richiede che le librerie a 32 bit siano presenti sul vostro sistema. Se le avete già, potete ignorare questo avviso. Altrimenti, installate Wine dal repository della vostra distribuzione (che porterà le librerie a 32 bit) o, in alternativa, selezionate un build WOW64 dall\'elenco sopra se disponibile.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'La modalità WOW64 sotto emulazione è nota per avere problemi. Aspettatevi un\'installazione danneggiata.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Non usare la modalità WOW64 richiederà che le librerie a 32 bit siano presenti sul vostro sistema. Se le avete già, potete ignorare questo avviso. Altrimenti, installate Wine dal repository della vostra distribuzione, che porterà le librerie a 32 bit.';

  @override
  String get windowsExecutablesFilterName => 'Eseguibili Windows';

  @override
  String get dxvkOptionExplanation =>
      'Un\'implementazione più recente e veloce da Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Un\'implementazione matura da Wine. Da usare in caso di problemi con DXVK.';

  @override
  String get screensaverDisableReason =>
      'Un\'app Wine (possibilmente a schermo intero) è in esecuzione';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'L\'hash dello script winetricks scaricato non corrisponde a quello previsto.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'File scaricato: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'SHA256 previsto: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'SHA256 effettivo: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Termina prima le app in esecuzione in tutti i prefix';

  @override
  String get finishTheRunningAppsFirst => 'Termina prima le app in esecuzione';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Questo sistema manca delle capacità di virtualizzazione hardware (/dev/kvm è mancante) necessarie per eseguire Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar su ARM64 necessita di accesso in lettura-scrittura a /dev/kvm. Le app ordinarie normalmente hanno tale accesso, ma non i Snaps. Per concedere tale accesso, esegui il seguente comando dalla riga di comando:\n\n$kvmConnectCommand\n\nQuindi, riavvia Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Questo sistema necessita di muvm / FEX per poter eseguire app Windows. La versione Snap di Wine Bar ha muvm integrato. Altrimenti, installalo usando \"sudo dnf install muvm fex-emu\" o simili';

  @override
  String get prefixNameCantBeEmpty =>
      'Il nome del prefisso non può essere vuoto';

  @override
  String get illegalSymbolsPresent => 'Simboli non consentiti presenti';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Questo Wine prefix non include uno script winetricks e nessun script esterno è stato fornito.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Impossibile individuare gli eseguibili wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Impossibile individuare gli eseguibili wine / wineserver per l\'esecuzione di winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Il comando \"$command\" è fallito';
  }
}
