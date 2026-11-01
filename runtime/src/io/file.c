/* ==============================================================================
 * TheFlux Native Runtime: Universal File Operations
 * Source: runtime/src/io/file.c
 * ============================================================================== */

#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *flux_std_io_read_file(const char *path) {
    if (!path || !*path) return strdup("");
    FILE *f = fopen(path, "rb");
    if (!f) return strdup("");
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (sz < 0) { fclose(f); return strdup(""); }
    char *buf = (char *)malloc(sz + 1);
    if (!buf) { fclose(f); return strdup(""); }
    size_t read_bytes = fread(buf, 1, sz, f);
    buf[read_bytes] = '\0';
    fclose(f);
    return buf;
}

char *flux_std_io_write_file(const char *path, const char *content) {
    if (!path) return strdup("");
    if (!content) content = "";
    FILE *f = fopen(path, "wb");
    if (f) {
        fputs(content, f);
        fclose(f);
    }
    return strdup(content);
}

char *flux_std_io_append_file(const char *path, const char *content) {
    if (!path) return strdup("");
    if (!content) content = "";
    FILE *f = fopen(path, "ab");
    if (f) {
        fputs(content, f);
        fclose(f);
    }
    return strdup(content);
}

int64_t flux_std_io_delete_file(const char *path) {
    if (!path || !*path) return 0;
    return remove(path) == 0 ? 1 : 0;
}

int64_t flux_std_io_copy_file(const char *src, const char *dst) {
    if (!src || !dst) return 0;
    FILE *in = fopen(src, "rb");
    if (!in) return 0;
    FILE *out = fopen(dst, "wb");
    if (!out) { fclose(in); return 0; }
    char buf[8192];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), in)) > 0) {
        if (fwrite(buf, 1, n, out) != n) {
            fclose(in); fclose(out); return 0;
        }
    }
    fclose(in);
    fclose(out);
    return 1;
}

int64_t flux_std_io_move_file(const char *src, const char *dst) {
    if (!src || !dst) return 0;
    if (rename(src, dst) == 0) return 1;
    if (flux_std_io_copy_file(src, dst)) {
        remove(src);
        return 1;
    }
    return 0;
}

int64_t flux_std_io_file_exists(const char *path) {
    if (!path || !*path) return 0;
    FILE *f = fopen(path, "rb");
    if (f) { fclose(f); return 1; }
    return 0;
}

int64_t flux_std_io_file_size(const char *path) {
    if (!path || !*path) return 0;
    FILE *f = fopen(path, "rb");
    if (!f) return 0;
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fclose(f);
    return sz > 0 ? (int64_t)sz : 0;
}

void *flux_std_io_read_lines(const char *path, void *(*build)(int64_t, int64_t), void *(*push)(void*, int64_t, int64_t, const char*)) {
    void *list = build(0, 4);
    if (!path || !*path) return list;
    FILE *f = fopen(path, "r");
    if (!f) return list;
    char line[65536];
    while (fgets(line, sizeof(line), f)) {
        size_t n = strlen(line);
        while (n > 0 && (line[n - 1] == '\r' || line[n - 1] == '\n')) {
            line[--n] = '\0';
        }
        char *copy = strdup(line);
        list = push(list, 4, 0, copy);
    }
    fclose(f);
    return list;
}

char *flux_std_io_write_lines_helper(const char *path, void *list, int64_t (*get_len)(void*), void *(*get_data)(void*), const char *(*get_sval)(void*, int64_t), int append) {
    if (!path) return strdup("");
    FILE *f = fopen(path, append ? "ab" : "wb");
    if (!f) return strdup("");
    int64_t n = get_len ? get_len(list) : 0;
    void *ldata = get_data ? get_data(list) : list;
    size_t total_sz = 1;
    for (int64_t i = 1; i <= n; i++) {
        const char *s = get_sval ? get_sval(ldata, i) : "";
        if (s) total_sz += strlen(s);
        total_sz += 1;
    }
    char *out_buf = (char *)malloc(total_sz);
    if (out_buf) out_buf[0] = '\0';
    for (int64_t i = 1; i <= n; i++) {
        const char *s = get_sval ? get_sval(ldata, i) : "";
        if (s) {
            fputs(s, f);
            if (out_buf) strcat(out_buf, s);
        }
        fputc('\n', f);
        if (out_buf) strcat(out_buf, "\n");
    }
    fclose(f);
    return out_buf ? out_buf : strdup("");
}

char *flux_std_io_read_binary_file(const char *path) {
    if (!path || !*path) return strdup("");
    FILE *f = fopen(path, "rb");
    if (!f) return strdup("");
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (sz < 0) { fclose(f); return strdup(""); }
    char *buf = (char *)malloc(sz + 1);
    if (!buf) { fclose(f); return strdup(""); }
    size_t n = fread(buf, 1, sz, f);
    buf[n] = '\0';
    fclose(f);
    return buf;
}

char *flux_std_io_write_binary_file(const char *path, const char *content) {
    if (!path || !*path) return strdup("");
    if (!content) content = "";
    FILE *f = fopen(path, "wb");
    if (f) {
        size_t len = strlen(content);
        fwrite(content, 1, len, f);
        fclose(f);
    }
    return strdup(content);
}

