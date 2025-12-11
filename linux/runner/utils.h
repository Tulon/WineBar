#pragma once

#include <stdbool.h>
#include <stddef.h>

/**
 * Takes a path relative to the currently running executable and returns
 * the corresponding absolute path in the provided buffer.
 */
bool resolve_path_relative_to_executable_dir(const char *rel_path, char *buf,
                                             size_t buf_size);
