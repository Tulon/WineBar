cmake_minimum_required(VERSION 3.13)

project(win32-apps LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

find_library(GDIPLUS_LIB gdiplus REQUIRED)

add_library(
    common STATIC
    src/CaseInsensitiveCompare.cpp
    src/CaseInsensitiveCompare.h
    src/CoInitializer.cpp
    src/CoInitializer.h
    src/CommandLineBuilder.cpp
    src/CommandLineBuilder.h
    src/DefaultIconSelector.cpp
    src/DefaultIconSelector.h
    src/EnumerateFilesOnDesktop.cpp
    src/EnumerateFilesOnDesktop.h
    src/EscapeAndQuoteJsonString.cpp
    src/EscapeAndQuoteJsonString.h
    src/ErrorString.cpp
    src/ErrorString.h
    src/FillPinDirectory.cpp
    src/FillPinDirectory.h
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
    src/WritePinJson.cpp
    src/WritePinJson.h
    src/WStringException.h
    src/WStringRuntimeError.h
)

target_compile_definitions(
    common
    PRIVATE -DUNICODE -D_UNICODE
)

target_compile_options(
    common
    PRIVATE
        -ffunction-sections -fdata-sections
)

foreach(target installer-runner pin-executable-info-extractor)
    add_executable(
        ${target}
        "src/${target}.cpp"
    )

    target_compile_definitions(
        ${target}
        PRIVATE -DUNICODE -D_UNICODE
    )

    target_link_libraries(
        ${target}
        PRIVATE
            common ${GDIPLUS_LIB} -lshlwapi
    )

    target_link_options(
        ${target}
        PRIVATE
            -mwindows -municode -Wl,--gc-sections
            -static -static-libgcc -static-libstdc++
    )

    install(
        TARGETS ${target}
        RUNTIME DESTINATION bin-win32
    )
endforeach()
