# TODO: RealGfxStdLib — Gráficos Reais em TheFlux

## Objetivo

Implementar saída gráfica real (janela nativa Win32 ou Canvas HTML5) via intrinsics
`stdGfx*`, seguindo o mesmo padrão de `stdIo*`, `stdOs*`, `stdDateTime*`.

---

## Estratégia

Uma única API `stdGfx*`, implementada em cada backend:

| Backend | Implementação | Janela real? |
|---|---|---|
| `in` / `vm` / `vmr` | `gfx_helpers.py` → `ctypes` → Win32 API | ✅ Win32 nativo |
| `llvm` | `flux_gfx.c` compilado com clang | ✅ Win32 nativo |
| `wat` | stubs (wasmer não suporta canvas) | ❌ |
| `wasm` + web runner | host imports `flux_gfx` → `<canvas>` HTML5 modal | ✅ Canvas2D |

> **Nota**: "Win32 API" é o nome oficial da API do Windows mesmo em 64-bit.
> O binário gerado pelo clang é x86_64 nativo. `HWND` é tratado como `int64`.

---

## Primitivas `stdGfx*`

### Janela
- `stdGfxWindowCreate(w, h, title)` → `int64` (hwnd_id)
- `stdGfxWindowClose(hwnd)` → `int64`
- `stdGfxWindowFlush(hwnd)` → `int64` (apresenta frame)

### Desenho
- `stdGfxClear(hwnd, r, g, b)` → `int64`
- `stdGfxFillRect(hwnd, x, y, w, h, r, g, b)` → `int64`
- `stdGfxDrawRect(hwnd, x, y, w, h, r, g, b)` → `int64`
- `stdGfxDrawLine(hwnd, x1, y1, x2, y2, r, g, b)` → `int64`
- `stdGfxDrawText(hwnd, x, y, text, r, g, b)` → `int64`

### Eventos
- `stdGfxEventPoll(hwnd)` → `int64` (tipo do evento, ou 0 se vazio)
- `stdGfxEventX()` → `int64` (coordenada X do último evento)
- `stdGfxEventY()` → `int64` (coordenada Y do último evento)
- `stdGfxWindowClosed(hwnd)` → `bool`

### Valores de `stdGfxEventPoll()`
| Retorno | Evento |
|---|---|
| 0 | Nenhum |
| 1 | Clique esquerdo (mouse down) |
| 2 | Clique direito |
| 3 | Mouse move |
| 4 | Tecla pressionada |
| -1 | Janela fechada (WM_QUIT) |

---

## Arquivos a Criar / Modificar

### 1. `src/flux_proto/llvm/runtime/flux_gfx.c` [NOVO]

Runtime C com Win32 GDI + double-buffer offscreen:
- Registra `WNDCLASS`, cria janela, processa mensagens via `PeekMessage` (não-bloqueante)
- Fila de eventos circular interna (sem dependências externas)
- `WNDPROC` estático coloca eventos na fila; Flux lê via `flux_std_gfx_event_poll()`
- Double-buffer: `CreateCompatibleDC` + `BitBlt` no flush
- `#ifdef _WIN32` / `#else stubs #endif` para portabilidade de compilação cross

Funções exportadas:
```c
int64_t flux_std_gfx_window_create(int64_t w, int64_t h, const char* title);
int64_t flux_std_gfx_window_close(int64_t hwnd_id);
int64_t flux_std_gfx_window_flush(int64_t hwnd_id);
int64_t flux_std_gfx_clear(int64_t hwnd_id, int64_t r, int64_t g, int64_t b);
int64_t flux_std_gfx_fill_rect(int64_t hwnd_id, int64_t x, int64_t y, int64_t w, int64_t h, int64_t r, int64_t g, int64_t b);
int64_t flux_std_gfx_draw_rect(int64_t hwnd_id, int64_t x, int64_t y, int64_t w, int64_t h, int64_t r, int64_t g, int64_t b);
int64_t flux_std_gfx_draw_line(int64_t hwnd_id, int64_t x1, int64_t y1, int64_t x2, int64_t y2, int64_t r, int64_t g, int64_t b);
int64_t flux_std_gfx_draw_text(int64_t hwnd_id, int64_t x, int64_t y, const char* text, int64_t r, int64_t g, int64_t b);
int64_t flux_std_gfx_event_poll(int64_t hwnd_id);
int64_t flux_std_gfx_event_x(void);
int64_t flux_std_gfx_event_y(void);
int64_t flux_std_gfx_window_closed(int64_t hwnd_id);
```

