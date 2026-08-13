// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hi there. I\'m the author of Wine Bar.\n\nI started working on the project in summer 2025. Since then, I’ve put a lot of effort into it. Today, Wine Bar already does everything I personally need from it. That\'s not to say it\'s perfect - it\'s just my needs are modest. That means I can keep working on it only if I can justify the time and energy it requires.\n\nTo keep development going, I’m asking for your support. Donations help cover time and ongoing work on Wine Bar, giving me a reason to keep working on it. Alternatively, if you’re a developer comfortable with Dart/Flutter, consider joining the development effort.\n\nPlease note that this message will appear occasionally even if you do donate, as Wine Bar doesn’t track who has or hasn’t donated.\n\nThank you for your understanding.';

  @override
  String get kronekWineSourceDescription =>
      'Standart, Staging, TkG ve Proton Wine derlemelerini sağlar.';

  @override
  String get geProtonWineSourceDescription =>
      'DXVK / VK3D içeren Proton derlemelerini sağlar. Oyunlar ve diğer tam ekran uygulamalar için önerilir.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Uygulamanın sabitlemesinin kaldırılması onayı';

  @override
  String get createWinePrefixDialogTitle => 'Wine Prefix Oluştur';

  @override
  String get cloneWinePrefixDialogTitle => 'Wine Prefix Kopyala';

  @override
  String get prefixDeletionConfirmationDialogTitle => 'Prefix silme onayı';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Wine\'den erişilemeyen yol';

  @override
  String get winePrefixesPageTitle => 'Wine Prefixleri';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'Wine Prefix: $prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'Wine Prefix $prefixName Ayarları';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel Ayarları';
  }

  @override
  String get processLogsTitle => 'İşlem Günlükleri';

  @override
  String licenseInfoPattern(String license) {
    return 'Lisans: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Yazar: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Kopyalama işlemi $exitCode durum koduyla başarısız oldu';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'DXVK paketi x32 veya x64 alt dizinini içermiyor';

  @override
  String get failedToPrepareWinetricksScript =>
      'winetricks betiği hazırlanamadı:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return '$toplevelDataDir klasörü var ancak bu uygulamaya ait olarak tanınmadı.\nLütfen yeniden adlandırın veya Çöp Kutusu\'na taşıyıp ardından uygulamayı yeniden başlatın.';
  }

  @override
  String get extractionFailedMessage => 'Çıkartma başarısız oldu';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" zaten var';
  }

  @override
  String get unknownErrorMessage => 'Bilinmeyen hata';

  @override
  String get criticalErrorCaption => 'Kritik Hata';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Bu işlemden hiç günlük yakalanmadı';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix güncellendi';

  @override
  String get pinnedAppUpdatedMessage => 'Sabitlenmiş uygulama güncellendi';

  @override
  String get moreDetailsLink => 'Daha fazla ayrıntı.';

  @override
  String get wow64ModeSection => 'WOW64 modu';

  @override
  String get useWow64ModeIfAvailable => 'Mümkünse WOW64 modunu kullan';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 uygulaması';

  @override
  String get useParticularD3D8To11Impl =>
      'Belirli bir Direct3D 8-11 uygulamasını kullan';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Bu özel Wine derlemesi için varsayılan bir uygulama kullanılacak';

  @override
  String get windowsLocale => 'Yerel';

  @override
  String get useParticularWindowsLocale => 'Belirli bir yerel kullan';

  @override
  String get dontShowThisWarningAgain => 'Bu uyarıyı tekrar gösterme';

  @override
  String get nameForTheNewPrefixHintText => 'Yeni wine prefixi için ad';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Bu, Unicode olmayan uygulamalarda metin görüntülemeye yardımcı olabilir';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Sistem yereli, Windows uygulamaları tarafından kullanılacak';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Bu, metni çok küçük yapacak ama eski tam ekran uygulamaları bozmayacaktır';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Ekranınız için mükemmel ölçek';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Metin çok küçük olduğunda yardımcı olur, ancak eski tam ekran uygulamaları bozar';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Ekranınız için mükemmel ölçek, ancak eski tam ekran uygulamaları bozar';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Bu, çok büyük metin üretebilir';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Bu prefix silinemeyecek bir durumda';

  @override
  String get hiDpiScaleLabel => 'HiDPI ölçeği';

  @override
  String get pleaseSelect => 'Lütfen seçiniz';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Uygulamalar bu ön ekte çalışıyor';

  @override
  String get refreshWineReleasesTooltip => 'Wine sürümlerini yenile';

  @override
  String get prefixSettingsTooltip => 'Ön ek ayarları';

  @override
  String get killProcessTooltip => 'İşlemi sonlandır';

  @override
  String get scrollToBottomTooltip => 'En alta kaydır';

  @override
  String get scrollToTopTooltip => 'En üste kaydır';

  @override
  String get viewLogsTooltip => 'Günlükleri görüntüle';

  @override
  String get viewLogsLink => 'Günlükleri görüntüle.';

  @override
  String get useParticularGPU => 'Belirli bir GPU kullan';

  @override
  String get gpuSelection => 'GPU seçimi';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Kullanılabilir GPU listesi alınamadı';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Bu özelliğin tüm senaryolarda çalışmayabileceğini unutmayın';

  @override
  String get addWinePrefixButtonLabel => 'Wine Prefix Ekle';

  @override
  String get aboutButtonLabel => 'Hakkında';

  @override
  String get donateButtonLabel => 'Bağış Yap';

  @override
  String get unpinButtonLabel => 'Çıkar';

  @override
  String get deleteButtonLabel => 'Sil';

  @override
  String get createWinePrefixButtonLabel => 'Wine Prefix Oluştur';

  @override
  String get startingButtonLabel => 'Başlatılıyor ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'İndiriliyor ve Çıkarılıyor ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'DXVK İndiriliyor ve Çıkarılıyor ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Wine Prefix Oluşturuluyor ...';

  @override
  String get updateWinePrefixButtonLabel => 'Wine Prefix Güncelle';

  @override
  String get updatingWinePrefixButtonLabel => 'Wine Prefix Güncelleniyor ...';

  @override
  String get cloneButtonLabel => 'Klonla';

  @override
  String get cloningButtonLabel => 'Klonlanıyor ...';

  @override
  String get pinExecutableButtonLabel => 'Çalıştırılabilir Dosyayı Sabitle';

  @override
  String get proceedAnywayButtonLabel => 'Yine de Devam Et';

  @override
  String get runExecutableButtonLabel => 'Çalıştırılabilir Dosyayı Çalıştır';

  @override
  String get runInstallerButtonLabel => 'Kurucuyu Çalıştır';

  @override
  String get settingsMenuItem => 'Ayarlar';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Aşağıdaki uygulama sabitlemesinden kaldırılacak:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Aşağıdaki prefix silinecek:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Aşağıdaki yol Wine\'den erişilemez:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Bir yol, Wine Bar veya yalnızca Wine\'in sanal bir makinede (Apple silicon Mac\'lerde) çalışması ya da Snap / Flatpak sandbox içinde olması nedeniyle Wine\'den erişilemez olabilir.';

  @override
  String get solutionHeading => 'Çözüm';

  @override
  String get pathInaccessibleFromWineSolution =>
      'İlgili klasörü ev dizininizin altındaki bir yere kopyalayın.';

  @override
  String get thisActionCantBeUndone => 'Bu işlem geri alınamaz!';

  @override
  String get selectWineBuildProviderStepName =>
      'wine build sağlayıcısını seçin';

  @override
  String get selectWineReleaseStepName => 'wine sürümünü seçin';

  @override
  String get selectWineBuildStepName => 'wine build\'ini seçin';

  @override
  String get setOptionsStepName => 'seçenekleri ayarlayın';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'WOW64 derlemesi seçildi. Emülasyon altında sorunlu olduğu biliniyor. Bozuk bir kurulum bekleyin.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Bu derleme, sisteminizde 32 bit kütüphanelerin bulunmasını gerektirir. Zaten varsa, bu uyarıyı görmezden gelebilirsiniz. Aksi takdirde, dağıtımınızın paket deposundan Wine kurun (bu 32 bit kütüphaneleri getirecektir) veya yukarıdaki listeden bir WOW64 derlemesi seçin, eğer mevcutsa.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'Emülasyon altında WOW64 modu bilinen sorunlara sahiptir. Bozuk bir kurulum bekleyin.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'WOW64 modu kullanılmadığında, sisteminizde 32 bit kütüphanelerin bulunması gerekir. Zaten varsa, bu uyarıyı görmezden gelebilirsiniz. Aksi takdirde, dağıtımınızın paket deposundan Wine kurun; bu 32 bit kütüphaneleri getirecektir.';

  @override
  String get windowsExecutablesFilterName => 'Windows çalıştırılabilirleri';

  @override
  String get dxvkOptionExplanation =>
      'Proton\'dan yeni ve daha hızlı bir uygulama';

  @override
  String get wineD3DOptionExplanation =>
      'Wine\'den olgun bir uygulama. DXVK ile ilgili sorunlarda kullanılacak.';

  @override
  String get screensaverDisableReason =>
      'Bir Wine uygulaması (muhtemelen tam ekran) çalışıyor';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'İndirilen winetricks betiğinin hash\'i beklenenle eşleşmiyor.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'İndirilen dosya: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Beklenen SHA256 hash: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Gerçek SHA256 hash: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Tüm prefixlerde çalışan uygulamaları önce bitir';

  @override
  String get finishTheRunningAppsFirst => 'Çalışan uygulamaları önce bitir';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Bu sistem, Wine Bar’ı çalıştırmak için gerekli olan donanım sanallaştırma yeteneklerine (/dev/kvm eksik) sahip değil.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar on ARM64, /dev/kvm’e okuma-yazma erişimine ihtiyaç duyar. Normal uygulamalar genellikle bu erişime sahiptir, ancak Snap’ler için geçerli değildir. Böyle bir erişim sağlamak için aşağıdaki komutu terminalden çalıştırın:\n\n$kvmConnectCommand\n\nDaha sonra Wine Bar’ı yeniden başlatın.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Bu sistem, Windows uygulamalarını çalıştırabilmek için muvm / FEX’e ihtiyaç duyar. Wine Bar’ın Snap sürümü muvm’i dahili olarak içerir. Aksi takdirde, \"sudo dnf install muvm fex-emu\" veya benzeri bir komutla kurun.';

  @override
  String get prefixNameCantBeEmpty => 'Prefix adı boş olamaz';

  @override
  String get illegalSymbolsPresent => 'Yasak semboller var';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Bu Wine prefix’i bir winetricks betiği içermez ve dışarıdan da sağlanmamıştır.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'wine / wineserver yürütülebilir dosyaları bulunamadı';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'winetricks çalıştırmak için wine / wineserver yürütülebilir dosyaları bulunamadı';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\" komutu başarısız oldu';
  }
}
