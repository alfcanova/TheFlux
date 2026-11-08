# TheFlux Language Support & LSP (VS Code)

Extensao oficial do **TheFlux** para o Visual Studio Code, equipada com integracao nativa ao **Language Server Protocol (`fluxlsp`)**, realce de sintaxe TextMate, autocompletar inteligente com snippets, formatacao canonica automatica e diagnosticos semanticos em tempo real.

---

## Recursos Suportados

1. **Language Server Protocol Nativo (`fluxlsp`)**:
   - **Diagnosticos Semanticos (`textDocument/publishDiagnostics`)**:
     - Detecao imediata de violacao de indentacao canonica (obrigatoriedade de multiplos de 6 espacos).
     - Proibicao de caracteres de tabulacao (`\t`) com indicacao visual de coluna e linha.
     - Deteccao de comentarios legados (`#`) sugerindo `#L`, `#B...B#` ou `#D...D#`.
     - Aviso de pontos-e-virgulas redundantes (`;`).
     - Alerta de divisao estatica por zero (`/ 0`, `/i 0`, `/r 0`).
   - **Documentacao ao Passar o Mouse (`textDocument/hover`)**:
     - Explicacoes ricas em Markdown com exemplos de codigo para todas as palavras-chave, tipos de dados e operadores.
   - **Autocompletar e Snippets (`textDocument/completion`)**:
     - Snippets estruturados para `contract`, `agent`, `route`, `infinite`, `function`, etc.
   - **Navegacao para Definicao (`textDocument/definition`)**:
     - Salto direto (F12) para a declaracao de contratos, agentes, funcoes e operacoes.
   - **Formatacao de Documento (`textDocument/formatting`)**:
     - Formatacao automatica no padrao canonico do TheFlux (6 espacos de indentacao, normalizacao de espacamentos e remocao de terminadores redundantes).
   - **Breadcrumbs e Simbolos de Documento (`textDocument/documentSymbol`)**:
     - Navegacao hierarquica pelo outline do arquivo.

2. **Esquema de Cores com Fundo Suave**:
   - Destaque semantico com fundo suave exclusivo:
     - **Variaveis Mutaveis (`mut`)**: Vermelho Suave (`#FF6B6B`) com fundo suave vinho escuro (`#3B1A1E`).
     - **Constantes Imutaveis (`imut`)**: Verde Claro (`#4ECCA3`) com fundo suave verde floresta escuro (`#183324`).
     - **Arquitetura (`contract`, `agent`)**: Lilas (`#C792EA`) com fundo suave roxo escuro (`#2E1C38`).
     - **Controle de Fluxo (`route`, `infinite`, `emit`)**: Ouro/Ambar (`#FFCB6B`) com fundo suave tabaco escuro (`#382F18`).
     - **Operadores de Fluxo (`==>`)**: Ciano Eletrico (`#00FFFF`) com fundo suave petrolio escuro (`#0A333A`).

3. **Exportacao para Notepad++ (UDL 2.1)**:
   - Gere o arquivo de definicao compativel com o Notepad++ diretamente pelo executavel do servidor:
     ```bash
     fluxlsp --xml
     # ou especificando o caminho de destino:
     fluxlsp --xml meuestilo_notepadpp.xml
     ```

---

## Instalacao no Visual Studio Code

### Opcao 1: Desenvolvimento Local (Link Simbolico / Extensoes)
Para testar a extensao no seu VS Code local:
```bash
# Navegue ate a pasta do VS Code no seu sistema:
# Windows: %USERPROFILE%\.vscode\extensions
# Linux/macOS: ~/.vscode/extensions

# Crie um link simbolico ou copie a pasta editors/vscode:
# Windows (PowerShell Executado como Administrador ou com Permissao de Desenvolvedor):
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.vscode\extensions\theflux-language-support" -Target "D:\Projetos\TheFlux\editors\vscode"
```

### Opcao 2: Empacotamento VSIX (via vsce)
Se tiver o `vsce` instalado (`npm install -g @vscode/vsce`):
```bash
cd editors/vscode
npm install
npx vsce package
code --install-extension theflux-language-support-1.0.0.vsix
```

---

## Configuracoes (`settings.json`)

No VS Code, abra as configuracoes (`Ctrl+,` ou `settings.json`) e configure:

```json
{
      "theflux.lsp.serverPath": "D:\\Projetos\\TheFlux\\bin\\fluxlsp.exe",
      "theflux.lsp.trace.server": "off",
      "[flux]": {
            "editor.tabSize": 6,
            "editor.insertSpaces": true,
            "editor.detectIndentation": false,
            "editor.formatOnSave": true
      }
}
```

---

## Executando o fluxlsp Manualmente via Linha de Comando

```bash
# Modo Servidor LSP via stdio:
bin\fluxlsp.exe

# Geracao de definicao XML Notepad++:
bin\fluxlsp.exe --xml theflux_npp.xml

# Exibir Ajuda:
bin\fluxlsp.exe --help

# Exibir Versao:
bin\fluxlsp.exe --version
```
