/* ==============================================================================
 * TheFlux Native Runtime: Directory & Path Operations
 * Source: runtime/src/io/dir.c
 * ============================================================================== */

#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#if defined(_WIN32)
#include <windows.h>
#include <direct.h>
#else
#include <unistd.h>
#include <dirent.h>
#endif

int64_t flux_std_io_dir_exists(const char *path) {
    if (!path || !*path) return 0;
    struct stat st;
    if (stat(path, &st) == 0) {
#if defined(_WIN32)
        return (st.st_mode & _S_IFDIR) ? 1 : 0;
#else
        return S_ISDIR(st.st_mode) ? 1 : 0;
#endif
    }
    return 0;
}

int64_t flux_std_io_create_dir(const char *path) {
    if (!path || !*path) return 0;
    if (flux_std_io_dir_exists(path)) return 1;
#if defined(_WIN32)
    return _mkdir(path) == 0 ? 1 : 0;
#else
    return mkdir(path, 0777) == 0 ? 1 : 0;
#endif
}

int64_t flux_std_io_remove_dir(const char *path) {
    if (!path || !*path) return 0;
#if defined(_WIN32)
    return _rmdir(path) == 0 ? 1 : 0;
#else
    return rmdir(path) == 0 ? 1 : 0;
#endif
}

char *flux_std_io_path_base_name(const char *path) {
    if (!path || !*path) return strdup("");
    char *buf = strdup(path);
    for (char *p = buf; *p; p++) if (*p == '\\') *p = '/';
    size_t len = strlen(buf);
    while (len > 1 && buf[len - 1] == '/') buf[--len] = '\0';
    char *slash = strrchr(buf, '/');
    char *res = strdup(slash ? slash + 1 : buf);
    free(buf);
    return res;
}

char *flux_std_io_path_dir_name(const char *path) {
    if (!path || !*path) return strdup("");
    char *buf = strdup(path);
    for (char *p = buf; *p; p++) if (*p == '\\') *p = '/';
    size_t len = strlen(buf);
    while (len > 1 && buf[len - 1] == '/') buf[--len] = '\0';
    char *slash = strrchr(buf, '/');
    char *res;
    if (slash) {
        if (slash == buf) {
            res = strdup("/");
        } else {
            *slash = '\0';
            res = strdup(buf);
        }
    } else {
        res = strdup("");
    }
    free(buf);
    return res;
}

char *flux_std_io_path_extension(const char *path) {
    if (!path || !*path) return strdup("");
    char *base = flux_std_io_path_base_name(path);
    char *dot = strrchr(base, '.');
    char *res = strdup(dot ? dot + 1 : "");
    free(base);
    return res;
}

char *flux_std_io_path_join(const char *dir, const char *file) {
    if (!dir || !*dir) return strdup(file ? file : "");
    if (!file || !*file) return strdup(dir);
    char *d = strdup(dir);
    for (char *p = d; *p; p++) if (*p == '\\') *p = '/';
    size_t dlen = strlen(d);
    while (dlen > 0 && d[dlen - 1] == '/') d[--dlen] = '\0';

    const char *f = file;
    while (*f == '/' || *f == '\\') f++;

    size_t sz = dlen + 1 + strlen(f) + 1;
    char *res = (char *)malloc(sz);
    if (!res) { free(d); return strdup(""); }
    snprintf(res, sz, "%s/%s", d, f);
    free(d);
    return res;
}

void flux_std_io_print_err(const char *text) {
    if (!text) text = "";
    fprintf(stderr, "%s\n", text);
    fflush(stderr);
}

void *flux_std_io_list_dir(const char *path, void *(*build)(int64_t, int64_t), void *(*push)(void*, int64_t, int64_t, const char*)) {
    void *list = build(0, 4);
    if (!path || !*path) return list;
#if defined(_WIN32)
    char search_path[MAX_PATH];
    snprintf(search_path, sizeof(search_path), "%s\\*", path);
    WIN32_FIND_DATAA fd;
    HANDLE h = FindFirstFileA(search_path, &fd);
    if (h != INVALID_HANDLE_VALUE) {
        do {
            if (strcmp(fd.cFileName, ".") != 0 && strcmp(fd.cFileName, "..") != 0) {
                char *copy = strdup(fd.cFileName);
                list = push(list, 4, 0, copy);
            }
        } while (FindNextFileA(h, &fd));
        FindClose(h);
    }
#else
    DIR *d = opendir(path);
    if (d) {
        struct dirent *entry;
        while ((entry = readdir(d)) != NULL) {
            if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
                char *copy = strdup(entry->d_name);
                list = push(list, 4, 0, copy);
            }
        }
        closedir(d);
    }
#endif
    return list;
}
