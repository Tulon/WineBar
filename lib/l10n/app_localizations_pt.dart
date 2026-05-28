// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get kronekWineSourceDescription =>
      'Fornece as compilações padrão, Staging, TkG e Proton do Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Fornece compilações Proton com DXVK / VK3D incluídos. Recomendado para jogos e outros aplicativos em tela cheia.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Confirmação de desfixação do aplicativo';

  @override
  String get createWinePrefixDialogTitle => 'Criar um Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Clonar Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Confirmação de exclusão do prefixo';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Caminho inacessível a partir do Wine';

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
    return '$pinnedExecutableLabel Configurações';
  }

  @override
  String get processLogsTitle => 'Registros de Processos';

  @override
  String licenseInfoPattern(String license) {
    return 'Licença: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autor: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'O processo de cópia falhou com status $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'O pacote DXVK está faltando o subdiretório x32 ou x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Falha ao preparar o script winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'A pasta $toplevelDataDir existe, mas não foi reconhecida como pertencente a este aplicativo.\nRenomeie-a ou mova-a para o Lixo e reinicie o aplicativo.';
  }

  @override
  String get extractionFailedMessage => 'Falha na extração';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" já existe';
  }

  @override
  String get unknownErrorMessage => 'Erro desconhecido';

  @override
  String get criticalErrorCaption => 'Erro crítico';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Nenhum log foi capturado deste processo';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix atualizado';

  @override
  String get pinnedAppUpdatedMessage => 'Aplicativo fixado atualizado';

  @override
  String get moreDetailsLink => 'Mais detalhes.';

  @override
  String get wow64ModeSection => 'Modo WOW64';

  @override
  String get useWow64ModeIfAvailable => 'Use o modo WOW64 se disponível';

  @override
  String get d3D8To11Implementation => 'Implementação Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Use uma implementação específica do Direct3D 8-11';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Uma implementação padrão para esta versão específica do Wine será usada';

  @override
  String get windowsLocale => 'Localidade';

  @override
  String get useParticularWindowsLocale => 'Usar uma localidade específica';

  @override
  String get dontShowThisWarningAgain => 'Não mostrar este aviso novamente';

  @override
  String get nameForTheNewPrefixHintText => 'Nome para o novo wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Isso pode ajudar na exibição de texto em aplicativos não-Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'A localidade do sistema será usada pelos aplicativos Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Isso fará o texto ficar pequeno demais, mas não quebrará aplicativos em tela cheia mais antigos';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Esta é a escala perfeita para o seu ecrã';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Isso ajudará a evitar que o texto fique pequeno, mas quebrará aplicações em tela cheia mais antigas';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Esta é a escala perfeita para o seu ecrã, mas quebrará aplicações em tela cheia mais antigas';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Isso pode produzir texto muito grande';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Este prefixo está num estado em que não pode ser eliminado';

  @override
  String get hiDpiScaleLabel => 'Escala HiDPI';

  @override
  String get pleaseSelect => 'Selecione';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Aplicativos em execução neste prefixo';

  @override
  String get refreshWineReleasesTooltip => 'Atualizar lançamentos do wine';

  @override
  String get prefixSettingsTooltip => 'Configurações do prefixo';

  @override
  String get killProcessTooltip => 'Encerrar processo';

  @override
  String get scrollToBottomTooltip => 'Rolar para o fim';

  @override
  String get scrollToTopTooltip => 'Rolar para o início';

  @override
  String get viewLogsTooltip => 'Ver logs';

  @override
  String get viewLogsLink => 'Ver logs.';

  @override
  String get useParticularGPU => 'Usar um GPU específico';

  @override
  String get gpuSelection => 'Seleção de GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Falha ao obter a lista de GPUs disponíveis';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Observe que este recurso não funciona em todos os cenários';

  @override
  String get addWinePrefixButtonLabel => 'Adicionar Wine Prefix';

  @override
  String get aboutButtonLabel => 'Sobre';

  @override
  String get donateButtonLabel => 'Doar';

  @override
  String get unpinButtonLabel => 'Desafixar';

  @override
  String get deleteButtonLabel => 'Excluir';

  @override
  String get createWinePrefixButtonLabel => 'Criar Wine Prefix';

  @override
  String get startingButtonLabel => 'Iniciando ...';

  @override
  String get downloadingAndExtractingButtonLabel => 'Baixando e Extraindo ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Baixando e Extraindo DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Criando Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Atualizar Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Atualizando Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'Clonar';

  @override
  String get cloningButtonLabel => 'Clonando ...';

  @override
  String get pinExecutableButtonLabel => 'Fixar Executável';

  @override
  String get proceedAnywayButtonLabel => 'Continuar Mesmo Assim';

  @override
  String get runExecutableButtonLabel => 'Executar Executável';

  @override
  String get runInstallerButtonLabel => 'Executar Instalador';

  @override
  String get settingsMenuItem => 'Configurações';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'O seguinte aplicativo está prestes a ser desfixado:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'O seguinte prefixo está prestes a ser excluído:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'O seguinte caminho é inacessível a partir do Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Um caminho pode ser inacessível a partir do Wine porque todo o Wine Bar ou apenas o Wine está em execução em uma máquina virtual (em Macs com Apple silicon) ou em um sandbox Snap / Flatpak.';

  @override
  String get solutionHeading => 'Solução';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Copie a pasta em questão para algum lugar dentro do seu diretório home.';

  @override
  String get thisActionCantBeUndone => 'Esta ação não pode ser desfeita!';

  @override
  String get selectWineBuildProviderStepName =>
      'Selecione o provedor de build do Wine';

  @override
  String get selectWineReleaseStepName => 'Selecione a release do Wine';

  @override
  String get selectWineBuildStepName => 'Selecione o build do Wine';

  @override
  String get setOptionsStepName => 'Definir opções';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Uma compilação WOW64 foi selecionada. São conhecidas por apresentarem problemas em emulação. Espere uma instalação quebrada.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Esta compilação requer bibliotecas de 32 bits presentes em seu sistema. Se você já as possui, pode ignorar este aviso. Caso contrário, instale o Wine a partir do repositório da sua distribuição (o que trará essas bibliotecas de 32 bits) ou, alternativamente, selecione uma compilação WOW64 na lista acima se houver alguma disponível.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'O modo WOW64 em emulação é conhecido por apresentar problemas. Espere uma instalação quebrada.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Não usar o modo WOW64 exigirá que bibliotecas de 32 bits estejam presentes em seu sistema. Se você já as possui, pode ignorar este aviso. Caso contrário, instale o Wine a partir do repositório da sua distribuição, que trará essas bibliotecas de 32 bits.';

  @override
  String get windowsExecutablesFilterName => 'Executáveis do Windows';

  @override
  String get dxvkOptionExplanation =>
      'Uma implementação mais nova e rápida do Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Uma implementação madura do Wine. Usar em caso de problemas com o DXVK.';

  @override
  String get screensaverDisableReason =>
      'Um aplicativo Wine (possivelmente em tela cheia) está em execução';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'O hash do script winetricks baixado não corresponde ao esperado.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Arquivo baixado: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Hash SHA256 esperado: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Hash SHA256 real: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Finalize os aplicativos em execução em todos os prefixes primeiro';

  @override
  String get finishTheRunningAppsFirst =>
      'Finalize os aplicativos em execução primeiro';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Este sistema carece das capacidades de virtualização de hardware (/dev/kvm está ausente) necessárias para executar o Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'O Wine Bar em ARM64 precisa de acesso de leitura e escrita a /dev/kvm. Aplicativos comuns normalmente têm esse acesso, mas os Snaps não. Para conceder tal acesso, execute o seguinte comando no terminal:\n\n$kvmConnectCommand\n\nEm seguida, reinicie o Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Este sistema precisa de muvm / FEX para poder executar aplicativos do Windows. A versão Snap do Wine Bar já inclui o muvm. Caso contrário, instale-o usando \"sudo dnf install muvm fex-emu\" ou similar.';

  @override
  String get prefixNameCantBeEmpty => 'O nome do prefixo não pode estar vazio';

  @override
  String get illegalSymbolsPresent => 'Símbolos ilegais presentes';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Este Wine prefix não inclui um script winetricks e nenhum externo foi fornecido.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Falha ao localizar os executáveis wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Falha ao localizar os executáveis wine / wineserver para executar winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'O comando \"$command\" falhou';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get kronekWineSourceDescription =>
      'Fornece as versões padrão, Staging, TkG e Proton do Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Fornece compilação Proton com DXVK / VK3D incluídos. Recomendado para jogos e outros aplicativos em tela cheia.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Confirmação de desfixação do aplicativo';

  @override
  String get createWinePrefixDialogTitle => 'Criar um Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Clonar Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Confirmação de exclusão do prefixo';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Caminho inacessível a partir do Wine';

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
    return '$pinnedExecutableLabel Configurações';
  }

  @override
  String get processLogsTitle => 'Registros de Processos';

  @override
  String licenseInfoPattern(String license) {
    return 'Licença: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autor: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'O processo de cópia falhou com status $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'O pacote DXVK está faltando o subdiretório x32 ou x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Falha ao preparar o script winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'A pasta $toplevelDataDir existe, mas não foi reconhecida como pertencente a este aplicativo.\nRenomeie-a ou mova para o Lixo e reinicie o aplicativo.';
  }

  @override
  String get extractionFailedMessage => 'Falha na extração';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'Prefix \"$prefixName\" já existe';
  }

  @override
  String get unknownErrorMessage => 'Erro desconhecido';

  @override
  String get criticalErrorCaption => 'Erro crítico';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'Nenhum log foi capturado deste processo';

  @override
  String get winePrefixUpdatedMessage => 'Wine prefix atualizado';

  @override
  String get pinnedAppUpdatedMessage => 'Aplicativo fixado atualizado';

  @override
  String get moreDetailsLink => 'Mais detalhes.';

  @override
  String get wow64ModeSection => 'Modo WOW64';

  @override
  String get useWow64ModeIfAvailable => 'Use o modo WOW64 se disponível';

  @override
  String get d3D8To11Implementation => 'Implementação Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Use uma implementação específica do Direct3D 8-11';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Uma implementação padrão para esta versão específica do Wine será usada';

  @override
  String get windowsLocale => 'Localidade';

  @override
  String get useParticularWindowsLocale => 'Usar uma localidade específica';

  @override
  String get dontShowThisWarningAgain => 'Não mostrar este aviso novamente';

  @override
  String get nameForTheNewPrefixHintText => 'Nome do novo Wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Isso pode ajudar na exibição de texto em aplicativos não-Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'A localidade do sistema será usada pelos aplicativos Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Isso fará o texto ficar pequeno demais, mas não quebrará aplicativos em tela cheia mais antigos';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Esta é a escala perfeita para sua tela';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Isso ajudará a evitar textos muito pequenos, mas quebrará aplicativos em tela cheia mais antigos';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Esta é a escala perfeita para sua tela, mas quebrará aplicativos em tela cheia mais antigos';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Isso pode produzir textos muito grandes';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Este prefixo está em um estado onde não pode ser excluído';

  @override
  String get hiDpiScaleLabel => 'Escala HiDPI';

  @override
  String get pleaseSelect => 'Selecione';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Aplicativos em execução neste prefixo';

  @override
  String get refreshWineReleasesTooltip => 'Atualizar versões do wine';

  @override
  String get prefixSettingsTooltip => 'Configurações do prefixo';

  @override
  String get killProcessTooltip => 'Encerrar processo';

  @override
  String get scrollToBottomTooltip => 'Rolar para o fim';

  @override
  String get scrollToTopTooltip => 'Rolar para o início';

  @override
  String get viewLogsTooltip => 'Ver logs';

  @override
  String get viewLogsLink => 'Ver logs.';

  @override
  String get useParticularGPU => 'Usar um GPU específico';

  @override
  String get gpuSelection => 'Seleção de GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Falha ao obter a lista de GPUs disponíveis';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Observe que este recurso não funciona em todos os cenários';

  @override
  String get addWinePrefixButtonLabel => 'Adicionar Wine Prefix';

  @override
  String get aboutButtonLabel => 'Sobre';

  @override
  String get donateButtonLabel => 'Doar';

  @override
  String get unpinButtonLabel => 'Desprender';

  @override
  String get deleteButtonLabel => 'Excluir';

  @override
  String get createWinePrefixButtonLabel => 'Criar Wine Prefix';

  @override
  String get startingButtonLabel => 'Iniciando ...';

  @override
  String get downloadingAndExtractingButtonLabel => 'Baixando e Extraindo ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Baixando e Extraindo DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Criando Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Atualizar Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Atualizando Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'Clonar';

  @override
  String get cloningButtonLabel => 'Clonando ...';

  @override
  String get pinExecutableButtonLabel => 'Fixar Executável';

  @override
  String get proceedAnywayButtonLabel => 'Continuar Mesmo Assim';

  @override
  String get runExecutableButtonLabel => 'Executar Executável';

  @override
  String get runInstallerButtonLabel => 'Executar Instalador';

  @override
  String get settingsMenuItem => 'Configurações';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'O seguinte aplicativo está prestes a ser desfixado:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'O seguinte prefixo está prestes a ser excluído:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'O seguinte caminho é inacessível a partir do Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Um caminho pode ser inacessível a partir do Wine porque todo o Wine Bar ou apenas o Wine está rodando em uma máquina virtual (em Macs com Apple silicon) ou em um sandbox Snap / Flatpak.';

  @override
  String get solutionHeading => 'Solução';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Copie a pasta em questão para algum lugar dentro do seu diretório home.';

  @override
  String get thisActionCantBeUndone => 'Esta ação não pode ser desfeita!';

  @override
  String get selectWineBuildProviderStepName =>
      'Selecione o provedor de build do Wine';

  @override
  String get selectWineReleaseStepName => 'Selecione a release do Wine';

  @override
  String get selectWineBuildStepName => 'Selecione o build do Wine';

  @override
  String get setOptionsStepName => 'Defina opções';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Uma build WOW64 foi selecionada. Elas são conhecidas por apresentar problemas em emulação. Espere uma instalação quebrada.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Esta build requer bibliotecas de 32 bits presentes em seu sistema. Se você já as possui, pode ignorar este aviso. Caso contrário, instale o Wine a partir do repositório da sua distribuição (o que trará essas bibliotecas de 32 bits) ou, alternativamente, selecione uma build WOW64 na lista acima se houver alguma disponível.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'O modo WOW64 em emulação é conhecido por apresentar problemas. Espere uma instalação quebrada.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'Não usar o modo WOW64 exigirá que bibliotecas de 32 bits estejam presentes em seu sistema. Se você já as possui, pode ignorar este aviso. Caso contrário, instale o Wine a partir do repositório da sua distribuição, que trará essas bibliotecas de 32 bits.';

  @override
  String get windowsExecutablesFilterName => 'Executáveis do Windows';

  @override
  String get dxvkOptionExplanation =>
      'Uma implementação mais nova e rápida do Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Uma implementação madura do Wine. Usar em caso de problemas com o DXVK.';

  @override
  String get screensaverDisableReason =>
      'Um aplicativo Wine (possivelmente em tela cheia) está em execução';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'O hash do script winetricks baixado não corresponde ao esperado.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Arquivo baixado: $downloadedFile';
  }

  @override
  String expectedSha256Hash(String hash) {
    return 'Hash SHA256 esperado: $hash';
  }

  @override
  String actualSha256Hash(String hash) {
    return 'Hash SHA256 real: $hash';
  }

  @override
  String get finishTheAppsRunningInAllPrefixesFirst =>
      'Finalize os aplicativos em execução em todos os prefixes primeiro';

  @override
  String get finishTheRunningAppsFirst =>
      'Finalize os aplicativos em execução primeiro';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Este sistema carece das capacidades de virtualização de hardware (/dev/kvm está ausente) necessárias para executar o Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'O Wine Bar em ARM64 precisa de acesso de leitura e escrita ao /dev/kvm. Aplicativos comuns normalmente têm esse acesso, mas os Snaps não. Para conceder tal acesso, execute o seguinte comando no terminal:\n\n$kvmConnectCommand\n\nEm seguida, reinicie o Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Este sistema precisa de muvm / FEX para poder executar aplicativos do Windows. A versão Snap do Wine Bar já inclui o muvm. Caso contrário, instale-o usando \"sudo dnf install muvm fex-emu\" ou algo semelhante.';

  @override
  String get prefixNameCantBeEmpty => 'O nome do prefixo não pode estar vazio';

  @override
  String get illegalSymbolsPresent => 'Símbolos ilegais presentes';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Este Wine prefix não inclui um script winetricks e nenhum externo foi fornecido.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Falha ao localizar os executáveis wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Falha ao localizar os executáveis wine / wineserver para executar winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'O comando \"$command\" falhou';
  }
}
