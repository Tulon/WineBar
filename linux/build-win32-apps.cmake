include(ExternalProject)

set(prefix_dir "${PROJECT_BINARY_DIR}/win32-apps")
set(install_dir "${prefix_dir}/instdir")

ExternalProject_Add(
    win32-apps
    BUILD_ALWAYS TRUE
    PREFIX "${prefix_dir}"
    SOURCE_DIR "${CMAKE_SOURCE_DIR}/../win32-apps"
    INSTALL_DIR "${install_dir}"
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=Release
    "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
    "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/../win32-apps/cmake/mingw-w64-x86.cmake"

    INSTALL_COMMAND ${CMAKE_COMMAND} --install . --config Release $<$<NOT:$<CONFIG:Debug>>:--strip>

    # Adding that COMMAND_EXPAND_LISTS is a dirty hack to pass it to the underlying add_custom_target()
    # in order to avoid passing an empty argument to cmake --install in a debug configuration.    
    COMMAND_EXPAND_LISTS
)

# We do need this separate install() call. If we try to make ExternalProject_Add() to install
# the executable at its final destination within the bundle, that doesn't work, as the bundle
# directory seems to get re-created on every build.
install(
    PROGRAMS
        "${install_dir}/bin-win32/installer-runner.exe"
        "${install_dir}/bin-win32/pin-executable-info-extractor.exe"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/bin-win32"
    COMPONENT Runtime
)
