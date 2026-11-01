/* ==============================================================================
 * TheFlux Native Runtime: Console I/O & Interactive Typed Stdin
 * Source: runtime/src/io/console.c
 * ============================================================================== */

#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <math.h>

#if defined(_WIN32)
#include <windows.h>
static int timegm_compat(struct tm *tm) {
    return _mkgmtime(tm);
}
#else
#include <unistd.h>
#define timegm_compat timegm
#endif

#define LINE_BUF 65536

static const char ANSI_GRAY[] = "\x1b[90m";
static const char ANSI_RESET[] = "\x1b[0m";

static int is_int_type(const char *t) { return strncmp(t, "int", 3) == 0; }
static int is_uint_type(const char *t) { return strncmp(t, "uint", 4) == 0; }
static int is_float_type(const char *t) {
    return strncmp(t, "float", 5) == 0
        || strncmp(t, "fp8", 3) == 0
        || strcmp(t, "bf16_e8m7") == 0
        || strcmp(t, "tf32_e8m10") == 0;
}
static int is_complex_type(const char *t) { return strncmp(t, "complex", 7) == 0; }

static void gray(const char *msg) {
    printf("%s%s%s\n", ANSI_GRAY, msg, ANSI_RESET);
    fflush(stdout);
}

static const char *type_retry_message(const char *t) {
    if (is_int_type(t) || is_uint_type(t)) return "Digite um inteiro, como: 35";
    if (is_float_type(t)) return "Digite um float, como: 19.99";
    if (is_complex_type(t)) return "Digite um complexo, como: 3+4i";
    if (strcmp(t, "char") == 0) return "Digite um caractere, como: a";
    if (strcmp(t, "bool") == 0) return "Digite um bool, como: true/false";
    if (strcmp(t, "datetime") == 0) return "Digite um date, como: 2026-08-29T12:00:00Z";
    return "Digite um texto, como: Olá mundo";
}

static void retry(const char *t) {
    gray(type_retry_message(t));
}

static int parse_signed(const char *line, int64_t *out) {
    char *end = NULL;
    long long v = strtoll(line, &end, 0);
    if (end == line) return 0;
    while (*end == ' ' || *end == '\t' || *end == '\r' || *end == '\n') end++;
    if (*end != '\0') return 0;
    *out = (int64_t)v;
    return 1;
}

static int parse_unsigned(const char *line, uint64_t *out) {
    char *end = NULL;
    unsigned long long v = strtoull(line, &end, 0);
    if (end == line) return 0;
    while (*end == ' ' || *end == '\t' || *end == '\r' || *end == '\n') end++;
    if (*end != '\0') return 0;
    *out = (uint64_t)v;
    return 1;
}

static int int_in_range(const char *t, int64_t v) {
    if (strcmp(t, "int8") == 0) return v >= -128 && v <= 127;
    if (strcmp(t, "int16") == 0) return v >= -32768 && v <= 32767;
    if (strcmp(t, "int32") == 0) return v >= -2147483648LL && v <= 2147483647LL;
    if (strcmp(t, "uint8") == 0) return v >= 0 && v <= 255;
    if (strcmp(t, "uint16") == 0) return v >= 0 && v <= 65535;
    if (strcmp(t, "uint32") == 0) return v >= 0 && v <= 4294967295LL;
    return 1;
}

static int parse_double(const char *line, double *out) {
    char buf[LINE_BUF];
    strncpy(buf, line, sizeof(buf) - 1);
    buf[sizeof(buf) - 1] = '\0';
    for (char *p = buf; *p; p++) {
        if (*p == ',') *p = '.';
    }
    char *end = NULL;
    double v = strtod(buf, &end);
    if (end == buf) return 0;
    while (*end == ' ' || *end == '\t' || *end == '\r' || *end == '\n') end++;
    if (*end != '\0') return 0;
    *out = v;
    return 1;
}

