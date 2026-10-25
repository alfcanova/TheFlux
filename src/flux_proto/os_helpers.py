from __future__ import annotations

import getpass
import os
import platform
import socket
import subprocess
import sys
import tempfile
import time


def os_get_env(name: str) -> str:
    return os.environ.get(str(name), "")


def os_get_env_or_default(name: str, default: str) -> str:
    return os.environ.get(str(name), str(default))


def os_set_env(name: str, value: str) -> bool:
    try:
        os.environ[str(name)] = str(value)
        return True
    except Exception:
        return False


def os_has_env(name: str) -> bool:
    return str(name) in os.environ


def os_unset_env(name: str) -> bool:
    try:
        if str(name) in os.environ:
            del os.environ[str(name)]
        return True
    except Exception:
        return False


def os_list_env() -> list[str]:
    return sorted(list(os.environ.keys()))


def os_platform() -> str:
    p = sys.platform.lower()
    if p.startswith("win"):
        return "windows"
    if p.startswith("linux"):
        return "linux"
    if p.startswith("darwin"):
        return "macos"
    return "unknown"


def os_arch() -> str:
    m = platform.machine().lower()
    if m in ("amd64", "x86_64"):
        return "x86_64"
    if m in ("arm64", "aarch64"):
        return "arm64"
    if m in ("x86", "i386", "i686"):
        return "x86"
    return m or "x86_64"


def os_family() -> str:
    return "windows" if os.name == "nt" else "unix"


def os_hostname() -> str:
    try:
        return socket.gethostname().lower()
    except Exception:
        return "localhost"


def os_line_separator() -> str:
    return os.linesep


def os_path_separator() -> str:
    return os.pathsep


def os_dir_separator() -> str:
    return os.sep


def os_get_pid() -> int:
    try:
        return os.getpid()
    except Exception:
        return 1


def os_get_parent_pid() -> int:
    try:
        return os.getppid()
    except Exception:
        return 0


def os_cwd() -> str:
    try:
        return os.getcwd().replace("\\", "/")
    except Exception:
        return "."


def os_chdir(path: str) -> bool:
    try:
        os.chdir(str(path))
        return True
    except Exception:
        return False


def os_exec(command: str) -> int:
    try:
        res = subprocess.run(str(command), shell=True)
        return res.returncode
    except Exception:
        return -1


def os_exec_output(command: str) -> str:
    try:
        res = subprocess.run(
            str(command), shell=True, capture_output=True, text=True, encoding="utf-8", errors="replace"
        )
        return res.stdout.strip()
    except Exception:
        return ""


def os_sleep(ms: int) -> bool:
    try:
        time.sleep(max(0, int(ms)) / 1000.0)
        return True
    except Exception:
        return False


def os_user_name() -> str:
    try:
        return getpass.getuser()
    except Exception:
        return os.environ.get("USERNAME", os.environ.get("USER", "user"))


def os_home_dir() -> str:
    try:
        return os.path.expanduser("~").replace("\\", "/")
    except Exception:
        return os.environ.get("USERPROFILE", os.environ.get("HOME", "/")).replace("\\", "/")


def os_temp_dir() -> str:
    try:
        return tempfile.gettempdir().replace("\\", "/")
    except Exception:
        return "/tmp"


def os_cpu_count() -> int:
    try:
        cnt = os.cpu_count()
        return cnt if cnt and cnt > 0 else 1
    except Exception:
        return 1


def os_uptime() -> int:
    if os.name == "nt":
        try:
            import ctypes
            kernel32 = ctypes.windll.kernel32
            return int(kernel32.GetTickCount64() // 1000)
        except Exception:
            return 3600
    else:
        try:
            with open("/proc/uptime", "r") as f:
                return int(float(f.readline().split()[0]))
        except Exception:
            return 3600


def os_memory_total() -> int:
    if os.name == "nt":
        try:
            import ctypes
            class MEMORYSTATUSEX(ctypes.Structure):
                _fields_ = [
                    ("dwLength", ctypes.c_ulong),
                    ("dwMemoryLoad", ctypes.c_ulong),
                    ("ullTotalPhys", ctypes.c_ulonglong),
                    ("ullAvailPhys", ctypes.c_ulonglong),
                    ("ullTotalPageFile", ctypes.c_ulonglong),
                    ("ullAvailPageFile", ctypes.c_ulonglong),
                    ("ullTotalVirtual", ctypes.c_ulonglong),
                    ("ullAvailVirtual", ctypes.c_ulonglong),
                    ("sullAvailExtendedVirtual", ctypes.c_ulonglong),
                ]
            stat = MEMORYSTATUSEX()
            stat.dwLength = ctypes.sizeof(stat)
            if ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(stat)):
                return int(stat.ullTotalPhys)
        except Exception:
            pass
    return 8 * 1024 * 1024 * 1024  # 8 GB fallback


def os_memory_free() -> int:
    if os.name == "nt":
        try:
            import ctypes
            class MEMORYSTATUSEX(ctypes.Structure):
                _fields_ = [
                    ("dwLength", ctypes.c_ulong),
                    ("dwMemoryLoad", ctypes.c_ulong),
                    ("ullTotalPhys", ctypes.c_ulonglong),
                    ("ullAvailPhys", ctypes.c_ulonglong),
                    ("ullTotalPageFile", ctypes.c_ulonglong),
                    ("ullAvailPageFile", ctypes.c_ulonglong),
                    ("ullTotalVirtual", ctypes.c_ulonglong),
                    ("ullAvailVirtual", ctypes.c_ulonglong),
                    ("sullAvailExtendedVirtual", ctypes.c_ulonglong),
                ]
            stat = MEMORYSTATUSEX()
            stat.dwLength = ctypes.sizeof(stat)
            if ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(stat)):
                return int(stat.ullAvailPhys)
        except Exception:
            pass
    return 4 * 1024 * 1024 * 1024  # 4 GB fallback
