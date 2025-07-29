cmake_minimum_required(VERSION 3.13)

project(run-and-pin-launcher LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

find_library(GDIPLUS_LIB gdiplus REQUIRED)

add_executable(
    ${PROJECT_NAME}
    src/CaseInsensitiveCompare.cpp
    src/CaseInsensitiveCompare.h
    src/CoInitializer.cpp
    src/CoInitializer.h
    src/CommandLineBuilder.cpp
    src/CommandLineBuilder.h
    src/DefaultIconSelector.cpp
    src/DefaultIconSelector.h
    src/EscapeAndQuoteJsonString.cpp
    src/EscapeAndQuoteJsonString.h
    src/ErrorString.cpp
    src/ErrorString.h
    src/IconFromAssociatedApplication.cpp
    src/IconFromAssociatedApplication.h
    src/IconForFile.cpp
    src/IconForFile.h
    src/IconForLnkFile.cpp
    src/IconForLnkFile.h
    src/IconFromIcoFile.cpp
    src/IconFromIcoFile.h
    src/IconFromPortableExecutable.cpp
    src/IconFromPortableExecutable.h
    src/IconFromPortableExecutableOrIcoFile.cpp
    src/IconFromPortableExecutableOrIcoFile.h
    src/main.cpp
    src/PickIconGroupResource.cpp
    src/PickIconGroupResource.h
    src/ResourceNameHolder.cpp
    src/ResourceNameHolder.h
    src/RunProcess.cpp
    src/RunProcess.h
    src/ScopeCleanup.h
    src/SignedIndexIconSelector.cpp
    src/SignedIndexIconSelector.h
    src/ToWindowsFilePath.cpp
    src/ToWindowsFilePath.h
    src/UnixToWindowsFilePath.cpp
    src/UnixToWindowsFilePath.h
    src/WriteIconToPng.cpp
    src/WriteIconToPng.h
    src/WritePinnedExecutableJson.cpp
    src/WritePinnedExecutableJson.h
    src/WStringException.h
    src/WStringRuntimeError.h
)

target_compile_definitions(
    ${PROJECT_NAME}
    PRIVATE -DUNICODE -D_UNICODE
)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
        ${GDIPLUS_LIB} -lshlwapi
)

target_link_options(
    ${PROJECT_NAME}
    PRIVATE
        -mwindows -municode -static -static-libgcc -static-libstdc++
)

install(
    TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin-win32
)