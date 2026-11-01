#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#if defined(_WIN32)
#include <windows.h>
#endif

/* ==============================================================================
 * NativeGfxStdLib - Native Win32 GDI & Double-Buffered Window Driver
 * ============================================================================== */
#if defined(_WIN32)
#pragma comment(lib, "user32")
#pragma comment(lib, "gdi32")

#define MAX_GFX_WINDOWS 64

typedef struct {
    HWND hwnd;
    HDC win_dc;
    HDC mem_dc;
    HBITMAP mem_bmp;
    HBITMAP old_bmp;
    int64_t width;
    int64_t height;
    int64_t is_closed;
    char title[256];
} flux_gfx_win_t;

static flux_gfx_win_t _g_gfx_wins[MAX_GFX_WINDOWS] = {0};
static int64_t _g_gfx_next_win_id = 1;
static int _g_gfx_class_registered = 0;
static const char *_GFX_CLASS_NAME = "TheFluxNativeGfxClassC";

static int64_t _g_gfx_last_x = 0;
static int64_t _g_gfx_last_y = 0;
static int64_t _g_gfx_last_key = 0;

static LRESULT CALLBACK _flux_gfx_wnd_proc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    if (msg == WM_PAINT) {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hwnd, &ps);
        for (int i = 1; i < MAX_GFX_WINDOWS; i++) {
            if (_g_gfx_wins[i].hwnd == hwnd && _g_gfx_wins[i].mem_dc) {
                BitBlt(hdc, 0, 0, (int)_g_gfx_wins[i].width, (int)_g_gfx_wins[i].height,
                       _g_gfx_wins[i].mem_dc, 0, 0, SRCCOPY);
                break;
            }
        }
        EndPaint(hwnd, &ps);
        return 0;
    }
    if (msg == WM_ERASEBKGND) {
        return 1;
    }
    if (msg == WM_CLOSE) {
        for (int i = 1; i < MAX_GFX_WINDOWS; i++) {
            if (_g_gfx_wins[i].hwnd == hwnd) {
                _g_gfx_wins[i].is_closed = 1;
                break;
            }
        }
        DestroyWindow(hwnd);
        return 0;
    }
    if (msg == WM_DESTROY) {
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProcA(hwnd, msg, wParam, lParam);
}

static void _ensure_gfx_class(void) {
    if (_g_gfx_class_registered) return;
    WNDCLASSEXA wcex;
    memset(&wcex, 0, sizeof(wcex));
    wcex.cbSize = sizeof(wcex);
    wcex.style = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc = _flux_gfx_wnd_proc;
    wcex.hInstance = GetModuleHandleA(NULL);
    wcex.hIcon = LoadIconA(NULL, IDI_APPLICATION);
    wcex.hCursor = LoadCursorA(NULL, IDC_ARROW);
    wcex.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH);
    wcex.lpszClassName = _GFX_CLASS_NAME;
    RegisterClassExA(&wcex);
    _g_gfx_class_registered = 1;
}

static inline COLORREF _gfx_rgb(int64_t r, int64_t g, int64_t b) {
    int red = (int)(r < 0 ? 0 : (r > 255 ? 255 : r));
    int green = (int)(g < 0 ? 0 : (g > 255 ? 255 : g));
    int blue = (int)(b < 0 ? 0 : (b > 255 ? 255 : b));
    return RGB(red, green, blue);
}
#endif

int64_t flux_std_gfx_clear(int64_t win_id, int64_t r, int64_t g, int64_t b);
int64_t flux_std_gfx_window_flush(int64_t win_id);

