# Version 3.28 is required for the EXCLUDE_FROM_ALL argument
# to FetchContent_Declare()
cmake_minimum_required(VERSION 3.28)

project(log-capturing-runner LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED TRUE)

# The order matters here.
add_subdirectory(dependencies)
add_subdirectory(src)
add_subdirectory(tests)
