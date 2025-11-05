add_library(
    mainlib STATIC
    FdSetCloexecFlag.c
    FdSetCloexecFlag.h
    FdSetNonblockFlag.c
    FdSetNonblockFlag.h
    HeadBuffer.c
    HeadBuffer.h
    HeadTailBuffer.c
    HeadTailBuffer.h
    Log.c
    Log.h
    RunEventLoop.c
    RunEventLoop.h
    SpawnProcess.c
    SpawnProcess.h
    TailBuffer.c
    TailBuffer.h
    TimespecUtils.c
    TimespecUtils.h
)

add_executable(${PROJECT_NAME} log-capturing-runner.c)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE mainlib
)

install(
    TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    COMPONENT Runtime
)
