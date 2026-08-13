// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'Παρέχει τις προεπιλεγμένες, Staging, TkG και Proton εκδόσεις του Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Παρέχει εκδόσεις Proton με ενσωματωμένο DXVK / VK3D. Συνιστάται για παιχνίδια και άλλες εφαρμογές πλήρους οθόνης.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Επιβεβαίωση αποπροσκόλλησης εφαρμογής';

  @override
  String get createWinePrefixDialogTitle => 'Δημιουργία Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Κλωνοποίηση Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Επιβεβαίωση διαγραφής Prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Μονοπάτι μη προσβάσιμο από το Wine';

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
    return '$pinnedExecutableLabel Ρυθμίσεις';
  }

  @override
  String get processLogsTitle => 'Καταγραφές Διαδικασιών';

  @override
  String licenseInfoPattern(String license) {
    return 'Άδεια: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Συγγραφέας: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Η διαδικασία αντιγραφής απέτυχε με κατάσταση $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'Το πακέτο DXVK λείπει το υποκατάλογο x32 ή x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Αποτυχία προετοιμασίας του σενάριου winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Ο φάκελος $toplevelDataDir υπάρχει αλλά δεν αναγνωρίστηκε ως ανήκων σε αυτήν την εφαρμογή.\nΠαρακαλώ μετονομάστε τον ή μετακινήστε τον στο Κάδο Απορριμμάτων και στη συνέχεια επανεκκινήστε την εφαρμογή.';
  }

  @override
  String get extractionFailedMessage => 'Η εξαγωγή απέτυχε';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Το προφίλ \"$prefixName\" υπάρχει ήδη';
  }

  @override
  String get unknownErrorMessage => 'Άγνωστο σφάλμα';

  @override
  String get criticalErrorCaption => 'Κρίσιμο σφάλμα';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Δεν καταγράφηκαν αρχεία καταγραφής από αυτή τη διαδικασία';

  @override
  String get winePrefixUpdatedMessage => 'Το Wine prefix ενημερώθηκε';

  @override
  String get pinnedAppUpdatedMessage => 'Η καρφιτσωμένη εφαρμογή ενημερώθηκε';

  @override
  String get moreDetailsLink => 'Περισσότερες λεπτομέρειες.';

  @override
  String get wow64ModeSection => 'Λειτουργία WOW64';

  @override
  String get useWow64ModeIfAvailable =>
      'Χρησιμοποιήστε τη λειτουργία WOW64 εάν είναι διαθέσιμη';

  @override
  String get d3D8To11Implementation => 'Υλοποίηση Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Χρησιμοποιήστε μια συγκεκριμένη υλοποίηση Direct3D 8-11';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Θα χρησιμοποιηθεί μια προεπιλεγμένη υλοποίηση για αυτήν την συγκεκριμένη έκδοση του Wine';

  @override
  String get windowsLocale => 'Τοπικό';

  @override
  String get useParticularWindowsLocale => 'Χρήση ενός συγκεκριμένου τοπικού';

  @override
  String get dontShowThisWarningAgain =>
      'Μην εμφανίζεις ξανά αυτήν την προειδοποίηση';

  @override
  String get nameForTheNewPrefixHintText => 'Όνομα για το νέο wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Αυτό μπορεί να βοηθήσει με την εμφάνιση κειμένου σε μη-Unicode εφαρμογές';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Το τοπικό του συστήματος θα χρησιμοποιηθεί από τις εφαρμογές Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Αυτό θα κάνει το κείμενο πολύ μικρό, αλλά δεν θα σπάσει τις παλιές εφαρμογές πλήρους οθόνης';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Αυτός είναι ο τέλειος κλίμακας για την οθόνη σας';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Αυτό θα βοηθήσει με το κείμενο να είναι πολύ μικρό, αλλά θα σπάσει παλαιότερες εφαρμογές πλήρους οθόνης';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Αυτός είναι ο τέλειος κλίμακας για την οθόνη σας, αν και θα σπάσει παλαιότερες εφαρμογές πλήρους οθόνης';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Αυτό μπορεί να παράγει κείμενο που είναι πολύ μεγάλο';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Αυτό το prefix βρίσκεται σε κατάσταση όπου δεν μπορεί να διαγραφεί';

  @override
  String get hiDpiScaleLabel => 'Κλίμακα HiDPI';

  @override
  String get pleaseSelect => 'Παρακαλώ επιλέξτε';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Οι εφαρμογές εκτελούνται σε αυτό το προφίλ';

  @override
  String get refreshWineReleasesTooltip => 'Ανανέωση κυκλοφοριών Wine';

  @override
  String get prefixSettingsTooltip => 'Ρυθμίσεις προφίλ';

  @override
  String get killProcessTooltip => 'Τερματισμός διεργασίας';

  @override
  String get scrollToBottomTooltip => 'Κύλιση προς τα κάτω';

  @override
  String get scrollToTopTooltip => 'Κύλιση προς τα πάνω';

  @override
  String get viewLogsTooltip => 'Προβολή αρχείων καταγραφής';

  @override
  String get viewLogsLink => 'Προβολή αρχείων καταγραφής.';

  @override
  String get useParticularGPU => 'Χρήση συγκεκριμένου GPU';

  @override
  String get gpuSelection => 'Επιλογή GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Αποτυχία λήψης της λίστας διαθέσιμων GPU';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Σημειώστε ότι αυτή η λειτουργία δεν λειτουργεί σε όλες τις περιπτώσεις';

  @override
  String get addWinePrefixButtonLabel => 'Προσθήκη Wine Prefix';

  @override
  String get aboutButtonLabel => 'Σχετικά';

  @override
  String get donateButtonLabel => 'Δωρεά';

  @override
  String get unpinButtonLabel => 'Αποπροσάρτηση';

  @override
  String get deleteButtonLabel => 'Διαγραφή';

  @override
  String get createWinePrefixButtonLabel => 'Δημιουργία Wine Prefix';

  @override
  String get startingButtonLabel => 'Εκκίνηση ...';

  @override
  String get downloadingAndExtractingButtonLabel => 'Λήψη και εξαγωγή ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Λήψη και εξαγωγή DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Δημιουργία Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Ενημέρωση Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Ενημέρωση Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Κλωνοποίηση';

  @override
  String get cloningButtonLabel => 'Κλωνοποίηση …';

  @override
  String get pinExecutableButtonLabel => 'Καρφίτσωμα Εκτελέσιμου';

  @override
  String get proceedAnywayButtonLabel => 'Συνέχεια Όλα Τι';

  @override
  String get runExecutableButtonLabel => 'Εκτέλεση Εκτελέσιμου';

  @override
  String get runInstallerButtonLabel => 'Εκτέλεση Εγκαταστάτη';

  @override
  String get settingsMenuItem => 'Ρυθμίσεις';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Η ακόλουθη εφαρμογή πρόκειται να αποκαρφίτηται:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Το ακόλουθο prefix πρόκειται να διαγραφεί:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Η ακόλουθη διαδρομή είναι μη προσβάσιμη από Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Μια διαδρομή μπορεί να είναι μη προσβάσιμη από το Wine επειδή ολόκληρο το Wine Bar ή μόνο το Wine εκτελείται σε εικονική μηχανή (σε Macs με Apple silicon) ή σε sandbox Snap / Flatpak.';

  @override
  String get solutionHeading => 'Λύση';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Αντιγράψτε τον κατάλογο που αφορά κάπου κάτω από το προσωπικό σας φάκελο.';

  @override
  String get thisActionCantBeUndone =>
      'Αυτή η ενέργεια δεν μπορεί να αναιρεθεί!';

  @override
  String get selectWineBuildProviderStepName =>
      'Επιλέξτε πάροχο κατασκευής wine';

  @override
  String get selectWineReleaseStepName => 'Επιλέξτε έκδοση wine';

  @override
  String get selectWineBuildStepName => 'Επιλέξτε κατασκευή wine';

  @override
  String get setOptionsStepName => 'Ορίστε επιλογές';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Ένα build WOW64 επιλέχθηκε. Γνωρίζεται ότι έχει προβλήματα υπό προσομοίωση. Αναμένετε μια χαλασμένη εγκατάσταση.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Αυτό το build απαιτεί την παρουσία 32‑bit βιβλιοθηκών στο σύστημά σας. Αν τις έχετε ήδη, μπορείτε να αγνοήσετε αυτήν την προειδοποίηση. Διαφορετικά, εγκαταστήστε το Wine από το αποθετήριο της διανομής σας (που θα φέρει αυτές τις 32‑bit βιβλιοθήκες) ή, εναλλακτικά, επιλέξτε ένα build WOW64 από τη λίστα παραπάνω αν υπάρχει διαθέσιμο.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'Η λειτουργία WOW64 υπό προσομοίωση είναι γνωστή για προβλήματα. Αναμένετε μια χαλασμένη εγκατάσταση.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Η μη χρήση της λειτουργίας WOW64 θα απαιτήσει την παρουσία 32‑bit βιβλιοθηκών στο σύστημά σας. Αν τις έχετε ήδη, μπορείτε να αγνοήσετε αυτήν την προειδοποίηση. Διαφορετικά, εγκαταστήστε το Wine από το αποθετήριο της διανομής σας, που θα φέρει αυτές τις 32‑bit βιβλιοθήκες.';

  @override
  String get windowsExecutablesFilterName => 'Εκτελέσιμα Windows';

  @override
  String get dxvkOptionExplanation =>
      'Μια πιο πρόσφατη και ταχύτερη υλοποίηση από το Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Μια ώριμη υλοποίηση από το Wine. Χρησιμοποιείται σε περίπτωση προβλημάτων με το DXVK.';

  @override
  String get screensaverDisableReason =>
      'Εκτελείται μια εφαρμογή Wine (πιθανώς σε πλήρη οθόνη)';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Το hash του ληφθέντος σενάριο winetricks δεν ταιριάζει με το αναμενόμενο.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Ληφθείσες αρχεία: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Αναμενόμενο SHA256 hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Πραγματικό SHA256 hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Ολοκληρώστε τις εφαρμογές που εκτελούνται σε όλα τα prefixes πρώτα';

  @override
  String get finishTheRunningAppsFirst =>
      'Ολοκληρώστε τις εκτελούμενες εφαρμογές πρώτα';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Το σύστημα δεν διαθέτει τις δυνατότητες υλικολογικής εικονικοποίησης (/dev/kvm λείπει) που απαιτούνται για την εκτέλεση του Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Το Wine Bar σε ARM64 χρειάζεται πρόσβαση ανάγνωση-εγγραφή στο /dev/kvm. Τα συνηθισμένα προγράμματα συνήθως έχουν τέτοια πρόσβαση, αλλά όχι τα Snap. Για να παραχωρήσετε αυτή την πρόσβαση, εκτελέστε την ακόλουθη εντολή από τη γραμμή εντολών:\n\n$kvmConnectCommand\n\nΣτη συνέχεια, επανεκκινήστε το Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Το σύστημα χρειάζεται muvm / FEX για να μπορεί να εκτελεί εφαρμογές Windows. Η έκδοση Snap του Wine Bar έχει ενσωματωμένο muvm. Διαφορετικά, παρακαλούμε εγκαταστήστε το χρησιμοποιώντας \"sudo dnf install muvm fex-emu\" ή παρόμοιο.';

  @override
  String get prefixNameCantBeEmpty =>
      'Το όνομα του προθέματος δεν μπορεί να είναι κενό';

  @override
  String get illegalSymbolsPresent => 'Παρουσιάζονται παράνομες συμβολές';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Αυτό το Wine prefix δεν περιλαμβάνει ένα σενάριο winetricks και ούτε παρέχεται εξωτερικό.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Αποτυχία εντοπισμού των εκτελέσιμων αρχείων wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Αποτυχία εντοπισμού των εκτελέσιμων αρχείων wine / wineserver για την εκτέλεση winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Η εντολή \"$command\" απέτυχε';
  }
}
