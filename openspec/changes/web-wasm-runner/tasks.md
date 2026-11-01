## 1. Servidor local (`web_wasm/server.py`)

- [x] 1.1 Criar `web_wasm/server.py` com `ThreadingHTTPServer` + handler derivado de `SimpleHTTPRequestHandler` servindo a raiz do projeto
- [x] 1.2 Implementar `GET /api/files` retornando JSON ordenado com todos os arquivos de `t_wasm-1.0/`
- [x] 1.3 Enviar `Cache-Control: no-store` para `/api/files` e respostas `.wasm`
- [x] 1.4 Suportar `--port` (padrão 8000) e tratar erro de porta em uso com mensagem clara

## 2. Página `web_wasm/index.html`

- [x] 2.1 Estruturar layout flex: painel esquerdo (lista) + painel direito (console), com barra de status
- [x] 2.2 Implementar polling a cada 2s de `/api/files` com re-render preservando seleção e itens não-`.wasm` desabilitados
- [x] 2.3 Implementar execução: fetch + arrayBuffer + `WebAssembly.instantiate` com shim WASI `fd_write` (iovec da memória exportada, decode UTF-8, `nwritten`, errno 8 para fd inválido)
- [x] 2.4 Invocar `exports._start()`, exibir saída no painel direito e status concluído/erro com tempo decorrido
- [x] 2.5 Adicionar botões "limpar console" e "recarregar listagem"

## 3. Verificação

- [x] 3.1 Validar `python -m py_compile web_wasm/server.py` e iniciar o servidor
- [x] 3.2 Confirmar `GET /api/files` e cabeçalhos `no-store` via `curl`
- [x] 3.3 Executar `ExampleOfPrint.wasm` e `ExampleOfBreak.wasm` no browser e conferir saída; conferir reflexo da listagem ao adicionar/remover arquivo em `t_wasm-1.0/`
