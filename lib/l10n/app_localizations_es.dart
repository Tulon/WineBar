// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get kronekWineSourceDescription =>
      'Proporciona las compilaciones estándar, Staging, TkG y Proton de Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Proporciona compilaciones Proton con DXVK / VK3D incluidos. Recomendado para juegos y otras aplicaciones de pantalla completa.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Confirmación de desanclaje de la aplicación';

  @override
  String get createWinePrefixDialogTitle => 'Crear un Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Clonar Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Confirmación de eliminación del prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Ruta inaccesible desde Wine';

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
    return '$pinnedExecutableLabel Configuración';
  }

  @override
  String get processLogsTitle => 'Registros del proceso';

  @override
  String licenseInfoPattern(String license) {
    return 'Licencia: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autor: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'El proceso de copia falló con el estado $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'El paquete DXVK no contiene el subdirectorio x32 o x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Error al preparar el script winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'La carpeta $toplevelDataDir existe pero no se reconoció como perteneciente a esta aplicación.\nPor favor, renómbrala o muévela a la Papelera y luego reinicia la aplicación.';
  }

  @override
  String get extractionFailedMessage => 'Extracción fallida';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'El prefijo \"$prefixName\" ya existe';
  }

  @override
  String get unknownErrorMessage => 'Error desconocido';

  @override
  String get criticalErrorCaption => 'Error crítico';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'No se capturaron registros de este proceso';

  @override
  String get winePrefixUpdatedMessage => 'Prefijo Wine actualizado';

  @override
  String get pinnedAppUpdatedMessage => 'Aplicación fijada actualizada';

  @override
  String get moreDetailsLink => 'Más detalles.';

  @override
  String get wow64ModeSection => 'Modo WOW64';

  @override
  String get useWow64ModeIfAvailable => 'Usar el modo WOW64 si está disponible';

  @override
  String get d3D8To11Implementation => 'Implementación Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Usar una implementación particular de Direct3D 8-11';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Se usará una implementación predeterminada para esta versión de Wine';

  @override
  String get windowsLocale => 'Configuración regional';

  @override
  String get useParticularWindowsLocale =>
      'Usar una configuración regional específica';

  @override
  String get dontShowThisWarningAgain => 'No volver a mostrar esta advertencia';

  @override
  String get nameForTheNewPrefixHintText => 'Nombre del nuevo Wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Esto puede ayudar con la visualización de texto en aplicaciones no Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'La configuración regional del sistema será utilizada por las aplicaciones de Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Esto hará que el texto sea demasiado pequeño pero no romperá las aplicaciones de pantalla completa más antiguas';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Esta es la escala perfecta para su pantalla';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Esto ayudará a que el texto no sea demasiado pequeño, pero romperá las aplicaciones en pantalla completa más antiguas';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Esta es la escala perfecta para su pantalla, aunque romperá las aplicaciones en pantalla completa más antiguas';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Esto puede producir texto demasiado grande';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Este prefijo está en un estado donde no puede ser eliminado';

  @override
  String get hiDpiScaleLabel => 'Escala HiDPI';

  @override
  String get pleaseSelect => 'Por favor seleccione';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Las aplicaciones están ejecutándose en este prefijo';

  @override
  String get refreshWineReleasesTooltip => 'Actualizar versiones de wine';

  @override
  String get prefixSettingsTooltip => 'Configuración del prefijo';

  @override
  String get killProcessTooltip => 'Terminar proceso';

  @override
  String get scrollToBottomTooltip => 'Desplazar hasta abajo';

  @override
  String get scrollToTopTooltip => 'Desplazar hasta arriba';

  @override
  String get viewLogsTooltip => 'Ver registros';

  @override
  String get viewLogsLink => 'Ver registros.';

  @override
  String get useParticularGPU => 'Usar una GPU específica';

  @override
  String get gpuSelection => 'Selección de GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Error al obtener la lista de GPUs disponibles';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Tenga en cuenta que esta función no funciona en todos los escenarios';

  @override
  String get addWinePrefixButtonLabel => 'Añadir Wine Prefix';

  @override
  String get aboutButtonLabel => 'Acerca de';

  @override
  String get donateButtonLabel => 'Donar';

  @override
  String get unpinButtonLabel => 'Desanclar';

  @override
  String get deleteButtonLabel => 'Eliminar';

  @override
  String get createWinePrefixButtonLabel => 'Crear Wine Prefix';

  @override
  String get startingButtonLabel => 'Iniciando ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Descargando y extrayendo ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Descargando y extrayendo DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Creando Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Actualizar Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Actualizando Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'Clonar';

  @override
  String get cloningButtonLabel => 'Clonando ...';

  @override
  String get pinExecutableButtonLabel => 'Fijar Ejecutable';

  @override
  String get proceedAnywayButtonLabel => 'Continuar de todos modos';

  @override
  String get runExecutableButtonLabel => 'Ejecutar Ejecutable';

  @override
  String get runInstallerButtonLabel => 'Ejecutar Instalador';

  @override
  String get settingsMenuItem => 'Configuración';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'La siguiente aplicación está a punto de ser desanclada:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'El siguiente prefix está a punto de ser eliminado:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'La siguiente ruta es inaccesible desde Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Una ruta puede ser inaccesible desde Wine porque todo Wine Bar o solo Wine se está ejecutando en una máquina virtual (en Macs con Apple silicon) o dentro de un sandbox Snap / Flatpak.';

  @override
  String get solutionHeading => 'Solución';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Copia la carpeta en cuestión a algún lugar bajo tu directorio home.';

  @override
  String get thisActionCantBeUndone => '¡Esta acción no se puede deshacer!';

  @override
  String get selectWineBuildProviderStepName =>
      'Seleccionar proveedor de compilación Wine';

  @override
  String get selectWineReleaseStepName => 'Seleccionar versión Wine';

  @override
  String get selectWineBuildStepName => 'Seleccionar compilación Wine';

  @override
  String get setOptionsStepName => 'Establecer opciones';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Se seleccionó una compilación WOW64. Se sabe que presentan problemas bajo emulación. Espera una instalación rota.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Esta compilación requiere que las bibliotecas de 32 bits estén presentes en tu sistema. Si ya las tienes, puedes ignorar esta advertencia. De lo contrario, instala Wine desde el repositorio de tu distribución (lo que traerá esas bibliotecas de 32 bits) o, alternativamente, selecciona una compilación WOW64 de la lista anterior si está disponible.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'El modo WOW64 bajo emulación es conocido por tener problemas. Espera una instalación rota.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'No usar el modo WOW64 requerirá que las bibliotecas de 32 bits estén presentes en tu sistema. Si ya las tienes, puedes ignorar esta advertencia. De lo contrario, instala Wine desde el repositorio de tu distribución, que traerá esas bibliotecas de 32 bits.';

  @override
  String get windowsExecutablesFilterName => 'Ejecutables de Windows';

  @override
  String get dxvkOptionExplanation =>
      'Una implementación más nueva y rápida de Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Una implementación madura de Wine. Se debe usar en caso de problemas con DXVK.';

  @override
  String get screensaverDisableReason =>
      'Una aplicación Wine (posiblemente a pantalla completa) está en ejecución';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'El hash del script winetricks descargado no coincide con el esperado.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Archivo descargado: $downloadedFile';
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
      'Termina primero las aplicaciones que se están ejecutando en todos los prefijos';

  @override
  String get finishTheRunningAppsFirst =>
      'Termina primero las aplicaciones en ejecución';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Este sistema carece de las capacidades de virtualización por hardware (/dev/kvm falta) que son necesarias para ejecutar Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar en ARM64 necesita acceso de lectura-escritura a /dev/kvm. Las aplicaciones ordinarias normalmente tienen ese acceso, pero no los Snaps. Para conceder dicho acceso, ejecute el siguiente comando desde la línea de comandos:\n\n$kvmConnectCommand\n\nLuego, reinicie Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Este sistema necesita muvm / FEX para poder ejecutar aplicaciones de Windows. La versión Snap de Wine Bar tiene muvm incorporado. De lo contrario, instálelo usando \"sudo dnf install muvm fex-emu\" o similar';

  @override
  String get prefixNameCantBeEmpty =>
      'El nombre del prefijo no puede estar vacío';

  @override
  String get illegalSymbolsPresent => 'Símbolos ilegales presentes';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Este Wine prefix no incluye un script winetricks y tampoco se proporcionó uno externo.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'No se pudieron localizar los ejecutables de wine / wineserver';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'No se pudieron localizar los ejecutables de wine / wineserver para ejecutar winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'El comando \"$command\" falló';
  }
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get kronekWineSourceDescription =>
      'Proporciona las compilaciones estándar, Staging, TkG y Proton de Wine.';

  @override
  String get geProtonWineSourceDescription =>
      'Proporciona compilaciones Proton con DXVK / VK3D incluidos. Recomendado para juegos y otras aplicaciones de pantalla completa.';

  @override
  String get appUnpinningConfirmationDialogTitle =>
      'Confirmación de desanclaje de la aplicación';

  @override
  String get createWinePrefixDialogTitle => 'Crear un Wine Prefix';

  @override
  String get cloneWinePrefixDialogTitle => 'Clonar Wine Prefix';

  @override
  String get prefixDeletionConfirmationDialogTitle =>
      'Confirmación de eliminación del prefix';

  @override
  String get pathInaccessibleFromWineDialogTitle =>
      'Ruta inaccesible desde Wine';

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
    return '$pinnedExecutableLabel Configuración';
  }

  @override
  String get processLogsTitle => 'Registros de procesos';

  @override
  String licenseInfoPattern(String license) {
    return 'Licencia: $license';
  }

  @override
  String authorInfoPattern(String author) {
    return 'Autor: $author';
  }

  @override
  String theCopyingProcessFailedWithExitCode(int exitCode) {
    return 'El proceso de copia falló con el estado $exitCode';
  }

  @override
  String get dxvkPackageIsMissingTheX32OrX64Subdir =>
      'El paquete DXVK no contiene el subdirectorio x32 o x64';

  @override
  String get failedToPrepareWinetricksScript =>
      'Error al preparar el script winetricks:';

  @override
  String topLevelDataDirExistsButWasntRecognized(String toplevelDataDir) {
    return 'La carpeta $toplevelDataDir existe pero no se reconoció como perteneciente a esta aplicación.\nPor favor, renómbrala o muévela a la Papelera y luego reinicia la aplicación.';
  }

  @override
  String get extractionFailedMessage => 'Extracción fallida';

  @override
  String prefixAlreadyExists(String prefixName) {
    return 'El prefijo \"$prefixName\" ya existe';
  }

  @override
  String get unknownErrorMessage => 'Error desconocido';

  @override
  String get criticalErrorCaption => 'Error crítico';

  @override
  String get noLogsWereCapturedFromThisProcess =>
      'No se capturaron registros de este proceso';

  @override
  String get winePrefixUpdatedMessage => 'Prefijo Wine actualizado';

  @override
  String get pinnedAppUpdatedMessage => 'Aplicación fijada actualizada';

  @override
  String get moreDetailsLink => 'Más detalles.';

  @override
  String get wow64ModeSection => 'Modo WOW64';

  @override
  String get useWow64ModeIfAvailable => 'Usar el modo WOW64 si está disponible';

  @override
  String get d3D8To11Implementation => 'Implementación Direct3D 8-11';

  @override
  String get useParticularD3D8To11Impl =>
      'Usar una implementación particular de Direct3D 8-11';

  @override
  String get defaultD3D8To11ImplWillBeUsed =>
      'Se usará una implementación predeterminada para esta versión de Wine';

  @override
  String get windowsLocale => 'Configuración regional';

  @override
  String get useParticularWindowsLocale =>
      'Usar una configuración regional específica';

  @override
  String get dontShowThisWarningAgain => 'No volver a mostrar esta advertencia';

  @override
  String get nameForTheNewPrefixHintText => 'Nombre del nuevo Wine prefix';

  @override
  String get thisMayHelpWithTextInNonUnicodeApps =>
      'Esto puede ayudar con la visualización de texto en aplicaciones no Unicode';

  @override
  String get theSystemLocaleWillBeUsedForWindowsApps =>
      'La configuración regional del sistema será utilizada por las aplicaciones de Windows';

  @override
  String get thisWillMakeTheTextTooSmallButWontBreakOlderFullscreenApp =>
      'Esto hará que el texto sea demasiado pequeño pero no romperá las aplicaciones en pantalla completa más antiguas';

  @override
  String get thisIsThePrefectScaleForYourDisplay =>
      'Esta es la escala perfecta para su pantalla';

  @override
  String get thisWillHelpWithTextBeingTooSmallButWillBreakOlderFullscreenApps =>
      'Esto ayudará a que el texto no sea demasiado pequeño, pero romperá las aplicaciones en pantalla completa más antiguas';

  @override
  String
  get thisIsThePerfectScaleForYourDisplayButWillBreakOlderFullscreenApps =>
      'Esta es la escala perfecta para su pantalla, aunque romperá las aplicaciones en pantalla completa más antiguas';

  @override
  String get thisWillProduceTextThatsTooLarge =>
      'Esto puede producir texto demasiado grande';

  @override
  String get thisPrefixIsInAStateWhereItCantBeDeleted =>
      'Este prefijo está en un estado donde no puede ser eliminado';

  @override
  String get hiDpiScaleLabel => 'Escala HiDPI';

  @override
  String get pleaseSelect => 'Por favor seleccione';

  @override
  String get appsAreRunningInThisPrefixTooltip =>
      'Las aplicaciones están ejecutándose en este prefijo';

  @override
  String get refreshWineReleasesTooltip => 'Actualizar versiones de wine';

  @override
  String get prefixSettingsTooltip => 'Configuración del prefijo';

  @override
  String get killProcessTooltip => 'Terminar proceso';

  @override
  String get scrollToBottomTooltip => 'Desplazar hasta abajo';

  @override
  String get scrollToTopTooltip => 'Desplazar hasta arriba';

  @override
  String get viewLogsTooltip => 'Ver registros';

  @override
  String get viewLogsLink => 'Ver registros.';

  @override
  String get useParticularGPU => 'Usar una GPU específica';

  @override
  String get gpuSelection => 'Selección de GPU';

  @override
  String get failedToGetTheListOfAvailableGPUs =>
      'Error al obtener la lista de GPUs disponibles';

  @override
  String get noteThatThisFeatureWontWorkInAllScenarios =>
      'Tenga en cuenta que esta función no funciona en todos los escenarios';

  @override
  String get addWinePrefixButtonLabel => 'Agregar Wine Prefix';

  @override
  String get aboutButtonLabel => 'Acerca de';

  @override
  String get donateButtonLabel => 'Donar';

  @override
  String get unpinButtonLabel => 'Desanclar';

  @override
  String get deleteButtonLabel => 'Eliminar';

  @override
  String get createWinePrefixButtonLabel => 'Crear Wine Prefix';

  @override
  String get startingButtonLabel => 'Iniciando ...';

  @override
  String get downloadingAndExtractingButtonLabel =>
      'Descargando y extrayendo ...';

  @override
  String get downloadingAndExtractingDxvkButtonLabel =>
      'Descargando y extrayendo DXVK ...';

  @override
  String get creatingWinePrefixButtonLabel => 'Creando Wine Prefix ...';

  @override
  String get updateWinePrefixButtonLabel => 'Actualizar Wine Prefix';

  @override
  String get updatingWinePrefixButtonLabel => 'Actualizando Wine Prefix ...';

  @override
  String get cloneButtonLabel => 'Clonar';

  @override
  String get cloningButtonLabel => 'Clonando ...';

  @override
  String get pinExecutableButtonLabel => 'Fijar Ejecutable';

  @override
  String get proceedAnywayButtonLabel => 'Continuar de todos modos';

  @override
  String get runExecutableButtonLabel => 'Ejecutar Ejecutable';

  @override
  String get runInstallerButtonLabel => 'Ejecutar Instalador';

  @override
  String get settingsMenuItem => 'Configuración';

  @override
  String get theFollowingAppIsAboutToBeUnpinned =>
      'La siguiente aplicación está a punto de ser desanclada:';

  @override
  String get theFollowingPrefixIsAboutToBeDeleted =>
      'El siguiente prefix está a punto de ser eliminado:';

  @override
  String get theFollowingPathIsInaccessibleFromWine =>
      'La siguiente ruta es inaccesible desde Wine:';

  @override
  String get pathInaccessibleFromWineExplanation =>
      'Una ruta puede ser inaccesible desde Wine porque todo Wine Bar o solo Wine se está ejecutando en una máquina virtual (en Macs con Apple silicon) o dentro de un sandbox Snap / Flatpak.';

  @override
  String get solutionHeading => 'Solución';

  @override
  String get pathInaccessibleFromWineSolution =>
      'Copia la carpeta en cuestión a algún lugar bajo tu directorio home.';

  @override
  String get thisActionCantBeUndone => '¡Esta acción no se puede deshacer!';

  @override
  String get selectWineBuildProviderStepName =>
      'Seleccionar proveedor de compilación Wine';

  @override
  String get selectWineReleaseStepName => 'Seleccionar lanzamiento Wine';

  @override
  String get selectWineBuildStepName => 'Seleccionar compilación Wine';

  @override
  String get setOptionsStepName => 'Establecer opciones';

  @override
  String get wow64BuildSelectedUnderEmulationWarning =>
      'Se seleccionó una compilación WOW64. Se sabe que presentan problemas bajo emulación. Espera una instalación rota.';

  @override
  String get nonWow64BuildRequires32BitLibsWarning =>
      'Esta compilación requiere que las bibliotecas de 32 bits estén presentes en tu sistema. Si ya las tienes, puedes ignorar esta advertencia. De lo contrario, instala Wine desde el repositorio de tu distribución (lo que traerá esas bibliotecas de 32 bits) o, alternativamente, selecciona una compilación WOW64 de la lista anterior si está disponible.';

  @override
  String get wow64PreferenceUnderEmulationWarning =>
      'El modo WOW64 bajo emulación es conocido por tener problemas. Espera una instalación rota.';

  @override
  String get nonWow64PreferenceRequires32BitLibsWarning =>
      'No usar el modo WOW64 requerirá que las bibliotecas de 32 bits estén presentes en tu sistema. Si ya las tienes, puedes ignorar esta advertencia. De lo contrario, instala Wine desde el repositorio de tu distribución, que traerá esas bibliotecas de 32 bits.';

  @override
  String get windowsExecutablesFilterName => 'Ejecutables de Windows';

  @override
  String get dxvkOptionExplanation =>
      'Una implementación más nueva y rápida de Proton';

  @override
  String get wineD3DOptionExplanation =>
      'Una implementación madura de Wine. Se debe usar en caso de problemas con DXVK.';

  @override
  String get screensaverDisableReason =>
      'Una aplicación de Wine (posiblemente a pantalla completa) está en ejecución';

  @override
  String get downloadedWinetricksHashDoesntMatchExpectation =>
      'El hash del script winetricks descargado no coincide con el esperado.';

  @override
  String downloadedFile(String downloadedFile) {
    return 'Archivo descargado: $downloadedFile';
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
      'Termina primero las aplicaciones que están en ejecución en todos los prefijos';

  @override
  String get finishTheRunningAppsFirst =>
      'Termina primero las aplicaciones en ejecución';

  @override
  String get missingHardwareVirtualizationCapabilities =>
      'Este sistema carece de las capacidades de virtualización por hardware (/dev/kvm falta) que son necesarias para ejecutar Wine Bar.';

  @override
  String snapKvmNeedsConnection(String kvmConnectCommand) {
    return 'Wine Bar en ARM64 necesita acceso de lectura-escritura a /dev/kvm. Las aplicaciones ordinarias normalmente tienen ese acceso, pero los Snaps no. Para otorgar dicho acceso, ejecute el siguiente comando desde la línea de comandos:\n\n$kvmConnectCommand\n\nLuego, reinicie Wine Bar.';
  }

  @override
  String get muvmIsNeededButMissing =>
      'Este sistema necesita muvm / FEX para poder ejecutar aplicaciones de Windows. La versión Snap de Wine Bar tiene muvm incorporado. De lo contrario, instálelo usando \"sudo dnf install muvm fex-emu\" o similar';

  @override
  String get prefixNameCantBeEmpty =>
      'El nombre del prefijo no puede estar vacío';

  @override
  String get illegalSymbolsPresent => 'Símbolos ilegales presentes';

  @override
  String get noBundledAndNoExternalWinetricksScriptAvailable =>
      'Este Wine prefix no incluye un script winetricks y tampoco se proporcionó uno externo.';

  @override
  String get failedToLocateWineOrWineserverExecutables =>
      'Failed to locate the wine / wineserver executables';

  @override
  String get failedToLocateWineOrWineserverExecutablesForRunningWinetricks =>
      'Failed to locate the wine / wineserver executables for running winetricks';

  @override
  String specificCommandHasFailed(String command) {
    return 'The \"$command\" command failed';
  }
}
