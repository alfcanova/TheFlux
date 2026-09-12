## Context

O compilador TheFlux (`src/flux_proto/wasm/codegen.py`) gera módulos WASM com um formato fixo e minimalista:

- **Import**: apenas `wasi_snapshot_preview1.fd_write` (assinatura `[i32, i32, i32, i32] → [i32]`).
- **Exports**: `memory` (memória linear) e `_start` (função sem parâmetros/retorno).
- **Saída**: toda escrita de `print` flui por `fd_write` para o fd 1 (stdout), montando um iovec na memória linear.

A pasta `web_wasm/` está vazia. `t_wasm-1.0/` contém 6 módulos de exemplo. Não há specs existentes em `openspec/specs/`. O projeto usa Python 3.14+ e Node 24; o ambiente é Windows (pwsh).

Um browser não consegue listar arquivos de uma pasta arbitrária do disco nem fazer `fetch` de `file://` — é necessário um servidor HTTP local que exponha tanto a listagem quanto os binários.

## Goals / Non-Goals

**Goals:**
- Servidor HTTP em Python 3.14 com **stdlib apenas** (zero dependências novas).
- Página única servida em `web_wasm/`, sem frameworks nem CDNs.
- Listagem em tempo real de `t_wasm-1.0/` (polling leve, sem cache).
- Execução do `.wasm` selecionado no browser com shim WASI mínimo que captura a saída do programa.
- Compatibilidade garantida com o formato emitido pelo codegen atual.

**Non-Goals:**
- Suporte a outras versões (`t_wasm-2.0`, `t_wasm-3.0`) ou a `.wat`.
- Threads/workers para isolamento de loops infinitos (os exemplos têm condição de saída).
- Importação de módulos FDSL/runtime WASI completo (nenhum módulo atual os usa).
- Segurança multi-usuário (servidor local de desenvolvimento).

## Decisions

**1. Tecnologia do servidor: Python `http.server` (stdlib) em vez de Node/Express.**
O projeto é Python-first (compilador inteiro em Python 3.14). Um único arquivo `server.py` sem `requirements.txt` roda em qualquer máquina com Python. Node/Express exigiria `npm install` e introduziria uma cadeia de dependências para uma tarefa trivial. Alternativa considerada: Node `http` puro — descartada por consistência com o ecossistema do repo.

**2. Raiz de serviço = raiz do projeto.**
`SimpleHTTPRequestHandler` com `directory=ROOT` (`D:\Projetos\TheFlux`) serve `/web_wasm/index.html` (página) e `/t_wasm-1.0/<arquivo>.wasm` (binários) sem lógica de roteamento customizada. Um handler derivado intercepta apenas `/api/files`; todo o resto delega ao handler estático. Alternativa: rota dedicada `/wasm/` — descartada por não haver necessidade de redirecionamento.

**3. Listagem em tempo real por polling (2s) em vez de SSE/WebSocket.**
Polling com `fetch` + `setInterval` é simples, idempotente e suficiente para o requisito de "até 2 segundos". `Cache-Control: no-store` no endpoint e nos `.wasm` evita respostas obsoletas. SSE seria "mais real-time" mas adiciona estado de conexão no servidor sem ganho perceptível.

**4. Instantiation via `fetch().arrayBuffer()` + `WebAssembly.instantiate`, não `instantiateStreaming`.**
`instantiateStreaming` exige MIME `application/wasm` no Content-Type; `SimpleHTTPRequestHandler` não garante esse mime em todas as versões do Python. Com `arrayBuffer` o Content-Type é irrelevante e o código funciona em qualquer ambiente. Alternativa: estender mimetypes — descartada por fragilidade.

**5. Shim WASI assíncrono no client.**
O shim de `fd_write` é construído após a instanciação (precisa de `exports.memory`). Para evitar o problema de circularidade, o shim segura uma referência ao `instance` em uma variável `let instance`; o import object referencia uma função que acessa `instance.exports.memory` no momento da chamada — correto porque `fd_write` só é invocado durante/até a primeira chamada de `_start`, já com a instância criada. O decode é feito com `TextDecoder` (UTF-8), em conformidade com os `data segments` ASCII do codegen.

**6. Código client em um único `index.html`.**
CSS e JS embutidos mantêm a entrega num único arquivo, sem build step. `python server.py` + abrir `http://localhost:8000` é o fluxo de uso completo.

## Risks / Trade-offs

- **[Loop infinito congela a UI]** → Execução na main thread; os módulos de exemplo possuem condição de saída (confirmado pelo usuário). Um recarregamento da página encerra qualquer execução travada. Mitigação futura: mover para Web Worker com `terminate()`.
- **[Módulo com memória grande]** → A memória exportada é limitada a 1-2 páginas pelo codegen (configuração mínima); custo de leitura do buffer é desprezível.
- **[Conteúdo binário na listagem]** → A listagem inclui todos os arquivos da pasta, mas itens não-`.wasm` são desabilitados na UI (nenhuma tentativa de instanciação).
- **[Multiplataforma]** → Paths relativos e `pathlib` no servidor; porta configurável via `--port` para evitar conflito de porta 8000.
