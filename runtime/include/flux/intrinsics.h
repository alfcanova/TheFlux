/* ==============================================================================
 * TheFlux Native Runtime: Standard Library C Intrinsics
 * Header: runtime/include/flux/intrinsics.h
 * ============================================================================== */

#ifndef FLUX_INTRINSICS_H
#define FLUX_INTRINSICS_H

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* SimdStdLib */
double flux_std_simd_dot_f64(const double *a, const double *b, int64_t n);
void flux_std_simd_add_f64(const double *a, const double *b, double *out, int64_t n);
void flux_std_simd_mul_f64(const double *a, const double *b, double *out, int64_t n);

/* CompressStdLib */
char *flux_std_compress_deflate(const char *data);
char *flux_std_decompress_deflate(const char *data);

/* Archive / Tar / Zip */
int64_t flux_std_archive_extract(const char *archive_path, const char *dest_dir);
int64_t flux_std_archive_create(const char *archive_path, const char *src_dir);

/* DbStdLib */
void *flux_std_db_connect(const char *conn_str);
int64_t flux_std_db_execute(void *conn, const char *sql);
void *flux_std_db_query(void *conn, const char *sql);
void flux_std_db_disconnect(void *conn);

/* NetStdLib */
int64_t flux_std_net_socket_create(int64_t domain, int64_t type, int64_t protocol);
int64_t flux_std_net_socket_connect(int64_t fd, const char *host, int64_t port);
int64_t flux_std_net_socket_send(int64_t fd, const char *buf, int64_t len);
int64_t flux_std_net_socket_recv(int64_t fd, char *buf, int64_t max_len);
void flux_std_net_socket_close(int64_t fd);

/* DslStdLib & GfxStdLib */
void *flux_std_dsl_create(void);
int64_t flux_std_gfx_window_create(int64_t w, int64_t h, const char *title);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_INTRINSICS_H */