### 2. `src/flux_proto/gfx_helpers.py` [NOVO]

Wrapper Python via `ctypes` para Win32 (backends `in`, `vm`, `vmr`):
- Windows: `ctypes.windll.user32` + `ctypes.windll.gdi32`
- Usa `PeekMessageW` para loop não-bloqueante
- Mantém dicionários `_windows{}`, `_hdcs{}`, `_events{}` por `hwnd_id`
- Fallback tkinter para Linux/macOS (stubs básicos)

### 3. `src/flux_proto/interpreter/interpreter.py` [MODIFICAR]

Adicionar dispatch e método `_eval_gfx_intrinsic()`:
```python
# Em _eval_call(), junto com stdOs/stdNet (~linha 1741):
if name.startswith("stdGfx"):
    return self._eval_gfx_intrinsic(name, node.args)
```

### 4. `src/flux_proto/vm/runtime.py` [MODIFICAR]

Adicionar entradas no dicionário `_BUILTINS` após `stdOsUptime`:
```python
import flux_proto.gfx_helpers as _gfxh
"stdGfxWindowCreate":  (3, lambda w, h, t: _gfxh.gfx_window_create(int(w), int(h), str(t))),
"stdGfxWindowClose":   (1, lambda hwnd:    _gfxh.gfx_window_close(int(hwnd))),
"stdGfxWindowFlush":   (1, lambda hwnd:    _gfxh.gfx_window_flush(int(hwnd))),
"stdGfxClear":         (4, lambda hwnd, r, g, b: _gfxh.gfx_clear(int(hwnd), int(r), int(g), int(b))),
"stdGfxFillRect":      (8, lambda hwnd, x, y, w, h, r, g, b: _gfxh.gfx_fill_rect(int(hwnd), int(x), int(y), int(w), int(h), int(r), int(g), int(b))),
"stdGfxDrawRect":      (8, lambda hwnd, x, y, w, h, r, g, b: _gfxh.gfx_draw_rect(int(hwnd), int(x), int(y), int(w), int(h), int(r), int(g), int(b))),
"stdGfxDrawLine":      (8, lambda hwnd, x1, y1, x2, y2, r, g, b: _gfxh.gfx_draw_line(int(hwnd), int(x1), int(y1), int(x2), int(y2), int(r), int(g), int(b))),
"stdGfxDrawText":      (7, lambda hwnd, x, y, txt, r, g, b: _gfxh.gfx_draw_text(int(hwnd), int(x), int(y), str(txt), int(r), int(g), int(b))),
"stdGfxEventPoll":     (1, lambda hwnd:    _gfxh.gfx_event_poll(int(hwnd))),
"stdGfxEventX":        (0, lambda:         _gfxh.gfx_event_x()),
"stdGfxEventY":        (0, lambda:         _gfxh.gfx_event_y()),
"stdGfxWindowClosed":  (1, lambda hwnd:    _gfxh.gfx_window_closed(int(hwnd))),
```

### 5. `src/flux_proto/llvm/codegen.py` [MODIFICAR]

