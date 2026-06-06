// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get kronekWineSourceDescription =>
      'Tarjoaa standardin, Staging-, TkG- ja Proton-Wine-versiot.';

  @override
  String get geProtonWineSourceDescription =>
      'Tarjoaa Proton-versioita DXVK / VK3D -sisältäen. Suositeltu peleille ja muille täysnäyttöisille sovelluksille.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Sovelluksen irrottamisen vahvistus';

  @override
  String get createWinePrefixDialogTitle => 'Luo Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Kloonaa Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Prefixin poistamisen vahvistus';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Polku ei ole Wineen saatavilla';

  @override
  String get winePrefixesPageTitle => 'Wine Prefixit';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'Wine Prefix: $prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'Wine Prefix $prefixName Asetukset';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel Asetukset';
  }

  @override
  String get processLogsTitle => 'Prosessilokit';

  @override
  String licenseInfoPattern(String license) {
    return 'Lisenssi: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Tekijä: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Kopiointiprosessi epäonnistui tilakoodilla $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'DXVK-pakettia puuttuu x32- tai x64-alihakemisto';

  @override
  String get failedToPrepareWinetricksScript =>
      'Winetricks-skriptin valmistelu epäonnistui:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Kansio $toplevelDataDir on olemassa, mutta sitä ei tunnistettu kuuluvan tähän sovellukseen.\nKäytä nimeä uudelleen tai siirrä se roskakoriin ja käynnistä sovellus sitten uudestaan.';
  }

  @override
  String get extractionFailedMessage => 'Pureminen epäonnistui';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" on jo olemassa';
  }

  @override
  String get unknownErrorMessage => 'Tuntematon virhe';

  @override
  String get criticalErrorCaption => 'Kriittinen virhe';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Tämän prosessin lokit eivät ole tallennettu';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix päivitetty';

  @override
  String get pinnedAppUpdatedMessage => 'Kiinnitetty sovellus päivitetty';

  @override
  String get moreDetailsLink => 'Lisätietoja.';

  @override
  String get wow64ModeSection => 'WOW64-tila';

  @override
  String get useWow64ModeIfAvailable =>
      'Käytä WOW64-tilaa, jos se on saatavilla';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 -toteutus';

  @override
  String get useParticularD3D8To11Impl =>
      'Käytä tiettyä Direct3D 8-11 -toteutusta';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Tähän Wine-versioon oletusarvoinen toteutus käytetään';

  @override
  String get windowsLocale => 'Kieliasetukset';

  @override
  String get useParticularWindowsLocale => 'Käytä tiettyä kieliasetusta';

  @override
  String get dontShowThisWarningAgain => 'Älä näytä tätä varoitusta uudelleen';

  @override
  String get nameForTheNewPrefixHintText => 'Uuden Wine‑prefixin nimi';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Tämä voi auttaa tekstin näyttämisessä ei-Unicode-sovelluksissa';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Järjestelmän kieliasetus käytetään Windows-sovelluksissa';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Tämä tekee tekstistä liian pienen, mutta ei riko vanhoja kokoruutu-sovelluksia';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Tämä on täydellinen skaala näytöllesi';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Tämä auttaa, jos teksti on liian pieni, mutta rikkoo vanhemmat koko näytön sovellukset';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Tämä on täydellinen skaala näytöllesi, mutta rikkoo vanhemmat koko näytön sovellukset';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Tämä voi tuottaa liian suurta tekstiä';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Tämä prefix on tilassa, jossa sitä ei voi poistaa';

  @override
  String get hiDpiScaleLabel => 'HiDPI-skaala';

  @override
  String get pleaseSelect => 'Valitse';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Sovellukset toimivat tässä prefiksissä';

  @override
  String get refreshWineReleasesTooltip => 'Päivitä wine-julkaisut';

  @override
  String get prefixSettingsTooltip => 'Prefiksin asetukset';

  @override
  String get killProcessTooltip => 'Lopeta prosessi';

  @override
  String get scrollToBottomTooltip => 'Vieritä alas';

  @override
  String get scrollToTopTooltip => 'Vieritä ylös';

  @override
  String get viewLogsTooltip => 'Näytä lokit';

  @override
  String get viewLogsLink => 'Näytä lokit.';

  @override
  String get useParticularGPU => 'Käytä tiettyä GPU:ta';

  @override
  String get gpuSelection => 'GPU-valinta';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'GPU-listan hakeminen epäonnistui';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Huomaa, että tämä ominaisuus ei toimi kaikissa tilanteissa';

  @override
  String get addWinePrefixButtonLabel => 'Lisää Wine Prefix';

  @override
  String get aboutButtonLabel => 'Tietoja';

  @override
  String get donateButtonLabel => 'Lahjoita';

  @override
  String get unpinButtonLabel => 'Poista kiinnitys';

  @override
  String get deleteButtonLabel => 'Poista';

  @override
  String get createWinePrefixButtonLabel => 'Luo Wine Prefix';

  @override
  String get startingButtonLabel => 'Käynnistetään ...';

  @override
  String get downloadingAndExtractingButtonLabel => 'Ladataan ja puretaan ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Ladataan ja puretaan DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Luodaan Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Päivitä Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Päivitetään Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Kloonaa';

  @override
  String get cloningButtonLabel => 'Kloonaa …';

  @override
  String get pinExecutableButtonLabel => 'Kiinnitä suoritettava';

  @override
  String get proceedAnywayButtonLabel => 'Jatka silti';

  @override
  String get runExecutableButtonLabel => 'Suorita suoritettava';

  @override
  String get runInstallerButtonLabel => 'Suorita asennusohjelma';

  @override
  String get settingsMenuItem => 'Asetukset';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Seuraava sovellus on poistettavissa kiinnityksestä:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Seuraava prefix on poistettavissa:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Seuraava polku on Wineen pääsyistä ulkopuolella:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Polku saattaa olla Wine:lle saavuttamattomissa, jos koko Wine Bar tai vain Wine ajetaan virtuaalikoneessa (Apple silicon -Macissa) tai Snap / Flatpak -suoja-alueella.';

  @override
  String get solutionHeading => 'Ratkaisu';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Kopioi kyseinen kansio johonkin kotihakemiston alla.';

  @override
  String get thisActionCantBeUndone => 'Tätä toimintoa ei voi perua!';

  @override
  String get selectWineBuildProviderStepName => 'Valitse wine build provider';

  @override
  String get selectWineReleaseStepName => 'Valitse wine release';

  @override
  String get selectWineBuildStepName => 'Valitse wine build';

  @override
  String get setOptionsStepName => 'Aseta valinnat';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'WOW64-versio on valittu. Tiedetään, että se voi aiheuttaa ongelmia emulaatiossa. Odota rikkiä asennusta.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Tämä versio vaatii 32-bittisten kirjastojen olevan järjestelmässäsi. Jos ne ovat jo asennettuna, voit ohittaa tämän varoituksen. Muussa tapauksessa asenna Wine jakelusi arkistosta (joka tuo mukanaan 32-bittiset kirjastot) tai valitse vaihtoehtoisesti yllä olevasta listasta WOW64-versio, jos sellainen on saatavilla.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'WOW64-tila emulaatiossa on tunnettu ongelmallisena. Odota rikkiä asennusta.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'WOW64-tilan käyttämättä jättäminen vaatii 32-bittisten kirjastojen olevan järjestelmässäsi. Jos ne ovat jo asennettuna, voit ohittaa tämän varoituksen. Muussa tapauksessa asenna Wine jakelusi arkistosta, joka tuo mukanaan 32-bittiset kirjastot.';

  @override
  String get windowsExecutablesFilterName => 'Windows-sovellukset';

  @override
  String get dxvkOptionExplanation => 'Uudempi ja nopeampi toteutus Protonista';

  @override
  String get wineD3DOptionExplanation =>
      'Kypsä toteutus Wine:stä. Käytettävä DXVK-ongelmien yhteydessä.';

  @override
  String get screensaverDisableReason =>
      'Wine-sovellus (mahdollisesti koko näytön) on käynnissä';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Ladatun winetricks-skriptin hash ei vastaa odotettua.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Ladattu tiedosto: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Odotettu SHA256-hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Todellinen SHA256-hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Lopeta ensin kaikki prefixeissa käynnissä olevat sovellukset';

  @override
  String get finishTheRunningAppsFirst =>
      'Lopeta ensin käynnissä olevat sovellukset';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Tässä järjestelmässä puuttuu laitteistopohjaisen virtualisoinnin ominaisuudet (/dev/kvm puuttuu), joita Wine Barin suorittaminen vaatii.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar ARM64:lle tarvitsee luku- ja kirjoitusoikeudet /dev/kvm:iin. Tavalliset sovellukset saavat tällaisen oikeuden, mutta Snap-sovelluksilla ei. Antamalla tämän oikeuden suorita seuraava komento komentoriviltä:\n\n$kvmConnectCommand\n\nSitten käynnistä Wine Bar uudelleen.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Tämä järjestelmä tarvitsee muvm / FEX:n, jotta Windows-sovelluksia voidaan suorittaa. Wine Barin Snap-versio sisältää muvm:n sisäänrakennettuna. Muussa tapauksessa asenna se komennolla \"sudo dnf install muvm fex-emu\" tai vastaavalla.';

  @override
  String get prefixNameCantBeEmpty => 'Etunimen on oltava täytetty';

  @override
  String get illegalSymbolsPresent => 'Kiellettyjä symboleja';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Tämä Wine prefix ei sisällä winetricks-skriptiä eikä ulkoinen skripti ole annettu.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Ei löytynyt wine- tai wineserver-suoritettavia tiedostoja';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Ei löytynyt wine- tai wineserver-suoritettavia tiedostoja winetricksin ajamiseen';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\"-komento epäonnistui';
  }
}
