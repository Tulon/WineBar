import 'package:winebar/utils/wine_installation_descriptor.dart';

/// This class exists purely for mocking / dependency injection purposes.
class UtilityService {
  Future<WineInstallationDescriptor>
  wineInstallationDescriptorForWineInstallDir(String wineInstallDir) {
    return WineInstallationDescriptor.forWineInstallDir(wineInstallDir);
  }
}
