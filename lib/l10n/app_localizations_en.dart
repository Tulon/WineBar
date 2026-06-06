// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get kronekWineSourceDescription =>
      'Provides the standard, Staging, TkG and Proton Wine builds.';

  @override
  String get geProtonWineSourceDescription =>
      'Provides Proton builds with DXVK / VK3D included. Recommended for games and other fullscreen apps.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'App unpinning confirmation';

  @override
  String get createWinePrefixDialogTitle => 'Create a Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Clone Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Prefix deletion confirmation';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Path inaccessible from Wine';

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
    return 'Prefix \"$prefixName\" already exists';
  }

  @override
  String get unknownErrorMessage => 'Unknown error';

  @override
  String get criticalErrorCaption => 'Critical Error';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'No logs were captured from this process';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix updated';

  @override
  String get pinnedAppUpdatedMessage => 'Pinned app updated';

  @override
  String get moreDetailsLink => 'More details.';

  @override
  String get wow64ModeSection => 'WOW64 mode';

  @override
  String get useWow64ModeIfAvailable => 'Use the WOW64 mode if available';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 implementation';

  @override
  String get useParticularD3D8To11Impl =>
      'Use a particular Direct3D 8-11 implementation';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'A default implementation for this particular Wine build will be used';

  @override
  String get windowsLocale => 'Locale';

  @override
  String get useParticularWindowsLocale => 'Use a particular locale';

  @override
  String get dontShowThisWarningAgain => 'Don\'t show this warning again';

  @override
  String get nameForTheNewPrefixHintText => 'Name for the new wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'This may help with text display in non-Unicode apps';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'The system locale will be used by Windows apps';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'This will make the text too small but won\'t break older fullscreen apps';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'This is the perfect scale for your display';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'This will help with text being too small but will break older fullscreen apps';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'This is the perfect scale for your display, though it will break older fullscreen apps';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'This may produce text that\'s too large';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'This prefix is in a state were it can\'t be deleted';

  @override
  String get hiDpiScaleLabel => 'HiDPI scale';

  @override
  String get pleaseSelect => 'Please select';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Apps are running in this prefix';

  @override
  String get refreshWineReleasesTooltip => 'Refresh wine releases';

  @override
  String get prefixSettingsTooltip => 'Prefix settings';

  @override
  String get killProcessTooltip => 'Kill process';

  @override
  String get scrollToBottomTooltip => 'Scroll to bottom';

  @override
  String get scrollToTopTooltip => 'Scroll to top';

  @override
  String get viewLogsTooltip => 'View Logs';

  @override
  String get viewLogsLink => 'View Logs.';

  @override
  String get useParticularGPU => 'Use a particular GPU';

  @override
  String get gpuSelection => 'GPU selection';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Failed to get the list of available GPUs';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Note that this feature doesn\'t work in all scenarios';

  @override
  String get addWinePrefixButtonLabel => 'Add Wine Prefix';

  @override
  String get aboutButtonLabel => 'About';

  @override
  String get donateButtonLabel => 'Donate';

  @override
  String get unpinButtonLabel => 'Unpin';

  @override
  String get deleteButtonLabel => 'Delete';

  @override
  String get createWinePrefixButtonLabel => 'Create Wine Prefix';

  @override
  String get startingButtonLabel => 'Starting ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Downloading and Extracting ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Downloading and Extracting DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Creating Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Update Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Updating Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'Clone';

  @override
  String get cloningButtonLabel => 'Cloning ...';

  @override
  String get pinExecutableButtonLabel => 'Pin Executable';

  @override
  String get proceedAnywayButtonLabel => 'Proceed Anyway';

  @override
  String get runExecutableButtonLabel => 'Run Executable';

  @override
  String get runInstallerButtonLabel => 'Run Installer';

  @override
  String get settingsMenuItem => 'Settings';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'The following app is about to be unpinned:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'The following prefix is about to be deleted:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'The following path is inaccessible from Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'A path may be inaccessible from Wine because the whole Wine Bar or just Wine is running in a virtual machine (on Apple silicon Macs) or in a Snap / Flatpak sandbox.';

  @override
  String get solutionHeading => 'Solution';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Copy the folder in question somewhere under your home directory.';

  @override
  String get thisActionCantBeUndone => 'This action can\'t be undone!';

  @override
  String get selectWineBuildProviderStepName => 'Select wine build provider';

  @override
  String get selectWineReleaseStepName => 'Select wine release';

  @override
  String get selectWineBuildStepName => 'Select wine build';

  @override
  String get setOptionsStepName => 'Set options';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'A WOW64 build was selected. Those are known to have issues under emulation. Expect a broken installation.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'This build requires 32-bit libraries to be present on your system. If you have them already, you can ignore this warning. Otherwise, install Wine from your distro\'s repository (which will bring in those 32-bit libraries) or alternatively, select a WOW64 build from the list above if one is available.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'The WOW64 mode under emulation is known to have issues. Expect a broken installation.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Not using the WOW64 mode will require 32-bit libraries to be present on your system. If you have them already, you can ignore this warning. Otherwise, install Wine from your distro\'s repository, which will bring in those 32-bit libraries.';

  @override
  String get windowsExecutablesFilterName => 'Windows executables';

  @override
  String get dxvkOptionExplanation =>
      'A newer and faster implementation from Proton';

  @override
  String get wineD3DOptionExplanation =>
      'A mature implementation from Wine. To be used in case of issues with DXVK.';

  @override
  String get screensaverDisableReason =>
      'A Wine app (possibly fullscreen) is running';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'The hash of the downloaded winetricks script doesn\'t match the expected one.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Downloaded file: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Expected SHA256 hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Actual SHA256 hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Finish the apps running in all prefixes first';

  @override
  String get finishTheRunningAppsFirst => 'Finish the running apps first';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'This system lacks the hardware virtualization capabilities (/dev/kvm is missing) that are required to run Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar on ARM64 needs read-write access to /dev/kvm. Ordinary apps normally have such access, but not Snaps. To grant such access, run the following command from the command line:\n\n$kvmConnectCommand\n\nThen, restart Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'This system needs muvm / FEX to be able to run Windows apps. The Snap version of Wine Bar has muvm built-in. Otherwise, please install it using \"sudo dnf install muvm fex-emu\" or similar';

  @override
  String get prefixNameCantBeEmpty => 'Prefix name can\'t be empty';

  @override
  String get illegalSymbolsPresent => 'Illegal symbols present';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'This Wine prefix doesn\'t bundle a winetricks script and neither was an external one provided.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Failed to locate the wine / wineserver executables';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Failed to locate the wine / wineserver executables for running winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'The \"$command\" command failed';
  }
}
