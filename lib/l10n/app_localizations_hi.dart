// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'नमस्ते। मैं Wine Bar का लेखक हूँ।\n\nमैंने इस प्रोजेक्ट पर गर्मियों 2025 में काम शुरू किया था। तब से, मैंने इसमें काफी प्रयास लगाया है। आज, Wine Bar पहले ही वह सब कुछ कर रहा है जो मुझे व्यक्तिगत रूप से इसकी आवश्यकता है। इसका मतलब यह नहीं कि यह परिपूर्ण है - मेरी ज़रूरतें बस मामूली हैं। इसका अर्थ है कि मैं केवल तभी इस पर काम जारी रख सकता हूँ जब मैं इसके लिए आवश्यक समय और ऊर्जा को सही ठहरा सकूँ।\n\nविकास जारी रखने के लिए, मैं आपकी सहायता माँग रहा हूँ। दान से Wine Bar पर समय और चल रहे कार्य को कवर करने में मदद मिलती है, जिससे मुझे इसे जारी रखने का कारण मिलता है। वैकल्पिक रूप से, यदि आप Dart/Flutter में सहज एक डेवलपर हैं, तो विकास प्रयास में शामिल होने पर विचार करें।\n\nकृपया ध्यान दें कि यह संदेश कभी-कभी दिखाई देगा, भले ही आप दान करें, क्योंकि Wine Bar ट्रैक नहीं करता कि किसने या किसने दान नहीं किया है।\n\nआपकी समझ के लिए धन्यवाद।';

  @override
  String get kronekWineSourceDescription =>
      'मानक, स्टेजिंग, TkG और Proton Wine बिल्ड्स प्रदान करता है।';

  @override
  String get geProtonWineSourceDescription =>
      'DXVK / VK3D शामिल Proton बिल्ड्स प्रदान करता है। गेम और अन्य फुलस्क्रीन ऐप्स के लिए अनुशंसित।';

  @override
  String get appUnpinningConfirmationDialogTitle => 'ऐप अनपिनिंग पुष्टि';

  @override
  String get createWinePrefixDialogTitle => 'एक Wine Prefix बनाएं';

  @override
  String get cloneWinePrefixDialogTitle => 'Wine Prefix क्लोन करें';

  @override
  String get prefixDeletionConfirmationDialogTitle => 'Prefix हटाने की पुष्टि';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'Wine से पथ अप्राप्य';

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
    return '$pinnedExecutableLabel सेटिंग्स';
  }

  @override
  String get processLogsTitle => 'प्रक्रिया लॉग';

  @override
  String licenseInfoPattern(String license) {
    return 'लाइसेंस: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'लेखक: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'कॉपी करने की प्रक्रिया स्थिति $exitCode के साथ विफल रही';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'DXVK पैकेज में x32 या x64 उपनिर्देशिका गायब है';

  @override
  String get failedToPrepareWinetricksScript =>
      'winetricks स्क्रिप्ट तैयार करने में विफल:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'फ़ोल्डर $toplevelDataDir मौजूद है लेकिन इस ऐप से संबंधित नहीं माना गया।\nकृपया इसे पुनः नाम दें या ट्रैश में ले जाएँ और फिर ऐप को पुनः प्रारंभ करें।';
  }

  @override
  String get extractionFailedMessage => 'निकासी विफल रही';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'प्रिफ़िक्स \"$prefixName\" पहले से मौजूद है';
  }

  @override
  String get unknownErrorMessage => 'अज्ञात त्रुटि';

  @override
  String get criticalErrorCaption => 'गंभीर त्रुटि';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'इस प्रक्रिया से कोई लॉग कैप्चर नहीं किया गया';

  @override
  String get winePrefixUpdatedMessage => 'Wine प्रिफ़िक्स अपडेट किया गया';

  @override
  String get pinnedAppUpdatedMessage => 'पिन किया गया ऐप अपडेट हुआ';

  @override
  String get moreDetailsLink => 'अधिक विवरण।';

  @override
  String get wow64ModeSection => 'WOW64 मोड';

  @override
  String get useWow64ModeIfAvailable =>
      'उपलब्ध होने पर WOW64 मोड का उपयोग करें';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 कार्यान्वयन';

  @override
  String get useParticularD3D8To11Impl =>
      'एक विशेष Direct3D 8-11 कार्यान्वयन का उपयोग करें';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'इस विशेष Wine बिल्ड के लिए एक डिफ़ॉल्ट कार्यान्वयन का उपयोग किया जाएगा';

  @override
  String get windowsLocale => 'स्थानीय';

  @override
  String get useParticularWindowsLocale => 'एक विशिष्ट स्थानीय का उपयोग करें';

  @override
  String get dontShowThisWarningAgain => 'इस चेतावनी को फिर से न दिखाएँ';

  @override
  String get nameForTheNewPrefixHintText => 'नए wine prefix का नाम';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'यह गैर-Unicode ऐप्स में पाठ प्रदर्शन के लिए मददगार हो सकता है';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'सिस्टम स्थानीय को Windows ऐप्स द्वारा उपयोग किया जाएगा';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'यह पाठ को बहुत छोटा बना देगा लेकिन पुराने फुलस्क्रीन ऐप्स को नहीं तोड़ेगा';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'यह आपके डिस्प्ले के लिए उपयुक्त स्केल है';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'यह पाठ को बहुत छोटा होने से रोकने में मदद करेगा, लेकिन इससे पुराने फुलस्क्रीन ऐप्स टूट सकते हैं';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'यह आपके डिस्प्ले के लिए उपयुक्त स्केल है, हालांकि इससे पुराने फुलस्क्रीन ऐप्स टूट सकते हैं';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'यह बहुत बड़ा पाठ उत्पन्न कर सकता है';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'यह प्रीफ़िक्स ऐसी स्थिति में है जिसे हटाया नहीं जा सकता';

  @override
  String get hiDpiScaleLabel => 'HiDPI स्केल';

  @override
  String get pleaseSelect => 'कृपया चुनें';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'ऐप्स इस प्रीफ़िक्स में चल रहे हैं';

  @override
  String get refreshWineReleasesTooltip => 'वाइन रिलीज़ को ताज़ा करें';

  @override
  String get prefixSettingsTooltip => 'प्रीफ़िक्स सेटिंग्स';

  @override
  String get killProcessTooltip => 'प्रक्रिया समाप्त करें';

  @override
  String get scrollToBottomTooltip => 'नीचे स्क्रॉल करें';

  @override
  String get scrollToTopTooltip => 'ऊपर स्क्रॉल करें';

  @override
  String get viewLogsTooltip => 'लॉग देखें';

  @override
  String get viewLogsLink => 'लॉग देखें.';

  @override
  String get useParticularGPU => 'एक विशेष GPU का उपयोग करें';

  @override
  String get gpuSelection => 'GPU चयन';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'उपलब्ध GPUs की सूची प्राप्त करने में विफल';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'ध्यान दें कि यह सुविधा सभी परिदृश्यों में काम नहीं करती';

  @override
  String get addWinePrefixButtonLabel => 'वाइन प्रीफ़िक्स जोड़ें';

  @override
  String get aboutButtonLabel => 'के बारे में';

  @override
  String get donateButtonLabel => 'दान करें';

  @override
  String get unpinButtonLabel => 'अनपिन करें';

  @override
  String get deleteButtonLabel => 'हटाएँ';

  @override
  String get createWinePrefixButtonLabel => 'वाइन प्रीफ़िक्स बनाएँ';

  @override
  String get startingButtonLabel => 'शुरू हो रहा है ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'डाउनलोड और निकाल रहा है ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'DXVK डाउनलोड और निकाल रहा है ...';

  @override
  String get creatingWinePrefixButtonLabel => 'वाइन प्रीफ़िक्स बना रहा है ...';

  @override
  String get updateWinePrefixButtonLabel => 'वाइन प्रीफ़िक्स अपडेट करें';

  @override
  String get updatingWinePrefixButtonLabel =>
      'वाइन प्रीफ़िक्स अपडेट हो रहा है ...';

  @override
  String get cloneButtonLabel => 'क्लोन';

  @override
  String get cloningButtonLabel => 'क्लोनिंग हो रही है ...';

  @override
  String get pinExecutableButtonLabel => 'एक्ज़िक्यूटेबल पिन करें';

  @override
  String get proceedAnywayButtonLabel => 'फिर भी आगे बढ़ें';

  @override
  String get runExecutableButtonLabel => 'एक्ज़िक्यूटेबल चलाएँ';

  @override
  String get runInstallerButtonLabel => 'इंस्टॉलर चलाएँ';

  @override
  String get settingsMenuItem => 'सेटिंग्स';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'निम्नलिखित ऐप अनपिन किया जाने वाला है:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'निम्नलिखित प्रीफ़िक्स हटाया जाने वाला है:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'निम्न पथ वाइन से पहुँच योग्य नहीं है:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'एक पथ Wine से असुलभ हो सकता है क्योंकि पूरा Wine Bar या केवल Wine वर्चुअल मशीन (Apple सिलिकॉन मैक पर) में चल रहा है या Snap / Flatpak सैंडबॉक्स में।';

  @override
  String get solutionHeading => 'समाधान';

  @override
  String get pathInaccessibleFromWineSolution =>
      'संबंधित फ़ोल्डर को अपने होम निर्देशिका के किसी स्थान पर कॉपी करें।';

  @override
  String get thisActionCantBeUndone => 'यह कार्रवाई उलटी नहीं की जा सकती!';

  @override
  String get selectWineBuildProviderStepName => 'वाइन बिल्ड प्रदाता चुनें';

  @override
  String get selectWineReleaseStepName => 'वाइन रिलीज़ चुनें';

  @override
  String get selectWineBuildStepName => 'वाइन बिल्ड चुनें';

  @override
  String get setOptionsStepName => 'विकल्प सेट करें';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'एक WOW64 बिल्ड चुना गया है। यह ज्ञात है कि इम्यूलेशन के तहत समस्याएँ होती हैं। एक टूटे हुए इंस्टॉलेशन की अपेक्षा करें।';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'इस बिल्ड के लिए आपके सिस्टम पर 32‑बिट लाइब्रेरीज़ मौजूद होना आवश्यक है। यदि आपके पास पहले से ही वे हैं, तो आप इस चेतावनी को अनदेखा कर सकते हैं। अन्यथा, अपने वितरण के रिपॉज़िटरी से Wine स्थापित करें (जिससे 32‑बिट लाइब्रेरीज़ भी मिलेंगी) या वैकल्पिक रूप से ऊपर की सूची में उपलब्ध होने पर एक WOW64 बिल्ड चुनें।';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'इम्यूलेशन के तहत WOW64 मोड में समस्याएँ ज्ञात हैं। एक टूटे हुए इंस्टॉलेशन की अपेक्षा करें।';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'WOW64 मोड का उपयोग न करने से आपके सिस्टम पर 32‑बिट लाइब्रेरीज़ मौजूद होना आवश्यक होगा। यदि आपके पास पहले से ही वे हैं, तो आप इस चेतावनी को अनदेखा कर सकते हैं। अन्यथा, अपने वितरण के रिपॉज़िटरी से Wine स्थापित करें, जिससे 32‑बिट लाइब्रेरीज़ भी मिलेंगी।';

  @override
  String get windowsExecutablesFilterName => 'Windows निष्पादन योग्य फ़ाइलें';

  @override
  String get dxvkOptionExplanation => 'प्रोटॉन से एक नया और तेज़ कार्यान्वयन';

  @override
  String get wineD3DOptionExplanation =>
      'वाइन से एक परिपक्व कार्यान्वयन। DXVK में समस्याओं के मामले में उपयोग किया जाता है।';

  @override
  String get screensaverDisableReason =>
      'एक Wine ऐप (संभवतः पूर्ण स्क्रीन) चल रहा है';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'डाउनलोड किए गए winetricks स्क्रिप्ट का हैश अपेक्षित से मेल नहीं खाता।';

  @override
  String downloadedFile(String downloadedFile) {
    return 'डाउनलोड की गई फ़ाइल: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'अपेक्षित SHA256 हैश: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'वास्तविक SHA256 हैश: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'सभी प्रीफ़िक्स में चल रहे ऐप्स को पहले समाप्त करें';

  @override
  String get finishTheRunningAppsFirst => 'चल रहे ऐप्स को पहले समाप्त करें';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'इस सिस्टम में हार्डवेयर वर्चुअलाइज़ेशन क्षमताएँ (/dev/kvm अनुपलब्ध) नहीं हैं, जो Wine Bar चलाने के लिए आवश्यक हैं।';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar on ARM64 को /dev/kvm पर पढ़ने‑लिखने की पहुँच चाहिए। सामान्य ऐप्स के पास आम तौर पर ऐसी पहुँच होती है, लेकिन Snap में नहीं। इस पहुँच को देने के लिए, कमांड लाइन से निम्नलिखित कमांड चलाएँ:\n\n$kvmConnectCommand\n\nफिर, Wine Bar को पुनः प्रारंभ करें।';
  }

  @override
  String get muvmIsNeededButMissing =>
      'इस सिस्टम को Windows ऐप्स चलाने के लिए muvm / FEX की आवश्यकता है। Wine Bar का Snap संस्करण muvm को अंतर्निहित रूप से शामिल करता है। अन्यथा, \"sudo dnf install muvm fex-emu\" या इसी तरह का कमांड चलाकर इसे स्थापित करें।';

  @override
  String get prefixNameCantBeEmpty => 'प्रिफ़िक्स का नाम खाली नहीं हो सकता';

  @override
  String get illegalSymbolsPresent => 'अवैध प्रतीक मौजूद हैं';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'इस Wine प्रिफ़िक्स में winetricks स्क्रिप्ट बंडल नहीं है और न ही कोई बाहरी स्क्रिप्ट उपलब्ध थी।';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'wine / wineserver निष्पादन योग्य फ़ाइलों को खोजने में विफल';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      '\"winetricks\" चलाने के लिए wine / wineserver निष्पादन योग्य फ़ाइलों को खोजने में विफल';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\" कमांड विफल हुआ';
  }
}
