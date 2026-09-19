/* TheFlux LLVM runtime: typed stdin input with type re-prompt.
 *
 * Mirrors the behaviour documented in docs/keywords/KW_input.yaml:
 *   - reads a line from stdin after an optional prompt
 *   - validates the value against the declared Flux type (after Enter)
 *   - on mismatch, re-prompts and writes "Digite um <tipo>" in gray
 *
 * The `out` pointer must be cast to the slot of the declared Flux storage
 * type (i64 / double / float / i32 / i1 / i8* / { double, double }).
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <math.h>
#include <sys/stat.h>

#if defined(_WIN32)
#include <windows.h>
#include <direct.h>
#include <tlhelp32.h>
#include <process.h>
static int timegm(struct tm *tm);
#else
#include <unistd.h>
#include <dirent.h>
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
    /* forms: "a", "a+bi", "a-bi", "bi", "i", "-i", with optional 'j'/'i' suffix and commas/spaces */
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
        char *nump = end + 1;
        if (strcmp(nump, "i") == 0 || strcmp(nump, "j") == 0 || strcmp(nump, "I") == 0 || strcmp(nump, "J") == 0) {
            *re = a; *im = (sign == '-') ? -1.0 : 1.0; return 1;
        }
        char *end2 = NULL;
        double b = strtod(nump, &end2);
        if (end2 == nump) return 0;
        if (*end2 != 'i' && *end2 != 'j' && *end2 != 'I' && *end2 != 'J') return 0;
        if (*(end2 + 1) != '\0') return 0;
        if (sign == '-') b = -b;
        *re = a; *im = b; return 1;
    }
    return 0;
}

void flux_input(const char *prompt, const char *type, void *out) {
    char line[LINE_BUF];
    while (1) {
        if (prompt) { fputs(prompt, stdout); fflush(stdout); }
        if (fgets(line, sizeof(line), stdin) == NULL) line[0] = '\0';

        if (is_int_type(type) || is_uint_type(type)) {
            int64_t v;
            if (parse_signed(line, &v) && int_in_range(type, v) && !is_uint_type(type)) {
                *(int64_t *)out = v;
                return;
            }
            if (is_uint_type(type) && strcmp(type, "int8") != 0 && strcmp(type, "int16") != 0 &&
                strcmp(type, "int32") != 0) {
                uint64_t u;
                if (parse_unsigned(line, &u)) {
                    /* confirm no minus sign */
                    const char *p = line;
                    while (*p == ' ' || *p == '\t') p++;
                    if (*p != '-') { *(uint64_t *)out = u; return; }
                }
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
            /* simplified ISO 8601 -> nanoseconds since epoch (UTC) */
            int y, mo, d, h, mi, s;
            double frac = 0.0;
            if (sscanf(line, "%d-%d-%dT%d:%d:%d", &y, &mo, &d, &h, &mi, &s) == 6) {
                struct tm tmv;
                memset(&tmv, 0, sizeof(tmv));
                tmv.tm_year = y - 1900; tmv.tm_mon = mo - 1; tmv.tm_mday = d;
                tmv.tm_hour = h; tmv.tm_min = mi; tmv.tm_sec = s;
                time_t tt = timegm(&tmv);
                if (tt != (time_t)-1) {
                    *(int64_t *)out = (int64_t)tt * 1000000000LL;
                    return;
                }
            }
            (void)frac;
        } else {
            /* string and any other type: accept as-is, strip trailing newline */
            size_t n = strlen(line);
            while (n > 0 && (line[n - 1] == '\n' || line[n - 1] == '\r')) line[--n] = '\0';
            char *copy = (char *)malloc(strlen(line) + 1);
            if (copy) { strcpy(copy, line); *(char **)out = copy; }
            return;
        }
        retry(type);
    }
}

#if defined(_WIN32)
static int timegm(struct tm *tm) {
    return _mkgmtime(tm);
}
#endif

typedef unsigned __int128 u128;
typedef __int128 i128;

static u128 _udivmod128(u128 n, u128 d, u128 *rem) {
    if (d == 0) {
        if (rem) *rem = 0;
        return 0;
    }
    u128 q = 0;
    u128 r = 0;
    for (int i = 127; i >= 0; i--) {
        r = (r << 1) | ((n >> i) & 1);
        if (r >= d) {
            r -= d;
            q |= ((u128)1 << i);
        }
    }
    if (rem) *rem = r;
    return q;
}

i128 __divti3(i128 a, i128 b) {
    int neg = 0;
    u128 ua = (u128)a;
    u128 ub = (u128)b;
    if (a < 0) { ua = (u128)(-a); neg = !neg; }
    if (b < 0) { ub = (u128)(-b); neg = !neg; }
    u128 uq = _udivmod128(ua, ub, NULL);
    return neg ? -(i128)uq : (i128)uq;
}

i128 __modti3(i128 a, i128 b) {
    int neg = 0;
    u128 ua = (u128)a;
    u128 ub = (u128)b;
    if (a < 0) { ua = (u128)(-a); neg = 1; }
    if (b < 0) { ub = (u128)(-b); }
    u128 ur = 0;
    _udivmod128(ua, ub, &ur);
    return neg ? -(i128)ur : (i128)ur;
}

u128 __udivti3(u128 a, u128 b) {
    return _udivmod128(a, b, NULL);
}

u128 __umodti3(u128 a, u128 b) {
    u128 rem = 0;
    _udivmod128(a, b, &rem);
    return rem;
}

u128 __udivmodti4(u128 a, u128 b, u128 *rem) {
    return _udivmod128(a, b, rem);
}

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

/* =========================================================================
 * DateTimeStdLib C Runtime Implementation
 * ========================================================================= */

static inline void _civil_from_days_c(int64_t days, int64_t *year, int64_t *month, int64_t *day) {
    int64_t z = days + 719468;
    int64_t era = (z >= 0 ? z : z - 146096) / 146097;
    int64_t doe = z - era * 146097;
    int64_t yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
    int64_t y = yoe + era * 400;
    int64_t doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
    int64_t mp = (5 * doy + 2) / 153;
    int64_t d = doy - (153 * mp + 2) / 5 + 1;
    int64_t m = mp < 10 ? mp + 3 : mp - 9;
    *year = m <= 2 ? y + 1 : y;
    *month = m;
    *day = d;
}

static inline int64_t _days_from_civil_c(int64_t year, int64_t month, int64_t day) {
    int64_t y = month <= 2 ? year - 1 : year;
    int64_t era = (y >= 0 ? y : y - 399) / 400;
    int64_t yoe = y - era * 400;
    int64_t m_prime = month <= 2 ? month + 9 : month - 3;
    int64_t doy = (153 * m_prime + 2) / 5 + day - 1;
    int64_t doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
    return era * 146097 + doe - 719468;
}

static inline int _is_leap_year_c(int64_t y) {
    return (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0)) ? 1 : 0;
}

static inline int64_t _days_in_month_c(int64_t y, int64_t m) {
    if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) return 31;
    if (m == 4 || m == 6 || m == 9 || m == 11) return 30;
    if (m == 2) return _is_leap_year_c(y) ? 29 : 28;
    return 30;
}

static inline void _split_nanos_c(int64_t nanos, int64_t *y, int64_t *m, int64_t *d, int64_t *h, int64_t *mi, int64_t *s, int64_t *frac) {
    int64_t sec = nanos / 1000000000LL;
    int64_t f = nanos % 1000000000LL;
    if (f < 0) { f += 1000000000LL; sec--; }
    int64_t days = sec / 86400;
    int64_t rem_sec = sec % 86400;
    if (rem_sec < 0) { rem_sec += 86400; days--; }
    *h = rem_sec / 3600;
    *mi = (rem_sec % 3600) / 60;
    *s = rem_sec % 60;
    *frac = f;
    _civil_from_days_c(days, y, m, d);
}

int64_t flux_std_datetime_now(void) {
#if defined(_WIN32)
    FILETIME ft;
    GetSystemTimeAsFileTime(&ft);
    ULARGE_INTEGER uli;
    uli.LowPart = ft.dwLowDateTime;
    uli.HighPart = ft.dwHighDateTime;
    int64_t epoch_diff = 116444736000000000ULL;
    return (int64_t)(uli.QuadPart - epoch_diff) * 100LL;
#else
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    return (int64_t)ts.tv_sec * 1000000000LL + ts.tv_nsec;
#endif
}

int64_t flux_std_datetime_monotonic_now(void) {
#if defined(_WIN32)
    LARGE_INTEGER count, freq;
    QueryPerformanceCounter(&count);
    QueryPerformanceFrequency(&freq);
    return (int64_t)((count.QuadPart * 1000000000ULL) / freq.QuadPart);
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000LL + ts.tv_nsec;
#endif
}

int64_t flux_std_datetime_monotonic_elapsed(int64_t start_ns) {
    return flux_std_datetime_monotonic_now() - start_ns;
}

int64_t flux_std_datetime_today(void) {
    int64_t now = flux_std_datetime_now();
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(now, &y, &m, &d, &h, &mi, &s, &frac);
    return _days_from_civil_c(y, m, d) * 86400000000000LL;
}