int64_t flux_std_gfx_window_create(int64_t w, int64_t h, const char *title) {
#if defined(_WIN32)
    int64_t win_id = _g_gfx_next_win_id++;
    if (win_id >= MAX_GFX_WINDOWS) return 1;
    _ensure_gfx_class();

    int width = (int)(w < 10 ? 10 : w);
    int height = (int)(h < 10 ? 10 : h);
    const char *title_str = (title && *title) ? title : "TheFlux Native Graphics";

    DWORD style = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_VISIBLE;
    RECT rc = {0, 0, width, height};
    AdjustWindowRect(&rc, style, FALSE);
    int win_w = rc.right - rc.left;
    int win_h = rc.bottom - rc.top;

    HWND hwnd = CreateWindowExA(
        0, _GFX_CLASS_NAME, title_str, style,
        100, 100, win_w, win_h,
        NULL, NULL, GetModuleHandleA(NULL), NULL
    );

    if (!hwnd) {
        _g_gfx_wins[win_id].width = width;
        _g_gfx_wins[win_id].height = height;
        _g_gfx_wins[win_id].is_closed = 0;
        return win_id;
    }

    ShowWindow(hwnd, SW_SHOW);
    UpdateWindow(hwnd);

    HDC win_dc = GetDC(hwnd);
    HDC mem_dc = CreateCompatibleDC(win_dc);
    HBITMAP mem_bmp = CreateCompatibleBitmap(win_dc, width, height);
    HBITMAP old_bmp = (HBITMAP)SelectObject(mem_dc, mem_bmp);

    _g_gfx_wins[win_id].hwnd = hwnd;
    _g_gfx_wins[win_id].win_dc = win_dc;
    _g_gfx_wins[win_id].mem_dc = mem_dc;
    _g_gfx_wins[win_id].mem_bmp = mem_bmp;
    _g_gfx_wins[win_id].old_bmp = old_bmp;
    _g_gfx_wins[win_id].width = width;
    _g_gfx_wins[win_id].height = height;
    _g_gfx_wins[win_id].is_closed = 0;
    strncpy(_g_gfx_wins[win_id].title, title_str, 255);

    flux_std_gfx_clear(win_id, 30, 30, 35);
    flux_std_gfx_window_flush(win_id);
    return win_id;
#else
    (void)w; (void)h; (void)title;
    return 1;
#endif
}

int64_t flux_std_gfx_window_close(int64_t win_id) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    w->is_closed = 1;
    if (w->hwnd) {
        SelectObject(w->mem_dc, w->old_bmp);
        DeleteObject(w->mem_bmp);
        DeleteDC(w->mem_dc);
        ReleaseDC(w->hwnd, w->win_dc);
        DestroyWindow(w->hwnd);
        w->hwnd = NULL;
    }
    return 1;
#else
    (void)win_id;
    return 1;
#endif
}

int64_t flux_std_gfx_window_flush(int64_t win_id) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->hwnd) return 0;
    BitBlt(w->win_dc, 0, 0, (int)w->width, (int)w->height, w->mem_dc, 0, 0, SRCCOPY);
    GdiFlush();
    UpdateWindow(w->hwnd);
    MSG msg;
    while (PeekMessageW(&msg, w->hwnd, 0, 0, PM_REMOVE)) {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
    return 1;
#else
    (void)win_id;
    return 1;
#endif
}

int64_t flux_std_gfx_clear(int64_t win_id, int64_t r, int64_t g, int64_t b) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->mem_dc) return 0;
    HBRUSH brush = CreateSolidBrush(_gfx_rgb(r, g, b));
    RECT rc = {0, 0, (int)w->width, (int)w->height};
    FillRect(w->mem_dc, &rc, brush);
    DeleteObject(brush);
    return 1;
#else
    (void)win_id; (void)r; (void)g; (void)b;
    return 1;
#endif
}

int64_t flux_std_gfx_fill_rect(int64_t win_id, int64_t x, int64_t y, int64_t rw, int64_t rh, int64_t r, int64_t g, int64_t b) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->mem_dc) return 0;
    HBRUSH brush = CreateSolidBrush(_gfx_rgb(r, g, b));
    RECT rc = {(int)x, (int)y, (int)(x + rw), (int)(y + rh)};
    FillRect(w->mem_dc, &rc, brush);
    DeleteObject(brush);
    return 1;
#else
    (void)win_id; (void)x; (void)y; (void)rw; (void)rh; (void)r; (void)g; (void)b;
    return 1;
#endif
}