static int parse_complex(const char *line, double *re, double *im) {
    char buf[LINE_BUF];
    size_t idx = 0;
    for (const char *p = line; *p && idx < sizeof(buf) - 1; p++) {
        if (*p != ' ' && *p != '\t' && *p != '\r' && *p != '\n') {
            buf[idx++] = (*p == ',') ? '.' : *p;
        }
    }
    buf[idx] = '\0';
    if (idx == 0) return 0;

    if (strcmp(buf, "i") == 0 || strcmp(buf, "+i") == 0 || strcmp(buf, "j") == 0 || strcmp(buf, "+j") == 0) {
        *re = 0.0; *im = 1.0; return 1;
    }
    if (strcmp(buf, "-i") == 0 || strcmp(buf, "-j") == 0) {
        *re = 0.0; *im = -1.0; return 1;
    }

    char *end = NULL;
    double a = strtod(buf, &end);
    if (end == buf) return 0;
    if (*end == '\0') {
        *re = a; *im = 0.0; return 1;
    }
    if (strcmp(end, "i") == 0 || strcmp(end, "j") == 0 || strcmp(end, "I") == 0 || strcmp(end, "J") == 0) {
        *re = 0.0; *im = a; return 1;
    }
    if (*end == '+' || *end == '-') {
        char sign = *end;
        char *end2 = NULL;
        double b = strtod(end + 1, &end2);
        if (end2 == end + 1) {
            if (strcmp(end + 1, "i") == 0 || strcmp(end + 1, "j") == 0) {
                b = 1.0;
                end2 = end + 2;
            } else {
                return 0;
            }
        }
        if (strcmp(end2, "i") == 0 || strcmp(end2, "j") == 0 || strcmp(end2, "I") == 0 || strcmp(end2, "J") == 0) {
            *re = a;
            *im = (sign == '-') ? -b : b;
            return 1;
        }
    }
    return 0;
}

void flux_runtime_input(const char *prompt, const char *type, void *out) {
    char line[LINE_BUF];
    int first = 1;
    while (1) {
        if (prompt && *prompt && first) {
            printf("%s", prompt);
            fflush(stdout);
        }
        first = 0;
        if (!fgets(line, sizeof(line), stdin)) {
            line[0] = '\0';
        }
        if (is_int_type(type)) {
            int64_t v;
            if (parse_signed(line, &v) && int_in_range(type, v)) {
                if (strcmp(type, "int8") == 0) { *(int8_t *)out = (int8_t)v; return; }
                if (strcmp(type, "int16") == 0) { *(int16_t *)out = (int16_t)v; return; }
                if (strcmp(type, "int32") == 0) { *(int32_t *)out = (int32_t)v; return; }
                *(int64_t *)out = v;
                return;
            }
        } else if (is_uint_type(type)) {
            uint64_t v;
            if (parse_unsigned(line, &v) && int_in_range(type, (int64_t)v)) {
                if (strcmp(type, "uint8") == 0) { *(uint8_t *)out = (uint8_t)v; return; }
                if (strcmp(type, "uint16") == 0) { *(uint16_t *)out = (uint16_t)v; return; }
                if (strcmp(type, "uint32") == 0) { *(uint32_t *)out = (uint32_t)v; return; }
                *(uint64_t *)out = v;
                return;
            }
        } else if (is_float_type(type)) {
            double d;
            if (parse_double(line, &d)) {
                if (strcmp(type, "float32") == 0) { *(float *)out = (float)d; return; }
                *(double *)out = d;
                return;
            }
        } else if (is_complex_type(type)) {
            double re, im;
            if (parse_complex(line, &re, &im)) {
                double *c = (double *)out;
                c[0] = re; c[1] = im;
                return;
            }
        } else if (strcmp(type, "char") == 0) {
            size_t n = strlen(line);
            while (n > 0 && (line[n - 1] == '\n' || line[n - 1] == '\r')) line[--n] = '\0';
            const unsigned char *b = (const unsigned char *)line;
            if (n == 1 && b[0] < 0x80) {
                *(int *)out = (int)b[0];
                return;
            } else if (n == 2 && (b[0] & 0xE0) == 0xC0 && (b[1] & 0xC0) == 0x80) {
                int cp = ((b[0] & 0x1F) << 6) | (b[1] & 0x3F);
                if (cp >= 0x80) { *(int *)out = cp; return; }
            } else if (n == 3 && (b[0] & 0xF0) == 0xE0 && (b[1] & 0xC0) == 0x80 && (b[2] & 0xC0) == 0x80) {
                int cp = ((b[0] & 0x0F) << 12) | ((b[1] & 0x3F) << 6) | (b[2] & 0x3F);
                if (cp >= 0x800 && (cp < 0xD800 || cp > 0xDFFF)) { *(int *)out = cp; return; }
            } else if (n == 4 && (b[0] & 0xF8) == 0xF0 && (b[1] & 0xC0) == 0x80 && (b[2] & 0xC0) == 0x80 && (b[3] & 0xC0) == 0x80) {
                int cp = ((b[0] & 0x07) << 18) | ((b[1] & 0x3F) << 12) | ((b[2] & 0x3F) << 6) | (b[3] & 0x3F);
                if (cp >= 0x10000 && cp <= 0x10FFFF) { *(int *)out = cp; return; }
            }
        } else if (strcmp(type, "bool") == 0) {
            size_t n = strlen(line);
            while (n > 0 && (line[n - 1] == '\n' || line[n - 1] == '\r')) line[--n] = '\0';
            if (strcmp(line, "true") == 0 || strcmp(line, "verdadeiro") == 0) { *(char *)out = 1; return; }
            if (strcmp(line, "false") == 0 || strcmp(line, "falso") == 0) { *(char *)out = 0; return; }
        } else if (strcmp(type, "datetime") == 0) {
            int y, mo, d, h, mi, s;
            if (sscanf(line, "%d-%d-%dT%d:%d:%d", &y, &mo, &d, &h, &mi, &s) == 6) {
                struct tm tmv;
                memset(&tmv, 0, sizeof(tmv));
                tmv.tm_year = y - 1900; tmv.tm_mon = mo - 1; tmv.tm_mday = d;
                tmv.tm_hour = h; tmv.tm_min = mi; tmv.tm_sec = s;
                time_t tt = timegm_compat(&tmv);
                if (tt != (time_t)-1) {
                    *(int64_t *)out = (int64_t)tt * 1000000000LL;
                    return;
                }
            }
        } else {
            size_t n = strlen(line);
            while (n > 0 && (line[n - 1] == '\n' || line[n - 1] == '\r')) line[--n] = '\0';
            char *copy = (char *)malloc(strlen(line) + 1);
            if (copy) { strcpy(copy, line); *(char **)out = copy; }
            return;
        }
        retry(type);
    }
}

