# 📚 `RegexStdLib` — Processamento de Expressões Regulares, Captura e Substituição

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/RegexStdLib/RegexStdLib.fdsl`  
> **Modo de Importação**: `use RegexStdLib` ou `use RegexStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`RegexStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Engine de expressões regulares em conformidade com o padrão PCRE: compilação de padrões, verificação de correspondência (`match`), busca de subsequências (`search`), extração de grupos nomeados e capturas múltiplas com substituição dinâmica.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `RegexStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **5 módulos de domínio** e declara **27 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `RegexCapture.fdsl` | `RegexCaptureContract` | Domínio especializado de `RegexCapture` | 4 |
| `RegexPreset.fdsl` | `RegexPresetContract` | Domínio especializado de `RegexPreset` | 6 |
| `RegexSearch.fdsl` | `RegexSearchContract` | Domínio especializado de `RegexSearch` | 8 |
| `RegexTransform.fdsl` | `RegexTransformContract` | Domínio especializado de `RegexTransform` | 5 |
| `RegexUtility.fdsl` | `RegexUtilityContract` | Domínio especializado de `RegexUtility` | 4 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `RegexStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `RegexCaptureContract` (`RegexCapture.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `regexCaptureGroups` | `op regexCaptureGroups (as string: pattern, as string: text) as map` | `map` |
| `regexCaptureAll` | `op regexCaptureAll (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexExtractGroups` | `op regexExtractGroups (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexExtractAllGroups` | `op regexExtractAllGroups (as string: pattern, as string: text) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op regexCaptureGroups`
```flux
op regexCaptureGroups (as string: pattern, as string: text) as map
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexCaptureGroups` no domínio `RegexCaptureContract`.

##### `op regexCaptureAll`
```flux
op regexCaptureAll (as string: pattern, as string: text) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexCaptureAll` no domínio `RegexCaptureContract`.

##### `op regexExtractGroups`
```flux
op regexExtractGroups (as string: pattern, as string: text) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexExtractGroups` no domínio `RegexCaptureContract`.

##### `op regexExtractAllGroups`
```flux
op regexExtractAllGroups (as string: pattern, as string: text) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexExtractAllGroups` no domínio `RegexCaptureContract`.

### 4.2 Contrato `RegexPresetContract` (`RegexPreset.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `regexIsEmail` | `op regexIsEmail (as string: text) as bool` | `bool` |
| `regexIsUrl` | `op regexIsUrl (as string: text) as bool` | `bool` |
| `regexIsUuid` | `op regexIsUuid (as string: text) as bool` | `bool` |
| `regexIsIpv4` | `op regexIsIpv4 (as string: text) as bool` | `bool` |
| `regexIsNumeric` | `op regexIsNumeric (as string: text) as bool` | `bool` |
| `regexIsDate` | `op regexIsDate (as string: text) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op regexIsEmail`
```flux
op regexIsEmail (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsEmail` no domínio `RegexPresetContract`.

##### `op regexIsUrl`
```flux
op regexIsUrl (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsUrl` no domínio `RegexPresetContract`.

##### `op regexIsUuid`
```flux
op regexIsUuid (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsUuid` no domínio `RegexPresetContract`.

##### `op regexIsIpv4`
```flux
op regexIsIpv4 (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsIpv4` no domínio `RegexPresetContract`.

##### `op regexIsNumeric`
```flux
op regexIsNumeric (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsNumeric` no domínio `RegexPresetContract`.

##### `op regexIsDate`
```flux
op regexIsDate (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsDate` no domínio `RegexPresetContract`.

### 4.3 Contrato `RegexSearchContract` (`RegexSearch.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `regexIsMatch` | `op regexIsMatch (as string: pattern, as string: text) as bool` | `bool` |
| `regexFullMatch` | `op regexFullMatch (as string: pattern, as string: text) as bool` | `bool` |
| `regexFind` | `op regexFind (as string: pattern, as string: text) as string` | `string` |
| `regexFindAll` | `op regexFindAll (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexFindIndex` | `op regexFindIndex (as string: pattern, as string: text) as int64` | `int64` |
| `regexFindSpan` | `op regexFindSpan (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexFindAllSpans` | `op regexFindAllSpans (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexCount` | `op regexCount (as string: pattern, as string: text) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op regexIsMatch`
```flux
op regexIsMatch (as string: pattern, as string: text) as bool
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsMatch` no domínio `RegexSearchContract`.