int64_t flux_std_datetime_time(void) {
    int64_t now = flux_std_datetime_now();
    int64_t sec = now / 1000000000LL;
    int64_t frac = now % 1000000000LL;
    int64_t rem_sec = sec % 86400;
    return rem_sec * 1000000000LL + frac;
}

int64_t flux_std_datetime_create_date(int64_t y, int64_t m, int64_t d) {
    return _days_from_civil_c(y, m, d) * 86400000000000LL;
}

int64_t flux_std_datetime_create_time(int64_t h, int64_t m, int64_t s) {
    return (h * 3600 + m * 60 + s) * 1000000000LL;
}

int64_t flux_std_datetime_create_time_full(int64_t h, int64_t m, int64_t s, int64_t ms, int64_t us, int64_t ns) {
    return (h * 3600 + m * 60 + s) * 1000000000LL + ms * 1000000LL + us * 1000LL + ns;
}

int64_t flux_std_datetime_parse_iso(const char *text) {
    if (!text || !*text) return 0;
    int64_t y = 0, mo = 1, d = 1, h = 0, mi = 0, s = 0, frac = 0;
    const char *p = text;
    y = strtoll(p, (char**)&p, 10);
    if (*p == '-') p++;
    mo = strtoll(p, (char**)&p, 10);
    if (*p == '-') p++;
    d = strtoll(p, (char**)&p, 10);
    if (*p == 'T' || *p == ' ') p++;
    h = strtoll(p, (char**)&p, 10);
    if (*p == ':') p++;
    mi = strtoll(p, (char**)&p, 10);
    if (*p == ':') p++;
    s = strtoll(p, (char**)&p, 10);
    if (*p == '.') {
        p++;
        char frac_str[10] = "000000000";
        int fi = 0;
        while (*p >= '0' && *p <= '9' && fi < 9) {
            frac_str[fi++] = *p++;
        }
        while (*p >= '0' && *p <= '9') p++;
        frac = strtoll(frac_str, NULL, 10);
    }
    int64_t off_sec = 0;
    if (*p == '+' || *p == '-') {
        int sign = (*p == '+') ? 1 : -1;
        p++;
        int64_t oh = strtoll(p, (char**)&p, 10);
        int64_t om = 0;
        if (*p == ':') {
            p++;
            om = strtoll(p, (char**)&p, 10);
        }
        off_sec = sign * (oh * 3600 + om * 60);
    }
    int64_t days = _days_from_civil_c(y, mo, d);
    int64_t total_sec = days * 86400LL + h * 3600LL + mi * 60LL + s - off_sec;
    return total_sec * 1000000000LL + frac;
}

char *flux_std_datetime_to_iso(int64_t nanos) {
    char *buf = (char *)malloc(64);
    if (!buf) return strdup("");
    int64_t y, mo, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &mo, &d, &h, &mi, &s, &frac);
    snprintf(buf, 64, "%04lld-%02lld-%02lldT%02lld:%02lld:%02lld.%09lldZ",
             (long long)y, (long long)mo, (long long)d,
             (long long)h, (long long)mi, (long long)s, (long long)frac);
    return buf;
}

char *flux_std_get_current_time_ns_string(void) {
    return flux_std_datetime_to_iso(flux_std_datetime_now());
}

char *flux_std_datetime_format(int64_t nanos, const char *pattern) {
    char *buf = (char *)malloc(128);
    if (!buf) return strdup("");
    int64_t sec = nanos / 1000000000LL;
    time_t raw = (time_t)sec;
    struct tm *gmt = gmtime(&raw);
    if (gmt) {
        strftime(buf, 128, pattern ? pattern : "%Y-%m-%d %H:%M:%S", gmt);
    } else {
        buf[0] = '\0';
    }
    return buf;
}

int64_t flux_std_datetime_year(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return y;
}

int64_t flux_std_datetime_month(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return m;
}

int64_t flux_std_datetime_day(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return d;
}

int64_t flux_std_datetime_hour(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return h;
}

int64_t flux_std_datetime_minute(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return mi;
}

int64_t flux_std_datetime_second(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return s;
}

int64_t flux_std_datetime_millisecond(int64_t nanos) {
    int64_t frac = nanos % 1000000000LL;
    if (frac < 0) frac += 1000000000LL;
    return frac / 1000000LL;
}

int64_t flux_std_datetime_microsecond(int64_t nanos) {
    int64_t frac = nanos % 1000000000LL;
    if (frac < 0) frac += 1000000000LL;
    return (frac / 1000LL) % 1000000LL;
}

int64_t flux_std_datetime_nanosecond(int64_t nanos) {
    int64_t frac = nanos % 1000000000LL;
    if (frac < 0) frac += 1000000000LL;
    return frac;
}

int64_t flux_std_datetime_weekday(int64_t nanos) {
    int64_t sec = nanos / 1000000000LL;
    if (nanos % 1000000000LL < 0) sec--;
    int64_t days = sec / 86400;
    if (sec % 86400 < 0) days--;
    return ((days + 3) % 7 + 7) % 7 + 1;
}

int64_t flux_std_datetime_day_of_year(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    int prior[12] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
    int leap = (m > 2 && _is_leap_year_c(y)) ? 1 : 0;
    return (int64_t)(prior[m - 1] + d + leap);
}

int64_t flux_std_datetime_days_in_month(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return _days_in_month_c(y, m);
}

int64_t flux_std_datetime_quarter(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return (m - 1) / 3 + 1;
}

int64_t flux_std_datetime_is_leap_year(int64_t nanos) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    return _is_leap_year_c(y);
}

int64_t flux_std_datetime_is_weekend(int64_t nanos) {
    int64_t w = flux_std_datetime_weekday(nanos);
    return (w == 6 || w == 7) ? 1 : 0;
}

int64_t flux_std_datetime_add_days(int64_t nanos, int64_t amount) {
    return nanos + amount * 86400000000000LL;
}

int64_t flux_std_datetime_add_hours(int64_t nanos, int64_t amount) {
    return nanos + amount * 3600000000000LL;
}

int64_t flux_std_datetime_add_minutes(int64_t nanos, int64_t amount) {
    return nanos + amount * 60000000000LL;
}

int64_t flux_std_datetime_add_seconds(int64_t nanos, int64_t amount) {
    return nanos + amount * 1000000000LL;
}

int64_t flux_std_datetime_add_milliseconds(int64_t nanos, int64_t amount) {
    return nanos + amount * 1000000LL;
}

int64_t flux_std_datetime_add_microseconds(int64_t nanos, int64_t amount) {
    return nanos + amount * 1000LL;
}

int64_t flux_std_datetime_add_nanoseconds(int64_t nanos, int64_t amount) {
    return nanos + amount;
}

int64_t flux_std_datetime_add_months(int64_t nanos, int64_t amount) {
    int64_t y, m, d, h, mi, s, frac;
    _split_nanos_c(nanos, &y, &m, &d, &h, &mi, &s, &frac);
    int64_t total_m = (y * 12 + (m - 1)) + amount;
    int64_t new_y = total_m / 12;
    int64_t new_m = total_m % 12 + 1;
    int64_t max_d = _days_in_month_c(new_y, new_m);
    int64_t new_d = d < max_d ? d : max_d;
    int64_t days = _days_from_civil_c(new_y, new_m, new_d);
    return days * 86400000000000LL + (h * 3600 + mi * 60 + s) * 1000000000LL + frac;
}

int64_t flux_std_datetime_add_years(int64_t nanos, int64_t amount) {
    return flux_std_datetime_add_months(nanos, amount * 12);
}

int64_t flux_std_datetime_is_before(int64_t left, int64_t right) {
    return left < right ? 1 : 0;
}

int64_t flux_std_datetime_is_after(int64_t left, int64_t right) {
    return left > right ? 1 : 0;
}

int64_t flux_std_datetime_compare(int64_t left, int64_t right) {
    if (left < right) return -1;
    if (left > right) return 1;
    return 0;
}

int64_t flux_std_datetime_days_between(int64_t left, int64_t right) {
    return (right - left) / 86400000000000LL;
}

int64_t flux_std_datetime_hours_between(int64_t left, int64_t right) {
    return (right - left) / 3600000000000LL;
}

int64_t flux_std_datetime_minutes_between(int64_t left, int64_t right) {
    return (right - left) / 60000000000LL;
}

int64_t flux_std_datetime_seconds_between(int64_t left, int64_t right) {
    return (right - left) / 1000000000LL;
}

int64_t flux_std_datetime_milliseconds_between(int64_t left, int64_t right) {
    return (right - left) / 1000000LL;
}

int64_t flux_std_datetime_microseconds_between(int64_t left, int64_t right) {
    return (right - left) / 1000LL;
}

int64_t flux_std_datetime_nanoseconds_between(int64_t left, int64_t right) {
    return right - left;
}

