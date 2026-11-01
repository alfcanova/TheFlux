#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#if defined(_WIN32)
#include <windows.h>
#define timegm _mkgmtime
#endif

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


char *flux_std_datetime_to_iso8601(int64_t epoch_sec) {
    time_t t = (time_t)epoch_sec;
    struct tm *tmv = gmtime(&t);
    char buf[64];
    if (tmv) {
        strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%SZ", tmv);
    } else {
        strcpy(buf, "1970-01-01T00:00:00Z");
    }
    return strdup(buf);
}
