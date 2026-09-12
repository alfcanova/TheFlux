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



