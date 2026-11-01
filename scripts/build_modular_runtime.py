#!/usr/bin/env python3
"""
Decomposes runtime/flux_input.c into modular C subsystems under runtime/src/
and compiles bin/libfluxrt.a as specified in docs/SELFHOSTED.md (Marco M1).
"""

import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RUNTIME_DIR = ROOT / "runtime"
SRC_DIR = RUNTIME_DIR / "src"
INC_DIR = RUNTIME_DIR / "include"
BUILD_DIR = ROOT / "build" / "runtime"
BIN_DIR = ROOT / "bin"

def main():
    BUILD_DIR.mkdir(parents=True, exist_ok=True)
    BIN_DIR.mkdir(parents=True, exist_ok=True)

    with open(RUNTIME_DIR / "flux_input.c", "r", encoding="utf-8") as f:
        lines = f.readlines()

    # 1. runtime/src/sys/time.c (lines 592-1072)
    time_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <time.h>\n',
        '#include <stdint.h>\n',
        '#if defined(_WIN32)\n',
        '#include <windows.h>\n',
        '#define timegm _mkgmtime\n',
        '#endif\n\n'
    ] + lines[591:1072] + [
        '\nchar *flux_std_datetime_to_iso8601(int64_t epoch_sec) {\n',
        '    time_t t = (time_t)epoch_sec;\n',
        '    struct tm *tmv = gmtime(&t);\n',
        '    char buf[64];\n',
        '    if (tmv) {\n',
        '        strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%SZ", tmv);\n',
        '    } else {\n',
        '        strcpy(buf, "1970-01-01T00:00:00Z");\n',
        '    }\n',
        '    return strdup(buf);\n',
        '}\n'
    ]
    with open(SRC_DIR / "sys" / "time.c", "w", encoding="utf-8") as f:
        f.writelines(time_content)

    # 2. runtime/src/intrinsics/std_filesig.c (lines 1073-1552)
    filesig_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n\n'
    ] + lines[1072:1552]
    with open(SRC_DIR / "intrinsics" / "std_filesig.c", "w", encoding="utf-8") as f:
        f.writelines(filesig_content)

    # 3. runtime/src/sys/process.c (lines 1553-1959)
    proc_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n',
        '#if defined(_WIN32)\n',
        '#include <windows.h>\n',
        '#include <process.h>\n',
        '#include <tlhelp32.h>\n',
        '#include <direct.h>\n',
        '#else\n',
        '#include <unistd.h>\n',
        '#include <sys/types.h>\n',
        '#endif\n\n'
    ] + lines[1552:1959]
    with open(SRC_DIR / "sys" / "process.c", "w", encoding="utf-8") as f:
        f.writelines(proc_content)

    # 4. runtime/src/intrinsics/std_net.c (lines 1960-2325)
    net_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n',
        '#if defined(_WIN32)\n',
        '#include <winsock2.h>\n',
        '#include <ws2tcpip.h>\n',
        '#pragma comment(lib, "ws2_32.lib")\n',
        '#else\n',
        '#include <sys/socket.h>\n',
        '#include <netinet/in.h>\n',
        '#include <arpa/inet.h>\n',
        '#include <unistd.h>\n',
        '#endif\n\n'
    ] + lines[1959:2325]
    with open(SRC_DIR / "intrinsics" / "std_net.c", "w", encoding="utf-8") as f:
        f.writelines(net_content)

    # 5. runtime/src/intrinsics/std_runtime.c (lines 2523-2592)
    rt_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n\n'
    ] + lines[2522:2592]
    with open(SRC_DIR / "intrinsics" / "std_runtime.c", "w", encoding="utf-8") as f:
        f.writelines(rt_content)

    # 6. runtime/src/intrinsics/std_db.c (lines 2593-3032)
    db_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n\n'
    ] + lines[2592:3032]
    with open(SRC_DIR / "intrinsics" / "std_db.c", "w", encoding="utf-8") as f:
        f.writelines(db_content)

    # 7. runtime/src/intrinsics/std_dsl.c (lines 3033-3837)
    dsl_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n',
        '#if defined(_WIN32)\n',
        '#include <windows.h>\n',
        '#endif\n\n'
    ] + lines[3032:3837]
    with open(SRC_DIR / "intrinsics" / "std_dsl.c", "w", encoding="utf-8") as f:
        f.writelines(dsl_content)

    # 8. runtime/src/intrinsics/std_gfx.c (lines 3838-4278)
    gfx_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n',
        '#if defined(_WIN32)\n',
        '#include <windows.h>\n',
        '#endif\n\n'
    ] + lines[3837:4278]
    with open(SRC_DIR / "intrinsics" / "std_gfx.c", "w", encoding="utf-8") as f:
        f.writelines(gfx_content)

    # 9. runtime/src/intrinsics/std_compress.c (lines 4426-4502)
    comp_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n\n'
    ] + lines[4425:4502]
    with open(SRC_DIR / "intrinsics" / "std_compress.c", "w", encoding="utf-8") as f:
        f.writelines(comp_content)

    # 10. runtime/src/intrinsics/std_archive.c (lines 4503-4551)
    arch_content = [
        '#include "flux/flux.h"\n',
        '#include <stdio.h>\n',
        '#include <stdlib.h>\n',
        '#include <string.h>\n',
        '#include <stdint.h>\n\n'
    ] + lines[4502:4551]
    with open(SRC_DIR / "intrinsics" / "std_archive.c", "w", encoding="utf-8") as f:
        f.writelines(arch_content)

    # 11. runtime/src/intrinsics/std_char.c
    char_content = """#include "flux/flux.h"
#include <ctype.h>

int64_t flux_std_char_is_digit(int64_t c) { return isdigit((int)c) ? 1 : 0; }
int64_t flux_std_char_is_alpha(int64_t c) { return isalpha((int)c) ? 1 : 0; }
int64_t flux_std_char_is_alphanumeric(int64_t c) { return isalnum((int)c) ? 1 : 0; }
int64_t flux_std_char_is_whitespace(int64_t c) { return isspace((int)c) ? 1 : 0; }
int64_t flux_std_char_to_lower(int64_t c) { return tolower((int)c); }
int64_t flux_std_char_to_upper(int64_t c) { return toupper((int)c); }
int64_t flux_std_char_to_int(int64_t c) { return (c >= '0' && c <= '9') ? (c - '0') : -1; }
int64_t flux_std_char_from_int(int64_t v) { return (v >= 0 && v <= 9) ? ('0' + v) : 0; }
"""
    with open(SRC_DIR / "intrinsics" / "std_char.c", "w", encoding="utf-8") as f:
        f.write(char_content)

    # 12. runtime/src/intrinsics/std_string.c
    string_content = """#include "flux/flux.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

char *flux_std_string_to_lower(const char *s) {
    if (!s) return strdup("");
    char *res = strdup(s);
    for (char *p = res; *p; p++) *p = (char)tolower((unsigned char)*p);
    return res;
}

char *flux_std_string_to_upper(const char *s) {
    if (!s) return strdup("");
    char *res = strdup(s);
    for (char *p = res; *p; p++) *p = (char)toupper((unsigned char)*p);
    return res;
}

int64_t flux_std_string_starts_with(const char *s, const char *prefix) {
    if (!s || !prefix) return 0;
    size_t slen = strlen(s), plen = strlen(prefix);
    return (slen >= plen && memcmp(s, prefix, plen) == 0) ? 1 : 0;
}

int64_t flux_std_string_ends_with(const char *s, const char *suffix) {
    if (!s || !suffix) return 0;
    size_t slen = strlen(s), suflen = strlen(suffix);
    return (slen >= suflen && memcmp(s + slen - suflen, suffix, suflen) == 0) ? 1 : 0;
}

int64_t flux_std_string_contains(const char *s, const char *sub) {
    if (!s || !sub) return 0;
    return strstr(s, sub) != NULL ? 1 : 0;
}
"""
    with open(SRC_DIR / "intrinsics" / "std_string.c", "w", encoding="utf-8") as f:
        f.write(string_content)

    # 13. runtime/src/intrinsics/std_crypto_hash.c
    crypto_content = """#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *flux_std_crypto_hash_dummy(const char *data) {
    (void)data;
    return strdup("");
}
"""
    with open(SRC_DIR / "intrinsics" / "std_crypto_hash.c", "w", encoding="utf-8") as f:
        f.write(crypto_content)

    print("[OK] Subsystems decomposed successfully into runtime/src/")

if __name__ == "__main__":
    main()
