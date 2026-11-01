## Why

Os artefatos `.wasm` compilados pelo TheFlux (em `t_wasm-1.0/`) só podem ser executados localmente via CLI (`wasmer run`), dificultando demonstrações e inspeção visual. Uma página web com listagem em tempo real e execução no browser elimina essa fricção, mostrando a saída dos programas compilados sem instalar runtime.

## What Changes

- Criar `web_wasm/server.py`: servidor HTTP local em Python 3.14 (stdlib, sem dependências) que:
  - Serve os arquivos estáticos de `web_wasm/` e os `.wasm` de `t_wasm-1.0/` (via raiz do projeto).
  - Expõe `GET /api/files` retornando JSON com a listagem de todos os arquivos de `t_wasm-1.0/`.
  - Envia `Cache-Control: no-store` para `.wasm` e `/api/files`.
  - Aceita `--port` para configurar a porta (padrão 8000).
- Criar `web_wasm/index.html`: página única (HTML+CSS+JS embutidos, sem dependências externas) que:
  - Lista em tempo real (polling a cada 2s) os arquivos de `t_wasm-1.0/` em um painel esquerdo, preservando o item selecionado entre atualizações.
  - Ao selecionar um arquivo `.wasm`, executa-o no browser via `WebAssembly.instantiate` (fetch + arrayBuffer) e mostra a saída em um console à direita.
  - Implementa um shim WASI mínimo para `wasi_snapshot_preview1.fd_write`, decodificando o iovec da memória exportada como UTF-8.
  - Mostra status da execução (executando/concluído/erro) e tempo decorrido; oferece botões para limpar o console e recarregar a listagem.
  - Itens não-`.wasm` na listagem ficam desabilitados.

## Capabilities

### New Capabilities
- `web-wasm-runner`: página web que lista arquivos de `t_wasm-1.0/` em tempo real e executa os `.wasm` selecionados no browser com shim WASI.

### Modified Capabilities
<!-- Nenhuma spec existente é alterada. -->

## Impact

- Código novo: `web_wasm/server.py`, `web_wasm/index.html` (pasta `web_wasm/` atualmente vazia).
- Nenhuma alteração em `src/`, `flux/`, compilador ou runtime existente.
- Nenhuma dependência nova (Python 3.14 stdlib; browser moderno com suporte a WebAssembly).
- Compatível com o formato emitido por `src/flux_proto/wasm/codegen.py` (imports: `wasi_snapshot_preview1.fd_write`; exports: `memory`, `_start`).