int64_t flux_std_gfx_draw_rect(int64_t win_id, int64_t x, int64_t y, int64_t rw, int64_t rh, int64_t r, int64_t g, int64_t b) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->mem_dc) return 0;
    HPEN pen = CreatePen(PS_SOLID, 1, _gfx_rgb(r, g, b));
    HGDIOBJ old_pen = SelectObject(w->mem_dc, pen);
    HGDIOBJ old_brush = SelectObject(w->mem_dc, GetStockObject(NULL_BRUSH));
    Rectangle(w->mem_dc, (int)x, (int)y, (int)(x + rw), (int)(y + rh));
    SelectObject(w->mem_dc, old_pen);
    SelectObject(w->mem_dc, old_brush);
    DeleteObject(pen);
    return 1;
#else
    (void)win_id; (void)x; (void)y; (void)rw; (void)rh; (void)r; (void)g; (void)b;
    return 1;
#endif
}

int64_t flux_std_gfx_draw_line(int64_t win_id, int64_t x1, int64_t y1, int64_t x2, int64_t y2, int64_t r, int64_t g, int64_t b) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->mem_dc) return 0;
    HPEN pen = CreatePen(PS_SOLID, 1, _gfx_rgb(r, g, b));
    HGDIOBJ old_pen = SelectObject(w->mem_dc, pen);
    MoveToEx(w->mem_dc, (int)x1, (int)y1, NULL);
    LineTo(w->mem_dc, (int)x2, (int)y2);
    SelectObject(w->mem_dc, old_pen);
    DeleteObject(pen);
    return 1;
#else
    (void)win_id; (void)x1; (void)y1; (void)x2; (void)y2; (void)r; (void)g; (void)b;
    return 1;
#endif
}

int64_t flux_std_gfx_draw_circle(int64_t win_id, int64_t cx, int64_t cy, int64_t radius, int64_t r, int64_t g, int64_t b) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->mem_dc) return 0;
    HPEN pen = CreatePen(PS_SOLID, 1, _gfx_rgb(r, g, b));
    HGDIOBJ old_pen = SelectObject(w->mem_dc, pen);
    HGDIOBJ old_brush = SelectObject(w->mem_dc, GetStockObject(NULL_BRUSH));
    int rad = (int)radius;
    Ellipse(w->mem_dc, (int)(cx - rad), (int)(cy - rad), (int)(cx + rad), (int)(cy + rad));
    SelectObject(w->mem_dc, old_pen);
    SelectObject(w->mem_dc, old_brush);
    DeleteObject(pen);
    return 1;
#else
    (void)win_id; (void)cx; (void)cy; (void)radius; (void)r; (void)g; (void)b;
    return 1;
#endif
}

int64_t flux_std_gfx_fill_circle(int64_t win_id, int64_t cx, int64_t cy, int64_t radius, int64_t r, int64_t g, int64_t b) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->mem_dc) return 0;
    HBRUSH brush = CreateSolidBrush(_gfx_rgb(r, g, b));
    HPEN pen = CreatePen(PS_SOLID, 1, _gfx_rgb(r, g, b));
    HGDIOBJ old_brush = SelectObject(w->mem_dc, brush);
    HGDIOBJ old_pen = SelectObject(w->mem_dc, pen);
    int rad = (int)radius;
    Ellipse(w->mem_dc, (int)(cx - rad), (int)(cy - rad), (int)(cx + rad), (int)(cy + rad));
    SelectObject(w->mem_dc, old_brush);
    SelectObject(w->mem_dc, old_pen);
    DeleteObject(brush);
    DeleteObject(pen);
    return 1;
#else
    (void)win_id; (void)cx; (void)cy; (void)radius; (void)r; (void)g; (void)b;
    return 1;
#endif
}

int64_t flux_std_gfx_draw_text(int64_t win_id, int64_t x, int64_t y, const char *text, int64_t r, int64_t g, int64_t b) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->mem_dc) return 0;
    SetBkMode(w->mem_dc, TRANSPARENT);
    SetTextColor(w->mem_dc, _gfx_rgb(r, g, b));
    const char *str = text ? text : "";
    TextOutA(w->mem_dc, (int)x, (int)y, str, (int)strlen(str));
    return 1;
#else
    (void)win_id; (void)x; (void)y; (void)text; (void)r; (void)g; (void)b;
    return 1;
