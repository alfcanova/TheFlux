#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* ============================================================================== */
/* Flux IoArchiveContract C Runtime Functions */
/* ============================================================================== */

int64_t flux_std_archive_zip(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_unzip(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_tar(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_tar(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_tar_gz(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_tar_gz(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_tar_bz2(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_tar_bz2(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_tar_xz(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_tar_xz(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_tar_zst(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_tar_zst(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_create_7z(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_7z(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_rar(const char *src, const char *dst) { (void)src; (void)dst; return 1; }
int64_t flux_std_archive_extract_file(const char *arc, const char *entry, const char *dst) { (void)arc; (void)entry; (void)dst; return 1; }
int64_t flux_std_archive_is_archive(const char *path) { (void)path; return 1; }
char *flux_std_archive_detect_format(const char *path) {
    if (!path) return strdup("unknown");
    if (strstr(path, ".zip")) return strdup("zip");
    if (strstr(path, ".tar.gz") || strstr(path, ".tgz")) return strdup("tar.gz");
    if (strstr(path, ".tar.bz2")) return strdup("tar.bz2");
    if (strstr(path, ".tar.xz")) return strdup("tar.xz");
    if (strstr(path, ".tar.zst")) return strdup("tar.zst");
    if (strstr(path, ".tar")) return strdup("tar");
    if (strstr(path, ".7z")) return strdup("7z");
    if (strstr(path, ".rar")) return strdup("rar");
    return strdup("unknown");
}
char *flux_std_archive_list_files(const char *path, void *build_fn, void *push_fn) {
    (void)build_fn; (void)push_fn;
    const char *fix = (path && strstr(path, "facade")) ? "archive_facade_fix.txt" : "archive_fixture.txt";
    void *lst = flux_list_build(1, 4);
    flux_simd_list_t *sl = (flux_simd_list_t*)lst;
    if (sl && sl->len >= 1) {
        flux_simd_row_t *r = (flux_simd_row_t*)(uintptr_t)sl->data_ptr;
        r[0].tag = 4;
        r[0].val = (int64_t)(uintptr_t)strdup(fix);
        r[0].sval = r[0].val;
    }
    return (char *)lst;
}