int64_t flux_runtime_input_i64(const char *prompt, const char *type_name) {
    int64_t v = 0;
    flux_runtime_input(prompt, type_name ? type_name : "int64", &v);
    return v;
}

double flux_runtime_input_f64(const char *prompt, const char *type_name) {
    double v = 0;
    flux_runtime_input(prompt, type_name ? type_name : "float64", &v);
    return v;
}

float flux_runtime_input_f32(const char *prompt, const char *type_name) {
    float v = 0;
    flux_runtime_input(prompt, type_name ? type_name : "float32", &v);
    return v;
}

int32_t flux_runtime_input_i32(const char *prompt, const char *type_name) {
    int32_t v = 0;
    flux_runtime_input(prompt, type_name ? type_name : "int32", &v);
    return v;
}

bool flux_runtime_input_bool(const char *prompt, const char *type_name) {
    char v = 0;
    flux_runtime_input(prompt, type_name ? type_name : "bool", &v);
    return v != 0;
}

char flux_runtime_input_char(const char *prompt, const char *type_name) {
    int v = 0;
    flux_runtime_input(prompt, type_name ? type_name : "char", &v);
    return (char)v;
}

char *flux_runtime_input_string(const char *prompt, const char *type_name) {
    char *v = NULL;
    flux_runtime_input(prompt, type_name ? type_name : "string", &v);
    return v ? v : strdup("");
}

void flux_runtime_input_complex(const char *prompt, const char *type_name, double *re, double *im) {
    double c[2] = {0.0, 0.0};
    flux_runtime_input(prompt, type_name ? type_name : "complex", c);
    if (re) *re = c[0];
    if (im) *im = c[1];
}

char *flux_runtime_input_datetime(const char *prompt, const char *type_name) {
    int64_t ns = 0;
    flux_runtime_input(prompt, type_name ? type_name : "datetime", &ns);
    return flux_std_datetime_to_iso8601(ns / 1000000000LL);
}
