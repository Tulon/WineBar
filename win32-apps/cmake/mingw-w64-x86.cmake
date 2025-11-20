set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR i686)

set(TOOLCHAIN_PREFIX i686-w64-mingw32)

# cross compilers to use for C, C++ and Fortran
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_RC_COMPILER ${TOOLCHAIN_PREFIX}-windres)

# Target environment on the build host system.
set(
    CMAKE_FIND_ROOT_PATH
    
    # This one is for Fedora.
    /usr/${TOOLCHAIN_PREFIX}/sys-root/mingw
    
    # This one is for Ubuntu. It has to go after the Fedora one,
    # as this path is also present on Fedora.
    /usr/${TOOLCHAIN_PREFIX}
)

# Search for libraries and includes in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)