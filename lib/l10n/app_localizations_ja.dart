// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get donationSolicitationDialogText =>
      'こんにちは。私は Wine Bar の作者です。\n\n2025 年の夏にプロジェクトに取り組み始めました。それ以来、多くの努力を注いできました。現在、Wine Bar は私が個人的に必要とするすべてを実現しています。完璧だと言うわけではありませんが、私のニーズは控えめです。そのため、必要な時間とエネルギーを正当化できる場合にのみ開発を継続できます。\n\n開発を継続するため、皆さんのご支援をお願いしています。寄付は Wine Bar の時間と継続的な作業費用を賄い、私に開発を続ける理由を与えてくれます。あるいは、Dart/Flutter に慣れている開発者の方であれば、開発チームに参加してみてください。\n\nご注意：寄付をいただいても、Wine Bar は誰が寄付したかを追跡しないため、このメッセージは時折表示されます。\n\nご理解いただきありがとうございます。';

  @override
  String get kronekWineSourceDescription =>
      '標準、Staging、TkG、および Proton Wine ビルドを提供します。';

  @override
  String get geProtonWineSourceDescription =>
      'DXVK / VK3D を含む Proton ビルドを提供します。ゲームやその他のフルスクリーンアプリに推奨されます。';

  @override
  String get appUnpinningConfirmationDialogTitle => 'アプリのピン解除確認';

  @override
  String get createWinePrefixDialogTitle => 'Wine Prefix を作成';

  @override
  String get cloneWinePrefixDialogTitle => 'Wine Prefix をクローン';

  @override
  String get prefixDeletionConfirmationDialogTitle => 'Prefix 削除確認';

  @override
  String get pathInaccessibleFromWineDialogTitle => 'Wine からアクセスできないパス';

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
    return '$pinnedExecutableLabel 設定';
  }

  @override
  String get processLogsTitle => 'プロセスログ';

  @override
  String licenseInfoPattern(String license) {
    return 'ライセンス: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return '作者: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'コピー処理がステータス $exitCode で失敗しました';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'DXVK パッケージに x32 または x64 サブディレクトリがありません';

  @override
  String get failedToPrepareWinetricksScript => 'winetricks スクリプトの準備に失敗しました:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'フォルダー $toplevelDataDir は存在しますが、このアプリに属していると認識されませんでした。\n名前を変更するか、ゴミ箱に移動してからアプリを再起動してください。';
  }

  @override
  String get extractionFailedMessage => '抽出に失敗しました';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'プレフィックス \"$prefixName\" は既に存在します';
  }

  @override
  String get unknownErrorMessage => '不明なエラー';

  @override
  String get criticalErrorCaption => '重大なエラー';

  @override
  String get noLogsWereCapturedFromThisProcess => 'このプロセスからログは取得されませんでした';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix が更新されました';

  @override
  String get pinnedAppUpdatedMessage => 'ピン留めされたアプリが更新されました';

  @override
  String get moreDetailsLink => '詳細を見る。';

  @override
  String get wow64ModeSection => 'WOW64 モード';

  @override
  String get useWow64ModeIfAvailable => '利用可能なら WOW64 モードを使用する';

  @override
  String get d3D8To11Implementation => 'Direct3D 8-11 実装';

  @override
  String get useParticularD3D8To11Impl => '特定の Direct3D 8-11 実装を使用する';

  @override
  String get defaultD3D8To11ImplWillBeUsed => 'このWineビルド専用のデフォルト実装が使用されます';

  @override
  String get windowsLocale => 'ロケール';

  @override
  String get useParticularWindowsLocale => '特定のロケールを使用する';

  @override
  String get dontShowThisWarningAgain => 'この警告を再表示しない';

  @override
  String get nameForTheNewPrefixHintText => '新しいWine prefixの名前';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      '非Unicodeアプリでのテキスト表示に役立つ場合があります';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'システムロケールはWindowsアプリで使用されます';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'テキストが小さくなりますが、古いフルスクリーンアプリは壊れません';

  @override
  String get thisIsThePrefectScaleForYourDisplay => 'ディスプレイに最適なスケールです';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'テキストが小さくなる問題を解決しますが、古いフルスクリーンアプリは動作しなくなります';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'ディスプレイに最適なスケールですが、古いフルスクリーンアプリは動作しなくなります';

  @override
  String get thisWillProduceTextThatsTooLarge => 'テキストが大きくなりすぎる可能性があります';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'このプレフィックスは削除できない状態にあります';

  @override
  String get hiDpiScaleLabel => 'HiDPI スケール';

  @override
  String get pleaseSelect => '選択してください';

  @override
  String get appsAreRunningInThisPrefixTooltip => 'このプレフィックスでアプリが実行中です';

  @override
  String get refreshWineReleasesTooltip => 'Wine リリースを更新';

  @override
  String get prefixSettingsTooltip => 'プレフィックス設定';

  @override
  String get killProcessTooltip => 'プロセスを終了';

  @override
  String get scrollToBottomTooltip => '下へスクロール';

  @override
  String get scrollToTopTooltip => '上へスクロール';

  @override
  String get viewLogsTooltip => 'ログを表示';

  @override
  String get viewLogsLink => 'ログを表示。';

  @override
  String get useParticularGPU => '特定の GPU を使用';

  @override
  String get gpuSelection => 'GPU 選択';

  @override
  String get failedToGetTheListOfAvailableGPUs => '利用可能な GPU のリストを取得できませんでした';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'この機能はすべてのシナリオで動作しないことに注意してください';

  @override
  String get addWinePrefixButtonLabel => 'Wine Prefix を追加';

  @override
  String get aboutButtonLabel => '情報';

  @override
  String get donateButtonLabel => '寄付';

  @override
  String get unpinButtonLabel => 'ピン留め解除';

  @override
  String get deleteButtonLabel => '削除';

  @override
  String get createWinePrefixButtonLabel => 'Wine Prefix を作成';

  @override
  String get startingButtonLabel => '開始中 …';

  @override
  String get downloadingAndExtractingButtonLabel => 'ダウンロード中・展開中 …';

  @override
  String get downloadingAndExtractingDxvkButtonLabel => 'DXVK のダウンロード中・展開中 …';

  @override
  String get creatingWinePrefixButtonLabel => 'Wine Prefix を作成中 …';

  @override
  String get updateWinePrefixButtonLabel => 'Wine Prefix を更新';

  @override
  String get updatingWinePrefixButtonLabel => 'Wine Prefix を更新中 …';

  @override
  String get cloneButtonLabel => '複製';

  @override
  String get cloningButtonLabel => '複製中 …';

  @override
  String get pinExecutableButtonLabel => '実行ファイルを固定';

  @override
  String get proceedAnywayButtonLabel => 'それでも続行';

  @override
  String get runExecutableButtonLabel => '実行ファイルを起動';

  @override
  String get runInstallerButtonLabel => 'インストーラを起動';

  @override
  String get settingsMenuItem => '設定';

  @override
  String get theFollowingAppIsAboutToBeUnpinned => '以下のアプリが固定解除されます:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted => '以下の prefix が削除されます:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      '以下のパスは Wine からアクセスできません:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'パスが Wine からアクセスできない場合があります。これは、Apple Silicon Mac 上の仮想マシンで Wine Bar または Wine が実行されているか、Snap / Flatpak サンドボックス内で動作しているためです。';

  @override
  String get solutionHeading => '解決策';

  @override
  String get pathInaccessibleFromWineSolution =>
      '対象フォルダーをホームディレクトリの下にコピーしてください。';

  @override
  String get thisActionCantBeUndone => 'この操作は元に戻せません！';

  @override
  String get selectWineBuildProviderStepName => 'wine ビルドプロバイダーを選択';

  @override
  String get selectWineReleaseStepName => 'wine リリースを選択';

  @override
  String get selectWineBuildStepName => 'wine ビルドを選択';

  @override
  String get setOptionsStepName => 'オプションを設定';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'WOW64 ビルドが選択されました。エミュレーション下で問題が発生することが知られています。インストールに失敗する可能性があります。';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'このビルドは、システムに 32‑bit ライブラリが存在する必要があります。既にインストール済みの場合は、この警告を無視できます。そうでない場合は、ディストリビューションのリポジトリから Wine をインストールしてください（32‑bit ライブラリが同時に入ります）または、上記のリストから利用可能な WOW64 ビルドを選択してください。';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'エミュレーション下で WOW64 モードは問題があることが知られています。インストールに失敗する可能性があります。';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'WOW64 モードを使用しない場合、システムに 32‑bit ライブラリが存在する必要があります。既にインストール済みの場合は、この警告を無視できます。そうでない場合は、ディストリビューションのリポジトリから Wine をインストールしてください（32‑bit ライブラリが同時に入ります）。';

  @override
  String get windowsExecutablesFilterName => 'Windows 実行ファイル';

  @override
  String get dxvkOptionExplanation => 'Protonからの新しく高速な実装';

  @override
  String get wineD3DOptionExplanation => 'Wine の成熟した実装。DXVK に問題がある場合に使用します。';

  @override
  String get screensaverDisableReason => 'Wine アプリ（フルスクリーンの可能性あり）が実行中です';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'ダウンロードした winetricks スクリプトのハッシュが期待値と一致しません。';

  @override
  String downloadedFile(String downloadedFile) {
    return 'ダウンロードしたファイル: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return '期待される SHA256 ハッシュ: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return '実際の SHA256 ハッシュ: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'すべての prefix に実行中のアプリを先に終了してください';

  @override
  String get finishTheRunningAppsFirst => '実行中のアプリを先に終了してください';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'このシステムには Wine Bar を実行するために必要なハードウェア仮想化機能（/dev/kvm が欠落）がありません。';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar on ARM64 は /dev/kvm に読み書きアクセスが必要です。通常のアプリはこのアクセス権を持ちますが、Snap ではありません。そのようなアクセス権を付与するには、コマンドラインから次のコマンドを実行してください：\n\n$kvmConnectCommand\n\nその後、Wine Bar を再起動してください。';
  }

  @override
  String get muvmIsNeededButMissing =>
      'このシステムでは Windows アプリを実行するために muvm / FEX が必要です。Wine Bar の Snap バージョンには muvm が組み込まれています。それ以外の場合は、\"sudo dnf install muvm fex-emu\" などを使用してインストールしてください。';

  @override
  String get prefixNameCantBeEmpty => 'プレフィックス名は空にできません';

  @override
  String get illegalSymbolsPresent => '不正なシンボルが含まれています';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'この Wine prefix は winetricks スクリプトをバンドルしておらず、外部スクリプトも提供されていません。';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'wine / wineserver 実行ファイルを見つけられませんでした';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'winetricks を実行するための wine / wineserver 実行ファイルを見つけられませんでした';

  @override
  String specificCommandHasFailed(String command) {
    return '\"$command\" コマンドが失敗しました';
  }
}
