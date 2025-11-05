include(FetchContent)

# Make option() do nothing when a variable already exist.
cmake_policy(SET CMP0077 NEW)

set(BUILD_SHARED_LIBS OFF)
set(WITH_EXAMPLES OFF)
set(UNIT_TESTING OFF)

FetchContent_Declare(
    cmocka
    GIT_REPOSITORY https://gitlab.com/cmocka/cmocka.git
    GIT_TAG 5912a32c42d7342a20da7837b3ec0eaffbe455a6
    OVERRIDE_FIND_PACKAGE
    EXCLUDE_FROM_ALL
)
