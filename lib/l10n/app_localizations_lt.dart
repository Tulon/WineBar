// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Sveiki! Aš esu Wine Bar kūrėjas.\n\nPradėjau dirbti prie projekto vasarą 2025 m. Nuo to laiko skyriau daug pastangų. Šiandien Wine Bar jau atlieka viską, ko man asmeniškai reikia. Tai nereiškia, kad tai yra tobula – tiesiog mano poreikiai yra nedideli. Tai reiškia, kad galiu tęsti darbą tik tada, kai galėsiu pagrįsti reikalaujamą laiko ir energijos išlaikymą.\n\nNorėdamas tęsti kūrimą, prašau jūsų paramos. Paaukštai padeda apmokėti laiko ir nuolatinio darbo išlaidas Wine Bar, suteikdami man priežastį tęsti darbą. Alternatyviai, jei esate kūrėjas, patogiai dirbantis su Dart/Flutter, apsvarstykite galimybę prisijungti prie kūrimo pastangų.\n\nAtkreipkite dėmesį, kad šis pranešimas kartais bus rodomas net jei nepaaukštėte, nes Wine Bar neperskaito, kas paaukštė, o kas ne.\n\nAčiū už supratimą.';

  @override
  String get kronekWineSourceDescription =>
      'Suteikia standartinius, Staging, TkG ir Proton Wine versijas.';

  @override
  String get geProtonWineSourceDescription =>
      'Suteikia Proton versijas su įtrauktu DXVK / VK3D. Rekomenduojama žaidimams ir kitiems pilno ekrano programoms.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Patvirtinimas, kad programa nebus fiksuota';

  @override
  String get createWinePrefixDialogTitle => 'Sukurti Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Klonuoti Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Patvirtinimas, kad prefix bus ištrintas';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Kelias nepasiekiamas iš Wine';

  @override
  String get winePrefixesPageTitle => 'Wine Prefix';

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
    return '$pinnedExecutableLabel Nustatymai';
  }

  @override
  String get processLogsTitle => 'Procesų žurnalai';

  @override
  String licenseInfoPattern(String license) {
    return 'Licencija: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autorius: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Kopijavimo procesas nepavyko su statusu $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'DXVK paketas trūksta x32 arba x64 poaplankio';

  @override
  String get failedToPrepareWinetricksScript =>
      'Klaida paruošiant winetricks scenarijų:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Aplankas $toplevelDataDir egzistuoja, bet nebuvo atpažintas kaip priklausantis šiai programai.\nPakeiskite jo pavadinimą arba perkelkite į šiukšliadėžę, tada paleiskite programą iš naujo.';
  }

  @override
  String get extractionFailedMessage => 'Išskleidimas nepavyko';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" jau egzistuoja';
  }

  @override
  String get unknownErrorMessage => 'Nežinoma klaida';

  @override
  String get criticalErrorCaption => 'Kritinė klaida';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Nuo šio proceso nebuvo surinkti jokių žurnalų';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix atnaujintas';

  @override
  String get pinnedAppUpdatedMessage =>
      'Prisegtas programos įrašas atnaujintas';

  @override
  String get moreDetailsLink => 'Daugiau detalių.';

  @override
  String get wow64ModeSection => 'WOW64 režimas';

  @override
  String get useWow64ModeIfAvailable => 'Naudoti WOW64 režimą, jei įmanoma';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 įgyvendinimas';

  @override
  String get useParticularD3D8To11Impl =>
      'Naudoti konkretų Direct3D 8-11 įgyvendinimą';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Bus naudojama numatytoji šio Wine versijos įgyvendinimo';

  @override
  String get windowsLocale => 'Kalba';

  @override
  String get useParticularWindowsLocale => 'Naudoti konkrečią kalbą';

  @override
  String get dontShowThisWarningAgain => 'Nerodyti šio įspėjimo dar kartą';

  @override
  String get nameForTheNewPrefixHintText => 'Naujo wine prefix pavadinimas';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Tai gali padėti su tekstų rodymu ne-Unicode programose';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Sistemos kalba bus naudojama Windows programoms';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Tai padarys tekstą per mažą, bet nesugadins senesnių viso ekrano programų';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Tai yra idealus mastelis jūsų ekranu';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Tai padės, kai tekstas yra per mažas, tačiau sugadins senesnes viso ekrano programas';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Tai yra idealus mastelis jūsų ekranu, tačiau sugadins senesnes viso ekrano programas';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Tai gali sukelti per didelį tekstą';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Šis prefixas yra būsenoje, kai jį negalima ištrinti';

  @override
  String get hiDpiScaleLabel => 'HiDPI mastelis';

  @override
  String get pleaseSelect => 'Pasirinkite';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Programos veikia šiame prefiksas';

  @override
  String get refreshWineReleasesTooltip => 'Atnaujinti wine leidimus';

  @override
  String get prefixSettingsTooltip => 'Prefikso nustatymai';

  @override
  String get killProcessTooltip => 'Nutraukti procesą';

  @override
  String get scrollToBottomTooltip => 'Slinkti į apačią';

  @override
  String get scrollToTopTooltip => 'Slinkti į viršų';

  @override
  String get viewLogsTooltip => 'Žiūrėti žurnalus';

  @override
  String get viewLogsLink => 'Žiūrėti žurnalus.';

  @override
  String get useParticularGPU => 'Naudoti tam tikrą GPU';

  @override
  String get gpuSelection => 'GPU pasirinkimas';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Neįmanoma gauti prieinamų GPU sąrašo';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Atkreipkite dėmesį, kad ši funkcija neveikia visose situacijose';

  @override
  String get addWinePrefixButtonLabel => 'Pridėti Wine Prefix';

  @override
  String get aboutButtonLabel => 'Apie';

  @override
  String get donateButtonLabel => 'Paaukoti';

  @override
  String get unpinButtonLabel => 'Atšaukti';

  @override
  String get deleteButtonLabel => 'Ištrinti';

  @override
  String get createWinePrefixButtonLabel => 'Sukurti Wine Prefix';

  @override
  String get startingButtonLabel => 'Pradedama ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Atsiunčiama ir išskleidžiama ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Atsiunčiama ir išskleidžiama DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Kuriama Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Atnaujinti Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Atnaujinama Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Klonuoti';

  @override
  String get cloningButtonLabel => 'Klonuojama …';

  @override
  String get pinExecutableButtonLabel => 'Prisegti vykdomąjį failą';

  @override
  String get proceedAnywayButtonLabel => 'Tęsti vis tiek';

  @override
  String get runExecutableButtonLabel => 'Vykdyti vykdomąjį failą';

  @override
  String get runInstallerButtonLabel => 'Vykdyti diegimo programą';

  @override
  String get settingsMenuItem => 'Nustatymai';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Ši programa bus atšaukta iš fiksavimo:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Šis prefix bus ištrintas:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Šis kelias nepasiekiamas iš Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Kelias gali būti nepasiekiamas iš Wine, nes visas Wine Bar arba tik Wine veikia virtualioje mašinoje (Apple silicon Mac\'ų atveju) arba Snap / Flatpak sandbox\'e.';

  @override
  String get solutionHeading => 'Sprendimas';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Kopijuokite nurodytą aplanką į savo namų katalogo vietą.';

  @override
  String get thisActionCantBeUndone => 'Ši veiksmas negali būti atšauktas!';

  @override
  String get selectWineBuildProviderStepName =>
      'Pasirinkite wine build tiekėją';

  @override
  String get selectWineReleaseStepName => 'Pasirinkite wine release';

  @override
  String get selectWineBuildStepName => 'Pasirinkite wine build';

  @override
  String get setOptionsStepName => 'Nustatykite parinktis';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Pasirinktas WOW64 versija. Žinoma, kad emuliacijoje sukelia problemų. Tikėkitės sugadintos įdiegimo.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Ši versija reikalauja, kad jūsų sistemoje būtų 32‑bitų bibliotekos. Jei jos jau yra, galite ignoruoti šį įspėjimą. Kitu atveju, įdiekite Wine iš savo distributoriaus saugyklos (tai suteiks 32‑bitų bibliotekas) arba, jei yra galimybė, pasirinkite WOW64 versiją iš aukščiau pateiktos sąrašo.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'WOW64 režimas emuliacijoje žinoma, kad sukelia problemų. Tikėkitės sugadintos įdiegimo.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Neužsidarant WOW64 režimo bus reikalaujama, kad jūsų sistemoje būtų 32‑bitų bibliotekos. Jei jos jau yra, galite ignoruoti šį įspėjimą. Kitu atveju, įdiekite Wine iš savo distributoriaus saugyklos, kuri suteiks 32‑bitų bibliotekas.';

  @override
  String get windowsExecutablesFilterName => 'Windows programos';

  @override
  String get dxvkOptionExplanation =>
      'Naujesnė ir greitesnė Proton implementacija';

  @override
  String get wineD3DOptionExplanation =>
      'Patikima Wine implementacija. Naudojama, kai DXVK sukelia problemų.';

  @override
  String get screensaverDisableReason =>
      'Veikia Wine programa (galbūt viso ekrano)';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Atsisiųsto winetricks scenarijaus hash nesutampa su tikėtu.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Atsisiųstas failas: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Tikėtinas SHA256 hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Faktinis SHA256 hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Pirmiausia užbaikite programas, veikiančias visose Wine prefixuose';

  @override
  String get finishTheRunningAppsFirst =>
      'Pirmiausia užbaikite veikiantys programos';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Ši sistema neturi aparatinės virtualizacijos galimybių (/dev/kvm trūksta), kurios reikalingos Wine Bar veikimui.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar ARM64 versijai reikia skaitymo-rašymo prieigos prie /dev/kvm. Įprasti programos paprastai turi tokį leidimą, tačiau Snap jų neturi. Norėdami suteikti šią prieigą, paleiskite šią komandą iš komandinės eilutės:\n\n$kvmConnectCommand\n\nTada paleiskite Wine Bar iš naujo.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Ši sistema reikalauja muvm / FEX, kad galėtų paleisti Windows programas. Wine Bar Snap versija turi muvm integruotą. Kitu atveju, įdiekite jį naudodami \"sudo dnf install muvm fex-emu\" arba panašiai';

  @override
  String get prefixNameCantBeEmpty =>
      'Prieigos pavadinimas negali būti tuščias';

  @override
  String get illegalSymbolsPresent => 'Yra neleistini simboliai';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Ši Wine prieiga neįtraukia winetricks scenarijaus ir taip pat neturėjo išorinio.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Neįmanoma rasti wine / wineserver vykdomųjų failų';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Neįmanoma rasti wine / wineserver vykdomųjų failų, reikalingų paleidžiant winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return '„$command“ komanda nepavyko';
  }
}
