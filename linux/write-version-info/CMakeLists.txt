# Flutter writes the version information to
# <bundle>/data/flutter_assets/version.json. Unfortunately, on Linux,
# the version written in that file comes directly from pubspec.yaml,
# and is not overridden by the --build-name argument as it should.
# Therefore, in order for the app to be able to display its own
# version, we have to write our own file into the bundle directory.

include("${FLUTTER_MANAGED_DIR}/ephemeral/generated_config.cmake")

file(
    WRITE "${CMAKE_CURRENT_BINARY_DIR}/version.txt"
    "${FLUTTER_VERSION_MAJOR}.${FLUTTER_VERSION_MINOR}.${FLUTTER_VERSION_PATCH}"
)

install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/version.txt"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/data/"
    COMPONENT Runtime
)