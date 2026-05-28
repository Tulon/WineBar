import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lt'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('sv'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Shown when selecting the Kronek Wine build source
  ///
  /// In en, this message translates to:
  /// **'Provides the standard, Staging, TkG and Proton Wine builds.'**
  String get kronekWineSourceDescription;

  /// Shown when selecting the GE Proton Wine build source
  ///
  /// In en, this message translates to:
  /// **'Provides Proton builds with DXVK / VK3D included. Recommended for games and other fullscreen apps.'**
  String get geProtonWineSourceDescription;

  /// This text is used as a title in a dialog
  ///
  /// In en, this message translates to:
  /// **'App unpinning confirmation'**
  String get appUnpinningConfirmationDialogTitle;

  /// This text is used as a title in a dialog
  ///
  /// In en, this message translates to:
  /// **'Create a Wine Prefix'**
  String get createWinePrefixDialogTitle;

  /// This text is used as a title of a dialog
  ///
  /// In en, this message translates to:
  /// **'Clone Wine Prefix'**
  String get cloneWinePrefixDialogTitle;

  /// This text is used as a title of a dialog
  ///
  /// In en, this message translates to:
  /// **'Prefix deletion confirmation'**
  String get prefixDeletionConfirmationDialogTitle;

  /// This text is used as a title of a dialog
  ///
  /// In en, this message translates to:
  /// **'Path inaccessible from Wine'**
  String get pathInaccessibleFromWineDialogTitle;

  /// This text is used as a tile of a page
  ///
  /// In en, this message translates to:
  /// **'Wine Prefixes'**
  String get winePrefixesPageTitle;

  /// This text is used as a tile of a page
  ///
  /// In en, this message translates to:
  /// **'Wine Prefix: {prefixName}'**
  String winePrefixPageTitlePattern(String prefixName);

  /// The pattern for the Prefix Settings dialog's title
  ///
  /// In en, this message translates to:
  /// **'Wine Prefix {prefixName} Settings'**
  String prefixSettingsDialogTitlePattern(String prefixName);

  /// The pattern for the Pinned Executable Settings dialog's title
  ///
  /// In en, this message translates to:
  /// **'{pinnedExecutableLabel} Settings'**
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  );

  /// This text is used as a page title
  ///
  /// In en, this message translates to:
  /// **'Process Logs'**
  String get processLogsTitle;

  /// A string that ends up on the About Dialog
  ///
  /// In en, this message translates to:
  /// **'License: {license}'**
  String licenseInfoPattern(String license);

  /// A string that ends up on the About Dialog
  ///
  /// In en, this message translates to:
  /// **'Author: {author}'**
  String authorInfoPattern(String author);

  /// The error message shown when `cp -a` fails
  ///
  /// In en, this message translates to:
  /// **'The copying process failed with status {exitCode}'**
  String theCopyingProcessFailedWithExitCode(int exitCode);

  /// The error message shown when the directory structure of the downloaded DXVK package doesn't match our expectations
  ///
  /// In en, this message translates to:
  /// **'The DXVK package is missing the x32 or x64 subdirectory'**
  String get dxvkPackageIsMissingTheX32OrX64Subdir;

  /// The error message shown when downloading or validating the winetricks script fails
  ///
  /// In en, this message translates to:
  /// **'Failed to prepare the winetricks script:'**
  String get failedToPrepareWinetricksScript;

  /// The error message shown when we suspect the app's data directory wasn't actually created by this app
  ///
  /// In en, this message translates to:
  /// **'Folder {toplevelDataDir} exists but wasn\'t recognized as belonging to this app.\nPlease rename it or move it to Trash and then restart the app.'**
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir);

  /// The error message shown when archive extraction fails
  ///
  /// In en, this message translates to:
  /// **'Extraction failed'**
  String get extractionFailedMessage;

  /// The error message shown when trying to create a prefix that already exists
  ///
  /// In en, this message translates to:
  /// **'Prefix \"{prefixName}\" already exists'**
  String prefixAlreadyExists(String prefixName);

  /// A plaholder for the error text when no specific error is available
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownErrorMessage;

  /// A caption of the error message box
  ///
  /// In en, this message translates to:
  /// **'Critical Error'**
  String get criticalErrorCaption;

  /// An informational message
  ///
  /// In en, this message translates to:
  /// **'No logs were captured from this process'**
  String get noLogsWereCapturedFromThisProcess;

  /// An informational message
  ///
  /// In en, this message translates to:
  /// **'Wine prefix updated'**
  String get winePrefixUpdatedMessage;

  /// An informational message
  ///
  /// In en, this message translates to:
  /// **'Pinned app updated'**
  String get pinnedAppUpdatedMessage;

  /// This text becomes a clickable link that gets inserted at the end of an error message
  ///
  /// In en, this message translates to:
  /// **'More details.'**
  String get moreDetailsLink;

  /// This text appears on an input decoration
  ///
  /// In en, this message translates to:
  /// **'WOW64 mode'**
  String get wow64ModeSection;

  /// This text appears next to a checkbox
  ///
  /// In en, this message translates to:
  /// **'Use the WOW64 mode if available'**
  String get useWow64ModeIfAvailable;

  /// This text appears on an input decoration
  ///
  /// In en, this message translates to:
  /// **'Direct3D 8-11 implementation'**
  String get d3D8To11Implementation;

  /// This text appears next to a checkbox
  ///
  /// In en, this message translates to:
  /// **'Use a particular Direct3D 8-11 implementation'**
  String get useParticularD3D8To11Impl;

  /// The text displayed when no particular Direct3D 8-11 implementation is selected
  ///
  /// In en, this message translates to:
  /// **'A default implementation for this particular Wine build will be used'**
  String get defaultD3D8To11ImplWillBeUsed;

  /// The text next to a locale selection field. It's a Windows locale for a given Wine prefix.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get windowsLocale;

  /// This text appears next to a checkbox
  ///
  /// In en, this message translates to:
  /// **'Use a particular locale'**
  String get useParticularWindowsLocale;

  /// This text appears next to a checkbox
  ///
  /// In en, this message translates to:
  /// **'Don\'t show this warning again'**
  String get dontShowThisWarningAgain;

  /// The hint text appearing in an input field
  ///
  /// In en, this message translates to:
  /// **'Name for the new wine prefix'**
  String get nameForTheNewPrefixHintText;

  /// An informational text appearing if a particular windows locale is selected
  ///
  /// In en, this message translates to:
  /// **'This may help with text display in non-Unicode apps'**
  String get thisMayHelpWithTextInNonUnicodeApps;

  /// An informational text appearing if no particular windows locale is selected
  ///
  /// In en, this message translates to:
  /// **'The system locale will be used by Windows apps'**
  String get theSystemLocaleWillBeUsedForWindowsApps;

  /// This text appears when a smaller HiDPI scale than recommended is selected
  ///
  /// In en, this message translates to:
  /// **'This will make the text too small but won\'t break older fullscreen apps'**
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp;

  /// This text appears when the recommended HiDPI scale is selected and that recommended scale is 1.0
  ///
  /// In en, this message translates to:
  /// **'This is the perfect scale for your display'**
  String get thisIsThePrefectScaleForYourDisplay;

  /// This text appears when a higher than 1 HiDPI scale is selected, but that value is still lower than than the recommended scale
  ///
  /// In en, this message translates to:
  /// **'This will help with text being too small but will break older fullscreen apps'**
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps;

  /// This text appears when the recommended HiDPI scale is selected but the recommended scale is grater than 1.0
  ///
  /// In en, this message translates to:
  /// **'This is the perfect scale for your display, though it will break older fullscreen apps'**
  String get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps;

  /// This text appears when a larger HiDPI scale than recommended is selected
  ///
  /// In en, this message translates to:
  /// **'This may produce text that\'s too large'**
  String get thisWillProduceTextThatsTooLarge;

  /// For instance, the prefix may already be in the process of deletion
  ///
  /// In en, this message translates to:
  /// **'This prefix is in a state were it can\'t be deleted'**
  String get thisPrefixIsInAStateWhereItCantBeDeleted;

  /// This text appears on an input decoration
  ///
  /// In en, this message translates to:
  /// **'HiDPI scale'**
  String get hiDpiScaleLabel;

  /// This text appears when a selection is required but no option is selected
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get pleaseSelect;

  /// This text is placed on a tooltip. The 'prefix' here refers to a Wine prefix
  ///
  /// In en, this message translates to:
  /// **'Apps are running in this prefix'**
  String get appsAreRunningInThisPrefixTooltip;

  /// This text is placed on a tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh wine releases'**
  String get refreshWineReleasesTooltip;

  /// This text is placed on a tooltip
  ///
  /// In en, this message translates to:
  /// **'Prefix settings'**
  String get prefixSettingsTooltip;

  /// This text is placed on a tooltip
  ///
  /// In en, this message translates to:
  /// **'Kill process'**
  String get killProcessTooltip;

  /// This text is placed on a tooltip
  ///
  /// In en, this message translates to:
  /// **'Scroll to bottom'**
  String get scrollToBottomTooltip;

  /// This text is placed on a tooltip
  ///
  /// In en, this message translates to:
  /// **'Scroll to top'**
  String get scrollToTopTooltip;

  /// This text is placed on a tooltip
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogsTooltip;

  /// This text becomes a clickable link that gets inserted at the end of an error message
  ///
  /// In en, this message translates to:
  /// **'View Logs.'**
  String get viewLogsLink;

  /// This text appears next to a checkbox
  ///
  /// In en, this message translates to:
  /// **'Use a particular GPU'**
  String get useParticularGPU;

  /// This text appears on an input decoration
  ///
  /// In en, this message translates to:
  /// **'GPU selection'**
  String get gpuSelection;

  /// This text is placed on a tooltip
  ///
  /// In en, this message translates to:
  /// **'Failed to get the list of available GPUs'**
  String get failedToGetTheListOfAvailableGPUs;

  /// Informational text displayed when the user activates a feature that doesn't work in all scenarios
  ///
  /// In en, this message translates to:
  /// **'Note that this feature doesn\'t work in all scenarios'**
  String get noteThatThisFeatureWontWorkInAllScenarios;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Add Wine Prefix'**
  String get addWinePrefixButtonLabel;

  /// This text is placed on a button or a menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donateButtonLabel;

  /// This text is placed on a button or a menu item
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpinButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Create Wine Prefix'**
  String get createWinePrefixButtonLabel;

  /// This text is placed on a button when a certain operation is starting
  ///
  /// In en, this message translates to:
  /// **'Starting ...'**
  String get startingButtonLabel;

  /// This text is placed on a button when a download and extraction operation is in progress
  ///
  /// In en, this message translates to:
  /// **'Downloading and Extracting ...'**
  String get downloadingAndExtractingButtonLabel;

  /// This text is placed on a button when the download and extraction operation for DXVK is in progress
  ///
  /// In en, this message translates to:
  /// **'Downloading and Extracting DXVK ...'**
  String get downloadingAndExtractingDxvkButtonLabel;

  /// This text is placed on a button when a Wine prefix is being created
  ///
  /// In en, this message translates to:
  /// **'Creating Wine Prefix ...'**
  String get creatingWinePrefixButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Update Wine Prefix'**
  String get updateWinePrefixButtonLabel;

  /// This text is placed on a button when a Wine prefix is being updated
  ///
  /// In en, this message translates to:
  /// **'Updating Wine Prefix ...'**
  String get updatingWinePrefixButtonLabel;

  /// This text is placed on a button or a menu item
  ///
  /// In en, this message translates to:
  /// **'Clone'**
  String get cloneButtonLabel;

  /// This text is placed on a button when a wine prefix cloning operation is in progress
  ///
  /// In en, this message translates to:
  /// **'Cloning ...'**
  String get cloningButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Pin Executable'**
  String get pinExecutableButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Proceed Anyway'**
  String get proceedAnywayButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Run Executable'**
  String get runExecutableButtonLabel;

  /// This text is placed on a button
  ///
  /// In en, this message translates to:
  /// **'Run Installer'**
  String get runInstallerButtonLabel;

  /// This text is placed on a menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMenuItem;

  /// This text appears on a dialog
  ///
  /// In en, this message translates to:
  /// **'The following app is about to be unpinned:'**
  String get theFollowingAppIsAboutToBeUnpinned;

  /// This text appears on a dialog. The 'prefix' here refers to a Wine Prefix
  ///
  /// In en, this message translates to:
  /// **'The following prefix is about to be deleted:'**
  String get theFollowingPrefixIsAboutToBeDeleted;

  /// This text appears on a dialog
  ///
  /// In en, this message translates to:
  /// **'The following path is inaccessible from Wine:'**
  String get theFollowingPathIsInaccessibleFromWine;

  /// This text appears on a dialog
  ///
  /// In en, this message translates to:
  /// **'A path may be inaccessible from Wine because the whole Wine Bar or just Wine is running in a virtual machine (on Apple silicon Macs) or in a Snap / Flatpak sandbox.'**
  String get pathInaccessibleFromWineExplanation;

  /// This text appears on a dialog as a heading, followed by more text below
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get solutionHeading;

  /// This text appears on a dialog after the 'Solution' heading
  ///
  /// In en, this message translates to:
  /// **'Copy the folder in question somewhere under your home directory.'**
  String get pathInaccessibleFromWineSolution;

  /// This text appears on a dialog
  ///
  /// In en, this message translates to:
  /// **'This action can\'t be undone!'**
  String get thisActionCantBeUndone;

  /// This text appears in a list of wizard pages and also at the top of the corresponding page
  ///
  /// In en, this message translates to:
  /// **'Select wine build provider'**
  String get selectWineBuildProviderStepName;

  /// This text appears in a list of wizard pages and also at the top of the corresponding page
  ///
  /// In en, this message translates to:
  /// **'Select wine release'**
  String get selectWineReleaseStepName;

  /// This text appears in a list of wizard pages and also at the top of the corresponding page
  ///
  /// In en, this message translates to:
  /// **'Select wine build'**
  String get selectWineBuildStepName;

  /// This text appears in a list of wizard pages and also at the top of the corresponding page
  ///
  /// In en, this message translates to:
  /// **'Set options'**
  String get setOptionsStepName;

  /// A warning message shown when a WOW64-only Wine build is going to be used under emumation
  ///
  /// In en, this message translates to:
  /// **'A WOW64 build was selected. Those are known to have issues under emulation. Expect a broken installation.'**
  String get wow64BuildSelectedUnderEmulationWarning;

  /// A warning message shown when a non-WOW64-capable build is selected in an environment where 32-bit libraries may not be present
  ///
  /// In en, this message translates to:
  /// **'This build requires 32-bit libraries to be present on your system. If you have them already, you can ignore this warning. Otherwise, install Wine from your distro\'s repository (which will bring in those 32-bit libraries) or alternatively, select a WOW64 build from the list above if one is available.'**
  String get nonWow64BuildRequires32BitLibsWarning;

  /// A warning message shown when the WOW64 mode is preferred (on builds that support it optionally) in an environment that requires emulation
  ///
  /// In en, this message translates to:
  /// **'The WOW64 mode under emulation is known to have issues. Expect a broken installation.'**
  String get wow64PreferenceUnderEmulationWarning;

  /// A warning message shown when the WOW64 mode is not preferred (on builds that support it optionally) in an environment where 32-bit libraries may not be present
  ///
  /// In en, this message translates to:
  /// **'Not using the WOW64 mode will require 32-bit libraries to be present on your system. If you have them already, you can ignore this warning. Otherwise, install Wine from your distro\'s repository, which will bring in those 32-bit libraries.'**
  String get nonWow64PreferenceRequires32BitLibsWarning;

  /// This text ends up the "File type" dropdown on the file selection dialog
  ///
  /// In en, this message translates to:
  /// **'Windows executables'**
  String get windowsExecutablesFilterName;

  /// A description text shown when the DXVK implementation of Direct3D 8-11 is selected
  ///
  /// In en, this message translates to:
  /// **'A newer and faster implementation from Proton'**
  String get dxvkOptionExplanation;

  /// A description text shown when the WineD3D implementation of Direct3D 8-11 is selected
  ///
  /// In en, this message translates to:
  /// **'A mature implementation from Wine. To be used in case of issues with DXVK.'**
  String get wineD3DOptionExplanation;

  /// The reason for disabling the screensaver, as required by the corresponding DBus API
  ///
  /// In en, this message translates to:
  /// **'A Wine app (possibly fullscreen) is running'**
  String get screensaverDisableReason;

  /// The error message shown when the hash of a downloaded winetricks script doesn't match the expected one
  ///
  /// In en, this message translates to:
  /// **'The hash of the downloaded winetricks script doesn\'t match the expected one.'**
  String get downloadedWinetricksHashDoesntMatchExpectation;

  /// A line in a larger error message
  ///
  /// In en, this message translates to:
  /// **'Downloaded file: {downloadedFile}'**
  String downloadedFile(String downloadedFile);

  /// A line in a larger error message
  ///
  /// In en, this message translates to:
  /// **'Expected SHA256 hash: {hash}'**
  String expectedSha256Hash(String hash);

  /// A line in a larger error message
  ///
  /// In en, this message translates to:
  /// **'Actual SHA256 hash: {hash}'**
  String actualSha256Hash(String hash);

  /// The error message shown when trying to do something that requres no apps to be running across all prefixes
  ///
  /// In en, this message translates to:
  /// **'Finish the apps running in all prefixes first'**
  String get finishTheAppsRunningInAllPrefixesFirst;

  /// The error message shown when trying to do something that requires no apps to be running in the current prefix
  ///
  /// In en, this message translates to:
  /// **'Finish the running apps first'**
  String get finishTheRunningAppsFirst;

  /// The error message shown on systems where we need hardware virtualization which is not available
  ///
  /// In en, this message translates to:
  /// **'This system lacks the hardware virtualization capabilities (/dev/kvm is missing) that are required to run Wine Bar.'**
  String get missingHardwareVirtualizationCapabilities;

  /// The error message shown when running under Snap and not having write access to /dev/kvm
  ///
  /// In en, this message translates to:
  /// **'Wine Bar on ARM64 needs read-write access to /dev/kvm. Ordinary apps normally have such access, but not Snaps. To grant such access, run the following command from the command line:\n\n{kvmConnectCommand}\n\nThen, restart Wine Bar.'**
  String snapKvmNeedsConnection(String kvmConnectCommand);

  /// The error message shown when muvm is unavailable on systems where we need it
  ///
  /// In en, this message translates to:
  /// **'This system needs muvm / FEX to be able to run Windows apps. The Snap version of Wine Bar has muvm built-in. Otherwise, please install it using \"sudo dnf install muvm fex-emu\" or similar'**
  String get muvmIsNeededButMissing;

  /// The error message shown when trying to create a Wine prefix with an empty name
  ///
  /// In en, this message translates to:
  /// **'Prefix name can\'t be empty'**
  String get prefixNameCantBeEmpty;

  /// The error message shown when non allowed symbols are present in an input field
  ///
  /// In en, this message translates to:
  /// **'Illegal symbols present'**
  String get illegalSymbolsPresent;

  /// The error message shown when trying to run a winetricks script that couldn't be found
  ///
  /// In en, this message translates to:
  /// **'This Wine prefix doesn\'t bundle a winetricks script and neither was an external one provided.'**
  String get noBundledAndNoExternalWinetricksScriptAvailable;

  /// Running Wine apps requires us locating the appropriate wine and wineserver executables. This error message is shown when we are not able to do that.
  ///
  /// In en, this message translates to:
  /// **'Failed to locate the wine / wineserver executables'**
  String get failedToLocateWineOrWineserverExecutables;

  /// Winetricks may need different versions (think with or without wow64) than for regular apps. This error message is shown when we are not able to locate them.
  ///
  /// In en, this message translates to:
  /// **'Failed to locate the wine / wineserver executables for running winetricks'**
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks;

  /// The error message shown when an external tool has failed
  ///
  /// In en, this message translates to:
  /// **'The \"{command}\" command failed'**
  String specificCommandHasFailed(String command);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'he',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'lt',
    'nl',
    'no',
    'pl',
    'pt',
    'sv',
    'tr',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'lt':
      return AppLocalizationsLt();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'sv':
      return AppLocalizationsSv();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