##### `op regexFullMatch`
```flux
op regexFullMatch (as string: pattern, as string: text) as bool
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexFullMatch` no domínio `RegexSearchContract`.

##### `op regexFind`
```flux
op regexFind (as string: pattern, as string: text) as string
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexFind` no domínio `RegexSearchContract`.

##### `op regexFindAll`
```flux
op regexFindAll (as string: pattern, as string: text) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexFindAll` no domínio `RegexSearchContract`.

##### `op regexFindIndex`
```flux
op regexFindIndex (as string: pattern, as string: text) as int64
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexFindIndex` no domínio `RegexSearchContract`.

##### `op regexFindSpan`
```flux
op regexFindSpan (as string: pattern, as string: text) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexFindSpan` no domínio `RegexSearchContract`.

##### `op regexFindAllSpans`
```flux
op regexFindAllSpans (as string: pattern, as string: text) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexFindAllSpans` no domínio `RegexSearchContract`.

##### `op regexCount`
```flux
op regexCount (as string: pattern, as string: text) as int64
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexCount` no domínio `RegexSearchContract`.

### 4.4 Contrato `RegexTransformContract` (`RegexTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `regexReplace` | `op regexReplace (as string: pattern, as string: text, as string: replacement) as string` | `string` |
| `regexReplaceFirst` | `op regexReplaceFirst (as string: pattern, as string: text, as string: replacement) as string` | `string` |
| `regexReplaceLimit` | `op regexReplaceLimit (as string: pattern, as string: text, as string: replacement, as int64: max_count) as string` | `string` |
| `regexSplit` | `op regexSplit (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexSplitLimit` | `op regexSplitLimit (as string: pattern, as string: text, as int64: limit) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op regexReplace`
```flux
op regexReplace (as string: pattern, as string: text, as string: replacement) as string
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `replacement` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexReplace` no domínio `RegexTransformContract`.

##### `op regexReplaceFirst`
```flux
op regexReplaceFirst (as string: pattern, as string: text, as string: replacement) as string
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `replacement` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexReplaceFirst` no domínio `RegexTransformContract`.

##### `op regexReplaceLimit`
```flux
op regexReplaceLimit (as string: pattern, as string: text, as string: replacement, as int64: max_count) as string
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `replacement` (`string`): Parâmetro de entrada para processamento da operação.
  - `max_count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexReplaceLimit` no domínio `RegexTransformContract`.

##### `op regexSplit`
```flux
op regexSplit (as string: pattern, as string: text) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexSplit` no domínio `RegexTransformContract`.

##### `op regexSplitLimit`
```flux
op regexSplitLimit (as string: pattern, as string: text, as int64: limit) as list of data
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `limit` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexSplitLimit` no domínio `RegexTransformContract`.

### 4.5 Contrato `RegexUtilityContract` (`RegexUtility.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `regexEscape` | `op regexEscape (as string: text) as string` | `string` |
| `regexIsValid` | `op regexIsValid (as string: pattern) as bool` | `bool` |
| `regexIsPatternLiteral` | `op regexIsPatternLiteral (as string: pattern) as bool` | `bool` |
| `regexMatchWithFlags` | `op regexMatchWithFlags (as string: pattern, as string: text, as string: flags) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op regexEscape`
```flux
op regexEscape (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexEscape` no domínio `RegexUtilityContract`.

##### `op regexIsValid`
```flux
op regexIsValid (as string: pattern) as bool
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsValid` no domínio `RegexUtilityContract`.

##### `op regexIsPatternLiteral`
```flux
op regexIsPatternLiteral (as string: pattern) as bool
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexIsPatternLiteral` no domínio `RegexUtilityContract`.

##### `op regexMatchWithFlags`
```flux
op regexMatchWithFlags (as string: pattern, as string: text, as string: flags) as bool
```
- **Parâmetros**:
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `flags` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `regexMatchWithFlags` no domínio `RegexUtilityContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da RegexStdLib
use RegexStdLib

program (ExemploRegexStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: RegexStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = RegexStdLib::regexMatch("^[0-9]+$", "12345")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