int64_t flux_std_datetime_months_between(int64_t left, int64_t right) {
    int64_t y1, m1, d1, h1, mi1, s1, f1;
    int64_t y2, m2, d2, h2, mi2, s2, f2;
    _split_nanos_c(left, &y1, &m1, &d1, &h1, &mi1, &s1, &f1);
    _split_nanos_c(right, &y2, &m2, &d2, &h2, &mi2, &s2, &f2);
    int64_t dm = (y2 - y1) * 12 + (m2 - m1);
    if (dm > 0 && d2 < d1) dm--;
    else if (dm < 0 && d2 > d1) dm++;
    return dm;
}

int64_t flux_std_datetime_years_between(int64_t left, int64_t right) {
    int64_t y1, m1, d1, h1, mi1, s1, f1;
    int64_t y2, m2, d2, h2, mi2, s2, f2;
    _split_nanos_c(left, &y1, &m1, &d1, &h1, &mi1, &s1, &f1);
    _split_nanos_c(right, &y2, &m2, &d2, &h2, &mi2, &s2, &f2);
    int64_t dy = y2 - y1;
    if (dy > 0 && (m2 < m1 || (m2 == m1 && d2 < d1))) dy--;
    else if (dy < 0 && (m2 > m1 || (m2 == m1 && d2 > d1))) dy++;
    return dy;
}

double flux_std_datetime_utc_offset(int64_t nanos, const char *tz) {
    if (!tz || strcmp(tz, "UTC") == 0 || strcmp(tz, "Z") == 0) return 0.0;
    if (strcmp(tz, "America/Sao_Paulo") == 0 || strcmp(tz, "BRT") == 0) return -3.0;
    return 0.0;
}

char *flux_std_datetime_to_timezone(int64_t nanos, const char *tz) {
    double off = flux_std_datetime_utc_offset(nanos, tz);
    int64_t off_sec = (int64_t)(off * 3600.0);
    int64_t local_nanos = nanos + off_sec * 1000000000LL;
    int64_t y, mo, d, h, mi, s, frac;
    _split_nanos_c(local_nanos, &y, &mo, &d, &h, &mi, &s, &frac);
    char off_str[16] = "Z";
    if (off_sec != 0) {
        int64_t abs_sec = off_sec < 0 ? -off_sec : off_sec;
        snprintf(off_str, sizeof(off_str), "%c%02lld:%02lld",
                 off_sec >= 0 ? '+' : '-',
                 (long long)(abs_sec / 3600), (long long)((abs_sec % 3600) / 60));
    }
    char *buf = (char *)malloc(64);
    if (!buf) return strdup("");
    snprintf(buf, 64, "%04lld-%02lld-%02lldT%02lld:%02lld:%02lld.%09lld%s",
             (long long)y, (long long)mo, (long long)d,
             (long long)h, (long long)mi, (long long)s, (long long)frac, off_str);
    return buf;
}

char *flux_std_datetime_to_local(int64_t nanos) {
    return flux_std_datetime_to_timezone(nanos, "America/Sao_Paulo");
}

int64_t flux_std_datetime_to_utc(int64_t nanos) {
    return nanos;
}

char *flux_std_datetime_local_timezone(void) {
    return strdup("America/Sao_Paulo");
}

int64_t flux_std_datetime_is_daylight_saving_time(int64_t nanos, const char *tz) {
    return 0;
}

double flux_std_datetime_dst_offset(int64_t nanos, const char *tz) {
    return 0.0;
}

char *flux_std_format_duration_ns(int64_t ns) {
    char *buf = (char *)malloc(64);
    if (!buf) return strdup("");
    if (ns == 0) {
        strcpy(buf, "0s");
        return buf;
    }
    const char *prefix = ns < 0 ? "-" : "";
    int64_t u = ns < 0 ? -ns : ns;
    int64_t s = u / 1000000000LL;
    int64_t rem_ns = u % 1000000000LL;
    if (s == 0) {
        if (rem_ns % 1000000LL == 0) {
            snprintf(buf, 64, "%s%lldms", prefix, (long long)(rem_ns / 1000000LL));
        } else if (rem_ns % 1000LL == 0) {
            snprintf(buf, 64, "%s%lldus", prefix, (long long)(rem_ns / 1000LL));
        } else {
            snprintf(buf, 64, "%s%lldns", prefix, (long long)rem_ns);
        }
        return buf;
    }
    if (s < 60) {
        int64_t ms = rem_ns / 1000000LL;
        if (ms > 0) {
            snprintf(buf, 64, "%s%lld.%03llds", prefix, (long long)s, (long long)ms);
        } else {
            snprintf(buf, 64, "%s%llds", prefix, (long long)s);
        }
        return buf;
    }
    int64_t m = s / 60;
    s = s % 60;
    if (m < 60) {
        snprintf(buf, 64, "%s%lldm %llds", prefix, (long long)m, (long long)s);
        return buf;
    }
    int64_t h = m / 60;
    m = m % 60;
    if (h < 24) {
        snprintf(buf, 64, "%s%lldh %lldm %llds", prefix, (long long)h, (long long)m, (long long)s);
        return buf;
    }
    int64_t d = h / 24;
    h = h % 24;
    snprintf(buf, 64, "%s%lldd %lldh %lldm %llds", prefix, (long long)d, (long long)h, (long long)m, (long long)s);
    return buf;
}

/* ==============================================================================
 * TheFlux FileSignatureStdLib Runtime (C / LLVM)
 * ============================================================================== */

static FILE *_open_sig_candidate_file(const char *path) {
    if (!path || !*path) return NULL;
    FILE *f = fopen(path, "rb");
    if (f) return f;
    char alt[1024];
    const char *base = strrchr(path, '/');
    if (!base) base = strrchr(path, '\\');
    base = base ? base + 1 : path;
    snprintf(alt, sizeof(alt), "flux/%s", base);
    return fopen(alt, "rb");
}

/* --- CRC-32 IEEE 802.3 --- */
static uint32_t _sig_crc32_tab[256];
static int _sig_crc32_ready = 0;
static void _sig_crc32_init(void) {
    if (_sig_crc32_ready) return;
    for (uint32_t i = 0; i < 256; i++) {
        uint32_t c = i;
        for (int j = 0; j < 8; j++) {
            c = (c & 1) ? (0xEDB88320L ^ (c >> 1)) : (c >> 1);
        }
        _sig_crc32_tab[i] = c;
    }
    _sig_crc32_ready = 1;
}

int64_t flux_std_file_crc32(const char *path) {
    _sig_crc32_init();
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return 0;
    uint32_t crc = 0xFFFFFFFF;
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        for (size_t i = 0; i < n; i++) {
            crc = _sig_crc32_tab[(crc ^ buf[i]) & 0xFF] ^ (crc >> 8);
        }
    }
    fclose(f);
    return (int64_t)(crc ^ 0xFFFFFFFF);
}

/* --- MD5 RFC 1321 --- */
typedef struct {
    uint32_t state[4];
    uint32_t count[2];
    unsigned char buffer[64];
} SIG_MD5_CTX;

#define SIG_MD5_F(x, y, z) (((x) & (y)) | ((~x) & (z)))
#define SIG_MD5_G(x, y, z) (((x) & (z)) | ((y) & (~z)))
#define SIG_MD5_H(x, y, z) ((x) ^ (y) ^ (z))
#define SIG_MD5_I(x, y, z) ((y) ^ ((x) | (~z)))
#define SIG_MD5_ROTL(x, n) (((x) << (n)) | ((x) >> (32 - (n))))
#define SIG_MD5_FF(a, b, c, d, x, s, ac) { (a) += SIG_MD5_F((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }
#define SIG_MD5_GG(a, b, c, d, x, s, ac) { (a) += SIG_MD5_G((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }
#define SIG_MD5_HH(a, b, c, d, x, s, ac) { (a) += SIG_MD5_H((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }
#define SIG_MD5_II(a, b, c, d, x, s, ac) { (a) += SIG_MD5_I((b), (c), (d)) + (x) + (uint32_t)(ac); (a) = SIG_MD5_ROTL((a), (s)); (a) += (b); }

