# 🛠️ `fluxlinter` — fluxlinter — Utilitário de Análise Estática e Linter Canônico

> **Binário Canônico**: `bin/fluxlinter.exe (Windows) / bin/fluxlinter (Linux)`  
> **Código-Fonte**: [`src/tools/fluxlinter/fluxlinter.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxlinter/fluxlinter.flux)  
> **Versão Oficial**: `v1.0.0`  
> **Status**: ✅ Homologado no ecossistema TheFlux v1.0.0

---

## 1. Visão Geral e Funcionalidades

O **`fluxlinter`** é o analisador estático e linter canônico oficial do TheFlux. Inspirado na arquitetura e ergonomia do Clippy do ecossistema Rust (`rustc`), ele realiza varreduras profundas na árvore sintática abstrata (AST) e na estrutura de tokens para identificar *bugs* potenciais, construções suspeitas, anti-patterns e desvios de estilo antes da compilação.

O utilitário organiza suas regras em 4 categorias formais de severidade e oferece recursos avançados de **Autofix** (`--fix`), permitindo corrigir automaticamente problemas de estilo e complexidade diretamente no disco.

---

## 2. Modos de Operação

### 2.1 Categorias e Regras Registradas (11 Lints Oficiais)
| Categoria | Nível Padrão | Regras Registradas |
|---|:---:|---|
| **`correctness`** | `deny` | `division_by_zero` (divisão inteira ou resto por zero literal)<br>`unreachable_route_arm` (ramo de rota posicionado após coringa `_`)<br>`empty_infinite_loop` (loop `infinite` sem saída via `break` ou `emit`) |
| **`suspicious`** | `warn` | `self_assignment` (atribuição redundante `x = x`)<br>`tautological_comparison` (comparação sempre verdadeira/falsa `a == a`)<br>`missing_operation_emit` (operação de agente sem caminho de `emit`) |
| **`style`** | `warn` | `redundant_mut` (variável `mut` nunca reatribuída; sugere `imut`)<br>`legacy_comment` (comentário `#` em vez de `#L`)<br>`naming_convention` (contrato ou agente fora de PascalCase) |
| **`complexity`** | `warn` | `collapsible_route` (rota booleana simplificável em expressão direta)<br>`superfluous_guard_parens` (parênteses redundantes em guarda `(c) ==>`) |

### 2.2 Sistema de Controle de Severidade
O desenvolvedor pode redefinir o comportamento de qualquer regra individual ou categoria inteira:
- `-W, --warn <lint|cat>`: Emite aviso informativo no terminal sem interromper o build.
- `-D, --deny <lint|cat>`: Promove a infração a erro impeditivo (exit code `1`).
- `-A, --allow <lint|cat>`: Silencia completamente a verificação.
- `-F, --forbid <lint|cat>`: Trata a regra como proibição irrevogável.

---

## 3. Especificação de Entradas e Opções de Linha de Comando

| Flag Curta | Flag Longa | Argumento | Padrão | Descrição |
|---|---|---|---|---|
| `-W` | `--warn` | `<lint\|cat>` | — | Define a severidade de uma regra ou categoria como warning |
| `-D` | `--deny` | `<lint\|cat>` | — | Define a severidade como erro impeditivo (exit code 1) |
| `-A` | `--allow` | `<lint\|cat>` | — | Silencia/ignora a regra ou categoria especificada |
| `-F` | `--forbid` | `<lint\|cat>` | — | Proibição estrita irrevogável da regra |
| `-f` | `--fix` | *nenhum* | `false` | Aplica correções automáticas seguras diretamente no disco |
| `-d` | `--diff` | *nenhum* | `false` | Exibe diff unificado com as correções propostas sem alterar disco |
| `-l` | `--list` | *nenhum* | — | Lista todos os 11 lints registrados com suas categorias |
| `-e` | `--explain` | `<lint>` | — | Exibe documentação embutida detalhada e exemplos do lint |
| `-r` | `--recursive` | *nenhum* | `false` | Inspeciona arquivos em subdiretórios recursivamente |
| `-h` | `--help` | *nenhum* | — | Exibe o manual de ajuda e sintaxe |
| `-v` | `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |

---

## 4. Especificação de Retornos e Saídas

### 4.1 Códigos de Término (Exit Codes)
| Código de Saída | Significado | Condição |
|:---:|---|---|
| `0` | **Sucesso** | Nenhuma violação impeditiva encontrada (apenas warnings ou código limpo) |
| `1` | **Erro de Lint** | Pelo menos uma infração de nível `deny` foi disparada |

### 4.2 Relatórios Diagnósticos (stdout/stderr)
Cada diagnóstico emitido detalha:
- Localização exata: `<arquivo>:<linha>:<coluna>`
- Nível de severidade: `error:`, `warning:` ou `suggestion:`
- Nome qualificado da regra: `[fluxlinter::<regra>]`
- Destaque visual da linha com apontador `^`
- Sugestão de correção acionável.

---

## 5. Exemplos Canônicos de Uso e Fluxos de Trabalho

```powershell
# 1. Analisar código com configurações padrão
fluxlinter src\* -r

# 2. Exigir conformidade estrita (tratar avisos de estilo como erro impeditivo no CI)
fluxlinter -D style src\* -r

# 3. Aplicar correções automáticas no disco
fluxlinter -f src\main.flux

# 4. Explicar um lint específico com exemplos
fluxlinter --explain fluxlinter::division_by_zero

# 5. Listar todos os lints disponíveis
fluxlinter --list
```