#endif
}

int64_t flux_std_gfx_event_poll(int64_t win_id) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return -1;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed) return -1;
    if (!w->hwnd) return 0;

    MSG msg;
    while (PeekMessageA(&msg, w->hwnd, 0, 0, PM_REMOVE)) {
        if (msg.message == WM_CLOSE || msg.message == WM_DESTROY) {
            w->is_closed = 1;
            return -1;
        } else if (msg.message == WM_LBUTTONDOWN) {
            _g_gfx_last_x = msg.lParam & 0xFFFF;
            _g_gfx_last_y = (msg.lParam >> 16) & 0xFFFF;
            return 1;
        } else if (msg.message == WM_RBUTTONDOWN) {
            _g_gfx_last_x = msg.lParam & 0xFFFF;
            _g_gfx_last_y = (msg.lParam >> 16) & 0xFFFF;
            return 2;
        } else if (msg.message == WM_MOUSEMOVE) {
            _g_gfx_last_x = msg.lParam & 0xFFFF;
            _g_gfx_last_y = (msg.lParam >> 16) & 0xFFFF;
            return 3;
        } else if (msg.message == WM_KEYDOWN) {
            _g_gfx_last_key = (int64_t)msg.wParam;
            return 4;
        }
        TranslateMessage(&msg);
        DispatchMessageA(&msg);
    }
    return 0;
#else
    (void)win_id;
    return 0;
#endif
}

int64_t flux_std_gfx_event_x(void) {
    return _g_gfx_last_x;
}

int64_t flux_std_gfx_event_y(void) {
    return _g_gfx_last_y;
}

int64_t flux_std_gfx_event_key(void) {
    return _g_gfx_last_key;
}

int64_t flux_std_gfx_window_closed(int64_t win_id) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 1;
    return _g_gfx_wins[win_id].is_closed ? 1 : 0;
#else
    (void)win_id;
    return 0;
#endif
}

int64_t flux_std_gfx_window_width(int64_t win_id) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 800;
    return _g_gfx_wins[win_id].width;
#else
    (void)win_id;
    return 800;
#endif
}

int64_t flux_std_gfx_window_height(int64_t win_id) {
#if defined(_WIN32)
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 600;
    return _g_gfx_wins[win_id].height;
#else
    (void)win_id;
    return 600;
#endif
}

int64_t flux_std_gfx_window_wait(int64_t win_id, int64_t ms) {
#if defined(_WIN32)
    if (getenv("FLUX_CI") != NULL) return 1;
    if (win_id <= 0 || win_id >= MAX_GFX_WINDOWS) return 0;
    flux_gfx_win_t *w = &_g_gfx_wins[win_id];
    if (w->is_closed || !w->hwnd) return 0;
    int is_persistent = (ms <= 0);
    int64_t dur_ns = ms > 0 ? (ms * 1000000LL) : 0;
    int64_t start_ns = flux_std_datetime_monotonic_now();
    while (!w->is_closed) {
        if (!is_persistent && flux_std_datetime_monotonic_elapsed(start_ns) >= dur_ns) {
            break;
        }
        MSG msg;
        while (PeekMessageW(&msg, w->hwnd, 0, 0, PM_REMOVE)) {
            if (msg.message == WM_CLOSE || msg.message == WM_DESTROY) {
                w->is_closed = 1;
                return 1;
            }
            if (msg.message == WM_KEYDOWN && msg.wParam == 27) { /* VK_ESCAPE */
                w->is_closed = 1;
                DestroyWindow(w->hwnd);
                return 1;
            }
            TranslateMessage(&msg);
            DispatchMessageW(&msg);
        }
        if (w->win_dc && w->mem_dc) {
            BitBlt(w->win_dc, 0, 0, (int)w->width, (int)w->height, w->mem_dc, 0, 0, SRCCOPY);
            GdiFlush();
        }
        Sleep(16);
    }
    return 1;
#else
    (void)win_id;
    (void)ms;
    return 1;
#endif
}

int64_t flux_std_gfx_export_html(int64_t win_id, const char *path) {
    (void)win_id;
    (void)path;
    return 1;
}