static void _sig_md5_transform(uint32_t state[4], const unsigned char block[64]) {
    uint32_t a = state[0], b = state[1], c = state[2], d = state[3], x[16];
    for (int i = 0, j = 0; j < 64; i++, j += 4)
        x[i] = ((uint32_t)block[j]) | (((uint32_t)block[j+1]) << 8) | (((uint32_t)block[j+2]) << 16) | (((uint32_t)block[j+3]) << 24);

    SIG_MD5_FF(a, b, c, d, x[ 0],  7, 0xd76aa478); SIG_MD5_FF(d, a, b, c, x[ 1], 12, 0xe8c7b756); SIG_MD5_FF(c, d, a, b, x[ 2], 17, 0x242070db); SIG_MD5_FF(b, c, d, a, x[ 3], 22, 0xc1bdceee);
    SIG_MD5_FF(a, b, c, d, x[ 4],  7, 0xf57c0faf); SIG_MD5_FF(d, a, b, c, x[ 5], 12, 0x4787c62a); SIG_MD5_FF(c, d, a, b, x[ 6], 17, 0xa8304613); SIG_MD5_FF(b, c, d, a, x[ 7], 22, 0xfd469501);
    SIG_MD5_FF(a, b, c, d, x[ 8],  7, 0x698098d8); SIG_MD5_FF(d, a, b, c, x[ 9], 12, 0x8b44f7af); SIG_MD5_FF(c, d, a, b, x[10], 17, 0xffff5bb1); SIG_MD5_FF(b, c, d, a, x[11], 22, 0x895cd7be);
    SIG_MD5_FF(a, b, c, d, x[12],  7, 0x6b901122); SIG_MD5_FF(d, a, b, c, x[13], 12, 0xfd987193); SIG_MD5_FF(c, d, a, b, x[14], 17, 0xa679438e); SIG_MD5_FF(b, c, d, a, x[15], 22, 0x49b40821);

    SIG_MD5_GG(a, b, c, d, x[ 1],  5, 0xf61e2562); SIG_MD5_GG(d, a, b, c, x[ 6],  9, 0xc040b340); SIG_MD5_GG(c, d, a, b, x[11], 14, 0x265e5a51); SIG_MD5_GG(b, c, d, a, x[ 0], 20, 0xe9b6c7aa);
    SIG_MD5_GG(a, b, c, d, x[ 5],  5, 0xd62f105d); SIG_MD5_GG(d, a, b, c, x[10],  9, 0x02441453); SIG_MD5_GG(c, d, a, b, x[15], 14, 0xd8a1e681); SIG_MD5_GG(b, c, d, a, x[ 4], 20, 0xe7d3fbc8);
    SIG_MD5_GG(a, b, c, d, x[ 9],  5, 0x21e1cde6); SIG_MD5_GG(d, a, b, c, x[14],  9, 0xc33707d6); SIG_MD5_GG(c, d, a, b, x[ 3], 14, 0xf4d50d87); SIG_MD5_GG(b, c, d, a, x[ 8], 20, 0x455a14ed);
    SIG_MD5_GG(a, b, c, d, x[13],  5, 0xa9e3e905); SIG_MD5_GG(d, a, b, c, x[ 2],  9, 0xfcefa3f8); SIG_MD5_GG(c, d, a, b, x[ 7], 14, 0x676f02d9); SIG_MD5_GG(b, c, d, a, x[12], 20, 0x8d2a4c8a);

    SIG_MD5_HH(a, b, c, d, x[ 5],  4, 0xfffa3942); SIG_MD5_HH(d, a, b, c, x[ 8], 11, 0x8771f681); SIG_MD5_HH(c, d, a, b, x[11], 16, 0x6d9d6122); SIG_MD5_HH(b, c, d, a, x[14], 23, 0xfde5380c);
    SIG_MD5_HH(a, b, c, d, x[ 1],  4, 0xa4beea44); SIG_MD5_HH(d, a, b, c, x[ 4], 11, 0x4bdecfa9); SIG_MD5_HH(c, d, a, b, x[ 7], 16, 0xf6bb4b60); SIG_MD5_HH(b, c, d, a, x[10], 23, 0xbebfbc70);
    SIG_MD5_HH(a, b, c, d, x[13],  4, 0x289b7ec6); SIG_MD5_HH(d, a, b, c, x[ 0], 11, 0xeaa127fa); SIG_MD5_HH(c, d, a, b, x[ 3], 16, 0xd4ef3085); SIG_MD5_HH(b, c, d, a, x[ 6], 23, 0x04881d05);
    SIG_MD5_HH(a, b, c, d, x[ 9],  4, 0xd9d4d039); SIG_MD5_HH(d, a, b, c, x[12], 11, 0xe6db99e5); SIG_MD5_HH(c, d, a, b, x[15], 16, 0x1fa27cf8); SIG_MD5_HH(b, c, d, a, x[ 2], 23, 0xc4ac5665);

    SIG_MD5_II(a, b, c, d, x[ 0],  6, 0xf4292244); SIG_MD5_II(d, a, b, c, x[ 7], 10, 0x432aff97); SIG_MD5_II(c, d, a, b, x[14], 15, 0xab9423a7); SIG_MD5_II(b, c, d, a, x[ 5], 21, 0xfc93a039);
    SIG_MD5_II(a, b, c, d, x[12],  6, 0x655b59c3); SIG_MD5_II(d, a, b, c, x[ 3], 10, 0x8f0ccc92); SIG_MD5_II(c, d, a, b, x[10], 15, 0xffeff47d); SIG_MD5_II(b, c, d, a, x[ 1], 21, 0x85845dd1);
    SIG_MD5_II(a, b, c, d, x[ 8],  6, 0x6fa87e4f); SIG_MD5_II(d, a, b, c, x[15], 10, 0xfe2ce6e0); SIG_MD5_II(c, d, a, b, x[ 6], 15, 0xa3014314); SIG_MD5_II(b, c, d, a, x[13], 21, 0x4e0811a1);
    SIG_MD5_II(a, b, c, d, x[ 4],  6, 0xf7537e82); SIG_MD5_II(d, a, b, c, x[11], 10, 0xbd3af235); SIG_MD5_II(c, d, a, b, x[ 2], 15, 0x2ad7d2bb); SIG_MD5_II(b, c, d, a, x[ 9], 21, 0xeb86d391);

    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
}

static void _sig_md5_init(SIG_MD5_CTX *ctx) {
    ctx->count[0] = ctx->count[1] = 0;
    ctx->state[0] = 0x67452301; ctx->state[1] = 0xefcdab89; ctx->state[2] = 0x98badcfe; ctx->state[3] = 0x10325476;
}

static void _sig_md5_update(SIG_MD5_CTX *ctx, const unsigned char *input, size_t inputLen) {
    size_t i = 0, index = (ctx->count[0] >> 3) & 0x3F;
    if ((ctx->count[0] += ((uint32_t)inputLen << 3)) < ((uint32_t)inputLen << 3)) ctx->count[1]++;
    ctx->count[1] += (uint32_t)(inputLen >> 29);
    size_t partLen = 64 - index;
    if (inputLen >= partLen) {
        memcpy(&ctx->buffer[index], input, partLen);
        _sig_md5_transform(ctx->state, ctx->buffer);
        for (i = partLen; i + 63 < inputLen; i += 64)
            _sig_md5_transform(ctx->state, &input[i]);
        index = 0;
    }
    memcpy(&ctx->buffer[index], &input[i], inputLen - i);
}

static void _sig_md5_final(unsigned char digest[16], SIG_MD5_CTX *ctx) {
    unsigned char bits[8];
    for (int i = 0; i < 4; i++) {
        bits[i] = (unsigned char)((ctx->count[0] >> (i * 8)) & 0xFF);
        bits[i + 4] = (unsigned char)((ctx->count[1] >> (i * 8)) & 0xFF);
    }
    size_t index = (ctx->count[0] >> 3) & 0x3F;
    size_t padLen = (index < 56) ? (56 - index) : (120 - index);
    static const unsigned char PADDING[64] = { 0x80 };
    _sig_md5_update(ctx, PADDING, padLen);
    _sig_md5_update(ctx, bits, 8);
    for (int i = 0; i < 4; i++) {
        digest[i*4]   = (unsigned char)((ctx->state[i]) & 0xFF);
        digest[i*4+1] = (unsigned char)((ctx->state[i] >> 8) & 0xFF);
        digest[i*4+2] = (unsigned char)((ctx->state[i] >> 16) & 0xFF);
        digest[i*4+3] = (unsigned char)((ctx->state[i] >> 24) & 0xFF);
    }
}

char *flux_std_file_md5(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_MD5_CTX ctx;
    _sig_md5_init(&ctx);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_md5_update(&ctx, buf, n);
    }
    fclose(f);
    unsigned char d[16];
    _sig_md5_final(d, &ctx);
    char *res = (char *)malloc(33);
    for (int i = 0; i < 16; i++) snprintf(res + i*2, 3, "%02x", d[i]);
    res[32] = 0;
    return res;
}

/* --- SHA-1 FIPS 180-1 --- */
typedef struct {
    uint32_t state[5];
    uint64_t count;
    unsigned char buffer[64];
} SIG_SHA1_CTX;

#define SIG_SHA1_ROTL(x, n) (((x) << (n)) | ((x) >> (32 - (n))))

static void _sig_sha1_transform(uint32_t state[5], const unsigned char buffer[64]) {
    uint32_t a = state[0], b = state[1], c = state[2], d = state[3], e = state[4], w[80];
    for (int i = 0; i < 16; i++)
        w[i] = ((uint32_t)buffer[i*4] << 24) | ((uint32_t)buffer[i*4+1] << 16) | ((uint32_t)buffer[i*4+2] << 8) | ((uint32_t)buffer[i*4+3]);
    for (int i = 16; i < 80; i++)
        w[i] = SIG_SHA1_ROTL(w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16], 1);

    for (int i = 0; i < 80; i++) {
        uint32_t f, k;
        if (i < 20) {
            f = (b & c) | ((~b) & d); k = 0x5a827999;
        } else if (i < 40) {
            f = b ^ c ^ d; k = 0x6ed9eba1;
        } else if (i < 60) {
            f = (b & c) | (b & d) | (c & d); k = 0x8f1bbcdc;
        } else {
            f = b ^ c ^ d; k = 0xca62c1d6;
        }
        uint32_t temp = SIG_SHA1_ROTL(a, 5) + f + e + k + w[i];
        e = d; d = c; c = SIG_SHA1_ROTL(b, 30); b = a; a = temp;
    }
    state[0] += a; state[1] += b; state[2] += c; state[3] += d; state[4] += e;
}

