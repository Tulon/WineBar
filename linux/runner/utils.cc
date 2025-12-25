#include "utils.h"

#include <string.h>
#include <unistd.h>

bool resolve_path_relative_to_executable_dir(const char *rel_path, char *buf,
                                             size_t buf_size) {
  ssize_t bytes_read = readlink("/proc/self/exe", buf, buf_size);
  if (bytes_read == -1 || bytes_read == sizeof(buf)) {
    return false;
  }

  char *last_slash_ptr = strrchr(buf, '/');
  if (!last_slash_ptr) {
    return false;
  }

  size_t rel_path_insertion_pos = (last_slash_ptr - buf) + 1;

  size_t rel_path_len = strlen(rel_path);

  if (rel_path_insertion_pos + rel_path_len + 1 > buf_size) {
    return false;
  }

  memcpy(buf + rel_path_insertion_pos, rel_path, rel_path_len + 1);
  return true;
}
