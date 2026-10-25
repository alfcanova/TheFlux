"""TheFlux Graphics Engine: Native Win32 GDI & Double-Buffered Window Driver.

Provides real on-screen rendering, double-buffering, HTML5 Canvas generation,
and input polling for the AST Interpreter and VM runtimes.
"""
from __future__ import annotations

import sys
import os
import time
from typing import Any

# Global event state tracking
_last_event_x: int = 0
_last_event_y: int = 0
_last_event_key: int = 0

_windows: dict[int, dict[str, Any]] = {}
_next_win_id: int = 1

_IS_WINDOWS = sys.platform == "win32"

if _IS_WINDOWS:
    import ctypes
    from ctypes import wintypes

    kernel32 = ctypes.windll.kernel32
    user32 = ctypes.windll.user32
    gdi32 = ctypes.windll.gdi32

    # Win32 Constants
    CS_HREDRAW = 0x0002
    CS_VREDRAW = 0x0001
    WS_OVERLAPPED = 0x00000000
    WS_CAPTION = 0x00C00000
    WS_SYSMENU = 0x00080000
    WS_MINIMIZEBOX = 0x00020000
    WS_VISIBLE = 0x10000000
    WS_WINDOW_STYLE = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_VISIBLE

    SW_SHOW = 5
    PM_REMOVE = 0x0001
    TRANSPARENT = 1
    NULL_BRUSH = 5
    SRCCOPY = 0x00CC0020

    WM_DESTROY = 0x0002
    WM_PAINT = 0x000F
    WM_CLOSE = 0x0010
    WM_ERASEBKGND = 0x0014
    WM_KEYDOWN = 0x0100
    WM_MOUSEMOVE = 0x0200
    WM_LBUTTONDOWN = 0x0201
    WM_RBUTTONDOWN = 0x0204

    # Win32 Function Signatures for 64-bit Architecture
    kernel32.GetModuleHandleW.argtypes = [wintypes.LPCWSTR]
    kernel32.GetModuleHandleW.restype = wintypes.HMODULE

    user32.DefWindowProcW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM]
    user32.DefWindowProcW.restype = wintypes.LPARAM

    user32.AdjustWindowRect.argtypes = [ctypes.POINTER(wintypes.RECT), wintypes.DWORD, wintypes.BOOL]
    user32.AdjustWindowRect.restype = wintypes.BOOL

    user32.CreateWindowExW.argtypes = [
        wintypes.DWORD, wintypes.LPCWSTR, wintypes.LPCWSTR, wintypes.DWORD,
        ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int,
        wintypes.HWND, wintypes.HMENU, wintypes.HINSTANCE, wintypes.LPVOID
    ]
    user32.CreateWindowExW.restype = wintypes.HWND

    user32.ShowWindow.argtypes = [wintypes.HWND, ctypes.c_int]
    user32.ShowWindow.restype = wintypes.BOOL

    user32.UpdateWindow.argtypes = [wintypes.HWND]
    user32.UpdateWindow.restype = wintypes.BOOL

    user32.GetDC.argtypes = [wintypes.HWND]
    user32.GetDC.restype = wintypes.HDC

    user32.ReleaseDC.argtypes = [wintypes.HWND, wintypes.HDC]
    user32.ReleaseDC.restype = ctypes.c_int

    user32.DestroyWindow.argtypes = [wintypes.HWND]
    user32.DestroyWindow.restype = wintypes.BOOL

    user32.FillRect.argtypes = [wintypes.HDC, ctypes.POINTER(wintypes.RECT), wintypes.HBRUSH]
    user32.FillRect.restype = ctypes.c_int

    class PAINTSTRUCT(ctypes.Structure):
        _fields_ = [
            ("hdc", wintypes.HDC),
            ("fErase", wintypes.BOOL),
            ("rcPaint", wintypes.RECT),
            ("fRestore", wintypes.BOOL),
            ("fIncUpdate", wintypes.BOOL),
            ("rgbReserved", ctypes.c_byte * 32),
        ]

    user32.BeginPaint.argtypes = [wintypes.HWND, ctypes.POINTER(PAINTSTRUCT)]
    user32.BeginPaint.restype = wintypes.HDC

    user32.EndPaint.argtypes = [wintypes.HWND, ctypes.POINTER(PAINTSTRUCT)]
    user32.EndPaint.restype = wintypes.BOOL

    user32.PeekMessageW.argtypes = [ctypes.POINTER(wintypes.MSG), wintypes.HWND, wintypes.UINT, wintypes.UINT, wintypes.UINT]
    user32.PeekMessageW.restype = wintypes.BOOL

    user32.TranslateMessage.argtypes = [ctypes.POINTER(wintypes.MSG)]
    user32.TranslateMessage.restype = wintypes.BOOL

    user32.DispatchMessageW.argtypes = [ctypes.POINTER(wintypes.MSG)]
    user32.DispatchMessageW.restype = wintypes.LPARAM

    gdi32.CreateCompatibleDC.argtypes = [wintypes.HDC]
    gdi32.CreateCompatibleDC.restype = wintypes.HDC

    gdi32.CreateCompatibleBitmap.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int]
    gdi32.CreateCompatibleBitmap.restype = wintypes.HBITMAP

    gdi32.SelectObject.argtypes = [wintypes.HDC, wintypes.HGDIOBJ]
    gdi32.SelectObject.restype = wintypes.HGDIOBJ

    gdi32.DeleteObject.argtypes = [wintypes.HGDIOBJ]
    gdi32.DeleteObject.restype = wintypes.BOOL

    gdi32.DeleteDC.argtypes = [wintypes.HDC]
    gdi32.DeleteDC.restype = wintypes.BOOL

    gdi32.BitBlt.argtypes = [
        wintypes.HDC, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int,
        wintypes.HDC, ctypes.c_int, ctypes.c_int, wintypes.DWORD
    ]
    gdi32.BitBlt.restype = wintypes.BOOL

    gdi32.GdiFlush.argtypes = []
    gdi32.GdiFlush.restype = wintypes.BOOL

    gdi32.CreateSolidBrush.argtypes = [wintypes.COLORREF]
    gdi32.CreateSolidBrush.restype = wintypes.HBRUSH

    gdi32.CreatePen.argtypes = [ctypes.c_int, ctypes.c_int, wintypes.COLORREF]
    gdi32.CreatePen.restype = wintypes.HPEN

    gdi32.Rectangle.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int]
    gdi32.Rectangle.restype = wintypes.BOOL

    gdi32.Ellipse.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int]
    gdi32.Ellipse.restype = wintypes.BOOL

    gdi32.MoveToEx.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int, ctypes.c_void_p]
    gdi32.MoveToEx.restype = wintypes.BOOL

    gdi32.LineTo.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int]
    gdi32.LineTo.restype = wintypes.BOOL

    gdi32.SetBkMode.argtypes = [wintypes.HDC, ctypes.c_int]
    gdi32.SetBkMode.restype = ctypes.c_int

    gdi32.SetTextColor.argtypes = [wintypes.HDC, wintypes.COLORREF]
    gdi32.SetTextColor.restype = wintypes.COLORREF

    gdi32.TextOutW.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int, wintypes.LPCWSTR, ctypes.c_int]
    gdi32.TextOutW.restype = wintypes.BOOL

    gdi32.GetStockObject.argtypes = [ctypes.c_int]
    gdi32.GetStockObject.restype = wintypes.HGDIOBJ

    # Win32 Structs
    WNDPROC = ctypes.WINFUNCTYPE(wintypes.LPARAM, wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM)

    class WNDCLASSEXW(ctypes.Structure):
        _fields_ = [
            ("cbSize", wintypes.UINT),
            ("style", wintypes.UINT),
            ("lpfnWndProc", WNDPROC),
            ("cbClsExtra", ctypes.c_int),
            ("cbWndExtra", ctypes.c_int),
            ("hInstance", wintypes.HINSTANCE),
            ("hIcon", wintypes.HICON),
            ("hCursor", wintypes.HICON),
            ("hbrBackground", wintypes.HBRUSH),
            ("lpszMenuName", wintypes.LPCWSTR),
            ("lpszClassName", wintypes.LPCWSTR),
            ("hIconSm", wintypes.HICON),
        ]

    _class_registered = False
    _CLASS_NAME = "TheFluxNativeGfxClass"

    def _rgb(r: int, g: int, b: int) -> int:
        r = max(0, min(255, int(r)))
        g = max(0, min(255, int(g)))
        b = max(0, min(255, int(b)))
        return (b << 16) | (g << 8) | r

    def _default_wnd_proc(hwnd: int, msg: int, wparam: int, lparam: int) -> int:
        if msg == WM_DESTROY:
            user32.PostQuitMessage(0)
            return 0
        elif msg == WM_ERASEBKGND:
            return 1
        elif msg == WM_PAINT:
            ps = PAINTSTRUCT()
            hdc = user32.BeginPaint(hwnd, ctypes.byref(ps))
            if hdc:
                for w in _windows.values():
                    if w.get("hwnd") == hwnd and w.get("mem_dc"):
                        gdi32.BitBlt(hdc, 0, 0, w["w"], w["h"], w["mem_dc"], 0, 0, SRCCOPY)
                        break
                user32.EndPaint(hwnd, ctypes.byref(ps))
            return 0
        elif msg == WM_CLOSE:
            for w in _windows.values():
                if w.get("hwnd") == hwnd:
                    w["closed"] = True
                    break
            user32.DestroyWindow(hwnd)
            return 0
        return user32.DefWindowProcW(hwnd, msg, wparam, lparam)

    _proc_ref = WNDPROC(_default_wnd_proc)

    def _ensure_class_registered() -> None:
        global _class_registered
        if _class_registered:
            return
        wcex = WNDCLASSEXW()
        wcex.cbSize = ctypes.sizeof(WNDCLASSEXW)
        wcex.style = CS_HREDRAW | CS_VREDRAW
        wcex.lpfnWndProc = _proc_ref
        wcex.cbClsExtra = 0
        wcex.cbWndExtra = 0
        wcex.hInstance = kernel32.GetModuleHandleW(None)
        wcex.hIcon = user32.LoadIconW(None, ctypes.c_wchar_p(32512))  # IDI_APPLICATION
        wcex.hCursor = user32.LoadCursorW(None, ctypes.c_wchar_p(32512))  # IDC_ARROW
        wcex.hbrBackground = gdi32.GetStockObject(NULL_BRUSH)
        wcex.lpszMenuName = None
        wcex.lpszClassName = _CLASS_NAME
        wcex.hIconSm = None
        user32.RegisterClassExW(ctypes.byref(wcex))
        _class_registered = True


