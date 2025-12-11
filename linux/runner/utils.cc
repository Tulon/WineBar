#include "utils.h"

#include <string.h>
#include <unistd.h>

bool resolve_path_relative_to_executable_dir(const char *rel_path, char *buf,
                                             size_t buf_size) {
  ssize_t bytes_read = readlink("/proc/self/exe", buf, buf_size);
  if (bytes_read == -1 || bytes_read == sizeof(buf)) {
    return false;
  }

  size_t rel_path_len = strlen(rel_path);

  if (bytes_read + rel_path_len + 1 > buf_size) {
    return false;
  }

  memcpy(buf + bytes_read, rel_path, rel_path_len + 1);
  return true;
}
