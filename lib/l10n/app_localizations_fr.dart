// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'Fournit les versions standard, Staging, TkG et Proton de Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Fournit les builds Proton avec DXVK / VK3D inclus. Recommandé pour les jeux et autres applications plein écran.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Confirmation du désépinglage de l’application';

  @override
  String get createWinePrefixDialogTitle => 'Créer un Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Cloner Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Confirmation de suppression du Prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Chemin inaccessible depuis Wine';

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
    return '$pinnedExecutableLabel Paramètres';
  }

  @override
  String get processLogsTitle => 'Journaux de processus';

  @override
  String licenseInfoPattern(String license) {
    return 'Licence : $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Auteur : $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Le processus de copie a échoué avec le statut $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'Le paquet DXVK ne contient pas le sous‑répertoire x32 ou x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Échec de la préparation du script winetricks :';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Le dossier $toplevelDataDir existe mais n\'a pas été reconnu comme appartenant à cette application.\nVeuillez le renommer ou le déplacer vers la Corbeille, puis redémarrez l\'application.';
  }

  @override
  String get extractionFailedMessage => 'Échec de l\'extraction';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Le préfixe \"$prefixName\" existe déjà';
  }

  @override
  String get unknownErrorMessage => 'Erreur inconnue';

  @override
  String get criticalErrorCaption => 'Erreur critique';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Aucun journal n\'a été capturé à partir de ce processus';

  @override
  String get winePrefixUpdatedMessage => 'Préfixe Wine mis à jour';

  @override
  String get pinnedAppUpdatedMessage => 'Application épinglée mise à jour';

  @override
  String get moreDetailsLink => 'Plus de détails.';

  @override
  String get wow64ModeSection => 'Mode WOW64';

  @override
  String get useWow64ModeIfAvailable => 'Utiliser le mode WOW64 si disponible';

  @override
  String get d3D8To11Implementation => 'Implémentation Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Utiliser une implémentation Direct3D 8-11 particulière';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Une implémentation par défaut pour cette version particulière de Wine sera utilisée';

  @override
  String get windowsLocale => 'Langue';

  @override
  String get useParticularWindowsLocale => 'Utiliser une locale particulière';

  @override
  String get dontShowThisWarningAgain => 'Ne plus afficher cet avertissement';

  @override
  String get nameForTheNewPrefixHintText => 'Nom du nouveau Wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Cela peut aider à l\'affichage du texte dans les applications non-Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'La locale système sera utilisée par les applications Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Cela rendra le texte trop petit mais ne cassera pas les anciennes applications plein écran';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Ceci est l’échelle parfaite pour votre affichage';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Cela aidera à éviter que le texte soit trop petit mais cassera les anciennes applications plein écran';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Ceci est l’échelle parfaite pour votre affichage, mais cassera les anciennes applications plein écran';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Cela peut produire un texte trop grand';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Ce prefix est dans un état où il ne peut pas être supprimé';

  @override
  String get hiDpiScaleLabel => 'Échelle HiDPI';

  @override
  String get pleaseSelect => 'Veuillez sélectionner';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Des applications sont en cours d\'exécution dans ce prefix';

  @override
  String get refreshWineReleasesTooltip => 'Actualiser les versions de wine';

  @override
  String get prefixSettingsTooltip => 'Paramètres du prefix';

  @override
  String get killProcessTooltip => 'Tuer le processus';

  @override
  String get scrollToBottomTooltip => 'Faire défiler vers le bas';

  @override
  String get scrollToTopTooltip => 'Faire défiler vers le haut';

  @override
  String get viewLogsTooltip => 'Afficher les journaux';

  @override
  String get viewLogsLink => 'Afficher les journaux.';

  @override
  String get useParticularGPU => 'Utiliser un GPU particulier';

  @override
  String get gpuSelection => 'Sélection du GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Échec de la récupération de la liste des GPU disponibles';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Notez que cette fonctionnalité ne fonctionne pas dans tous les scénarios';

  @override
  String get addWinePrefixButtonLabel => 'Ajouter un Wine Prefix';

  @override
  String get aboutButtonLabel => 'À propos';

  @override
  String get donateButtonLabel => 'Faire un don';

  @override
  String get unpinButtonLabel => 'Détacher';

  @override
  String get deleteButtonLabel => 'Supprimer';

  @override
  String get createWinePrefixButtonLabel => 'Créer un Wine Prefix';

  @override
  String get startingButtonLabel => 'Démarrage ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Téléchargement et extraction ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Téléchargement et extraction DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Création d\'un Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Mettre à jour le Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Mise à jour du Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Cloner';

  @override
  String get cloningButtonLabel => 'Clonage …';

  @override
  String get pinExecutableButtonLabel => 'Épingler l\'exécutable';

  @override
  String get proceedAnywayButtonLabel => 'Continuer quand même';

  @override
  String get runExecutableButtonLabel => 'Exécuter l\'exécutable';

  @override
  String get runInstallerButtonLabel => 'Exécuter l\'installateur';

  @override
  String get settingsMenuItem => 'Paramètres';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'L\'application suivante est sur le point d\'être désépinglée :';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Le prefix suivant est sur le point d\'être supprimé :';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Le chemin suivant est inaccessible depuis Wine :';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Un chemin peut être inaccessible depuis Wine parce que l’ensemble de Wine Bar ou seulement Wine s’exécute dans une machine virtuelle (sur les Macs Apple silicon) ou dans un bac à sable Snap / Flatpak.';

  @override
  String get solutionHeading => 'Solution';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Copiez le dossier concerné quelque part sous votre répertoire personnel.';

  @override
  String get thisActionCantBeUndone =>
      'Cette action ne peut pas être annulée !';

  @override
  String get selectWineBuildProviderStepName =>
      'Sélectionner le fournisseur de build Wine';

  @override
  String get selectWineReleaseStepName => 'Sélectionner la version Wine';

  @override
  String get selectWineBuildStepName => 'Sélectionner le build Wine';

  @override
  String get setOptionsStepName => 'Définir les options';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Une version WOW64 a été sélectionnée. On sait qu’elle présente des problèmes en mode émulation. Attendez une installation défectueuse.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Cette version nécessite que les bibliothèques 32 bits soient présentes sur votre système. Si vous les avez déjà, vous pouvez ignorer cet avertissement. Sinon, installez Wine depuis le dépôt de votre distribution (qui apportera ces bibliothèques 32 bits) ou, alternativement, choisissez une version WOW64 dans la liste ci‑dessus si elle est disponible.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'Le mode WOW64 en émulation est connu pour présenter des problèmes. Attendez une installation défectueuse.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Ne pas utiliser le mode WOW64 nécessitera que les bibliothèques 32 bits soient présentes sur votre système. Si vous les avez déjà, vous pouvez ignorer cet avertissement. Sinon, installez Wine depuis le dépôt de votre distribution, qui apportera ces bibliothèques 32 bits.';

  @override
  String get windowsExecutablesFilterName => 'Exécutables Windows';

  @override
  String get dxvkOptionExplanation =>
      'Une implémentation plus récente et rapide de Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Une implémentation mature de Wine. À utiliser en cas de problèmes avec DXVK.';

  @override
  String get screensaverDisableReason =>
      'Une application Wine (probablement en plein écran) est en cours d\'exécution';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Le hachage du script winetricks téléchargé ne correspond pas à celui attendu.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Fichier téléchargé : $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Hachage SHA256 attendu : $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Hachage SHA256 réel : $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Terminez d\'abord les applications en cours dans tous les prefixes';

  @override
  String get finishTheRunningAppsFirst =>
      'Terminez d\'abord les applications en cours';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Ce système ne dispose pas des capacités de virtualisation matérielle (/dev/kvm est manquant) nécessaires pour exécuter Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar sur ARM64 nécessite un accès lecture-écriture à /dev/kvm. Les applications ordinaires disposent normalement de cet accès, mais pas les Snaps. Pour accorder cet accès, exécutez la commande suivante depuis le terminal :\n\n$kvmConnectCommand\n\nEnsuite, redémarrez Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Ce système a besoin de muvm / FEX pour pouvoir exécuter des applications Windows. La version Snap de Wine Bar intègre muvm. Sinon, veuillez l\'installer avec \"sudo dnf install muvm fex-emu\" ou une commande similaire';

  @override
  String get prefixNameCantBeEmpty => 'Le nom du préfixe ne peut pas être vide';

  @override
  String get illegalSymbolsPresent => 'Symboles illégaux présents';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Ce Wine prefix ne contient pas de script winetricks et aucun script externe n\'a été fourni.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Échec de la localisation des exécutables wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Échec de la localisation des exécutables wine / wineserver pour l\'exécution de winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'La commande \"$command\" a échoué';
  }
}
