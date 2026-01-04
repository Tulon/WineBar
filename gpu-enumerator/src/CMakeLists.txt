add_executable(
    ${PROJECT_NAME}
    gpu-enumerator.c
    PrintHexEncodedByteArray.c
    PrintHexEncodedByteArray.h
    PrintQuotedAndEscapedJsonString.c
    PrintQuotedAndEscapedJsonString.h
)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE PkgConfig::Vulkan
)

install(
    TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    COMPONENT Runtime
)