def gfx_window_create(w: int, h: int, title: str) -> int:
    global _next_win_id
    win_id = _next_win_id
    _next_win_id += 1

    width = max(10, int(w))
    height = max(10, int(h))
    title_str = str(title)

    if not _IS_WINDOWS:
        _windows[win_id] = {
            "w": width, "h": height, "title": title_str, "closed": False,
            "events": [], "commands": []
        }
        return win_id

    try:
        _ensure_class_registered()

        # Adjust window dimensions so client area matches (w, h)
        rect = wintypes.RECT(0, 0, width, height)
        user32.AdjustWindowRect(ctypes.byref(rect), WS_WINDOW_STYLE, False)
        win_w = rect.right - rect.left
        win_h = rect.bottom - rect.top

        hwnd = user32.CreateWindowExW(
            0,
            _CLASS_NAME,
            title_str,
            WS_WINDOW_STYLE,
            100, 100,
            win_w, win_h,
            None, None,
            kernel32.GetModuleHandleW(None),
            None
        )

        if not hwnd:
            _windows[win_id] = {"w": width, "h": height, "title": title_str, "closed": False, "events": [], "commands": []}
            return win_id

        user32.ShowWindow(hwnd, SW_SHOW)
        user32.UpdateWindow(hwnd)

        # Offscreen double-buffer setup
        win_dc = user32.GetDC(hwnd)
        mem_dc = gdi32.CreateCompatibleDC(win_dc)
        mem_bmp = gdi32.CreateCompatibleBitmap(win_dc, width, height)
        old_bmp = gdi32.SelectObject(mem_dc, mem_bmp)

        _windows[win_id] = {
            "hwnd": hwnd,
            "win_dc": win_dc,
            "mem_dc": mem_dc,
            "mem_bmp": mem_bmp,
            "old_bmp": old_bmp,
            "w": width,
            "h": height,
            "title": title_str,
            "closed": False,
            "events": [],
            "commands": []
        }

        # Clear background initially to dark
        gfx_clear(win_id, 30, 30, 35)
        gfx_window_flush(win_id)

    except Exception:
        _windows[win_id] = {"w": width, "h": height, "title": title_str, "closed": False, "events": [], "commands": []}

    return win_id


