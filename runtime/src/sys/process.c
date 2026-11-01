#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#if defined(_WIN32)
#include <windows.h>
#include <process.h>
#include <tlhelp32.h>
#include <direct.h>
#else
#include <unistd.h>
#include <sys/types.h>
#endif

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

int64_t flux_std_os_exit(int64_t code) {
    exit((int)code);
    return 0;
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

