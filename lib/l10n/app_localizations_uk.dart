// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get kronekWineSourceDescription =>
      'Надає стандартні, Staging, TkG та Proton збірки Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Надає збірки Proton з DXVK / VK3D включеними. Рекомендовано для ігор та інших повноекранних застосунків.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Підтвердження відкріплення програми';

  @override
  String get createWinePrefixDialogTitle => 'Створити Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Клонувати Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Підтвердження видалення Prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'Шлях недоступний з Wine';

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
    return '$pinnedExecutableLabel Налаштування';
  }

  @override
  String get processLogsTitle => 'Журнали процесу';

  @override
  String licenseInfoPattern(String license) {
    return 'Ліцензія: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Автор: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'Процес копіювання завершився з кодом $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'У пакеті DXVK відсутня підкаталог x32 або x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Не вдалося підготувати скрипт winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'Тека $toplevelDataDir існує, але не була розпізнана як належна цій програмі.\nБудь ласка, перейменуйте її або перемістіть у смітник, а потім перезапустіть програму.';
  }

  @override
  String get extractionFailedMessage => 'Видобування не вдалося';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Префікс \"$prefixName\" вже існує';
  }

  @override
  String get unknownErrorMessage => 'Невідома помилка';

  @override
  String get criticalErrorCaption => 'Критична помилка';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Жодних журналів не було зібрано з цього процесу';

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
      'Для цієї конкретної збірки Wine буде використано типову реалізацію';

  @override
  String get windowsLocale => 'Локаль';

  @override
  String get useParticularWindowsLocale => 'Використати конкретну локаль';

  @override
  String get dontShowThisWarningAgain => 'Не показувати це попередження знову';

  @override
  String get nameForTheNewPrefixHintText => 'Назва нового wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Це може допомогти з відображенням тексту у програмах, що не використовують Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'Локаль системи буде використана програмами Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Це зробить текст занадто малим, але не порушить роботу старих повноекранних програм';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Це ідеальний масштаб для вашого дисплею';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Це допоможе, коли текст занадто малий, але зламає старі програми у повноекранному режимі';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Це ідеальний масштаб для вашого дисплею, але зламає старі програми у повноекранному режимі';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Це може призвести до надто великого тексту';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Цей префікс у стані, коли його не можна видалити';

  @override
  String get hiDpiScaleLabel => 'Масштаб HiDPI';

  @override
  String get pleaseSelect => 'Будь ласка, виберіть';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Додатки працюють у цьому префіксі';

  @override
  String get refreshWineReleasesTooltip => 'Оновити випуски Wine';

  @override
  String get prefixSettingsTooltip => 'Налаштування префікса';

  @override
  String get killProcessTooltip => 'Завершити процес';

  @override
  String get scrollToBottomTooltip => 'Прокрутити вниз';

  @override
  String get scrollToTopTooltip => 'Прокрутити вгору';

  @override
  String get viewLogsTooltip => 'Переглянути журнали';

  @override
  String get viewLogsLink => 'Переглянути журнали.';

  @override
  String get useParticularGPU => 'Використовувати конкретний GPU';

  @override
  String get gpuSelection => 'Вибір GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Не вдалося отримати список доступних GPU';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Зауважте, що ця функція не працює у всіх сценаріях';

  @override
  String get addWinePrefixButtonLabel => 'Додати Wine Prefix';

  @override
  String get aboutButtonLabel => 'Про програму';

  @override
  String get donateButtonLabel => 'Пожертвувати';

  @override
  String get unpinButtonLabel => 'Відкріпити';

  @override
  String get deleteButtonLabel => 'Видалити';

  @override
  String get createWinePrefixButtonLabel => 'Створити Wine Prefix';

  @override
  String get startingButtonLabel => 'Запуск ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Завантаження та розпакування ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Завантаження та розпакування DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Створення Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Оновити Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Оновлення Wine Prefix …';

  @override
  String get cloneButtonLabel => 'Клонувати';

  @override
  String get cloningButtonLabel => 'Клонування …';

  @override
  String get pinExecutableButtonLabel => 'Закріпити виконуваний файл';

  @override
  String get proceedAnywayButtonLabel => 'Продовжити все одно';

  @override
  String get runExecutableButtonLabel => 'Запустити виконуваний файл';

  @override
  String get runInstallerButtonLabel => 'Запустити інсталятор';

  @override
  String get settingsMenuItem => 'Налаштування';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'Наступний додаток збирається відкріпити:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'Наступний prefix збирається видалити:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'Наступний шлях недоступний з Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Шлях може бути недоступним з Wine, оскільки увесь Wine Bar або лише Wine працює у віртуальній машині (на Mac з Apple silicon) або у середовищі Snap / Flatpak.';

  @override
  String get solutionHeading => 'Рішення';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Скопіюйте відповідну папку в будь‑яке місце під вашим домашнім каталогом.';

  @override
  String get thisActionCantBeUndone => 'Цю дію не можна скасувати!';

  @override
  String get selectWineBuildProviderStepName =>
      'Виберіть постачальника збірки Wine';

  @override
  String get selectWineReleaseStepName => 'Виберіть випуск Wine';

  @override
  String get selectWineBuildStepName => 'Виберіть збірку Wine';

  @override
  String get setOptionsStepName => 'Встановіть параметри';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Вибрано збірку WOW64. Відомо, що вона має проблеми під час емуляції. Очікуйте пошкоджену інсталяцію.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Ця збірка потребує наявності 32‑розрядних бібліотек у вашій системі. Якщо вони вже встановлені, ви можете проігнорувати це попередження. В іншому випадку встановіть Wine з репозиторію вашого дистрибутива (який підключить ці 32‑розрядні бібліотеки) або, за бажанням, виберіть збірку WOW64 зі списку вище, якщо така доступна.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'Режим WOW64 під час емуляції відомий своїми проблемами. Очікуйте пошкоджену інсталяцію.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Не використання режиму WOW64 вимагатиме наявності 32‑розрядних бібліотек у вашій системі. Якщо вони вже встановлені, ви можете проігнорувати це попередження. В іншому випадку встановіть Wine з репозиторію вашого дистрибутива, який підключить ці 32‑розрядні бібліотеки.';

  @override
  String get windowsExecutablesFilterName => 'Виконувані файли Windows';

  @override
  String get dxvkOptionExplanation => 'Новіша і швидша реалізація від Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Зріла реалізація від Wine. Використовується у разі проблем з DXVK.';

  @override
  String get screensaverDisableReason =>
      'Запущено Wine‑програму (можливо, у повноекранному режимі)';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'Хеш завантаженого скрипту winetricks не збігається з очікуваним.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Завантажений файл: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Очікуваний SHA256 хеш: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Фактичний SHA256 хеш: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Спершу завершіть програми, що працюють у всіх префіксах';

  @override
  String get finishTheRunningAppsFirst => 'Спершу завершіть запущені програми';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Ця система не має можливостей апаратної віртуалізації (/dev/kvm відсутній), які потрібні для запуску Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar на ARM64 потребує доступу з читанням і записом до /dev/kvm. Зазвичай звичайні програми мають такий доступ, але Snap‑и ні. Щоб надати такий доступ, запустіть наступну команду з рядка команд:\n\n$kvmConnectCommand\n\nПотім перезапустіть Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Ця система потребує muvm / FEX, щоб запускати програми. Версія Snap Wine Bar має muvm вбудованим. Якщо ні, встановіть його за допомогою \"sudo dnf install muvm fex-emu\" або подібної команди';

  @override
  String get prefixNameCantBeEmpty => 'Назва префікса не може бути порожньою';

  @override
  String get illegalSymbolsPresent => 'Наявні заборонені символи';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Цей Wine prefix не містить скрипт winetricks і жоден зовнішній скрипт не був наданий.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Не вдалося знайти виконувані файли wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Не вдалося знайти виконувані файли wine / wineserver для запуску winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'Команда \"$command\" завершилася з помилкою';
  }
}