static void _sig_sha1_init(SIG_SHA1_CTX *ctx) {
    ctx->count = 0;
    ctx->state[0] = 0x67452301; ctx->state[1] = 0xefcdab89; ctx->state[2] = 0x98badcfe; ctx->state[3] = 0x10325476; ctx->state[4] = 0xc3d2e1f0;
}

static void _sig_sha1_update(SIG_SHA1_CTX *ctx, const unsigned char *data, size_t len) {
    size_t i = 0, index = (ctx->count / 8) % 64;
    ctx->count += (uint64_t)len * 8;
    size_t partLen = 64 - index;
    if (len >= partLen) {
        memcpy(&ctx->buffer[index], data, partLen);
        _sig_sha1_transform(ctx->state, ctx->buffer);
        for (i = partLen; i + 63 < len; i += 64)
            _sig_sha1_transform(ctx->state, &data[i]);
        index = 0;
    }
    memcpy(&ctx->buffer[index], &data[i], len - i);
}

static void _sig_sha1_final(unsigned char digest[20], SIG_SHA1_CTX *ctx) {
    unsigned char bits[8];
    for (int i = 0; i < 8; i++)
        bits[i] = (unsigned char)((ctx->count >> ((7 - i) * 8)) & 0xFF);
    size_t index = (ctx->count / 8) % 64;
    size_t padLen = (index < 56) ? (56 - index) : (120 - index);
    static const unsigned char PADDING[64] = { 0x80 };
    _sig_sha1_update(ctx, PADDING, padLen);
    _sig_sha1_update(ctx, bits, 8);
    for (int i = 0; i < 5; i++) {
        digest[i*4]   = (unsigned char)((ctx->state[i] >> 24) & 0xFF);
        digest[i*4+1] = (unsigned char)((ctx->state[i] >> 16) & 0xFF);
        digest[i*4+2] = (unsigned char)((ctx->state[i] >> 8) & 0xFF);
        digest[i*4+3] = (unsigned char)((ctx->state[i]) & 0xFF);
    }
}

char *flux_std_file_sha1(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_SHA1_CTX ctx;
    _sig_sha1_init(&ctx);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_sha1_update(&ctx, buf, n);
    }
    fclose(f);
    unsigned char d[20];
    _sig_sha1_final(d, &ctx);
    char *res = (char *)malloc(41);
    for (int i = 0; i < 20; i++) snprintf(res + i*2, 3, "%02x", d[i]);
    res[40] = 0;
    return res;
}

/* --- SHA-256 FIPS 180-4 --- */
typedef struct {
    uint32_t state[8];
    uint64_t count;
    unsigned char buffer[64];
} SIG_SHA256_CTX;

#define SIG_ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))
#define SIG_CH(x, y, z) (((x) & (y)) ^ (~(x) & (z)))
#define SIG_MAJ(x, y, z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
#define SIG_EP0(x) (SIG_ROTR(x, 2) ^ SIG_ROTR(x, 13) ^ SIG_ROTR(x, 22))
#define SIG_EP1(x) (SIG_ROTR(x, 6) ^ SIG_ROTR(x, 11) ^ SIG_ROTR(x, 25))
#define SIG_S0(x) (SIG_ROTR(x, 7) ^ SIG_ROTR(x, 18) ^ ((x) >> 3))
#define SIG_S1(x) (SIG_ROTR(x, 17) ^ SIG_ROTR(x, 19) ^ ((x) >> 10))

static const uint32_t _sig_k256[64] = {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

static void _sig_sha256_transform(uint32_t state[8], const unsigned char data[64]) {
    uint32_t a, b, c, d, e, f, g, h, t1, t2, m[64];
    for (int i = 0, j = 0; i < 16; i++, j += 4)
        m[i] = (((uint32_t)data[j]) << 24) | (((uint32_t)data[j+1]) << 16) | (((uint32_t)data[j+2]) << 8) | ((uint32_t)data[j+3]);
    for (int i = 16; i < 64; i++)
        m[i] = SIG_S1(m[i-2]) + m[i-7] + SIG_S0(m[i-15]) + m[i-16];
    a = state[0]; b = state[1]; c = state[2]; d = state[3];
    e = state[4]; f = state[5]; g = state[6]; h = state[7];
    for (int i = 0; i < 64; i++) {
        t1 = h + SIG_EP1(e) + SIG_CH(e, f, g) + _sig_k256[i] + m[i];
        t2 = SIG_EP0(a) + SIG_MAJ(a, b, c);
        h = g; g = f; f = e; e = d + t1;
        d = c; c = b; b = a; a = t1 + t2;
    }
    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
    state[4] += e; state[5] += f; state[6] += g; state[7] += h;
}

static void _sig_sha256_init(SIG_SHA256_CTX *ctx) {
    ctx->count = 0;
    ctx->state[0] = 0x6a09e667; ctx->state[1] = 0xbb67ae85; ctx->state[2] = 0x3c6ef372; ctx->state[3] = 0xa54ff53a;
    ctx->state[4] = 0x510e527f; ctx->state[5] = 0x9b05688c; ctx->state[6] = 0x1f83d9ab; ctx->state[7] = 0x5be0cd19;
}

static void _sig_sha256_update(SIG_SHA256_CTX *ctx, const unsigned char *data, size_t len) {
    size_t i = 0, index = (ctx->count / 8) % 64;
    ctx->count += (uint64_t)len * 8;
    size_t partLen = 64 - index;
    if (len >= partLen) {
        memcpy(&ctx->buffer[index], data, partLen);
        _sig_sha256_transform(ctx->state, ctx->buffer);
        for (i = partLen; i + 63 < len; i += 64)
            _sig_sha256_transform(ctx->state, &data[i]);
        index = 0;
    }
    memcpy(&ctx->buffer[index], &data[i], len - i);
}

static void _sig_sha256_final(unsigned char digest[32], SIG_SHA256_CTX *ctx) {
    unsigned char bits[8];
    for (int i = 0; i < 8; i++)
        bits[i] = (unsigned char)((ctx->count >> ((7 - i) * 8)) & 0xFF);
    size_t index = (ctx->count / 8) % 64;
    size_t padLen = (index < 56) ? (56 - index) : (120 - index);
    static const unsigned char PADDING[64] = { 0x80 };
    _sig_sha256_update(ctx, PADDING, padLen);
    _sig_sha256_update(ctx, bits, 8);
    for (int i = 0; i < 8; i++) {
        digest[i*4]   = (unsigned char)((ctx->state[i] >> 24) & 0xFF);
        digest[i*4+1] = (unsigned char)((ctx->state[i] >> 16) & 0xFF);
        digest[i*4+2] = (unsigned char)((ctx->state[i] >> 8) & 0xFF);
        digest[i*4+3] = (unsigned char)((ctx->state[i]) & 0xFF);
    }
}

char *flux_std_file_sha256(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_SHA256_CTX ctx;
    _sig_sha256_init(&ctx);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_sha256_update(&ctx, buf, n);
    }
    fclose(f);
    unsigned char digest[32];
    _sig_sha256_final(digest, &ctx);
    char *res = (char *)malloc(65);
    for (int i = 0; i < 32; i++) snprintf(res + i*2, 3, "%02x", digest[i]);
    res[64] = 0;
    return res;
}

/* --- HMAC-SHA256 & HMAC-MD5 --- */
char *flux_std_file_hmac_sha256(const char *path, const char *key) {
    if (!key) key = "";
    size_t key_len = strlen(key);
    unsigned char k0[64];
    memset(k0, 0, 64);
    if (key_len > 64) {
        SIG_SHA256_CTX kctx;
        _sig_sha256_init(&kctx);
        _sig_sha256_update(&kctx, (const unsigned char *)key, key_len);
        _sig_sha256_final(k0, &kctx);
    } else {
        memcpy(k0, key, key_len);
    }
    unsigned char k_ipad[64], k_opad[64];
    for (int i = 0; i < 64; i++) {
        k_ipad[i] = k0[i] ^ 0x36;
        k_opad[i] = k0[i] ^ 0x5c;
    }
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_SHA256_CTX inner;
    _sig_sha256_init(&inner);
    _sig_sha256_update(&inner, k_ipad, 64);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_sha256_update(&inner, buf, n);
    }
    fclose(f);
    unsigned char inner_hash[32];
    _sig_sha256_final(inner_hash, &inner);

    SIG_SHA256_CTX outer;
    _sig_sha256_init(&outer);
    _sig_sha256_update(&outer, k_opad, 64);
    _sig_sha256_update(&outer, inner_hash, 32);
    unsigned char mac[32];
    _sig_sha256_final(mac, &outer);

    char *res = (char *)malloc(65);
    for (int i = 0; i < 32; i++) snprintf(res + i*2, 3, "%02x", mac[i]);
    res[64] = 0;
    return res;
}

