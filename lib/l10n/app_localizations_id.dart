// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'Hai, saya penulis Wine Bar.\n\nSaya mulai mengerjakan proyek ini pada musim panas 2025. Sejak itu, saya telah menaruh banyak usaha ke dalamnya. Hari ini, Wine Bar sudah melakukan semua yang saya butuhkan secara pribadi. Itu tidak berarti sempurna - hanya kebutuhan saya sederhana. Artinya, saya dapat terus mengerjakannya hanya jika saya dapat membenarkan waktu dan energi yang dibutuhkan.\n\nUntuk menjaga pengembangan tetap berjalan, saya meminta dukungan Anda. Donasi membantu menutupi waktu dan pekerjaan berkelanjutan pada Wine Bar, memberi saya alasan untuk terus mengerjakannya. Sebagai alternatif, jika Anda seorang pengembang yang nyaman dengan Dart/Flutter, pertimbangkan untuk bergabung dalam upaya pengembangan.\n\nHarap dicatat bahwa pesan ini akan muncul sesekali meskipun Anda tidak menyumbang, karena Wine Bar tidak melacak siapa yang telah atau belum menyumbang.\n\nTerima kasih atas pengertian Anda.';

  @override
  String get kronekWineSourceDescription =>
      'Menyediakan build Wine standar, Staging, TkG dan Proton.';

  @override
  String get geProtonWineSourceDescription =>
      'Menyediakan build Proton dengan DXVK / VK3D terpasang. Direkomendasikan untuk permainan dan aplikasi layar penuh lainnya.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Konfirmasi pembongkaran pin aplikasi';

  @override
  String get createWinePrefixDialogTitle => 'Buat Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Klon Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Konfirmasi penghapusan Prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Jalur tidak dapat diakses dari Wine';

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
    return 'Prefix \"$prefixName\" sudah ada';
  }

  @override
  String get unknownErrorMessage => 'Kesalahan tidak dikenal';

  @override
  String get criticalErrorCaption => 'Kesalahan Kritis';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Tidak ada log yang ditangkap dari proses ini';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix diperbarui';

  @override
  String get pinnedAppUpdatedMessage => 'Aplikasi tersemat diperbarui';

  @override
  String get moreDetailsLink => 'Lebih banyak detail.';

  @override
  String get wow64ModeSection => 'WOW64 mode';

  @override
  String get useWow64ModeIfAvailable => 'Gunakan mode WOW64 jika tersedia';

  @override
  String get d3D8To11Implementation => 'Implementasi Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Gunakan implementasi Direct3D 8-11 tertentu';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Implementasi default untuk build Wine ini akan digunakan';

  @override
  String get windowsLocale => 'Locale';

  @override
  String get useParticularWindowsLocale => 'Gunakan locale tertentu';

  @override
  String get dontShowThisWarningAgain => 'Jangan tampilkan peringatan ini lagi';

  @override
  String get nameForTheNewPrefixHintText => 'Nama untuk wine prefix baru';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Ini dapat membantu tampilan teks di aplikasi non-Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Locale sistem akan digunakan oleh aplikasi Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Ini akan membuat teks terlalu kecil tetapi tidak akan merusak aplikasi layar penuh lama';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Ini adalah skala sempurna untuk tampilan Anda';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Ini akan membantu teks yang terlalu kecil tetapi akan merusak aplikasi layar penuh lama';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Ini adalah skala sempurna untuk tampilan Anda, meskipun akan merusak aplikasi layar penuh lama';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Ini dapat menghasilkan teks yang terlalu besar';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Prefix ini berada dalam keadaan di mana tidak dapat dihapus';

  @override
  String get hiDpiScaleLabel => 'Skala HiDPI';

  @override
  String get pleaseSelect => 'Silakan pilih';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Aplikasi sedang berjalan di prefix ini';

  @override
  String get refreshWineReleasesTooltip => 'Segarkan rilis wine';

  @override
  String get prefixSettingsTooltip => 'Pengaturan prefix';

  @override
  String get killProcessTooltip => 'Matikan proses';

  @override
  String get scrollToBottomTooltip => 'Gulir ke bawah';

  @override
  String get scrollToTopTooltip => 'Gulir ke atas';

  @override
  String get viewLogsTooltip => 'Lihat Log';

  @override
  String get viewLogsLink => 'Lihat Log.';

  @override
  String get useParticularGPU => 'Gunakan GPU tertentu';

  @override
  String get gpuSelection => 'Pemilihan GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Gagal mendapatkan daftar GPU yang tersedia';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Perhatikan bahwa fitur ini tidak bekerja di semua skenario';

  @override
  String get addWinePrefixButtonLabel => 'Tambah Wine Prefix';

  @override
  String get aboutButtonLabel => 'Tentang';

  @override
  String get donateButtonLabel => 'Donasi';

  @override
  String get unpinButtonLabel => 'Lepas';

  @override
  String get deleteButtonLabel => 'Hapus';

  @override
  String get createWinePrefixButtonLabel => 'Buat Wine Prefix';

  @override
  String get startingButtonLabel => 'Memulai ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Mengunduh dan Mengekstrak ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Mengunduh dan Mengekstrak DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Membuat Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Perbarui Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Memperbarui Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'Klon';

  @override
  String get cloningButtonLabel => 'Mengklon ...';

  @override
  String get pinExecutableButtonLabel => 'Pin Executable';

  @override
  String get proceedAnywayButtonLabel => 'Lanjutkan Semua';

  @override
  String get runExecutableButtonLabel => 'Jalankan Executable';

  @override
  String get runInstallerButtonLabel => 'Jalankan Installer';

  @override
  String get settingsMenuItem => 'Pengaturan';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Aplikasi berikut akan di-unpin:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Prefix berikut akan dihapus:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Jalur berikut tidak dapat diakses dari Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Sebuah jalur mungkin tidak dapat diakses dari Wine karena seluruh Wine Bar atau hanya Wine berjalan dalam mesin virtual (di Mac Apple silicon) atau di sandbox Snap / Flatpak.';

  @override
  String get solutionHeading => 'Solusi';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Salin folder yang dimaksud ke suatu tempat di bawah direktori home Anda.';

  @override
  String get thisActionCantBeUndone => 'Tindakan ini tidak dapat dibatalkan!';

  @override
  String get selectWineBuildProviderStepName => 'Pilih penyedia build wine';

  @override
  String get selectWineReleaseStepName => 'Pilih rilis wine';

  @override
  String get selectWineBuildStepName => 'Pilih build wine';

  @override
  String get setOptionsStepName => 'Atur opsi';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Sebuah build WOW64 telah dipilih. Diketahui memiliki masalah di bawah emulasi. Harapkan instalasi yang rusak.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Build ini memerlukan pustaka 32-bit di sistem Anda. Jika sudah ada, Anda dapat mengabaikan peringatan ini. Jika tidak, instal Wine dari repositori distro Anda (yang akan membawa pustaka 32-bit tersebut) atau pilih build WOW64 dari daftar di atas jika tersedia.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'Mode WOW64 di bawah emulasi diketahui memiliki masalah. Harapkan instalasi yang rusak.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Tidak menggunakan mode WOW64 akan memerlukan pustaka 32-bit di sistem Anda. Jika sudah ada, Anda dapat mengabaikan peringatan ini. Jika tidak, instal Wine dari repositori distro Anda, yang akan membawa pustaka 32-bit tersebut.';

  @override
  String get windowsExecutablesFilterName => 'Eksekutabel Windows';

  @override
  String get dxvkOptionExplanation =>
      'Implementasi yang lebih baru dan lebih cepat dari Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Implementasi matang dari Wine. Digunakan bila ada masalah dengan DXVK.';

  @override
  String get screensaverDisableReason =>
      'Aplikasi Wine (mungkin fullscreen) sedang berjalan';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Hash skrip winetricks yang diunduh tidak cocok dengan hash yang diharapkan.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Berkas terunduh: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Hash SHA256 yang diharapkan: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Hash SHA256 aktual: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Selesaikan aplikasi yang berjalan di semua prefix terlebih dahulu';

  @override
  String get finishTheRunningAppsFirst =>
      'Selesaikan aplikasi yang sedang berjalan terlebih dahulu';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Sistem ini tidak memiliki kemampuan virtualisasi perangkat keras (/dev/kvm hilang) yang diperlukan untuk menjalankan Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar pada ARM64 memerlukan akses baca-tulis ke /dev/kvm. Aplikasi biasa biasanya memiliki akses tersebut, tetapi Snap tidak. Untuk memberikan akses tersebut, jalankan perintah berikut dari baris perintah:\n\n$kvmConnectCommand\n\nKemudian, restart Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Sistem ini memerlukan muvm / FEX untuk dapat menjalankan aplikasi Windows. Versi Snap Wine Bar sudah menyertakan muvm. Jika tidak, silakan instal menggunakan \"sudo dnf install muvm fex-emu\" atau serupa';

  @override
  String get prefixNameCantBeEmpty => 'Nama prefix tidak boleh kosong';

  @override
  String get illegalSymbolsPresent => 'Simbol ilegal ditemukan';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Wine prefix ini tidak menyertakan skrip winetricks dan juga tidak ada skrip eksternal yang disediakan.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Gagal menemukan eksekutabel wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Gagal menemukan eksekutabel wine / wineserver untuk menjalankan winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Perintah \"$command\" gagal';
  }
}
