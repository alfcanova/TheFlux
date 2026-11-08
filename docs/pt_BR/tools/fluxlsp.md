# 🛠️ `fluxlsp` — fluxlsp — Servidor Language Server Protocol (LSP) e Suporte a IDEs

> **Binário Canônico**: `bin/fluxlsp.exe (Windows) / bin/fluxlsp (Linux)`  
> **Código-Fonte**: [`src/tools/fluxlsp/fluxlsp.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxlsp/fluxlsp.flux)  
> **Versão Oficial**: `v1.0.0`  
> **Status**: ✅ Homologado no ecossistema TheFlux v1.0.0

---

## 1. Visão Geral e Funcionalidades

O **`fluxlsp`** é o servidor de linguagem oficial e motor de suporte a IDEs da linguagem TheFlux. Ele implementa a especificação padronizada **Language Server Protocol (LSP)** sobre transporte JSON-RPC 2.0 via entrada/saída padrão (`stdio`), oferecendo uma experiência de desenvolvimento rica, reativa e inteligente no Visual Studio Code e em qualquer editor compatível com LSP.

Adicionalmente, o `fluxlsp` possui o gerador de esquemas **User Defined Language (UDL 2.1)** para Notepad++ via flag `--xml`, permitindo exportar o realce sintático oficial de palavras-chave, comentários `#L` e operadores para ambientes sem suporte a LSP.

---

## 2. Modos de Operação

### 2.1 Servidor LSP para Visual Studio Code (JSON-RPC 2.0)
Quando invocado sem opções (`fluxlsp`), o utilitário entra no modo de escuta contínua de requisições e notificações estruturadas via `stdio`, implementando os seguintes recursos:
- **`textDocument/publishDiagnostics`**: Diagnósticos reativos de sintaxe, validação em tempo real de indentação de 6 espaços e alertas do `fluxlinter`.
- **`textDocument/hover`**: Documentação sob demanda ao repousar o cursor sobre palavras-chave, contratos, agentes e operadores.
- **`textDocument/completion`**: Autocompletar contextual com snippets semânticos para `route`, `infinite`, `program`, `contract`, `agent`, etc.
- **`textDocument/definition`**: Navegação com salto direto (*Go to Definition*) para funções e contratos.
- **`textDocument/formatting`**: Formatação canônica do documento acionada via atalho de teclado ou automaticamente ao salvar (*Format on Save*), integrando o motor do `fluxfmt`.
- **`textDocument/documentSymbol`**: Árvore hierárquica de símbolos para navegação por breadcrumbs e contorno de documento.

### 2.2 Gerador XML Notepad++ UDL 2.1 (`--xml`)
Quando invocado com `fluxlsp --xml [caminho]`, o utilitário gera um documento XML padronizado contendo todas as 74 palavras-chave canônicas TheFlux, delimitadores de comentários (`#L`, `#B ... B#`), separadores de blocos e operadores.

---

## 3. Especificação de Entradas e Opções de Linha de Comando

| Opção / Flag | Argumento | Padrão | Descrição |
|---|---|---|---|
| *nenhuma* | — | — | Inicia o servidor de linguagem LSP em background via JSON-RPC 2.0 (stdio) |
| `--xml` | `[caminho_arquivo]` | `theflux_udl.xml` | Exporta arquivo XML de realce sintático UDL 2.1 compatível com Notepad++ |
| `-h`, `--help` | *nenhum* | — | Exibe o manual de ajuda e sintaxe |
| `-v`, `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |

---

## 4. Especificação de Retornos e Saídas

### 4.1 Códigos de Término (Exit Codes)
| Código de Saída | Significado | Condição |
|:---:|---|---|
| `0` | **Sucesso** | Servidor finalizado normalmente via requisição `shutdown`/`exit` ou XML exportado |
| `1` | **Erro de Comunicação / I/O** | Quebra de pipe stdio, frame JSON-RPC corrompido ou erro de escrita do XML |

### 4.2 Protocolos e Formatos de Saída
- **No Modo LSP**:
  - Mensagens JSON-RPC 2.0 emitidas em `stdout` com cabeçalho `Content-Length: <n>

{"jsonrpc":"2.0",...}`.
  - Logs estruturados e telemetria emitidos em `stderr`.
- **No Modo XML**:
  - Arquivo XML em conformidade com o DTD do Notepad++ contendo grupos de palavras-chave (`Keywords1` a `Keywords8`), estilos de operadores e delimitadores de comentários.

---

## 5. Exemplos Canônicos de Uso e Fluxos de Trabalho

```powershell
# 1. Iniciar servidor LSP (geralmente invocado pela extensao TheFlux do VS Code)
fluxlsp

# 2. Gerar arquivo de realce sintatico para Notepad++
fluxlsp --xml theflux_notepadpp.xml

# 3. Importar no Notepad++:
#    Menu: Linguagem -> Definir linguagem... -> Importar... -> selecionar 'theflux_notepadpp.xml'
```