char *flux_std_io_read_hex_file(const char *path) {
    if (!path || !*path) return strdup("");
    FILE *f = fopen(path, "rb");
    if (!f) return strdup("");
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (sz < 0) { fclose(f); return strdup(""); }
    unsigned char *raw = (unsigned char *)malloc(sz);
    if (!raw) { fclose(f); return strdup(""); }
    size_t n = fread(raw, 1, sz, f);
    fclose(f);
    char *hex = (char *)malloc(n * 2 + 1);
    if (!hex) { free(raw); return strdup(""); }
    static const char hex_chars[] = "0123456789abcdef";
    for (size_t i = 0; i < n; i++) {
        hex[i * 2]     = hex_chars[(raw[i] >> 4) & 0x0F];
        hex[i * 2 + 1] = hex_chars[raw[i] & 0x0F];
    }
    hex[n * 2] = '\0';
    free(raw);
    return hex;
}

char *flux_std_io_write_hex_file(const char *path, const char *hex_content) {
    if (!path || !*path) return strdup("");
    if (!hex_content) hex_content = "";
    size_t hlen = strlen(hex_content);
    size_t out_len = hlen / 2;
    unsigned char *raw = (unsigned char *)malloc(out_len + 1);
    if (!raw) return strdup("");
    for (size_t i = 0; i < out_len; i++) {
        unsigned int byte_val = 0;
        sscanf(hex_content + i * 2, "%2x", &byte_val);
        raw[i] = (unsigned char)byte_val;
    }
    FILE *f = fopen(path, "wb");
    if (f) {
        fwrite(raw, 1, out_len, f);
        fclose(f);
    }
    free(raw);
    return strdup(hex_content);
}

static const char _b64_table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

char *flux_std_io_read_base64_file(const char *path) {
    if (!path || !*path) return strdup("");
    FILE *f = fopen(path, "rb");
    if (!f) return strdup("");
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (sz < 0) { fclose(f); return strdup(""); }
    unsigned char *raw = (unsigned char *)malloc(sz);
    if (!raw) { fclose(f); return strdup(""); }
    size_t n = fread(raw, 1, sz, f);
    fclose(f);

    size_t out_len = 4 * ((n + 2) / 3);
    char *out = (char *)malloc(out_len + 1);
    if (!out) { free(raw); return strdup(""); }
    size_t j = 0;
    for (size_t i = 0; i < n; i += 3) {
        size_t rem = n - i;
        uint32_t oct_a = raw[i];
        uint32_t oct_b = (rem > 1) ? raw[i + 1] : 0;
        uint32_t oct_c = (rem > 2) ? raw[i + 2] : 0;
        uint32_t triple = (oct_a << 16) + (oct_b << 8) + oct_c;
        out[j++] = _b64_table[(triple >> 18) & 0x3F];
        out[j++] = _b64_table[(triple >> 12) & 0x3F];
        out[j++] = (rem < 2) ? '=' : _b64_table[(triple >> 6) & 0x3F];
        out[j++] = (rem < 3) ? '=' : _b64_table[triple & 0x3F];
    }
    out[j] = '\0';
    free(raw);
    return out;
}

char *flux_std_io_write_base64_file(const char *path, const char *b64_content) {
    if (!path || !*path) return strdup("");
    if (!b64_content) b64_content = "";
    size_t in_len = strlen(b64_content);
    if (in_len % 4 != 0) return strdup("");
    size_t out_len = in_len / 4 * 3;
    if (in_len > 0 && b64_content[in_len - 1] == '=') out_len--;
    if (in_len > 1 && b64_content[in_len - 2] == '=') out_len--;
    unsigned char *raw = (unsigned char *)malloc(out_len + 1);
    if (!raw) return strdup("");

    int d_table[256];
    for (int i = 0; i < 256; i++) d_table[i] = -1;
    for (int i = 0; i < 64; i++) d_table[(unsigned char)_b64_table[i]] = i;

    size_t j = 0;
    for (size_t i = 0; i < in_len;) {
        int a = b64_content[i] == '=' ? 0 : d_table[(unsigned char)b64_content[i]]; i++;
        int b = b64_content[i] == '=' ? 0 : d_table[(unsigned char)b64_content[i]]; i++;
        int c = b64_content[i] == '=' ? 0 : d_table[(unsigned char)b64_content[i]]; i++;
        int d = b64_content[i] == '=' ? 0 : d_table[(unsigned char)b64_content[i]]; i++;
        uint32_t triple = (a << 18) + (b << 12) + (c << 6) + d;
        if (j < out_len) raw[j++] = (triple >> 16) & 0xFF;
        if (j < out_len) raw[j++] = (triple >> 8) & 0xFF;
        if (j < out_len) raw[j++] = triple & 0xFF;
    }
    FILE *f = fopen(path, "wb");
    if (f) {
        fwrite(raw, 1, out_len, f);
        fclose(f);
    }
    free(raw);
    return strdup(b64_content);
}