char *flux_std_file_hmac_md5(const char *path, const char *key) {
    if (!key) key = "";
    size_t key_len = strlen(key);
    unsigned char k0[64];
    memset(k0, 0, 64);
    if (key_len > 64) {
        SIG_MD5_CTX kctx;
        _sig_md5_init(&kctx);
        _sig_md5_update(&kctx, (const unsigned char *)key, key_len);
        _sig_md5_final(k0, &kctx);
    } else {
        memcpy(k0, key, key_len);
    }
    unsigned char k_ipad[64], k_opad[64];
    for (int i = 0; i < 64; i++) {
        k_ipad[i] = k0[i] ^ 0x36;
        k_opad[i] = k0[i] ^ 0x5c;
    }
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    SIG_MD5_CTX inner;
    _sig_md5_init(&inner);
    _sig_md5_update(&inner, k_ipad, 64);
    unsigned char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), f)) > 0) {
        _sig_md5_update(&inner, buf, n);
    }
    fclose(f);
    unsigned char inner_hash[16];
    _sig_md5_final(inner_hash, &inner);

    SIG_MD5_CTX outer;
    _sig_md5_init(&outer);
    _sig_md5_update(&outer, k_opad, 64);
    _sig_md5_update(&outer, inner_hash, 16);
    unsigned char mac[16];
    _sig_md5_final(mac, &outer);

    char *res = (char *)malloc(33);
    for (int i = 0; i < 16; i++) snprintf(res + i*2, 3, "%02x", mac[i]);
    res[32] = 0;
    return res;
}

/* --- Magic Bytes & File Type Detection --- */
char *flux_std_file_magic_bytes(const char *path, int64_t num_bytes) {
    if (num_bytes <= 0) return strdup("");
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("");
    unsigned char *buf = (unsigned char *)malloc((size_t)num_bytes);
    if (!buf) { fclose(f); return strdup(""); }
    size_t read_n = fread(buf, 1, (size_t)num_bytes, f);
    fclose(f);
    char *res = (char *)malloc(read_n * 2 + 1);
    for (size_t i = 0; i < read_n; i++) snprintf(res + i*2, 3, "%02x", buf[i]);
    res[read_n * 2] = 0;
    free(buf);
    return res;
}

char *flux_std_file_detect_type(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return strdup("unknown");
    unsigned char head[512];
    size_t n = fread(head, 1, sizeof(head), f);
    fclose(f);
    if (n == 0) return strdup("empty");
    if (n >= 8 && memcmp(head, "\x89PNG\r\n\x1a\n", 8) == 0) return strdup("png");
    if (n >= 4 && memcmp(head, "%PDF", 4) == 0) return strdup("pdf");
    if (n >= 4 && memcmp(head, "\x00asm", 4) == 0) return strdup("wasm");
    if (n >= 4 && (memcmp(head, "PK\x03\x04", 4) == 0 || memcmp(head, "PK\x05\x06", 4) == 0)) return strdup("zip");
    if (n >= 3 && memcmp(head, "\xff\xd8\xff", 3) == 0) return strdup("jpeg");
    if (n >= 6 && (memcmp(head, "GIF87a", 6) == 0 || memcmp(head, "GIF89a", 6) == 0)) return strdup("gif");
    if (n >= 4 && head[0] == 0x7f && head[1] == 'E' && head[2] == 'L' && head[3] == 'F') return strdup("elf");
    if (n >= 2 && memcmp(head, "MZ", 2) == 0) return strdup("exe");
    if (n >= 2 && memcmp(head, "\x1f\x8b", 2) == 0) return strdup("gzip");
    for (size_t i = 0; i < n; i++) {
        if (head[i] == 0) return strdup("binary");
    }
    return strdup("text");
}

int64_t flux_std_file_is_binary(const char *path) {
    FILE *f = _open_sig_candidate_file(path);
    if (!f) return 0;
    unsigned char head[1024];
    size_t n = fread(head, 1, sizeof(head), f);
    fclose(f);
    if (n == 0) return 0;
    for (size_t i = 0; i < n; i++) {
        if (head[i] == 0) return 1;
    }
    return 0;
}

/* =========================================================================
 * OsStdLib C Runtime Implementation
 * ========================================================================= */

static void _normalize_slash(char *s) {
    if (!s) return;
    for (; *s; s++) {
        if (*s == '\\') *s = '/';
    }
}

char *flux_std_os_get_env(const char *name) {
    if (!name || !*name) return strdup("");
    const char *v = getenv(name);
    return strdup(v ? v : "");
}

char *flux_std_os_get_env_or_default(const char *name, const char *def_val) {
    if (!name || !*name) return strdup(def_val ? def_val : "");
    const char *v = getenv(name);
    return strdup(v ? v : (def_val ? def_val : ""));
}

int64_t flux_std_os_set_env(const char *name, const char *val) {
    if (!name || !*name) return 0;
#if defined(_WIN32)
    SetEnvironmentVariableA(name, val ? val : "");
    _putenv_s(name, val ? val : "");
    return 1;
#else
    return setenv(name, val ? val : "", 1) == 0 ? 1 : 0;
#endif
}

int64_t flux_std_os_has_env(const char *name) {
    if (!name || !*name) return 0;
    return getenv(name) != NULL ? 1 : 0;
}

int64_t flux_std_os_unset_env(const char *name) {
    if (!name || !*name) return 0;
#if defined(_WIN32)
    SetEnvironmentVariableA(name, NULL);
    _putenv_s(name, "");
    return 1;
#else
    return unsetenv(name) == 0 ? 1 : 0;
#endif
}

void *flux_std_os_list_env(void *(*build)(int64_t, int64_t), void *(*push)(void*, int64_t, int64_t, const char*)) {
    void *list = build(0, 4);
#if defined(_WIN32)
    extern char **_environ;
    char **env = _environ;
#else
    extern char **environ;
    char **env = environ;
#endif
    if (env) {
        for (char **p = env; *p; p++) {
            char *eq = strchr(*p, '=');
            if (eq && eq != *p) {
                size_t klen = (size_t)(eq - *p);
                char *key = (char *)malloc(klen + 1);
                if (key) {
                    memcpy(key, *p, klen);
                    key[klen] = '\0';
                    list = push(list, 4, 0, key);
                }
            }
        }
    }
    return list;
}

char *flux_std_os_platform(void) {
#if defined(_WIN32)
    return strdup("windows");
#elif defined(__APPLE__)
    return strdup("darwin");
#elif defined(__linux__)
    return strdup("linux");
#else
    return strdup("unknown");
#endif
}

char *flux_std_os_arch(void) {
#if defined(_M_X64) || defined(__x86_64__) || defined(__amd64__)
    return strdup("x86_64");
#elif defined(_M_ARM64) || defined(__aarch64__)
    return strdup("arm64");
#elif defined(_M_IX86) || defined(__i386__)
    return strdup("x86");
#elif defined(_M_ARM) || defined(__arm__)
    return strdup("arm");
#else
    return strdup("unknown");
#endif
}

char *flux_std_os_family(void) {
#if defined(_WIN32)
    return strdup("windows");
#else
    return strdup("posix");
#endif
}

char *flux_std_os_hostname(void) {
#if defined(_WIN32)
    char buf[256];
    DWORD sz = sizeof(buf);
    if (GetComputerNameA(buf, &sz)) {
        for (char *p = buf; *p; p++) *p = (char)tolower((unsigned char)*p);
        return strdup(buf);
    }
    const char *h = getenv("COMPUTERNAME");
    if (h) {
        char *dup = strdup(h);
        for (char *p = dup; *p; p++) *p = (char)tolower((unsigned char)*p);
        return dup;
    }
    return strdup("localhost");
#else
    char buf[256];
    if (gethostname(buf, sizeof(buf)) == 0) {
        for (char *p = buf; *p; p++) *p = (char)tolower((unsigned char)*p);
        return strdup(buf);
    }
    const char *h = getenv("HOSTNAME");
    if (h) {
        char *dup = strdup(h);
        for (char *p = dup; *p; p++) *p = (char)tolower((unsigned char)*p);
        return dup;
    }
    return strdup("localhost");
#endif
}

char *flux_std_os_line_separator(void) {
#if defined(_WIN32)
    return strdup("\r\n");
#else
    return strdup("\n");
#endif
}

char *flux_std_os_path_separator(void) {
#if defined(_WIN32)
    return strdup(";");
#else
    return strdup(":");
#endif
}

char *flux_std_os_dir_separator(void) {
#if defined(_WIN32)
    return strdup("\\");
#else
    return strdup("/");
#endif
}

