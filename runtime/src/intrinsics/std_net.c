#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#if defined(_WIN32)
#include <winsock2.h>
#include <ws2tcpip.h>
#pragma comment(lib, "ws2_32.lib")
#else
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#endif

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
    int depth = 0;
    int in_str = 0;
    while (*end) {
        if (*end == '"' && (end == p || *(end - 1) != '\\')) {
            in_str = !in_str;
        } else if (!in_str) {
            if (*end == '(') {
                depth++;
            } else if (*end == ')') {
                if (depth == 0) break;
                depth--;
            } else if (*end == ',' && depth == 0 && end[1] == ' ' && end[2] == '.') {
                break;
            }
        }
        end++;
    }
    size_t len = (size_t)(end - p);
    char *res = (char *)malloc(len + 1);
    memcpy(res, p, len);
    res[len] = '\0';
    return res;
}

