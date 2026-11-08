# 🛠️ `fluxfmt` — fluxfmt — Utilitário de Formatação Canônica de Código TheFlux

> **Binário Canônico**: `bin/fluxfmt.exe (Windows) / bin/fluxfmt (Linux)`  
> **Código-Fonte**: [`src/tools/fluxfmt/fluxfmt.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxfmt/fluxfmt.flux)  
> **Versão Oficial**: `v1.0.0`  
> **Status**: ✅ Homologado no ecossistema TheFlux v1.0.0

---

## 1. Visão Geral e Funcionalidades

O **`fluxfmt`** é o formatador oficial de código-fonte da linguagem TheFlux, concebido para impor consistência visual e estilística rigorosa em arquivos `.flux` e `.fdsl`. 

Ele implementa as regras da gramática canônica TheFlux:
1. **Indentação Estrita de 6 Espaços**: Cada nível de aninhamento de bloco (`program`, `contract`, `agent`, `route`, `infinite`, funções, structs e enums) recebe exatamente 6 espaços em branco, sem tabulações (*tabs*).
2. **Normalização de Comentários**: Converte comentários legados `#` para o padrão `#L` (comentário de linha) ou preserva blocos `#B ... B#`.
3. **Simplificação de Expressões de Guarda (`--simplify`)**: Remove parênteses redundantes em guardas de rota (ex: `(x > 0) ==>` torna-se `x > 0 ==>`).
4. **Higiene de Espaços em Branco**: Remove espaços excedentes no final de linhas (*trailing whitespace*) e garante final de arquivo limpo com quebra de linha determinística.

---

## 2. Modos de Operação

### 2.1 Modos de Operação
- **Modo Verificação (`-l` / `--list`)**: Inspeciona arquivos e lista apenas os caminhos daqueles que violam o padrão de formatação, retornando código de saída `1` se houver divergências. Ideal para linting em *pre-commit hooks* e CI/CD.
- **Modo Diff (`-d` / `--diff`)**: Computa as diferenças e exibe um diff unificado colorido no formato patch (`---` e `+++`) sem efetuar modificações no disco.
- **Modo Escrita (`-w` / `--write`)**: Aplica a formatação canônica diretamente sobre os arquivos no disco apenas se houver alterações reais.
- **Modo Simplificação (`-s` / `--simplify`)**: Além da indentação, aplica regras de modernização sintática e simplificação de código.

---

## 3. Especificação de Entradas e Opções de Linha de Comando

| Flag Curta | Flag Longa | Argumento | Padrão | Descrição |
|---|---|---|---|---|
| `-w` | `--write` | *nenhum* | `false` | Reescreve o arquivo fonte no disco se houver mudanças |
| `-d` | `--diff` | *nenhum* | `false` | Exibe diff unificado no formato patch sem alterar o disco |
| `-l` | `--list` | *nenhum* | `false` | Lista caminhos dos arquivos fora do padrão canônico |
| `-s` | `--simplify` | *nenhum* | `false` | Simplifica código (# para #L, parênteses em rotas) |
| `-e` | `--all-errors` | *nenhum* | `false` | Reporta todos os erros sintáticos/lexicais sem abortar precocemente |
| `-r` | `--recursive` | *nenhum* | `false` | Percorre subdiretórios recursivamente |
| `-h` | `--help` | *nenhum* | — | Exibe o manual de ajuda e sintaxe |
| `-v` | `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |

---

## 4. Especificação de Retornos e Saídas

### 4.1 Códigos de Término (Exit Codes)
| Código de Saída | Significado | Condição |
|:---:|---|---|
| `0` | **Conforme / Sucesso** | Todos os arquivos estão formatados ou foram reescritos com sucesso |
| `1` | **Divergência ou Erro** | Arquivos fora do padrão detectados no modo `-l`, ou erro sintático |

### 4.2 Saída no Terminal (stdout/stderr)
- No modo `-l`: Imprime a lista de caminhos que necessitam de formatação.
- No modo `-d`: Imprime patches unificados no formato:
  ```diff
  --- a/src/main.flux
  +++ b/src/main.flux
  @@ -1,5 +1,5 @@
  -# Legado
  +#L Canonico
  ```
- No modo `-w`: Imprime resumo informativo dos arquivos formatados.

---

## 5. Exemplos Canônicos de Uso e Fluxos de Trabalho

```powershell
# 1. Verificar se algum arquivo no projeto está fora do padrão (CI/CD)
fluxfmt -l -r src\*

# 2. Exibir o diff das correções propostas sem alterar o disco
fluxfmt -d src\main.flux

# 3. Formatar e simplificar todos os arquivos da pasta src recursivamente
fluxfmt -w -s -r src\*

# 4. Formatar arquivo específico no disco
fluxfmt -w examples\Canon\ExampleOfRoute.flux
```