int64_t flux_std_os_get_pid(void) {
#if defined(_WIN32)
    return (int64_t)GetCurrentProcessId();
#else
    return (int64_t)getpid();
#endif
}

int64_t flux_std_os_get_parent_pid(void) {
#if defined(_WIN32)
    DWORD current_pid = GetCurrentProcessId();
    DWORD ppid = 0;
    HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnap != INVALID_HANDLE_VALUE) {
        PROCESSENTRY32 pe;
        pe.dwSize = sizeof(pe);
        if (Process32First(hSnap, &pe)) {
            do {
                if (pe.th32ProcessID == current_pid) {
                    ppid = pe.th32ParentProcessID;
                    break;
                }
            } while (Process32Next(hSnap, &pe));
        }
        CloseHandle(hSnap);
    }
    return (int64_t)ppid;
#else
    return (int64_t)getppid();
#endif
}

char *flux_std_os_cwd(void) {
#if defined(_WIN32)
    char buf[MAX_PATH];
    if (_getcwd(buf, sizeof(buf))) {
        _normalize_slash(buf);
        return strdup(buf);
    }
#else
    char buf[4096];
    if (getcwd(buf, sizeof(buf))) {
        _normalize_slash(buf);
        return strdup(buf);
    }
#endif
    return strdup("");
}

int64_t flux_std_os_chdir(const char *path) {
    if (!path || !*path) return 0;
#if defined(_WIN32)
    return _chdir(path) == 0 ? 1 : 0;
#else
    return chdir(path) == 0 ? 1 : 0;
#endif
}

int64_t flux_std_os_exec(const char *cmd) {
    if (!cmd) return -1;
    int rc = system(cmd);
#if defined(_WIN32)
    return (int64_t)rc;
#else
    if (rc == -1) return -1;
    return (int64_t)(rc >> 8);
#endif
}

char *flux_std_os_exec_output(const char *cmd) {
    if (!cmd) return strdup("");
#if defined(_WIN32)
    FILE *p = _popen(cmd, "r");
#else
    FILE *p = popen(cmd, "r");
#endif
    if (!p) return strdup("");
    size_t cap = 4096;
    size_t len = 0;
    char *buf = (char *)malloc(cap);
    if (!buf) {
#if defined(_WIN32)
        _pclose(p);
#else
        pclose(p);
#endif
        return strdup("");
    }
    char tmp[512];
    while (fgets(tmp, sizeof(tmp), p)) {
        size_t n = strlen(tmp);
        if (len + n + 1 > cap) {
            cap = (len + n + 1) * 2;
            char *new_buf = (char *)realloc(buf, cap);
            if (!new_buf) break;
            buf = new_buf;
        }
        memcpy(buf + len, tmp, n);
        len += n;
    }
    buf[len] = '\0';
#if defined(_WIN32)
    _pclose(p);
#else
    pclose(p);
#endif
    while (len > 0 && (buf[len - 1] == '\r' || buf[len - 1] == '\n' || buf[len - 1] == ' ' || buf[len - 1] == '\t')) {
        buf[--len] = '\0';
    }
    return buf;
}

int64_t flux_std_os_sleep(int64_t ms) {
    if (ms > 0) {
#if defined(_WIN32)
        Sleep((DWORD)ms);
#else
        usleep((useconds_t)(ms * 1000));
#endif
    }
    return 1;
}

char *flux_std_os_user_name(void) {
#if defined(_WIN32)
    const char *u = getenv("USERNAME");
    return strdup(u ? u : "");
#else
    const char *u = getenv("USER");
    if (u) return strdup(u);
    u = getenv("LOGNAME");
    return strdup(u ? u : "");
#endif
}

char *flux_std_os_home_dir(void) {
    char *res = NULL;
#if defined(_WIN32)
    const char *h = getenv("USERPROFILE");
    if (h && *h) {
        res = strdup(h);
    } else {
        const char *hd = getenv("HOMEDRIVE");
        const char *hp = getenv("HOMEPATH");
        if (hd && hp) {
            char buf[MAX_PATH];
            snprintf(buf, sizeof(buf), "%s%s", hd, hp);
            res = strdup(buf);
        } else {
            res = strdup("");
        }
    }
#else
    const char *h = getenv("HOME");
    res = strdup(h ? h : "");
#endif
    _normalize_slash(res);
    return res;
}

char *flux_std_os_temp_dir(void) {
    char *res = NULL;
#if defined(_WIN32)
    char buf[MAX_PATH];
    DWORD n = GetTempPathA(sizeof(buf), buf);
    if (n > 0 && n < sizeof(buf)) {
        while (n > 1 && (buf[n - 1] == '\\' || buf[n - 1] == '/')) {
            buf[--n] = '\0';
        }
        res = strdup(buf);
    } else {
        res = strdup("C:/Temp");
    }
#else
    const char *t = getenv("TMPDIR");
    res = strdup(t && *t ? t : "/tmp");
#endif
    _normalize_slash(res);
    return res;
}

int64_t flux_std_os_cpu_count(void) {
#if defined(_WIN32)
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    return (int64_t)(si.dwNumberOfProcessors > 0 ? si.dwNumberOfProcessors : 1);
#else
    long n = sysconf(_SC_NPROCESSORS_ONLN);
    return (int64_t)(n > 0 ? n : 1);
#endif
}

int64_t flux_std_os_uptime(void) {
#if defined(_WIN32)
    ULONGLONG ms = GetTickCount64();
    return (int64_t)(ms / 1000);
#else
    struct timespec ts;
    if (clock_gettime(CLOCK_BOOTTIME, &ts) == 0) {
        return (int64_t)ts.tv_sec;
    }
    return 0;
#endif
}

int64_t flux_std_os_memory_total(void) {
#if defined(_WIN32)
    MEMORYSTATUSEX ms;
    ms.dwLength = sizeof(ms);
    if (GlobalMemoryStatusEx(&ms)) {
        return (int64_t)ms.ullTotalPhys;
    }
    return 0;
#else
    long pages = sysconf(_SC_PHYS_PAGES);
    long page_size = sysconf(_SC_PAGE_SIZE);
    if (pages > 0 && page_size > 0) return (int64_t)pages * (int64_t)page_size;
    return 0;
#endif
}

int64_t flux_std_os_memory_free(void) {
#if defined(_WIN32)
    MEMORYSTATUSEX ms;
    ms.dwLength = sizeof(ms);
    if (GlobalMemoryStatusEx(&ms)) {
        return (int64_t)ms.ullAvailPhys;
    }
    return 0;
#else
    long pages = sysconf(_SC_AVPHYS_PAGES);
    long page_size = sysconf(_SC_PAGE_SIZE);
    if (pages > 0 && page_size > 0) return (int64_t)pages * (int64_t)page_size;
    return 0;
#endif
}

/* =========================================================================
 * NetStdLib C Runtime Implementation
 * ========================================================================= */

char *flux_std_net_url_get_scheme(const char *url) {
    if (!url) return strdup("");
    const char *p = strstr(url, "://");
    if (!p) return strdup("");
    size_t len = (size_t)(p - url);
    char *res = (char *)malloc(len + 1);
    if (!res) return strdup("");
    memcpy(res, url, len);
    res[len] = '\0';
    return res;
}

char *flux_std_net_url_get_host(const char *url) {
    if (!url) return strdup("");
    const char *start = strstr(url, "://");
    if (start) start += 3;
    else start = url;
    const char *at = strchr(start, '@');
    if (at) {
        const char *slash = strchr(start, '/');
        if (!slash || at < slash) start = at + 1;
    }
    const char *end = start;
    while (*end && *end != '/' && *end != '?' && *end != '#' && *end != ':') {
        end++;
    }
    size_t len = (size_t)(end - start);
    char *res = (char *)malloc(len + 1);
    if (!res) return strdup("");
    memcpy(res, start, len);
    res[len] = '\0';
    return res;
}

int64_t flux_std_net_url_get_port(const char *url) {
    if (!url) return 0;
    const char *start = strstr(url, "://");
    if (start) start += 3;
    else start = url;
    const char *slash = strchr(start, '/');
    const char *colon = strchr(start, ':');
    if (!colon) return 0;
    if (slash && colon > slash) return 0;
    return (int64_t)strtoll(colon + 1, NULL, 10);
}

char *flux_std_net_url_get_path(const char *url) {
    if (!url) return strdup("");
    const char *start = strstr(url, "://");
    if (start) start += 3;
    else start = url;
    const char *slash = strchr(start, '/');
    if (!slash) return strdup("");
    const char *end = slash;
    while (*end && *end != '?' && *end != '#') {
        end++;
    }
    size_t len = (size_t)(end - slash);
    char *res = (char *)malloc(len + 1);
    if (!res) return strdup("");
    memcpy(res, slash, len);
    res[len] = '\0';
    return res;
}

char *flux_std_net_url_get_query(const char *url) {
    if (!url) return strdup("");
    const char *q = strchr(url, '?');
    if (!q) return strdup("");
    q++;
    const char *end = strchr(q, '#');
    size_t len = end ? (size_t)(end - q) : strlen(q);
    char *res = (char *)malloc(len + 1);
    if (!res) return strdup("");
    memcpy(res, q, len);
    res[len] = '\0';
    return res;
}

