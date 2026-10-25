from __future__ import annotations

import http
import http.client
import ipaddress
import socket
import urllib.parse
import urllib.request


# ==============================================================================
# NetUrlContract
# ==============================================================================

def net_url_get_scheme(url: str) -> str:
    try:
        return urllib.parse.urlsplit(str(url)).scheme
    except Exception:
        return ""


def net_url_get_host(url: str) -> str:
    try:
        return urllib.parse.urlsplit(str(url)).hostname or ""
    except Exception:
        return ""


def net_url_get_port(url: str) -> int:
    try:
        p = urllib.parse.urlsplit(str(url)).port
        return int(p) if p is not None else 0
    except Exception:
        return 0


def net_url_get_path(url: str) -> str:
    try:
        return urllib.parse.urlsplit(str(url)).path
    except Exception:
        return ""


def net_url_get_query(url: str) -> str:
    try:
        return urllib.parse.urlsplit(str(url)).query
    except Exception:
        return ""


def net_url_get_fragment(url: str) -> str:
    try:
        return urllib.parse.urlsplit(str(url)).fragment
    except Exception:
        return ""


def net_url_encode(text: str) -> str:
    try:
        return urllib.parse.quote(str(text), safe="")
    except Exception:
        return str(text)


def net_url_decode(text: str) -> str:
    try:
        return urllib.parse.unquote(str(text))
    except Exception:
        return str(text)


def net_url_is_valid(url: str) -> bool:
    try:
        parsed = urllib.parse.urlsplit(str(url))
        return bool(parsed.scheme and (parsed.netloc or parsed.path))
    except Exception:
        return False


def net_url_join(base_url: str, relative_path: str) -> str:
    try:
        return urllib.parse.urljoin(str(base_url), str(relative_path))
    except Exception:
        return str(base_url)


# ==============================================================================
# NetIpContract
# ==============================================================================

def net_ip_is_valid(ip: str) -> bool:
    try:
        ipaddress.ip_address(str(ip).strip())
        return True
    except Exception:
        return False


def net_ip_is_v4(ip: str) -> bool:
    try:
        addr = ipaddress.ip_address(str(ip).strip())
        return isinstance(addr, ipaddress.IPv4Address)
    except Exception:
        return False


def net_ip_is_v6(ip: str) -> bool:
    try:
        addr = ipaddress.ip_address(str(ip).strip())
        return isinstance(addr, ipaddress.IPv6Address)
    except Exception:
        return False


def net_ip_is_loopback(ip: str) -> bool:
    try:
        addr = ipaddress.ip_address(str(ip).strip())
        return addr.is_loopback
    except Exception:
        return False


def net_ip_is_private(ip: str) -> bool:
    try:
        addr = ipaddress.ip_address(str(ip).strip())
        return addr.is_private
    except Exception:
        return False


def net_resolve_host(host: str) -> str:
    try:
        h = str(host).strip()
        if h.lower() == "localhost":
            return "127.0.0.1"
        return socket.gethostbyname(h)
    except Exception:
        return "127.0.0.1" if str(host).strip().lower() == "localhost" else ""


def net_resolve_ip(ip: str) -> str:
    try:
        res = socket.gethostbyaddr(str(ip).strip())
        return res[0]
    except Exception:
        return "localhost" if str(ip).strip() in ("127.0.0.1", "::1") else ""


# ==============================================================================
# NetHttpContract
# ==============================================================================

_STATUS_TEXTS = {
    100: "Continue", 101: "Switching Protocols",
    200: "OK", 201: "Created", 202: "Accepted", 204: "No Content",
    301: "Moved Permanently", 302: "Found", 304: "Not Modified",
    400: "Bad Request", 401: "Unauthorized", 403: "Forbidden", 404: "Not Found",
    405: "Method Not Allowed", 408: "Request Timeout", 409: "Conflict",
    500: "Internal Server Error", 501: "Not Implemented", 502: "Bad Gateway",
    503: "Service Unavailable", 504: "Gateway Timeout",
}


def net_http_status_text(status_code: int) -> str:
    try:
        c = int(status_code)
        if c in _STATUS_TEXTS:
            return _STATUS_TEXTS[c]
        status = http.HTTPStatus(c)
        return status.phrase
    except Exception:
        return "Unknown Status"


def net_http_get(url: str) -> str:
    try:
        req = urllib.request.Request(str(url), headers={"User-Agent": "TheFlux/1.0"})
        with urllib.request.urlopen(req, timeout=5) as resp:
            return resp.read().decode("utf-8", errors="replace")
    except Exception:
        return ""


def net_http_get_status(url: str) -> int:
    try:
        req = urllib.request.Request(str(url), headers={"User-Agent": "TheFlux/1.0"})
        with urllib.request.urlopen(req, timeout=5) as resp:
            return int(resp.status)
    except urllib.error.HTTPError as e:
        return int(e.code)
    except Exception:
        return 0


def net_http_post(url: str, body: str, content_type: str) -> str:
    try:
        data = str(body).encode("utf-8")
        headers = {"User-Agent": "TheFlux/1.0"}
        if content_type:
            headers["Content-Type"] = str(content_type)
        req = urllib.request.Request(str(url), data=data, headers=headers, method="POST")
        with urllib.request.urlopen(req, timeout=5) as resp:
            return resp.read().decode("utf-8", errors="replace")
    except Exception:
        return ""


def net_http_put(url: str, body: str, content_type: str) -> str:
    try:
        data = str(body).encode("utf-8")
        headers = {"User-Agent": "TheFlux/1.0"}
        if content_type:
            headers["Content-Type"] = str(content_type)
        req = urllib.request.Request(str(url), data=data, headers=headers, method="PUT")
        with urllib.request.urlopen(req, timeout=5) as resp:
            return resp.read().decode("utf-8", errors="replace")
    except Exception:
        return ""


def net_http_delete(url: str) -> int:
    try:
        req = urllib.request.Request(str(url), headers={"User-Agent": "TheFlux/1.0"}, method="DELETE")
        with urllib.request.urlopen(req, timeout=5) as resp:
            return int(resp.status)
    except urllib.error.HTTPError as e:
        return int(e.code)
    except Exception:
        return 0


# ==============================================================================
# NetSocketContract
# ==============================================================================

def net_tcp_ping(host: str, port: int, timeout_ms: int) -> bool:
    try:
        t_sec = max(0.001, int(timeout_ms) / 1000.0)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(t_sec)
        res = s.connect_ex((str(host), int(port)))
        s.close()
        return res == 0
    except Exception:
        return False


def net_local_ip() -> str:
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        try:
            return socket.gethostbyname(socket.gethostname())
        except Exception:
            return "127.0.0.1"


def net_port_is_available(port: int) -> bool:
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.bind(("", int(port)))
        s.close()
        return True
    except Exception:
        return False


def net_ping(host: str) -> bool:
    try:
        h = str(host).strip()
        if not h:
            return False
        addr = socket.gethostbyname(h)
        return bool(addr)
    except Exception:
        return False
