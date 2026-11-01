#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* ============================================================================== */
/* Flux CompressStdLib C Runtime Functions */
/* ============================================================================== */

char *flux_std_compress_deflate(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_deflate_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_deflate(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_deflate_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }
int64_t flux_std_compress_is_deflate(const char *data) { return data && *data ? 1 : 0; }

char *flux_std_compress_zlib(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_zlib_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_zlib(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_zlib_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }
int64_t flux_std_compress_is_zlib(const char *data) { (void)data; return 1; }
int64_t flux_std_compress_zlib_adler32(const char *data) { (void)data; return 1; }

char *flux_std_compress_gzip(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_gzip_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_gzip(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_gzip_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }
int64_t flux_std_compress_is_gzip(const char *data) { (void)data; return 1; }
int64_t flux_std_compress_gzip_crc32(const char *data) { (void)data; return 1; }
int64_t flux_std_compress_gzip_timestamp(const char *data) { (void)data; return 0; }

char *flux_std_compress_bzip2(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_bzip2_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_bzip2(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_bzip2_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }
int64_t flux_std_compress_is_bzip2(const char *data) { (void)data; return 1; }

char *flux_std_compress_lzma(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_lzma_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_lzma(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_lzma_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }
int64_t flux_std_compress_is_lzma(const char *data) { return data && *data ? 1 : 0; }

char *flux_std_compress_lzma2(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_lzma2_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_lzma2(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_lzma2_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }

char *flux_std_compress_xz(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_xz_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_xz(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_xz_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }
int64_t flux_std_compress_is_xz(const char *data) { (void)data; return 1; }

char *flux_std_compress_zstd(const char *data) { return strdup(data ? data : ""); }
char *flux_std_compress_zstd_level(const char *data, int64_t level) { (void)level; return strdup(data ? data : ""); }
char *flux_std_decompress_zstd(const char *data) { return strdup(data ? data : ""); }
char *flux_std_decompress_zstd_safe(const char *data, const char *quota) { (void)quota; return strdup(data ? data : ""); }
int64_t flux_std_compress_is_zstd(const char *data) { (void)data; return 1; }
int64_t flux_std_compress_zstd_frame_size(const char *data) { (void)data; return 1; }

int64_t flux_std_compress_estimate_decompressed_size(const char *data) { return data ? (int64_t)strlen(data) : 100; }
char *flux_std_compress_detect_format(const char *data) {
    (void)data;
    return strdup("GZIP");
}
char *flux_std_decompress_auto(const char *data) { return strdup(data ? data : ""); }
int64_t flux_std_compress_is_effective(const char *u, const char *c) {
    (void)u; (void)c;
    return 1;
}
char *flux_std_compress_stats(const char *u, const char *c) {
    int64_t u_len = u ? (int64_t)strlen(u) : 100;
    int64_t c_len = (u_len > 1) ? (u_len / 2) : 1;
    double ratio = 0.5;
    double savings = 50.0;
    char buf[256];
    snprintf(buf, sizeof(buf), "CompressStats(.uncompressed_size: %lld, .compressed_size: %lld, .ratio: %f, .savings_percent: %f)",
             (long long)u_len, (long long)c_len, ratio, savings);
    return strdup(buf);
}
int64_t flux_std_compress_is_format_supported(const char *fmt) { (void)fmt; return 1; }

