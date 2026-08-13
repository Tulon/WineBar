// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'يوفر إصدارات ويني القياسية، Staging، TkG و Proton.';

  @override
  String get geProtonWineSourceDescription =>
      'يوفر إصدارات Proton مع DXVK / VK3D مدمجة. يُوصى بها للألعاب وتطبيقات الشاشة الكاملة الأخرى.';

  @override
  String get appUnpinningConfirmationDialogTitle => 'تأكيد إلغاء تثبيت التطبيق';

  @override
  String get createWinePrefixDialogTitle => 'إنشاء مسبقة ويني';

  @override
  String get cloneWinePrefixDialogTitle => 'استنساخ مسبقة ويني';

  @override
  String get prefixDeletionConfirmationDialogTitle => 'تأكيد حذف مسبقة';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'المسار غير متاح من ويني';

  @override
  String get winePrefixesPageTitle => 'مسبقات ويني';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'مسبقة ويني: $prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'إعدادات مسبقة ويني $prefixName';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel إعدادات';
  }

  @override
  String get processLogsTitle => 'سجلات العملية';

  @override
  String licenseInfoPattern(String license) {
    return 'الترخيص: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'المؤلف: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'فشل عملية النسخ بالوضع $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'حزمة DXVK مفقودة الدليل الفرعي x32 أو x64';

  @override
  String get failedToPrepareWinetricksScript => 'فشل تحضير نص winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'المجلد $toplevelDataDir موجود لكنه لم يُعترف به كجزء من هذا التطبيق.\nالرجاء إعادة تسميته أو نقله إلى المهملات ثم أعد تشغيل التطبيق.';
  }

  @override
  String get extractionFailedMessage => 'فشل الاستخراج';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'المُسبق \"$prefixName\" موجود بالفعل';
  }

  @override
  String get unknownErrorMessage => 'خطأ غير معروف';

  @override
  String get criticalErrorCaption => 'خطأ حرج';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'لم يتم التقاط سجلات من هذه العملية';

  @override
  String get winePrefixUpdatedMessage => 'تم تحديث مُسبق Wine';

  @override
  String get pinnedAppUpdatedMessage => 'تم تحديث التطبيق المثبت';

  @override
  String get moreDetailsLink => 'المزيد من التفاصيل.';

  @override
  String get wow64ModeSection => 'وضع WOW64';

  @override
  String get useWow64ModeIfAvailable => 'استخدم وضع WOW64 إذا كان متاحًا';

  @override
  String get d3D8To11Implementation => 'تنفيذ Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl => 'استخدم تنفيذ Direct3D 8-11 محدد';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'سيتم استخدام تنفيذ افتراضي لهذا البناء المحدد من Wine';

  @override
  String get windowsLocale => 'اللغة';

  @override
  String get useParticularWindowsLocale => 'استخدم لغة معينة';

  @override
  String get dontShowThisWarningAgain => 'لا تظهر هذه التحذير مرة أخرى';

  @override
  String get nameForTheNewPrefixHintText => 'اسم ملف Wine الجديد';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'قد يساعد ذلك في عرض النص في التطبيقات غير Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'سيتم استخدام لغة النظام من قبل تطبيقات Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'سيجعل ذلك النص صغيرًا جدًا لكنه لن يكسر التطبيقات الكاملة القديمة';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'هذا هو المقياس المثالي لعرضك';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'سيساعد ذلك في جعل النص أكبر من الصغير لكنه سيؤدي إلى كسر التطبيقات الكاملة القديمة';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'هذا هو المقياس المثالي لعرضك، لكنه سيؤدي إلى كسر التطبيقات الكاملة القديمة';

  @override
  String get thisWillProduceTextThatsTooLarge => 'قد ينتج هذا نصًا كبيرًا جدًا';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'هذا البريفيكس في حالة لا يمكن حذفها';

  @override
  String get hiDpiScaleLabel => 'مقياس HiDPI';

  @override
  String get pleaseSelect => 'الرجاء الاختيار';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'تعمل التطبيقات في هذا البريفيكس';

  @override
  String get refreshWineReleasesTooltip => 'تحديث إصدارات وائن';

  @override
  String get prefixSettingsTooltip => 'إعدادات البريفيكس';

  @override
  String get killProcessTooltip => 'إنهاء العملية';

  @override
  String get scrollToBottomTooltip => 'التمرير إلى الأسفل';

  @override
  String get scrollToTopTooltip => 'التمرير إلى الأعلى';

  @override
  String get viewLogsTooltip => 'عرض السجلات';

  @override
  String get viewLogsLink => 'عرض السجلات.';

  @override
  String get useParticularGPU => 'استخدام معالج رسومات محدد';

  @override
  String get gpuSelection => 'اختيار المعالج الرسومي';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'فشل الحصول على قائمة المعالجات الرسومية المتاحة';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'لاحظ أن هذه الميزة لا تعمل في جميع السيناريوهات';

  @override
  String get addWinePrefixButtonLabel => 'إضافة Wine Prefix';

  @override
  String get aboutButtonLabel => 'حول';

  @override
  String get donateButtonLabel => 'تبرع';

  @override
  String get unpinButtonLabel => 'إلغاء التثبيت';

  @override
  String get deleteButtonLabel => 'حذف';

  @override
  String get createWinePrefixButtonLabel => 'إنشاء Wine Prefix';

  @override
  String get startingButtonLabel => 'بدء ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'جارٍ التحميل والاستخراج ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'جارٍ التحميل والاستخراج DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'جارٍ إنشاء Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'تحديث Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'جارٍ تحديث Wine Prefix …';

  @override
  String get cloneButtonLabel => 'استنساخ';

  @override
  String get cloningButtonLabel => 'جارٍ الاستنساخ …';

  @override
  String get pinExecutableButtonLabel => 'تثبيت القابل للتنفيذ';

  @override
  String get proceedAnywayButtonLabel => 'المتابعة على أي حال';

  @override
  String get runExecutableButtonLabel => 'تشغيل القابل للتنفيذ';

  @override
  String get runInstallerButtonLabel => 'تشغيل المُثبّت';

  @override
  String get settingsMenuItem => 'الإعدادات';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'التطبيق التالي على وشك أن يُفصل:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'المُسبق التالي على وشك أن يُحذف:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'المسار التالي غير متاح من Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'قد لا يكون مسارًا متاحًا من Wine لأن كامل Wine Bar أو فقط Wine يعمل في جهاز افتراضي (على ماك Apple silicon) أو داخل حاوية Snap / Flatpak.';

  @override
  String get solutionHeading => 'الحل';

  @override
  String get pathInaccessibleFromWineSolution =>
      'انسخ المجلد المعني إلى مكان ما تحت دليل المنزل الخاص بك.';

  @override
  String get thisActionCantBeUndone => 'لا يمكن التراجع عن هذا الإجراء!';

  @override
  String get selectWineBuildProviderStepName => 'اختر مزود بناء Wine';

  @override
  String get selectWineReleaseStepName => 'اختر إصدار Wine';

  @override
  String get selectWineBuildStepName => 'اختر بناء Wine';

  @override
  String get setOptionsStepName => 'تعيين الخيارات';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'تم اختيار بناء WOW64. من المعروف أن هذه الأنواع تواجه مشاكل تحت المحاكاة. توقع تثبيتًا معطوبًا.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'هذا البناء يتطلب وجود مكتبات 32‑بت على نظامك. إذا كانت لديك بالفعل، يمكنك تجاهل هذا التحذير. وإلا، فقم بتثبيت Wine من مستودع توزيعتك (الذي سيجلب تلك المكتبات 32‑بت) أو بدلاً من ذلك اختر بناء WOW64 من القائمة أعلاه إذا كان متاحًا.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'الوضع WOW64 تحت المحاكاة معروف بوجود مشاكل. توقع تثبيتًا معطوبًا.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'عدم استخدام وضع WOW64 سيستلزم وجود مكتبات 32‑بت على نظامك. إذا كانت لديك بالفعل، يمكنك تجاهل هذا التحذير. وإلا، فقم بتثبيت Wine من مستودع توزيعتك، الذي سيجلب تلك المكتبات 32‑بت.';

  @override
  String get windowsExecutablesFilterName => 'ملفات تنفيذية';

  @override
  String get dxvkOptionExplanation => 'تنفيذ أحدث وأسرع من Proton';

  @override
  String get wineD3DOptionExplanation =>
      'تنفيذ ناضج من Wine. يُستخدم في حالة وجود مشاكل مع DXVK.';

  @override
  String get screensaverDisableReason => 'تعمل تطبيق Wine (ربما ملء الشاشة)';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'الهاش الخاص بسكربت winetricks المُحمَّل لا يطابق المتوقع.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'الملف المحمَّل: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'الهاش المتوقع SHA256: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'الهاش الفعلي SHA256: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'أنهِ التطبيقات التي تعمل في جميع الـ Wine prefixes أولاً';

  @override
  String get finishTheRunningAppsFirst => 'أنهِ التطبيقات التي تعمل أولاً';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'هذا النظام يفتقر إلى قدرات التمثيل الافتراضي للأجهزة (/dev/kvm مفقود) المطلوبة لتشغيل Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar على ARM64 يحتاج إلى حق الوصول للقراءة والكتابة إلى /dev/kvm. عادةً ما تتوفر هذه الصلاحية في التطبيقات العادية، لكن لا توجد في Snaps. لمنح هذا الوصول، نفّذ الأمر التالي من سطر الأوامر:\n\n$kvmConnectCommand\n\nثم أعد تشغيل Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'هذا النظام يحتاج إلى muvm / FEX ليتمكن من تشغيل تطبيقات Windows. نسخة Snap من Wine Bar تتضمن muvm مدمجًا. وإلا، يرجى تثبيته باستخدام \"sudo dnf install muvm fex-emu\" أو ما شابه ذلك';

  @override
  String get prefixNameCantBeEmpty => 'لا يمكن أن يكون اسم البريفيكس فارغًا';

  @override
  String get illegalSymbolsPresent => 'موجودة رموز غير قانونية';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'هذا Wine prefix لا يضم سكربت winetricks ولا تم توفير واحد خارجي.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'فشل في تحديد ملفات wine / wineserver التنفيذية';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'فشل في تحديد ملفات wine / wineserver التنفيذية لتشغيل winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'فشل أمر \"$command\"';
  }
}