Em `_emit_declarations()` (~linha 2575), adicionar declares:
```python
self._w.declare_function("flux_std_gfx_window_create", "i64", ["i64", "i64", "i8*"])
self._w.declare_function("flux_std_gfx_window_close",  "i64", ["i64"])
self._w.declare_function("flux_std_gfx_window_flush",  "i64", ["i64"])
self._w.declare_function("flux_std_gfx_clear",         "i64", ["i64", "i64", "i64", "i64"])
self._w.declare_function("flux_std_gfx_fill_rect",     "i64", ["i64", "i64", "i64", "i64", "i64", "i64", "i64", "i64"])
self._w.declare_function("flux_std_gfx_draw_rect",     "i64", ["i64", "i64", "i64", "i64", "i64", "i64", "i64", "i64"])
self._w.declare_function("flux_std_gfx_draw_line",     "i64", ["i64", "i64", "i64", "i64", "i64", "i64", "i64", "i64"])
self._w.declare_function("flux_std_gfx_draw_text",     "i64", ["i64", "i64", "i64", "i8*", "i64", "i64", "i64"])
self._w.declare_function("flux_std_gfx_event_poll",    "i64", ["i64"])
self._w.declare_function("flux_std_gfx_event_x",       "i64", [])
self._w.declare_function("flux_std_gfx_event_y",       "i64", [])
self._w.declare_function("flux_std_gfx_window_closed", "i64", ["i64"])
```

Em `_gen_call_std()` (~linha 7393):
```python
if name.startswith("stdGfx"):
    return self._gen_call_gfx_intrinsic(name, node.args)
```

### 6. `flux_lv.py` [MODIFICAR]

Incluir `flux_gfx.c` na compilação (linha 90):
```python
gfx_c = ROOT / "src" / "flux_proto" / "llvm" / "runtime" / "flux_gfx.c"
subprocess.run(
    [clang_exe, "-o", exe_path, ll_path, str(runtime_c), str(gfx_c)],
    ...
)
```

### 7. `src/flux_proto/wasm/codegen.py` [MODIFICAR]

Adicionar imports do módulo `flux_gfx` (host functions injetadas pelo browser):
```python
# Em _emit_imports():
t_gfx3   = self._mod.add_type([I64, I64, I32], [I64])
t_gfx1   = self._mod.add_type([I64], [I64])
t_gfx4   = self._mod.add_type([I64, I64, I64, I64], [I64])
t_gfx8   = self._mod.add_type([I64]*8, [I64])
t_gfx7s  = self._mod.add_type([I64, I64, I64, I32, I64, I64, I64], [I64])
t_gfx0   = self._mod.add_type([], [I64])

self._helper_funcs["$stdGfxWindowCreate"] = self._mod.add_import("flux_gfx", "window_create", t_gfx3)
self._helper_funcs["$stdGfxWindowClose"]  = self._mod.add_import("flux_gfx", "window_close",  t_gfx1)
self._helper_funcs["$stdGfxWindowFlush"]  = self._mod.add_import("flux_gfx", "window_flush",  t_gfx1)
self._helper_funcs["$stdGfxClear"]        = self._mod.add_import("flux_gfx", "clear",         t_gfx4)
self._helper_funcs["$stdGfxFillRect"]     = self._mod.add_import("flux_gfx", "fill_rect",     t_gfx8)
self._helper_funcs["$stdGfxDrawRect"]     = self._mod.add_import("flux_gfx", "draw_rect",     t_gfx8)
self._helper_funcs["$stdGfxDrawLine"]     = self._mod.add_import("flux_gfx", "draw_line",     t_gfx8)
self._helper_funcs["$stdGfxDrawText"]     = self._mod.add_import("flux_gfx", "draw_text",     t_gfx7s)
self._helper_funcs["$stdGfxEventPoll"]    = self._mod.add_import("flux_gfx", "event_poll",    t_gfx1)
self._helper_funcs["$stdGfxEventX"]       = self._mod.add_import("flux_gfx", "event_x",       t_gfx0)
self._helper_funcs["$stdGfxEventY"]       = self._mod.add_import("flux_gfx", "event_y",       t_gfx0)
self._helper_funcs["$stdGfxWindowClosed"] = self._mod.add_import("flux_gfx", "window_closed", t_gfx1)
```