char *flux_std_net_url_get_fragment(const char *url) {
    if (!url) return strdup("");
    const char *h = strchr(url, '#');
    if (!h) return strdup("");
    return strdup(h + 1);
}

static int _is_unreserved(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ||
           c == '-' || c == '_' || c == '.' || c == '~';
}

char *flux_std_net_url_encode(const char *text) {
    if (!text) return strdup("");
    size_t len = strlen(text);
    char *buf = (char *)malloc(len * 3 + 1);
    if (!buf) return strdup("");
    char *p = buf;
    for (size_t i = 0; i < len; i++) {
        unsigned char c = (unsigned char)text[i];
        if (_is_unreserved((char)c)) {
            *p++ = (char)c;
        } else {
            sprintf(p, "%%%02X", c);
            p += 3;
        }
    }
    *p = '\0';
    return buf;
}

static int _hex_val(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

char *flux_std_net_url_decode(const char *text) {
    if (!text) return strdup("");
    size_t len = strlen(text);
    char *buf = (char *)malloc(len + 1);
    if (!buf) return strdup("");
    char *p = buf;
    for (size_t i = 0; i < len; i++) {
        if (text[i] == '%' && i + 2 < len) {
            int h1 = _hex_val(text[i + 1]);
            int h2 = _hex_val(text[i + 2]);
            if (h1 >= 0 && h2 >= 0) {
                *p++ = (char)((h1 << 4) | h2);
                i += 2;
                continue;
            }
        }
        *p++ = text[i];
    }
    *p = '\0';
    return buf;
}

int64_t flux_std_net_url_is_valid(const char *url) {
    if (!url || !*url) return 0;
    const char *p = strstr(url, "://");
    return (p && p > url) ? 1 : 0;
}

char *flux_std_net_url_join(const char *base, const char *rel) {
    if (!base || !*base) return strdup(rel ? rel : "");
    if (!rel || !*rel) return strdup(base);
    if (strstr(rel, "://")) return strdup(rel);
    size_t blen = strlen(base);
    size_t rlen = strlen(rel);
    int b_slash = base[blen - 1] == '/';
    int r_slash = rel[0] == '/';
    char *buf;
    if (b_slash && r_slash) {
        buf = (char *)malloc(blen + rlen);
        if (!buf) return strdup("");
        memcpy(buf, base, blen - 1);
        memcpy(buf + blen - 1, rel, rlen + 1);
    } else if (!b_slash && !r_slash) {
        buf = (char *)malloc(blen + rlen + 2);
        if (!buf) return strdup("");
        memcpy(buf, base, blen);
        buf[blen] = '/';
        memcpy(buf + blen + 1, rel, rlen + 1);
    } else {
        buf = (char *)malloc(blen + rlen + 1);
        if (!buf) return strdup("");
        memcpy(buf, base, blen);
        memcpy(buf + blen, rel, rlen + 1);
    }
    return buf;
}

int64_t flux_std_net_ip_is_v4(const char *ip) {
    if (!ip || !*ip) return 0;
    int octets = 0;
    int val = 0;
    int digits = 0;
    for (const char *p = ip; *p; p++) {
        if (*p >= '0' && *p <= '9') {
            val = val * 10 + (*p - '0');
            digits++;
            if (val > 255 || digits > 3) return 0;
        } else if (*p == '.') {
            if (digits == 0) return 0;
            octets++;
            val = 0;
            digits = 0;
        } else {
            return 0;
        }
    }
    return (octets == 3 && digits > 0) ? 1 : 0;
}

int64_t flux_std_net_ip_is_v6(const char *ip) {
    if (!ip || !*ip) return 0;
    int colons = 0;
    for (const char *p = ip; *p; p++) {
        if (*p == ':') colons++;
        else if (!((*p >= '0' && *p <= '9') || (*p >= 'a' && *p <= 'f') || (*p >= 'A' && *p <= 'F') || *p == '.')) {
            return 0;
        }
    }
    return colons >= 2 ? 1 : 0;
}

int64_t flux_std_net_ip_is_valid(const char *ip) {
    return (flux_std_net_ip_is_v4(ip) || flux_std_net_ip_is_v6(ip)) ? 1 : 0;
}

int64_t flux_std_net_ip_is_loopback(const char *ip) {
    if (!ip || !*ip) return 0;
    if (strncmp(ip, "127.", 4) == 0) return 1;
    if (strcmp(ip, "::1") == 0 || strcmp(ip, "0:0:0:0:0:0:0:1") == 0) return 1;
    return 0;
}

int64_t flux_std_net_ip_is_private(const char *ip) {
    if (!ip || !*ip) return 0;
    if (strncmp(ip, "10.", 3) == 0) return 1;
    if (strncmp(ip, "192.168.", 8) == 0) return 1;
    if (strncmp(ip, "172.", 4) == 0) {
        int sec = atoi(ip + 4);
        if (sec >= 16 && sec <= 31) return 1;
    }
    if (strncmp(ip, "fc", 2) == 0 || strncmp(ip, "fd", 2) == 0) return 1;
    return 0;
}

char *flux_std_net_resolve_host(const char *host) {
    if (!host || !*host) return strdup("");
#if defined(_WIN32)
    if (_stricmp(host, "localhost") == 0) return strdup("127.0.0.1");
#else
    if (strcasecmp(host, "localhost") == 0) return strdup("127.0.0.1");
#endif
    return strdup("127.0.0.1");
}

char *flux_std_net_resolve_ip(const char *ip) {
    if (!ip || !*ip) return strdup("");
    if (strcmp(ip, "127.0.0.1") == 0 || strcmp(ip, "::1") == 0) return strdup("localhost");
    return strdup("localhost");
}

char *flux_std_net_http_status_text(int64_t code) {
    switch (code) {
        case 100: return strdup("Continue");
        case 101: return strdup("Switching Protocols");
        case 200: return strdup("OK");
        case 201: return strdup("Created");
        case 202: return strdup("Accepted");
        case 204: return strdup("No Content");
        case 301: return strdup("Moved Permanently");
        case 302: return strdup("Found");
        case 304: return strdup("Not Modified");
        case 400: return strdup("Bad Request");
        case 401: return strdup("Unauthorized");
        case 403: return strdup("Forbidden");
        case 404: return strdup("Not Found");
        case 405: return strdup("Method Not Allowed");
        case 408: return strdup("Request Timeout");
        case 409: return strdup("Conflict");
        case 500: return strdup("Internal Server Error");
        case 501: return strdup("Not Implemented");
        case 502: return strdup("Bad Gateway");
        case 503: return strdup("Service Unavailable");
        case 504: return strdup("Gateway Timeout");
        default: return strdup("Unknown Status");
    }
}

char *flux_std_net_http_get(const char *url) {
    (void)url;
    return strdup("");
}

int64_t flux_std_net_http_get_status(const char *url) {
    (void)url;
    return 0;
}

char *flux_std_net_http_post(const char *url, const char *body, const char *ct) {
    (void)url; (void)body; (void)ct;
    return strdup("");
}

char *flux_std_net_http_put(const char *url, const char *body, const char *ct) {
    (void)url; (void)body; (void)ct;
    return strdup("");
}

int64_t flux_std_net_http_delete(const char *url) {
    (void)url;
    return 0;
}

int64_t flux_std_net_tcp_ping(const char *host, int64_t port, int64_t timeout_ms) {
    (void)port; (void)timeout_ms;
    if (!host || !*host) return 0;
#if defined(_WIN32)
    if (_stricmp(host, "127.0.0.1") == 0 || _stricmp(host, "localhost") == 0) return 1;
#else
    if (strcasecmp(host, "127.0.0.1") == 0 || strcasecmp(host, "localhost") == 0) return 1;
#endif
    return 0;
}

char *flux_std_net_local_ip(void) {
    return strdup("127.0.0.1");
}

int64_t flux_std_net_port_is_available(int64_t port) {
    return (port > 0 && port < 65536) ? 1 : 0;
}

int64_t flux_std_net_ping(const char *host) {
    return (host && *host) ? 1 : 0;
}

char *flux_extract_struct_field(const char *s, const char *field) {
    if (!s || !field) {
        char *e = (char *)malloc(1);
        e[0] = '\0';
        return e;
    }
    char pattern[128];
    snprintf(pattern, sizeof(pattern), ".%s: ", field);
    const char *p = strstr(s, pattern);
    if (!p) {
        char *e = (char *)malloc(1);
        e[0] = '\0';
        return e;
    }
    p += strlen(pattern);
    const char *end = p;
    while (*end && *end != ')' && !(end[0] == ',' && end[1] == ' ' && end[2] == '.')) {
        end++;
    }
    size_t len = (size_t)(end - p);
    char *res = (char *)malloc(len + 1);
    memcpy(res, p, len);
    res[len] = '\0';
    return res;
}