def gfx_window_close(win_id: int) -> int:
    w = _windows.get(win_id)
    if not w:
        return 0
    w["closed"] = True
    if _IS_WINDOWS and "hwnd" in w and w["hwnd"]:
        try:
            gdi32.SelectObject(w["mem_dc"], w["old_bmp"])
            gdi32.DeleteObject(w["mem_bmp"])
            gdi32.DeleteDC(w["mem_dc"])
            user32.ReleaseDC(w["hwnd"], w["win_dc"])
            user32.DestroyWindow(w["hwnd"])
            w["hwnd"] = None
        except Exception:
            pass
    return 1


def export_html5_canvas(win_id: int, file_path: str | None = None) -> str:
    """Exports all recorded graphics operations for a window into a standalone HTML5 Canvas2D file."""
    w = _windows.get(win_id)
    if not w:
        return ""
    width = w.get("w", 800)
    height = w.get("h", 600)
    title = w.get("title", "TheFlux Canvas")
    cmds = w.get("commands", [])

    js_lines: list[str] = []
    for cmd in cmds:
        t = cmd.get("type")
        if t == "clear":
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.fillRect(0, 0, {width}, {height});')
        elif t == "fill_rect":
            x, y, rw, rh = cmd["x"], cmd["y"], cmd["w"], cmd["h"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.fillRect({x}, {y}, {rw}, {rh});')
        elif t == "draw_rect":
            x, y, rw, rh = cmd["x"], cmd["y"], cmd["w"], cmd["h"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.strokeStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.strokeRect({x}, {y}, {rw}, {rh});')
        elif t == "draw_line":
            x1, y1, x2, y2 = cmd["x1"], cmd["y1"], cmd["x2"], cmd["y2"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.strokeStyle = "rgb({r},{g},{b})";')
            js_lines.append('ctx.beginPath();')
            js_lines.append(f'ctx.moveTo({x1}, {y1});')
            js_lines.append(f'ctx.lineTo({x2}, {y2});')
            js_lines.append('ctx.stroke();')
        elif t == "draw_circle":
            cx, cy, rad = cmd["cx"], cmd["cy"], cmd["radius"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.strokeStyle = "rgb({r},{g},{b})";')
            js_lines.append('ctx.beginPath();')
            js_lines.append(f'ctx.arc({cx}, {cy}, {rad}, 0, 2 * Math.PI);')
            js_lines.append('ctx.stroke();')
        elif t == "fill_circle":
            cx, cy, rad = cmd["cx"], cmd["cy"], cmd["radius"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append('ctx.beginPath();')
            js_lines.append(f'ctx.arc({cx}, {cy}, {rad}, 0, 2 * Math.PI);')
            js_lines.append('ctx.fill();')
        elif t == "draw_text":
            x, y, text = cmd["x"], cmd["y"], cmd["text"].replace('"', '\\"')
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append('ctx.font = "14px Segoe UI, sans-serif";')
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.fillText("{text}", {x}, {y});')

    js_code = "\n    ".join(js_lines)

    html = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>{title}</title>
<style>
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: #141419;
    color: #e0e0e0;
    font-family: 'Segoe UI', system-ui, sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    padding: 20px;
  }}
  h2 {{
    margin-bottom: 14px;
    font-size: 20px;
    color: #4a90d9;
    font-weight: 600;
  }}
  #canvas-container {{
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
    overflow: hidden;
    background: #000;
  }}
  canvas {{
    display: block;
    cursor: default;
  }}
  #status-bar {{
    margin-top: 12px;
    font-size: 13px;
    color: #888;
  }}