### 8. `web_wasm/index.html` [MODIFICAR]

Adicionar `<canvas>` como modal overlay sobre o terminal:
- Div `#gfx-overlay` com `position:fixed`, `z-index:100`, `display:none`
- Canvas 2D dentro do overlay, dimensionado dinamicamente
- Objeto `fluxGfxHost` implementando todas as ops via Canvas2D API
- `canvas.addEventListener("mousedown"/"mousemove")` para captura de eventos
- Injetado no `wasiImportObject` como `flux_gfx: fluxGfxHost`

### 9. `web_wasm/wasi_worker.js` [MODIFICAR]

Objeto `flux_gfx` no worker que envia `postMessage({type:"gfx", op:..., ...args})` 
para o main thread para operações de desenho, e lê de um `SharedArrayBuffer` de
eventos gráficos para `event_poll()` (similar ao mecanismo de stdin existente).

### 10. `stdlib/NativeGfxStdLib.fdsl` [NOVO]

Contratos e agent wrapper:
```
contract (NativeGfxWindowContract) { ... }
contract (NativeGfxDrawContract) { ... }
contract (NativeGfxEventContract) { ... }

agent (NativeGfxStdLib) impl NativeGfxWindowContract, NativeGfxDrawContract, NativeGfxEventContract {
      #L As ops são pass-through para as intrinsics stdGfx*
}
```

### 11. `flux/ExampleOfUseNativeGfxStdLib_CanvasButtons.flux` [NOVO]

Janela 800×600 com botões CLS e CLOSE centralizados a 90% vertical:
- Fundo escuro (30,30,35)
- Botão CLS azul (0,120,215) em x=272, y=540, 120×36
- Botão CLOSE vermelho (200,50,50) em x=408, y=540, 120×36
- Loop de eventos: clique em CLS reseta desenho, CLOSE fecha janela

---

## Exemplo de Uso Final

```flux
use NativeGfxStdLib as Gfx

program (CanvasButtonsReal) {
      mut as int64: win = stdGfxWindowCreate(800, 600, "Canvas TheFlux")
      mut as bool: rodando = true

      infinite (rodando) {
            mut as int64: _ = stdGfxClear(win, 30, 30, 35)
            mut as int64: _ = stdGfxFillRect(win, 272, 540, 120, 36, 0, 120, 215)
            mut as int64: _ = stdGfxFillRect(win, 408, 540, 120, 36, 200, 50, 50)
            mut as int64: _ = stdGfxDrawText(win, 312, 563, "CLS",   255, 255, 255)
            mut as int64: _ = stdGfxDrawText(win, 438, 563, "CLOSE", 255, 255, 255)
            mut as int64: _ = stdGfxWindowFlush(win)

            mut as int64: ev = stdGfxEventPoll(win)
            route {
                  ev == -1 ==> { rodando = false }
                  ev == 1  ==> {
                        mut as int64: mx = stdGfxEventX()
                        mut as int64: my = stdGfxEventY()
                        route {
                              (mx >= 272 && mx <= 392 && my >= 540 && my <= 576) ==> {
                                    println("CLS clicado")
                              }
                              (mx >= 408 && mx <= 528 && my >= 540 && my <= 576) ==> {
                                    rodando = false
                              }
                        }
                  }
            }
      }
      mut as int64: _ = stdGfxWindowClose(win)
      println("Janela fechada.")
}
```

---

## Estimativa de Esforço

