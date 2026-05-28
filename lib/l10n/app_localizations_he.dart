// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get kronekWineSourceDescription =>
      'מספק את הגרסאות הסטנדרטיות, Staging, TkG ו-Proton של Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'מספק גרסאות Proton עם DXVK / VK3D כלולות. מומלץ למשחקים וליישומים אחרים במצב מלא.';

  @override
  String get appUnpinningConfirmationDialogTitle => 'אישור ביטול קיבוע יישום';

  @override
  String get createWinePrefixDialogTitle => 'יצירת פריפקס ויין';

  @override
  String get cloneWinePrefixDialogTitle => 'העתקת פריפקס ויין';

  @override
  String get prefixDeletionConfirmationDialogTitle => 'אישור מחיקת פריפקס';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'נתיב אינו נגיש מ‑Wine';

  @override
  String get winePrefixesPageTitle => 'פריפקסי ויין';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'פריפקס ויין: $prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'הגדרות פריפקס ויין $prefixName';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel הגדרות';
  }

  @override
  String get processLogsTitle => 'יומני תהליך';

  @override
  String licenseInfoPattern(String license) {
    return 'רישיון: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'יוצר: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'תהליך העתקה נכשל עם קוד יציאה $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'חבילת DXVK חסרה את התיקייה המשנית x32 או x64';

  @override
  String get failedToPrepareWinetricksScript => 'נכשל בהכנת סקריפט winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'תיקיית $toplevelDataDir קיימת אך לא זוהתה כקשורה ליישום זה.\nאנא שנה את שמו או העבר אותה לאשפה ולאחר מכן הפעל מחדש את היישום.';
  }

  @override
  String get extractionFailedMessage => 'שחזור נכשל';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'הפריפקס \"$prefixName\" כבר קיים';
  }

  @override
  String get unknownErrorMessage => 'שגיאה לא ידועה';

  @override
  String get criticalErrorCaption => 'שגיאה קריטית';

  @override
  String get noLogsWereCapturedFromThisProcess => 'לא נלכדו יומנים מתהליך זה';

  @override
  String get winePrefixUpdatedMessage => 'פריפקס Wine עודכן';

  @override
  String get pinnedAppUpdatedMessage => 'אפליקציה נעשית קבועה עודכנה';

  @override
  String get moreDetailsLink => 'פרטים נוספים.';

  @override
  String get wow64ModeSection => 'מצב WOW64';

  @override
  String get useWow64ModeIfAvailable => 'השתמש במצב WOW64 אם זמין';

  @override
  String get d3D8To11Implementation => 'יישום Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl => 'השתמש ביישום Direct3D 8-11 מסוים';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'תשתמש ביישום ברירת מחדל עבור בניית Wine זו';

  @override
  String get windowsLocale => 'שפה';

  @override
  String get useParticularWindowsLocale => 'השתמש בשפה מסוימת';

  @override
  String get dontShowThisWarningAgain => 'אל תציג אזהרה זו שוב';

  @override
  String get nameForTheNewPrefixHintText => 'שם עבור Wine prefix חדש';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'זה עשוי לעזור עם תצוגת טקסט באפליקציות שאינן Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'שפת המערכת תשתמש באפליקציות Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'זה יגרום לטקסט להיות קטן מדי אך לא ישבור אפליקציות מסך מלא ישנות';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'זוהי המידה המושלמת עבור התצוגה שלך';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'זה יעזור לטקסט שלא יהיה קטן מדי אך יפגע באפליקציות מסך מלא ישנות';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'זוהי המידה המושלמת עבור התצוגה שלך, אך יפגע באפליקציות מסך מלא ישנות';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'זה עשוי לגרום לטקסט להיות גדול מדי';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'הפריפקס נמצא במצב שבו אינו ניתן למחיקה';

  @override
  String get hiDpiScaleLabel => 'מידת HiDPI';

  @override
  String get pleaseSelect => 'אנא בחר';

  @override
  String get appsAreRunningInThisPrefixTooltip => 'היישומים פועלים בתפריקס זה';

  @override
  String get refreshWineReleasesTooltip => 'רענן גרסאות wine';

  @override
  String get prefixSettingsTooltip => 'הגדרות תפריקס';

  @override
  String get killProcessTooltip => 'סיים תהליך';

  @override
  String get scrollToBottomTooltip => 'גלול לתחתית';

  @override
  String get scrollToTopTooltip => 'גלול לראש';

  @override
  String get viewLogsTooltip => 'צפה ביומנים';

  @override
  String get viewLogsLink => 'צפה ביומנים.';

  @override
  String get useParticularGPU => 'השתמש ב-GPU מסוים';

  @override
  String get gpuSelection => 'בחירת GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'נכשל בקבלת רשימת ה-GPU הזמינים';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'שים לב שהפיצ\'ר הזה אינו עובד בכל הסצנות';

  @override
  String get addWinePrefixButtonLabel => 'הוסף פריפיקס ויין';

  @override
  String get aboutButtonLabel => 'אודות';

  @override
  String get donateButtonLabel => 'תרום';

  @override
  String get unpinButtonLabel => 'הסר קיבוע';

  @override
  String get deleteButtonLabel => 'מחק';

  @override
  String get createWinePrefixButtonLabel => 'צור פריפיקס ויין';

  @override
  String get startingButtonLabel => 'מתחיל ...';

  @override
  String get downloadingAndExtractingButtonLabel => 'מוריד ומחלץ ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel => 'מוריד ומחלץ DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'יוצר פריפיקס ויין ...';

  @override
  String get updateWinePrefixButtonLabel => 'עדכן פריפיקס ויין';

  @override
  String get updatingWinePrefixButtonLabel => 'עדכון Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'שכפל';

  @override
  String get cloningButtonLabel => 'שכפול ...';

  @override
  String get pinExecutableButtonLabel => 'הצמד קובץ ריצה';

  @override
  String get proceedAnywayButtonLabel => 'המשך בכל מקרה';

  @override
  String get runExecutableButtonLabel => 'הפעל קובץ ריצה';

  @override
  String get runInstallerButtonLabel => 'הפעל מתקין';

  @override
  String get settingsMenuItem => 'הגדרות';

  @override
  String get theFollowingAppIsAboutToBeUnpinned => 'היישום הבא עומד להיפתר:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted => 'הפריפקס הבא עומד להימחק:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'הנתיב הבא אינו נגיש מ-Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'נתיב עשוי להיות בלתי נגיש מ־Wine מכיוון ש־Wine Bar או רק Wine רץ במכונה וירטואלית (במחשבי Apple Silicon) או בסנדבוקס Snap / Flatpak.';

  @override
  String get solutionHeading => 'פתרון';

  @override
  String get pathInaccessibleFromWineSolution =>
      'העתיקו את התיקייה המדוברת למיקום כלשהו מתחת לתיקיית הבית שלכם.';

  @override
  String get thisActionCantBeUndone => 'פעולה זו אינה ניתנת לביטול!';

  @override
  String get selectWineBuildProviderStepName => 'בחרו ספק בניית Wine';

  @override
  String get selectWineReleaseStepName => 'בחרו גרסת Wine';

  @override
  String get selectWineBuildStepName => 'בחרו בניית Wine';

  @override
  String get setOptionsStepName => 'הגדרו אפשרויות';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'נבחר בניית WOW64. ידוע כי יש לה בעיות תחת אמולציה. צפה להתקנה שבורה.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'בניית זו דורשת ספריות 32‑ביט במערכת שלך. אם כבר יש לך אותן, תוכל להתעלם מהאזהרה. אחרת, התקן Wine ממאגרים של הפצתך (שהיא תביא את הספריות 32‑ביט) או בחר בניית WOW64 מהרשימה למעלה אם קיימת.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'מצב WOW64 תחת אמולציה ידוע כבעייתי. צפה להתקנה שבורה.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'אי‑שימוש במצב WOW64 ידרוש ספריות 32‑ביט במערכת שלך. אם כבר יש לך אותן, תוכל להתעלם מהאזהרה. אחרת, התקן Wine ממאגרים של הפצתך, שהיא תביא את הספריות 32‑ביט.';

  @override
  String get windowsExecutablesFilterName => 'מַרְכָּבִים של Windows';

  @override
  String get dxvkOptionExplanation => 'יישום חדש ומהיר יותר מProton';

  @override
  String get wineD3DOptionExplanation =>
      'יישום מבוסס Wine. יש להשתמש בו במקרים של בעיות עם DXVK.';

  @override
  String get screensaverDisableReason =>
      'אפליקציית Wine (יתכן במלוא המסך) פועלת';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'ה- hash של סקריפט winetricks שהורד אינו תואם את ה‑hash הצפוי.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'קובץ שהורד: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'SHA256 hash צפוי: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'SHA256 hash בפועל: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'סיים את האפליקציות הפועלות בכל ה‑prefixes תחילה';

  @override
  String get finishTheRunningAppsFirst => 'סיים את האפליקציות הפועלות תחילה';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'המערכת הזו חסרה את יכולות הוירטואליזציה החומרתית (/dev/kvm חסר) הנדרשות להפעלת Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar ב-ARM64 דורש גישה לקריאה וכתיבה ל-/dev/kvm. יישומים רגילים בדרך כלל מקבלים גישה כזו, אך Snaps לא. כדי להעניק גישה כזו, הרץ את הפקודה הבאה בשורת הפקודה:\n\n$kvmConnectCommand\n\nלאחר מכן, הפעל מחדש את Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'המערכת הזו צריכה muvm / FEX כדי להריץ יישומי Windows. גרסת Snap של Wine Bar כוללת muvm מובנה. אחרת, אנא התקן אותו באמצעות \"sudo dnf install muvm fex-emu\" או דומה.';

  @override
  String get prefixNameCantBeEmpty => 'שם ה‑Prefix לא יכול להיות ריק';

  @override
  String get illegalSymbolsPresent => 'סימנים אסורים קיימים';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Wine prefix זה אינו כולל סקריפט winetricks ואף אחד חיצוני לא הוגדר.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'נכשל באיתור קבצי wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'נכשל באיתור קבצי wine / wineserver להפעלת winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'הפקודה \"$command\" נכשלה';
  }
}