</style>
</head>
<body>
<h2>TheFlux — {title}</h2>
<div id="canvas-container">
  <canvas id="fluxCanvas" width="{width}" height="{height}"></canvas>
</div>
<div id="status-bar">Posição do Mouse: (0, 0) | Renderização: HTML5 Canvas2D Real</div>
<script>
  const canvas = document.getElementById('fluxCanvas');
  const ctx = canvas.getContext('2d');
  const statusBar = document.getElementById('status-bar');

  function renderFrame() {{
    {js_code}
  }}

  renderFrame();

  canvas.addEventListener('mousemove', (e) => {{
    const rect = canvas.getBoundingClientRect();
    const x = Math.floor(e.clientX - rect.left);
    const y = Math.floor(e.clientY - rect.top);
    statusBar.innerText = `Posição do Mouse: (${{x}}, ${{y}}) | Renderização: HTML5 Canvas2D Real`;
  }});
</script>
</body>
</html>
"""
    if file_path:
        try:
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(html)
        except Exception:
            pass
    return html


def gfx_window_flush(win_id: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0

    # Export HTML5 Canvas artifact on flush if requested
    export_target = w.get("html_export") or os.environ.get("FLUX_GFX_HTML_EXPORT")
    if export_target:
        try:
            export_html5_canvas(win_id, export_target)
        except Exception:
            pass

    if _IS_WINDOWS and "hwnd" in w and w["hwnd"]:
        try:
            gdi32.BitBlt(w["win_dc"], 0, 0, w["w"], w["h"], w["mem_dc"], 0, 0, SRCCOPY)
            gdi32.GdiFlush()
            user32.UpdateWindow(w["hwnd"])
            msg = wintypes.MSG()
            while user32.PeekMessageW(ctypes.byref(msg), w["hwnd"], 0, 0, PM_REMOVE):
                if msg.message in (WM_CLOSE, WM_DESTROY):
                    w["closed"] = True
                user32.TranslateMessage(ctypes.byref(msg))
                user32.DispatchMessageW(ctypes.byref(msg))
        except Exception:
            pass
    return 1


def gfx_window_wait(win_id: int, ms: int = 0) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    if os.environ.get("FLUX_CI"):
        return 1
    if not _IS_WINDOWS or "hwnd" not in w or not w["hwnd"]:
        return 1

    hwnd = w["hwnd"]
    start = time.monotonic()
    is_persistent = (ms <= 0)
    dur = (ms / 1000.0) if not is_persistent else 0.0
    msg = wintypes.MSG()

    while not w.get("closed"):
        if not is_persistent and (time.monotonic() - start) >= dur:
            break
        while user32.PeekMessageW(ctypes.byref(msg), hwnd, 0, 0, PM_REMOVE):
            if msg.message in (WM_CLOSE, WM_DESTROY):
                w["closed"] = True
                return 1
            if msg.message == WM_KEYDOWN and msg.wParam == 27:  # VK_ESCAPE
                w["closed"] = True
                user32.DestroyWindow(hwnd)
                return 1
            user32.TranslateMessage(ctypes.byref(msg))
            user32.DispatchMessageW(ctypes.byref(msg))
        if "win_dc" in w and "mem_dc" in w:
            gdi32.BitBlt(w["win_dc"], 0, 0, w["w"], w["h"], w["mem_dc"], 0, 0, SRCCOPY)
            gdi32.GdiFlush()
        time.sleep(0.016)
    return 1


def gfx_clear(win_id: int, r: int, g: int, b: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    w.setdefault("commands", []).append({
        "type": "clear", "r": int(r), "g": int(g), "b": int(b)
    })
    if _IS_WINDOWS and "mem_dc" in w and w["mem_dc"]:
        try:
            color = _rgb(r, g, b)
            brush = gdi32.CreateSolidBrush(color)
            rc = wintypes.RECT(0, 0, w["w"], w["h"])
            user32.FillRect(w["mem_dc"], ctypes.byref(rc), brush)
            gdi32.DeleteObject(brush)
        except Exception:
            pass
    return 1


def gfx_fill_rect(win_id: int, x: int, y: int, rw: int, rh: int, r: int, g: int, b: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    w.setdefault("commands", []).append({
        "type": "fill_rect", "x": int(x), "y": int(y), "w": int(rw), "h": int(rh),
        "r": int(r), "g": int(g), "b": int(b)
    })
    if _IS_WINDOWS and "mem_dc" in w and w["mem_dc"]:
        try:
            color = _rgb(r, g, b)
            brush = gdi32.CreateSolidBrush(color)
            rc = wintypes.RECT(int(x), int(y), int(x + rw), int(y + rh))
            user32.FillRect(w["mem_dc"], ctypes.byref(rc), brush)
            gdi32.DeleteObject(brush)
        except Exception:
            pass
    return 1


def gfx_draw_rect(win_id: int, x: int, y: int, rw: int, rh: int, r: int, g: int, b: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    w.setdefault("commands", []).append({
        "type": "draw_rect", "x": int(x), "y": int(y), "w": int(rw), "h": int(rh),
        "r": int(r), "g": int(g), "b": int(b)
    })
    if _IS_WINDOWS and "mem_dc" in w and w["mem_dc"]:
        try:
            color = _rgb(r, g, b)
            pen = gdi32.CreatePen(0, 1, color)
            old_pen = gdi32.SelectObject(w["mem_dc"], pen)
            null_brush = gdi32.GetStockObject(NULL_BRUSH)
            old_brush = gdi32.SelectObject(w["mem_dc"], null_brush)

            gdi32.Rectangle(w["mem_dc"], int(x), int(y), int(x + rw), int(y + rh))

            gdi32.SelectObject(w["mem_dc"], old_pen)
            gdi32.SelectObject(w["mem_dc"], old_brush)
            gdi32.DeleteObject(pen)
        except Exception:
            pass
    return 1


def gfx_draw_line(win_id: int, x1: int, y1: int, x2: int, y2: int, r: int, g: int, b: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    w.setdefault("commands", []).append({
        "type": "draw_line", "x1": int(x1), "y1": int(y1), "x2": int(x2), "y2": int(y2),
        "r": int(r), "g": int(g), "b": int(b)
    })
    if _IS_WINDOWS and "mem_dc" in w and w["mem_dc"]:
        try:
            color = _rgb(r, g, b)
            pen = gdi32.CreatePen(0, 1, color)
            old_pen = gdi32.SelectObject(w["mem_dc"], pen)

            gdi32.MoveToEx(w["mem_dc"], int(x1), int(y1), None)
            gdi32.LineTo(w["mem_dc"], int(x2), int(y2))

            gdi32.SelectObject(w["mem_dc"], old_pen)
            gdi32.DeleteObject(pen)
        except Exception:
            pass
    return 1


def gfx_draw_circle(win_id: int, cx: int, cy: int, radius: int, r: int, g: int, b: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    w.setdefault("commands", []).append({
        "type": "draw_circle", "cx": int(cx), "cy": int(cy), "radius": int(radius),
        "r": int(r), "g": int(g), "b": int(b)
    })
    if _IS_WINDOWS and "mem_dc" in w and w["mem_dc"]:
        try:
            color = _rgb(r, g, b)
            pen = gdi32.CreatePen(0, 1, color)
            old_pen = gdi32.SelectObject(w["mem_dc"], pen)
            null_brush = gdi32.GetStockObject(NULL_BRUSH)
            old_brush = gdi32.SelectObject(w["mem_dc"], null_brush)

            rad = int(radius)
            gdi32.Ellipse(w["mem_dc"], int(cx - rad), int(cy - rad), int(cx + rad), int(cy + rad))

            gdi32.SelectObject(w["mem_dc"], old_pen)
            gdi32.SelectObject(w["mem_dc"], old_brush)
            gdi32.DeleteObject(pen)
        except Exception:
            pass
    return 1


def gfx_fill_circle(win_id: int, cx: int, cy: int, radius: int, r: int, g: int, b: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    w.setdefault("commands", []).append({
        "type": "fill_circle", "cx": int(cx), "cy": int(cy), "radius": int(radius),
        "r": int(r), "g": int(g), "b": int(b)
    })
    if _IS_WINDOWS and "mem_dc" in w and w["mem_dc"]:
        try:
            color = _rgb(r, g, b)
            brush = gdi32.CreateSolidBrush(color)
            pen = gdi32.CreatePen(0, 1, color)
            old_brush = gdi32.SelectObject(w["mem_dc"], brush)
            old_pen = gdi32.SelectObject(w["mem_dc"], pen)

            rad = int(radius)
            gdi32.Ellipse(w["mem_dc"], int(cx - rad), int(cy - rad), int(cx + rad), int(cy + rad))

            gdi32.SelectObject(w["mem_dc"], old_brush)
            gdi32.SelectObject(w["mem_dc"], old_pen)
            gdi32.DeleteObject(brush)
            gdi32.DeleteObject(pen)
        except Exception:
            pass
    return 1


def gfx_draw_text(win_id: int, x: int, y: int, text: str, r: int, g: int, b: int) -> int:
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return 0
    w.setdefault("commands", []).append({
        "type": "draw_text", "x": int(x), "y": int(y), "text": str(text),
        "r": int(r), "g": int(g), "b": int(b)
    })
    if _IS_WINDOWS and "mem_dc" in w and w["mem_dc"]:
        try:
            gdi32.SetBkMode(w["mem_dc"], TRANSPARENT)
            gdi32.SetTextColor(w["mem_dc"], _rgb(r, g, b))
            txt = str(text)
            gdi32.TextOutW(w["mem_dc"], int(x), int(y), txt, len(txt))
        except Exception:
            pass
    return 1


def gfx_event_poll(win_id: int) -> int:
    global _last_event_x, _last_event_y, _last_event_key
    w = _windows.get(win_id)
    if not w or w.get("closed"):
        return -1

    if not _IS_WINDOWS or "hwnd" not in w or not w["hwnd"]:
        evs = w.get("events", [])
        if evs:
            ev, ex, ey, ek = evs.pop(0)
            _last_event_x = ex
            _last_event_y = ey
            _last_event_key = ek
            return ev
        return 0

    hwnd = w["hwnd"]
    msg = wintypes.MSG()

    while user32.PeekMessageW(ctypes.byref(msg), hwnd, 0, 0, PM_REMOVE):
        m = msg.message
        if m in (WM_CLOSE, WM_DESTROY):
            w["closed"] = True
            return -1
        elif m == WM_LBUTTONDOWN:
            _last_event_x = msg.lParam & 0xFFFF
            _last_event_y = (msg.lParam >> 16) & 0xFFFF
            return 1
        elif m == WM_RBUTTONDOWN:
            _last_event_x = msg.lParam & 0xFFFF
            _last_event_y = (msg.lParam >> 16) & 0xFFFF
            return 2
        elif m == WM_MOUSEMOVE:
            _last_event_x = msg.lParam & 0xFFFF
            _last_event_y = (msg.lParam >> 16) & 0xFFFF
            return 3
        elif m == WM_KEYDOWN:
            _last_event_key = msg.wParam
            return 4

        user32.TranslateMessage(ctypes.byref(msg))
        user32.DispatchMessageW(ctypes.byref(msg))

    return 0


def gfx_event_x(win_id: int = 0) -> int:
    return _last_event_x


def gfx_event_y(win_id: int = 0) -> int:
    return _last_event_y


def gfx_event_key(win_id: int = 0) -> int:
    return _last_event_key


def gfx_window_closed(win_id: int) -> int:
    w = _windows.get(win_id)
    if not w:
        return 1
    return 1 if w.get("closed") else 0


def gfx_window_width(win_id: int) -> int:
    w = _windows.get(win_id)
    if not w:
        return 0
    return int(w.get("w", 0))


def gfx_window_height(win_id: int) -> int:
    w = _windows.get(win_id)
    if not w:
        return 0
    return int(w.get("h", 0))


def export_html5_from_ast(program: Any, file_path: str | Any = None) -> str:
    """Walks the AST, discovers stdGfx calls, and emits a standalone HTML5 Canvas2D file."""
    calls: list[Any] = []

    def _walk(node: Any) -> None:
        if node is None:
            return
        if hasattr(node, "__class__") and node.__class__.__name__ == "CallExpr":
            calls.append(node)
        for attr in ("storages", "functions", "body", "items", "args", "expr", "value", "arms", "statements", "initializer", "target", "operand", "left", "right"):
            val = getattr(node, attr, None)
            if isinstance(val, list):
                for item in val:
                    _walk(item)
            elif val is not None:
                _walk(val)

    try:
        _walk(program)
    except Exception:
        pass

    def _callee_name(c: Any) -> str:
        callee = getattr(c, "callee", None)
        if hasattr(callee, "name"):
            return str(callee.name)
        return ""

    def _const_val(node: Any, default: Any = 0) -> Any:
        if node is None:
            return default
        if hasattr(node, "value"):
            return node.value
        return default

    width = 800
    height = 600
    title = "TheFlux Canvas"
    commands: list[dict[str, Any]] = []
    buttons: list[dict[str, Any]] = []

    for c in calls:
        name = _callee_name(c)
        args = getattr(c, "args", [])
        if name in ("stdGfxWindowCreate", "gfxWindowCreate") and len(args) >= 3:
            width = int(_const_val(args[0], 800))
            height = int(_const_val(args[1], 600))
            title = str(_const_val(args[2], "TheFlux Canvas"))
        elif name in ("stdGfxClear", "gfxClear") and len(args) >= 4:
            commands.append({
                "type": "clear",
                "r": int(_const_val(args[1], 0)),
                "g": int(_const_val(args[2], 0)),
                "b": int(_const_val(args[3], 0)),
            })
        elif name in ("stdGfxFillRect", "gfxFillRect") and len(args) >= 8:
            commands.append({
                "type": "fill_rect",
                "x": int(_const_val(args[1], 0)),
                "y": int(_const_val(args[2], 0)),
                "w": int(_const_val(args[3], 100)),
                "h": int(_const_val(args[4], 50)),
                "r": int(_const_val(args[5], 255)),
                "g": int(_const_val(args[6], 255)),
                "b": int(_const_val(args[7], 255)),
            })
        elif name in ("stdGfxDrawRect", "gfxDrawRect") and len(args) >= 8:
            commands.append({
                "type": "draw_rect",
                "x": int(_const_val(args[1], 0)),
                "y": int(_const_val(args[2], 0)),
                "w": int(_const_val(args[3], 100)),
                "h": int(_const_val(args[4], 50)),
                "r": int(_const_val(args[5], 255)),
                "g": int(_const_val(args[6], 255)),
                "b": int(_const_val(args[7], 255)),
            })
        elif name in ("stdGfxDrawLine", "gfxDrawLine") and len(args) >= 8:
            commands.append({
                "type": "draw_line",
                "x1": int(_const_val(args[1], 0)),
                "y1": int(_const_val(args[2], 0)),
                "x2": int(_const_val(args[3], 100)),
                "y2": int(_const_val(args[4], 100)),
                "r": int(_const_val(args[5], 255)),
                "g": int(_const_val(args[6], 255)),
                "b": int(_const_val(args[7], 255)),
            })
        elif name in ("stdGfxDrawCircle", "gfxDrawCircle") and len(args) >= 7:
            commands.append({
                "type": "draw_circle",
                "cx": int(_const_val(args[1], 50)),
                "cy": int(_const_val(args[2], 50)),
                "radius": int(_const_val(args[3], 25)),
                "r": int(_const_val(args[4], 255)),
                "g": int(_const_val(args[5], 255)),
                "b": int(_const_val(args[6], 255)),
            })
        elif name in ("stdGfxFillCircle", "gfxFillCircle") and len(args) >= 7:
            commands.append({
                "type": "fill_circle",
                "cx": int(_const_val(args[1], 50)),
                "cy": int(_const_val(args[2], 50)),
                "radius": int(_const_val(args[3], 25)),
                "r": int(_const_val(args[4], 255)),
                "g": int(_const_val(args[5], 255)),
                "b": int(_const_val(args[6], 255)),
            })
        elif name in ("stdGfxDrawText", "gfxDrawText") and len(args) >= 7:
            commands.append({
                "type": "draw_text",
                "x": int(_const_val(args[1], 10)),
                "y": int(_const_val(args[2], 20)),
                "text": str(_const_val(args[3], "")),
                "r": int(_const_val(args[4], 255)),
                "g": int(_const_val(args[5], 255)),
                "b": int(_const_val(args[6], 255)),
            })
        elif name in ("guiButton", "guiButtonEx"):
            btn_txt = str(_const_val(args[1], "Button")) if len(args) > 1 else "Button"
            bx = int(_const_val(args[2], 10)) if len(args) > 2 else 10
            by = int(_const_val(args[3], 10)) if len(args) > 3 else 10
            bw = int(_const_val(args[4], 100)) if len(args) > 4 else 100
            bh = int(_const_val(args[5], 35)) if len(args) > 5 else 35
            buttons.append({"text": btn_txt, "x": bx, "y": by, "w": bw, "h": bh})

    # If no gfx commands found, return empty
    if not commands and not buttons:
        return ""

    js_lines: list[str] = []
    for cmd in commands:
        t = cmd.get("type")
        if t == "clear":
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.fillRect(0, 0, {width}, {height});')
        elif t == "fill_rect":
            x, y, rw, rh = cmd["x"], cmd["y"], cmd["w"], cmd["h"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.fillRect({x}, {y}, {rw}, {rh});')
        elif t == "draw_rect":
            x, y, rw, rh = cmd["x"], cmd["y"], cmd["w"], cmd["h"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.strokeStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.strokeRect({x}, {y}, {rw}, {rh});')
        elif t == "draw_line":
            x1, y1, x2, y2 = cmd["x1"], cmd["y1"], cmd["x2"], cmd["y2"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.strokeStyle = "rgb({r},{g},{b})";')
            js_lines.append('ctx.beginPath();')
            js_lines.append(f'ctx.moveTo({x1}, {y1});')
            js_lines.append(f'ctx.lineTo({x2}, {y2});')
            js_lines.append('ctx.stroke();')
        elif t == "draw_circle":
            cx, cy, rad = cmd["cx"], cmd["cy"], cmd["radius"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.strokeStyle = "rgb({r},{g},{b})";')
            js_lines.append('ctx.beginPath();')
            js_lines.append(f'ctx.arc({cx}, {cy}, {rad}, 0, 2 * Math.PI);')
            js_lines.append('ctx.stroke();')
        elif t == "fill_circle":
            cx, cy, rad = cmd["cx"], cmd["cy"], cmd["radius"]
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append('ctx.beginPath();')
            js_lines.append(f'ctx.arc({cx}, {cy}, {rad}, 0, 2 * Math.PI);')
            js_lines.append('ctx.fill();')
        elif t == "draw_text":
            x, y, text = cmd["x"], cmd["y"], cmd["text"].replace('"', '\\"')
            r, g, b = cmd["r"], cmd["g"], cmd["b"]
            js_lines.append('ctx.font = "14px Segoe UI, sans-serif";')
            js_lines.append(f'ctx.fillStyle = "rgb({r},{g},{b})";')
            js_lines.append(f'ctx.fillText("{text}", {x}, {y});')

    for btn in buttons:
        bx, by, bw, bh = btn["x"], btn["y"], btn["w"], btn["h"]
        btxt = btn["text"].replace('"', '\\"')
        js_lines.append(f'// Interactive Button: {btxt}')
        js_lines.append(f'ctx.fillStyle = "#2d5a88";')
        js_lines.append(f'ctx.fillRect({bx}, {by}, {bw}, {bh});')
        js_lines.append(f'ctx.strokeStyle = "#4a90d9";')
        js_lines.append(f'ctx.strokeRect({bx}, {by}, {bw}, {bh});')
        js_lines.append('ctx.font = "bold 13px Segoe UI, sans-serif";')
        js_lines.append('ctx.fillStyle = "#ffffff";')
        js_lines.append(f'ctx.fillText("{btxt}", {bx + 12}, {by + bh - 12});')

    js_code = "\n    ".join(js_lines)

    html = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>{title}</title>
<style>
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    background: #141419;
    color: #e0e0e0;
    font-family: 'Segoe UI', system-ui, sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    padding: 20px;
  }}
  h2 {{
    margin-bottom: 14px;
    font-size: 20px;
    color: #4a90d9;
    font-weight: 600;
  }}
  #canvas-container {{
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
    overflow: hidden;
    background: #000;
  }}
  canvas {{
    display: block;
    cursor: pointer;
  }}
  #status-bar {{
    margin-top: 12px;
    font-size: 13px;
    color: #888;
  }}
</style>
</head>
<body>
<h2>TheFlux — {title}</h2>
<div id="canvas-container">
  <canvas id="fluxCanvas" width="{width}" height="{height}"></canvas>
</div>
<div id="status-bar">Posição do Mouse: (0, 0) | Renderização: HTML5 Canvas2D Autônomo</div>
<script>
  const canvas = document.getElementById('fluxCanvas');
  const ctx = canvas.getContext('2d');
  const statusBar = document.getElementById('status-bar');

  function renderFrame() {{
    {js_code}
  }}

  renderFrame();

  canvas.addEventListener('mousemove', (e) => {{
    const rect = canvas.getBoundingClientRect();
    const x = Math.floor(e.clientX - rect.left);
    const y = Math.floor(e.clientY - rect.top);
    statusBar.innerText = `Posição do Mouse: (${{x}}, ${{y}}) | Canvas Ativo`;
  }});

  canvas.addEventListener('click', (e) => {{
    const rect = canvas.getBoundingClientRect();
    const x = Math.floor(e.clientX - rect.left);
    const y = Math.floor(e.clientY - rect.top);
    statusBar.innerText = `Clique registrado em: (${{x}}, ${{y}})`;
  }});
</script>
</body>
</html>
"""
    if file_path:
        try:
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(html)
        except Exception:
            pass
    return html
