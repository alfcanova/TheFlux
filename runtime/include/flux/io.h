/* ==============================================================================
 * TheFlux Native Runtime: Universal I/O Subsystem
 * Header: runtime/include/flux/io.h
 * ============================================================================== */

#ifndef FLUX_IO_H
#define FLUX_IO_H

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Typed Console Input (Re-prompt on format mismatch) */
void flux_runtime_input(const char *prompt, const char *type_name, void *out);
int64_t flux_runtime_input_i64(const char *prompt, const char *type_name);
double flux_runtime_input_f64(const char *prompt, const char *type_name);
float flux_runtime_input_f32(const char *prompt, const char *type_name);
int32_t flux_runtime_input_i32(const char *prompt, const char *type_name);
bool flux_runtime_input_bool(const char *prompt, const char *type_name);
char flux_runtime_input_char(const char *prompt, const char *type_name);
char *flux_runtime_input_string(const char *prompt, const char *type_name);
void flux_runtime_input_complex(const char *prompt, const char *type_name, double *re, double *im);
char *flux_runtime_input_datetime(const char *prompt, const char *type_name);

/* File Operations */
char *flux_std_io_read_file(const char *path);
char *flux_std_io_write_file(const char *path, const char *content);
char *flux_std_io_append_file(const char *path, const char *content);
int64_t flux_std_io_delete_file(const char *path);
int64_t flux_std_io_copy_file(const char *src, const char *dst);
int64_t flux_std_io_move_file(const char *src, const char *dst);
int64_t flux_std_io_file_exists(const char *path);
int64_t flux_std_io_file_size(const char *path);

/* Directory Operations */
int64_t flux_std_io_dir_exists(const char *path);
int64_t flux_std_io_create_dir(const char *path);
int64_t flux_std_io_remove_dir(const char *path);
void *flux_std_io_list_dir(const char *path, void *(*build)(int64_t, int64_t), void *(*push)(void*, int64_t, int64_t, const char*));

/* Path Helpers */
char *flux_std_io_path_base_name(const char *path);
char *flux_std_io_path_dir_name(const char *path);
char *flux_std_io_path_extension(const char *path);
char *flux_std_io_path_join(const char *dir, const char *file);
void flux_std_io_print_err(const char *text);

/* Binary / Hex / Base64 File I/O */
char *flux_std_io_read_binary_file(const char *path);
char *flux_std_io_write_binary_file(const char *path, const char *content);
char *flux_std_io_read_hex_file(const char *path);
char *flux_std_io_write_hex_file(const char *path, const char *hex_content);
char *flux_std_io_read_base64_file(const char *path);
char *flux_std_io_write_base64_file(const char *path, const char *b64_content);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_IO_H */
