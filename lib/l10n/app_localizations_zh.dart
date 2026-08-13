// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      '你好。我是 Wine Bar 的作者。\n\n我在 2025 年夏天开始参与这个项目。从那时起，我投入了大量精力。如今，Wine Bar 已经满足了我个人的所有需求。这并不意味着它完美无缺——只是我的需求相对简单。也就是说，只有当我能证明它所需的时间和精力是合理的时候，我才能继续开发。\n\n为了让开发持续进行，我请求你的支持。捐赠可以帮助覆盖 Wine Bar 的时间成本和后续工作，让我有继续投入的理由。或者，如果你是一名熟悉 Dart/Flutter 的开发者，也可以考虑加入我们的开发团队。\n\n请注意，即使你不捐赠，这条信息也会偶尔出现，因为 Wine Bar 并不会跟踪谁已捐赠或未捐赠。\n\n感谢你的理解。';

  @override
  String get kronekWineSourceDescription =>
      '提供标准、Staging、TkG 和 Proton Wine 构建。';

  @override
  String get geProtonWineSourceDescription =>
      '提供包含 DXVK / VK3D 的 Proton 构建。推荐用于游戏和其他全屏应用。';

  @override
  String get appUnpinningConfirmationDialogTitle => '应用取消固定确认';

  @override
  String get createWinePrefixDialogTitle => '创建 Wine 前缀';

  @override
  String get cloneWinePrefixDialogTitle => '克隆 Wine 前缀';

  @override
  String get prefixDeletionConfirmationDialogTitle => '前缀删除确认';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'Wine 无法访问路径';

  @override
  String get winePrefixesPageTitle => 'Wine 前缀';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'Wine 前缀: $prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'Wine 前缀 $prefixName 设置';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel 设置';
  }

  @override
  String get processLogsTitle => '进程日志';

  @override
  String licenseInfoPattern(String license) {
    return '许可证：$license';
  }

  @override
  String authorInfoPattern(String author) {
    return '作者：$author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return '复制过程以状态码 $exitCode 失败';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir => 'DXVK 包缺少 x32 或 x64 子目录';

  @override
  String get failedToPrepareWinetricksScript => '准备 winetricks 脚本失败：';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return '文件夹 $toplevelDataDir 已存在，但未被识别为本应用的目录。\n请重命名它或将其移至废纸篓，然后重新启动应用。';
  }

  @override
  String get extractionFailedMessage => '提取失败';

  @override
  String prefixAlreadyExists(String prefixName) {
    return '前缀 \"$prefixName\" 已存在';
  }

  @override
  String get unknownErrorMessage => '未知错误';

  @override
  String get criticalErrorCaption => '严重错误';

  @override
  String get noLogsWereCapturedFromThisProcess => '未从此进程捕获日志';

  @override
  String get winePrefixUpdatedMessage => 'Wine 前缀已更新';

  @override
  String get pinnedAppUpdatedMessage => '已更新固定应用';

  @override
  String get moreDetailsLink => '更多详情。';

  @override
  String get wow64ModeSection => 'WOW64 模式';

  @override
  String get useWow64ModeIfAvailable => '如可用，使用 WOW64 模式';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 实现';

  @override
  String get useParticularD3D8To11Impl => '使用特定的 Direct3D 8-11 实现';

  @override
  String get defaultD3D8To11ImplWillBeUsed => '将使用此 Wine 构建的默认实现';

  @override
  String get windowsLocale => '语言环境';

  @override
  String get useParticularWindowsLocale => '使用特定的语言环境';

  @override
  String get dontShowThisWarningAgain => '不再显示此警告';

  @override
  String get nameForTheNewPrefixHintText => '新 Wine 前缀的名称';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps => '这可能有助于在非 Unicode 应用中显示文本';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps => '系统语言环境将被 Windows 应用使用';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      '这会使文本变得太小，但不会破坏旧的全屏应用';

  @override
  String get thisIsThePrefectScaleForYourDisplay => '此比例为您显示器的最佳比例';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      '此设置可解决文字过小的问题，但会破坏旧版全屏应用';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      '此比例为您显示器的最佳比例，但会破坏旧版全屏应用';

  @override
  String get thisWillProduceTextThatsTooLarge => '这可能导致文字过大';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted => '该前缀处于无法删除的状态';

  @override
  String get hiDpiScaleLabel => 'HiDPI 比例';

  @override
  String get pleaseSelect => '请选择';

  @override
  String get appsAreRunningInThisPrefixTooltip => '此前缀中正在运行的应用';

  @override
  String get refreshWineReleasesTooltip => '刷新 Wine 发布';

  @override
  String get prefixSettingsTooltip => '前缀设置';

  @override
  String get killProcessTooltip => '终止进程';

  @override
  String get scrollToBottomTooltip => '滚动到底部';

  @override
  String get scrollToTopTooltip => '滚动到顶部';

  @override
  String get viewLogsTooltip => '查看日志';

  @override
  String get viewLogsLink => '查看日志。';

  @override
  String get useParticularGPU => '使用特定 GPU';

  @override
  String get gpuSelection => 'GPU 选择';

  @override
  String get failedToGetTheListOfAvailableGPUs => '获取可用 GPU 列表失败';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios => '请注意此功能并非在所有场景下都能工作';

  @override
  String get addWinePrefixButtonLabel => '添加 Wine 前缀';

  @override
  String get aboutButtonLabel => '关于';

  @override
  String get donateButtonLabel => '捐赠';

  @override
  String get unpinButtonLabel => '取消固定';

  @override
  String get deleteButtonLabel => '删除';

  @override
  String get createWinePrefixButtonLabel => '创建 Wine 前缀';

  @override
  String get startingButtonLabel => '正在启动 ...';

  @override
  String get downloadingAndExtractingButtonLabel => '下载并解压缩 ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel => '下载并解压缩 DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => '正在创建 Wine 前缀 ...';

  @override
  String get updateWinePrefixButtonLabel => '更新 Wine 前缀';

  @override
  String get updatingWinePrefixButtonLabel => '正在更新 Wine 前缀 …';

  @override
  String get cloneButtonLabel => '克隆';

  @override
  String get cloningButtonLabel => '正在克隆 …';

  @override
  String get pinExecutableButtonLabel => '固定可执行文件';

  @override
  String get proceedAnywayButtonLabel => '仍然继续';

  @override
  String get runExecutableButtonLabel => '运行可执行文件';

  @override
  String get runInstallerButtonLabel => '运行安装程序';

  @override
  String get settingsMenuItem => '设置';

  @override
  String get theFollowingAppIsAboutToBeUnpinned => '以下应用即将被取消固定：';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted => '以下前缀即将被删除：';

  @override
  String get theFollowingPathIsInaccessibleFromWine => '以下路径在 Wine 中不可访问：';

  @override
  String get pathInaccessibleFromWineExplanation =>
      '路径可能无法从 Wine 访问，因为整个 Wine Bar 或仅 Wine 正在虚拟机中运行（适用于 Apple silicon Mac）或在 Snap / Flatpak 沙箱中。';

  @override
  String get solutionHeading => '解决方案';

  @override
  String get pathInaccessibleFromWineSolution => '将相关文件夹复制到您的主目录下的某个位置。';

  @override
  String get thisActionCantBeUndone => '此操作无法撤销！';

  @override
  String get selectWineBuildProviderStepName => '选择 Wine 构建提供商';

  @override
  String get selectWineReleaseStepName => '选择 Wine 发布版本';

  @override
  String get selectWineBuildStepName => '选择 Wine 构建';

  @override
  String get setOptionsStepName => '设置选项';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      '已选择 WOW64 构建。已知在仿真环境下会出现问题。请预期安装可能失败。';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      '此构建需要系统中存在 32 位库。如果你已经安装了它们，可以忽略此警告。否则，请从发行版的仓库中安装 Wine（这将带来所需的 32 位库），或者在上方列表中选择可用的 WOW64 构建。';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      '在仿真环境下，WOW64 模式已知会出现问题。请预期安装可能失败。';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      '不使用 WOW64 模式将需要系统中存在 32 位库。如果你已经安装了它们，可以忽略此警告。否则，请从发行版的仓库中安装 Wine，这将带来所需的 32 位库。';

  @override
  String get windowsExecutablesFilterName => 'Windows 可执行文件';

  @override
  String get dxvkOptionExplanation => '来自 Proton 的更新且更快的实现';

  @override
  String get wineD3DOptionExplanation => '来自 Wine 的成熟实现。若 DXVK 出现问题时使用。';

  @override
  String get screensaverDisableReason => '正在运行 Wine 应用（可能是全屏）';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      '下载的 winetricks 脚本哈希值与预期不符。';

  @override
  String downloadedFile(String downloadedFile) {
    return '已下载文件：$downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return '预期 SHA256 哈希值：$hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return '实际 SHA256 哈希值：$hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst => '请先结束所有前缀中的应用';

  @override
  String get finishTheRunningAppsFirst => '请先结束正在运行的应用';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      '此系统缺少运行 Wine Bar 所需的硬件虚拟化功能（/dev/kvm 缺失）。';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar 在 ARM64 上需要对 /dev/kvm 的读写访问。普通应用通常拥有此权限，但 Snap 并不具备。要授予该权限，请在命令行中执行以下命令：\n\n$kvmConnectCommand\n\n然后，重新启动 Wine Bar。';
  }

  @override
  String get muvmIsNeededButMissing =>
      '此系统需要 muvm / FEX 才能运行 Windows 应用。Wine Bar 的 Snap 版本已内置 muvm。否则，请使用 \"sudo dnf install muvm fex-emu\" 或类似命令安装。';

  @override
  String get prefixNameCantBeEmpty => '前缀名称不能为空';

  @override
  String get illegalSymbolsPresent => '存在非法符号';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      '此 Wine 前缀未捆绑 winetricks 脚本，也没有提供外部脚本。';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      '未能定位 wine / wineserver 可执行文件';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      '未能定位运行 winetricks 的 wine / wineserver 可执行文件';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\" 命令失败';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get donationSolicitationDialogText =>
      '你好。我是 Wine Bar 的作者。\n\n我在 2025 年夏天开始参与这个项目。从那时起，我投入了大量精力。如今，Wine Bar 已经满足了我个人的所有需求。这并不意味着它完美无缺——只是我的需求相对简单。也就是说，只有当我能证明它所需的时间和精力是合理的时候，我才能继续开发。\n\n为了保持开发进度，我请求你的支持。捐赠可以帮助覆盖 Wine Bar 的时间成本和持续工作，让我有理由继续投入其中。或者，如果你是一名熟悉 Dart/Flutter 的开发者，也可以考虑加入我们的开发团队。\n\n请注意，即使你不捐赠，这条信息也会偶尔出现，因为 Wine Bar 并不会跟踪谁已捐赠或未捐赠。\n\n感谢你的理解。';

  @override
  String get kronekWineSourceDescription =>
      '提供标准、Staging、TkG 和 Proton Wine 构建。';

  @override
  String get geProtonWineSourceDescription =>
      '提供包含 DXVK / VK3D 的 Proton 构建。推荐用于游戏和其他全屏应用。';

  @override
  String get appUnpinningConfirmationDialogTitle => '应用取消固定确认';

  @override
  String get createWinePrefixDialogTitle => '创建 Wine 前缀';

  @override
  String get cloneWinePrefixDialogTitle => '克隆 Wine 前缀';

  @override
  String get prefixDeletionConfirmationDialogTitle => '前缀删除确认';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'Wine 无法访问路径';

  @override
  String get winePrefixesPageTitle => 'Wine 前缀';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'Wine 前缀: $prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'Wine 前缀 $prefixName 设置';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel 设置';
  }

  @override
  String get processLogsTitle => '进程日志';

  @override
  String licenseInfoPattern(String license) {
    return '许可证：$license';
  }

  @override
  String authorInfoPattern(String author) {
    return '作者：$author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return '复制过程以状态码 $exitCode 失败';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir => 'DXVK 包缺少 x32 或 x64 子目录';

  @override
  String get failedToPrepareWinetricksScript => '准备 winetricks 脚本失败：';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return '文件夹 $toplevelDataDir 存在，但未被识别为本应用的目录。\n请重命名它或将其移至废纸篓，然后重新启动应用。';
  }

  @override
  String get extractionFailedMessage => '提取失败';

  @override
  String prefixAlreadyExists(String prefixName) {
    return '前缀 \"$prefixName\" 已存在';
  }

  @override
  String get unknownErrorMessage => '未知错误';

  @override
  String get criticalErrorCaption => '严重错误';

  @override
  String get noLogsWereCapturedFromThisProcess => '未捕获到此进程的日志';

  @override
  String get winePrefixUpdatedMessage => 'Wine 前缀已更新';

  @override
  String get pinnedAppUpdatedMessage => '已更新固定应用';

  @override
  String get moreDetailsLink => '更多详情。';

  @override
  String get wow64ModeSection => 'WOW64 模式';

  @override
  String get useWow64ModeIfAvailable => '如可用，使用 WOW64 模式';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 实现';

  @override
  String get useParticularD3D8To11Impl => '使用特定的 Direct3D 8-11 实现';

  @override
  String get defaultD3D8To11ImplWillBeUsed => '将使用此 Wine 构建的默认实现';

  @override
  String get windowsLocale => '语言环境';

  @override
  String get useParticularWindowsLocale => '使用特定的语言环境';

  @override
  String get dontShowThisWarningAgain => '不再显示此警告';

  @override
  String get nameForTheNewPrefixHintText => '新 Wine 前缀的名称';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps => '这可能有助于在非 Unicode 应用中显示文本';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps => '系统语言环境将被 Windows 应用使用';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      '这会使文本过小，但不会破坏旧的全屏应用';

  @override
  String get thisIsThePrefectScaleForYourDisplay => '这是您显示器的最佳缩放比例';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      '这将帮助解决文本过小的问题，但会破坏旧的全屏应用';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      '这是您显示器的最佳缩放比例，但会破坏旧的全屏应用';

  @override
  String get thisWillProduceTextThatsTooLarge => '这可能导致文字过大';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted => '该前缀处于无法删除的状态';

  @override
  String get hiDpiScaleLabel => 'HiDPI 缩放比例';

  @override
  String get pleaseSelect => '请选择';

  @override
  String get appsAreRunningInThisPrefixTooltip => '此前缀中正在运行的应用';

  @override
  String get refreshWineReleasesTooltip => '刷新 Wine 发布';

  @override
  String get prefixSettingsTooltip => '前缀设置';

  @override
  String get killProcessTooltip => '终止进程';

  @override
  String get scrollToBottomTooltip => '滚动到底部';

  @override
  String get scrollToTopTooltip => '滚动到顶部';

  @override
  String get viewLogsTooltip => '查看日志';

  @override
  String get viewLogsLink => '查看日志。';

  @override
  String get useParticularGPU => '使用特定 GPU';

  @override
  String get gpuSelection => 'GPU 选择';

  @override
  String get failedToGetTheListOfAvailableGPUs => '获取可用 GPU 列表失败';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios => '请注意此功能并非在所有场景下都能工作';

  @override
  String get addWinePrefixButtonLabel => '添加 Wine 前缀';

  @override
  String get aboutButtonLabel => '关于';

  @override
  String get donateButtonLabel => '捐赠';

  @override
  String get unpinButtonLabel => '取消固定';

  @override
  String get deleteButtonLabel => '删除';

  @override
  String get createWinePrefixButtonLabel => '创建 Wine 前缀';

  @override
  String get startingButtonLabel => '正在启动 ...';

  @override
  String get downloadingAndExtractingButtonLabel => '下载并解压缩 ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel => '下载并解压缩 DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => '创建 Wine 前缀 ...';

  @override
  String get updateWinePrefixButtonLabel => '更新 Wine 前缀';

  @override
  String get updatingWinePrefixButtonLabel => '正在更新 Wine 前缀 …';

  @override
  String get cloneButtonLabel => '克隆';

  @override
  String get cloningButtonLabel => '正在克隆 …';

  @override
  String get pinExecutableButtonLabel => '固定可执行文件';

  @override
  String get proceedAnywayButtonLabel => '仍然继续';

  @override
  String get runExecutableButtonLabel => '运行可执行文件';

  @override
  String get runInstallerButtonLabel => '运行安装程序';

  @override
  String get settingsMenuItem => '设置';

  @override
  String get theFollowingAppIsAboutToBeUnpinned => '以下应用即将被取消固定：';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted => '以下前缀即将被删除：';

  @override
  String get theFollowingPathIsInaccessibleFromWine => '以下路径在 Wine 中不可访问：';

  @override
  String get pathInaccessibleFromWineExplanation =>
      '路径可能无法从 Wine 访问，因为整个 Wine Bar 或仅 Wine 正在虚拟机中运行（适用于 Apple silicon Mac）或在 Snap / Flatpak 沙箱中。';

  @override
  String get solutionHeading => '解决方案';

  @override
  String get pathInaccessibleFromWineSolution => '将相关文件夹复制到您主目录下的某个位置。';

  @override
  String get thisActionCantBeUndone => '此操作无法撤销！';

  @override
  String get selectWineBuildProviderStepName => '选择 Wine 构建提供商';

  @override
  String get selectWineReleaseStepName => '选择 Wine 发布';

  @override
  String get selectWineBuildStepName => '选择 Wine 构建';

  @override
  String get setOptionsStepName => '设置选项';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      '已选择 WOW64 构建。已知在仿真环境下会出现问题。请预期安装失败。';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      '此构建需要系统中存在 32 位库。如果你已经安装了它们，可以忽略此警告。否则，请从发行版的仓库中安装 Wine（这将带来所需的 32 位库），或者在上方列表中选择可用的 WOW64 构建。';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      '在仿真环境下，WOW64 模式已知会出现问题。请预期安装失败。';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      '不使用 WOW64 模式将需要系统中存在 32 位库。如果你已经安装了它们，可以忽略此警告。否则，请从发行版的仓库中安装 Wine，这将带来所需的 32 位库。';

  @override
  String get windowsExecutablesFilterName => 'Windows 可执行文件';

  @override
  String get dxvkOptionExplanation => '来自 Proton 的更新更快实现';

  @override
  String get wineD3DOptionExplanation => '来自 Wine 的成熟实现。若 DXVK 出现问题时使用。';

  @override
  String get screensaverDisableReason => '正在运行 Wine 应用（可能是全屏）';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      '下载的 winetricks 脚本哈希值与预期不符。';

  @override
  String downloadedFile(String downloadedFile) {
    return '已下载文件：$downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return '预期 SHA256 哈希值：$hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return '实际 SHA256 哈希值：$hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst => '先完成所有前缀中运行的应用';

  @override
  String get finishTheRunningAppsFirst => '先结束正在运行的应用';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      '此系统缺少运行 Wine Bar 所需的硬件虚拟化功能（/dev/kvm 缺失）。';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar 在 ARM64 上需要对 /dev/kvm 的读写访问。普通应用通常拥有此权限，但 Snap 并不具备。要授予该权限，请在命令行中执行以下命令：\n\n$kvmConnectCommand\n\n然后，重新启动 Wine Bar。';
  }

  @override
  String get muvmIsNeededButMissing =>
      '此系统需要 muvm / FEX 才能运行 Windows 应用。Wine Bar 的 Snap 版本已内置 muvm。否则，请使用 \"sudo dnf install muvm fex-emu\" 或类似命令安装。';

  @override
  String get prefixNameCantBeEmpty => '前缀名称不能为空';

  @override
  String get illegalSymbolsPresent => '存在非法符号';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      '此 Wine prefix 未捆绑 winetricks 脚本，也未提供外部脚本。';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      '未能定位 wine / wineserver 可执行文件';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      '未能定位运行 winetricks 所需的 wine / wineserver 可执行文件';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\" 命令失败';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get donationSolicitationDialogText =>
      '嗨，您好！我是 Wine Bar 的作者。\n\n我於 2025 年夏季開始著手此專案，從那時起投入了大量精力。如今 Wine Bar 已能滿足我個人所需的一切功能，雖然並非完美——只是我的需求相對簡單。這意味著我只有在能證明其所需時間與精力的價值時，才會繼續開發。\n\n為了讓開發持續進行，我誠摯地請求您的支持。捐款能幫助覆蓋 Wine Bar 的開發時間與持續維護費用，給我繼續投入的動力。若您是熟悉 Dart/Flutter 的開發者，也歡迎加入我們的開發行列。\n\n請注意，即使您已捐款，該訊息仍會偶爾顯示，因為 Wine Bar 不追蹤誰已捐款或未捐款。\n\n感謝您的理解與支持。';

  @override
  String get kronekWineSourceDescription =>
      '提供標準、Staging、TkG 與 Proton Wine 版本。';

  @override
  String get geProtonWineSourceDescription =>
      '提供包含 DXVK / VK3D 的 Proton 構建。推薦用於遊戲與其他全螢幕應用。';

  @override
  String get appUnpinningConfirmationDialogTitle => '解除應用釘選確認';

  @override
  String get createWinePrefixDialogTitle => '建立 Wine 前綴';

  @override
  String get cloneWinePrefixDialogTitle => '複製 Wine 前綴';

  @override
  String get prefixDeletionConfirmationDialogTitle => '前綴刪除確認';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'Wine 無法存取路徑';

  @override
  String get winePrefixesPageTitle => 'Wine 前綴';

  @override
  String winePrefixPageTitlePattern(String prefixName) {
    return 'Wine 前綴：$prefixName';
  }

  @override
  String prefixSettingsDialogTitlePattern(String prefixName) {
    return 'Wine 前綴 $prefixName 設定';
  }

  @override
  String pinnedExecutableSettingsDialogTitlePattern(
    String pinnedExecutableLabel,
  ) {
    return '$pinnedExecutableLabel 設定';
  }

  @override
  String get processLogsTitle => '進程日誌';

  @override
  String licenseInfoPattern(String license) {
    return '授權：$license';
  }

  @override
  String authorInfoPattern(String author) {
    return '作者：$author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return '複製過程以狀態 $exitCode 失敗';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir => 'DXVK 套件缺少 x32 或 x64 子目錄';

  @override
  String get failedToPrepareWinetricksScript => '無法準備 winetricks 腳本：';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return '資料夾 $toplevelDataDir 已存在，但未被識別為本應用程式所屬。\n請重新命名或將其移至垃圾桶，然後重啟應用程式。';
  }

  @override
  String get extractionFailedMessage => '解壓失敗';

  @override
  String prefixAlreadyExists(String prefixName) {
    return '前綴 \"$prefixName\" 已存在';
  }

  @override
  String get unknownErrorMessage => '未知錯誤';

  @override
  String get criticalErrorCaption => '嚴重錯誤';

  @override
  String get noLogsWereCapturedFromThisProcess => '此進程未捕獲任何日誌';

  @override
  String get winePrefixUpdatedMessage => 'Wine 前綴已更新';

  @override
  String get pinnedAppUpdatedMessage => '已更新固定應用程式';

  @override
  String get moreDetailsLink => '更多細節。';

  @override
  String get wow64ModeSection => 'WOW64 模式';

  @override
  String get useWow64ModeIfAvailable => '如可用，使用 WOW64 模式';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 實作';

  @override
  String get useParticularD3D8To11Impl => '使用特定的 Direct3D 8-11 實作';

  @override
  String get defaultD3D8To11ImplWillBeUsed => '將使用此 Wine 構建的預設實作';

  @override
  String get windowsLocale => '語系';

  @override
  String get useParticularWindowsLocale => '使用特定語系';

  @override
  String get dontShowThisWarningAgain => '不再顯示此警告';

  @override
  String get nameForTheNewPrefixHintText => '新 Wine 前綴的名稱';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps => '這可能有助於非 Unicode 應用程式的文字顯示';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps => '系統語系將被 Windows 應用程式使用';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      '這會使文字變得太小，但不會破壞舊的全螢幕應用程式';

  @override
  String get thisIsThePrefectScaleForYourDisplay => '這是您螢幕的最佳縮放比例';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      '此設定可避免文字過小，但會破壞舊版全螢幕應用程式';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      '這是您螢幕的最佳縮放比例，但會破壞舊版全螢幕應用程式';

  @override
  String get thisWillProduceTextThatsTooLarge => '此設定可能會產生文字過大的問題';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted => '此前綴處於無法刪除的狀態';

  @override
  String get hiDpiScaleLabel => 'HiDPI 縮放比例';

  @override
  String get pleaseSelect => '請選擇';

  @override
  String get appsAreRunningInThisPrefixTooltip => '此前綴中正在運行應用程式';

  @override
  String get refreshWineReleasesTooltip => '重新整理 wine 發行版';

  @override
  String get prefixSettingsTooltip => '前綴設定';

  @override
  String get killProcessTooltip => '終止進程';

  @override
  String get scrollToBottomTooltip => '捲動到底部';

  @override
  String get scrollToTopTooltip => '捲動到頂部';

  @override
  String get viewLogsTooltip => '查看日誌';

  @override
  String get viewLogsLink => '查看日誌。';

  @override
  String get useParticularGPU => '使用特定 GPU';

  @override
  String get gpuSelection => 'GPU 選擇';

  @override
  String get failedToGetTheListOfAvailableGPUs => '無法取得可用 GPU 列表';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      '請注意此功能並非在所有情況下都能正常運作';

  @override
  String get addWinePrefixButtonLabel => '新增 Wine 前綴';

  @override
  String get aboutButtonLabel => '關於';

  @override
  String get donateButtonLabel => '贊助';

  @override
  String get unpinButtonLabel => '取消釘選';

  @override
  String get deleteButtonLabel => '刪除';

  @override
  String get createWinePrefixButtonLabel => '建立 Wine 前綴';

  @override
  String get startingButtonLabel => '啟動中 …';

  @override
  String get downloadingAndExtractingButtonLabel => '下載並解壓縮中 …';

  @override
  String get downloadingAndExtractingDxvkButtonLabel => '下載並解壓縮 DXVK 中 …';

  @override
  String get creatingWinePrefixButtonLabel => '建立 Wine 前綴 …';

  @override
  String get updateWinePrefixButtonLabel => '更新 Wine 前綴';

  @override
  String get updatingWinePrefixButtonLabel => '正在更新 Wine 前綴 …';

  @override
  String get cloneButtonLabel => '複製';

  @override
  String get cloningButtonLabel => '正在複製 …';

  @override
  String get pinExecutableButtonLabel => '固定可執行檔';

  @override
  String get proceedAnywayButtonLabel => '仍然繼續';

  @override
  String get runExecutableButtonLabel => '執行可執行檔';

  @override
  String get runInstallerButtonLabel => '執行安裝程式';

  @override
  String get settingsMenuItem => '設定';

  @override
  String get theFollowingAppIsAboutToBeUnpinned => '以下應用程式即將被取消固定：';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted => '以下前綴即將被刪除：';

  @override
  String get theFollowingPathIsInaccessibleFromWine => '以下路徑在 Wine 中無法存取：';

  @override
  String get pathInaccessibleFromWineExplanation =>
      '路徑可能因為整個 Wine Bar 或僅 Wine 在虛擬機器（Apple silicon Mac）或 Snap / Flatpak 沙盒中執行而無法從 Wine 訪問。';

  @override
  String get solutionHeading => '解決方案';

  @override
  String get pathInaccessibleFromWineSolution => '將相關資料夾複製到您主目錄下的某處。';

  @override
  String get thisActionCantBeUndone => '此操作無法復原！';

  @override
  String get selectWineBuildProviderStepName => '選擇 wine build provider';

  @override
  String get selectWineReleaseStepName => '選擇 wine release';

  @override
  String get selectWineBuildStepName => '選擇 wine build';

  @override
  String get setOptionsStepName => '設定選項';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      '已選擇 WOW64 建置。這類建置在模擬環境下已知會出現問題，請預期安裝失敗。';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      '此建置需要系統中存在 32 位元函式庫。若您已安裝，則可忽略此警告；否則請從發行版套件庫安裝 Wine（將同時帶入 32 位元函式庫），或在上方列表中選擇可用的 WOW64 建置。';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      '在模擬環境下，WOW64 模式已知會出現問題，請預期安裝失敗。';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      '不使用 WOW64 模式將需要系統中存在 32 位元函式庫。若您已安裝，則可忽略此警告；否則請從發行版套件庫安裝 Wine，將同時帶入 32 位元函式庫。';

  @override
  String get windowsExecutablesFilterName => 'Windows 可執行檔';

  @override
  String get dxvkOptionExplanation => 'Proton 的更新且更快的實作';

  @override
  String get wineD3DOptionExplanation => 'Wine 的成熟實作。若 DXVK 出現問題時使用。';

  @override
  String get screensaverDisableReason => '正在執行 Wine 應用程式（可能是全螢幕）';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      '下載的 winetricks 腳本雜湊值與預期不符。';

  @override
  String downloadedFile(String downloadedFile) {
    return '下載檔案：$downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return '預期 SHA256 雜湊值：$hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return '實際 SHA256 雜湊值：$hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst => '先結束所有前綴中執行的應用程式';

  @override
  String get finishTheRunningAppsFirst => '先結束正在執行的程式';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      '此系統缺少執行 Wine Bar 所需的硬體虛擬化功能（/dev/kvm 缺失）。';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar 在 ARM64 上需要對 /dev/kvm 的讀寫存取。普通程式通常具備此權限，但 Snap 版則沒有。要授予此權限，請在命令列執行以下指令：\n\n$kvmConnectCommand\n\n接著，重新啟動 Wine Bar。';
  }

  @override
  String get muvmIsNeededButMissing =>
      '此系統需要 muvm / FEX 才能執行 Windows 程式。Wine Bar 的 Snap 版本已內建 muvm。否則，請使用 \"sudo dnf install muvm fex-emu\" 或類似指令安裝。';

  @override
  String get prefixNameCantBeEmpty => '前綴名稱不能為空';

  @override
  String get illegalSymbolsPresent => '存在非法符號';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      '此 Wine prefix 未捆綁 winetricks 腳本，也未提供外部腳本。';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      '無法定位 wine / wineserver 可執行檔';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      '無法定位執行 winetricks 所需的 wine / wineserver 可執行檔';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\" 指令失敗';
  }
}