| Arquivo | Linhas estimadas | Complexidade |
|---|---|---|
| `flux_gfx.c` | ~350 | Alta (Win32 GDI double-buffer) |
| `gfx_helpers.py` | ~280 | Alta (ctypes Win32) |
| `interpreter.py` | ~60 | Baixa |
| `vm/runtime.py` | ~20 | Baixa |
| `llvm/codegen.py` | ~120 | Média |
| `flux_lv.py` | ~3 | Baixa |
| `wasm/codegen.py` | ~120 | Média |
| `web_wasm/index.html` | ~180 | Média |
| `web_wasm/wasi_worker.js` | ~90 | Alta |
| `NativeGfxStdLib.fdsl` | ~80 | Baixa |
| Exemplo `.flux` | ~50 | Baixa |
| **Total** | **~1353** | |

---

## Dependências e Ordem de Implementação

```
flux_gfx.c
    ↓
gfx_helpers.py
    ↓
interpreter.py + vm/runtime.py   (paralelo)
    ↓
llvm/codegen.py + flux_lv.py     (paralelo)
    ↓
wasm/codegen.py
    ↓
web_wasm/wasi_worker.js + index.html  (paralelo)
    ↓
NativeGfxStdLib.fdsl
    ↓
ExampleOfUseNativeGfxStdLib_CanvasButtons.flux
```

---

## Notas de Compatibilidade

- `backend_compliance.py` não testará exemplos com loop de eventos infinito interativo
- Criar versão determinística do exemplo para o compliance (sem loop, apenas abre/fecha/reporta)
- WAT (`wasmer` CLI) recebe stubs — sem janela fora do web runner
- Linux/macOS: stubs no `flux_gfx.c` e fallback tkinter no `gfx_helpers.py`

---

## Integração: GfxStdLib × GuiStdLib × NativeGfxStdLib

### 1. Arquitetura em 3 Camadas

1. **Camada 1: Driver de Hardware (`NativeGfxStdLib.fdsl`)**
   - Criação e controle de janela (Win32 HWND / Canvas HTML5).
   - Rasterização de primitivas em baixo nível (`clear`, `fillRect`, `drawLine`, `drawText`).
   - Coleta de eventos reais do SO/Navegador (`eventPoll`, `eventX`, `eventY`, `windowClosed`).
   - Double-buffering e VSync (`windowFlush`).

2. **Camada 2: Motor Gráfico & Física Óptica (`GfxStdLib.fdsl`)**
   - Modelos de cor (RGBA, Hex, Lerp, Alpha, espectro Kelvin).
   - Geometria e detecção de colisões matemáticas (`gfxCheckCollisionPointRec`, `gfxCheckCollisionCircles`).
   - Projeção e Câmera 2D (`gfxWorldToScreen2D`, zoom, rotação).
   - Ponte opcional `GfxNativeBridgeContract` para converter primitivas de alto nível (`list of int64: color`, `float64`) para chamadas `stdGfx*`.

3. **Camada 3: Interface Declarativa IMGUI (`GuiStdLib.fdsl`)**
   - Gerenciamento de layout (Row, Column, Spacing, Cursor, margens).
   - Temas visuais e paletas de cores (Dark, Light, Custom).
   - Widgets interativos (Botões, Sliders, Checkboxes, Inputs, Scroll).
   - Ponte opcional `GuiNativeBridgeContract` para vincular janela nativa, sincronizar mouse real e renderizar widgets temáticos com realce de hover e clique.

### 2. Ciclo de Vida do Frame (Frame Loop)

A cada iteração do `infinite (rodando)`:
1. **Entrada de Eventos**: `stdGfxEventPoll(win)` drena eventos de hardware e atualiza coordenadas de mouse.
2. **Hit-Testing e Lógica**: `gfxCheckCollisionPointRec(...)` determina se o mouse está sobre botões (hover/pressed).
3. **Renderização**: `stdGfxClear` limpa a tela; botões são desenhados com a cor do tema correspondente ao estado.
4. **Buffer Swap**: `stdGfxWindowFlush(win)` apresenta o frame final ao usuário sem flickering.

