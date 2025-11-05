include_directories(../src)

set(
    tests
    TestHeadBuffer
    TestHeadTailBuffer
    TestTailBuffer
    TestTimespecUtils
)

foreach(test ${tests})
    add_executable(${test} EXCLUDE_FROM_ALL "${test}.c")
    add_dependencies(build_tests ${test})

    add_test(NAME ${test} COMMAND ${test})

    target_link_libraries(${test} mainlib cmocka)
endforeach()
