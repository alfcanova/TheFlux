# 📚 Arquitetura Padrão de Bibliotecas Modulares (`*StdLib`) da Linguagem TheFlux

> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Exemplo Canônico de Referência**: `stdlib/MathStdLib/`

---

> [!IMPORTANT]
> ### ⚠️ RESSALVA UNIVERSAL DE LINGUAGEM
> As diretrizes, convenções de nomenclatura, estruturas de diretório, contratos de domínio, manifestos declarativos via `use` e mecanismos de fusão transparente definidos neste documento são **padrões universais e mandatórios da linguagem TheFlux**.
> 
> **Esta arquitetura aplica-se rigorosamente a todas as 37 bibliotecas padrão (`*StdLib`) do ecossistema TheFlux** (por exemplo: `TimeStdLib`, `NetStdLib`, `IoStdLib`, `CryptoStdLib`, `DbStdLib`, `LinAlgStdLib`, `SimdStdLib`, etc.), bem como a quaisquer bibliotecas padrão modulares futuras. A biblioteca **`MathStdLib`** documentada a seguir constitui o **exemplo canônico e modelo formal de implementação** a ser seguido em toda a plataforma.

---

## 📦 0. Catálogo das 37 Bibliotecas Padrão pelos 4 Pilares Arquiteturais

|--------------------------|----------------------------|------------------------------|---------------------------|
| 🔤 1. Núcleo, Texto & OO | 📊 2. Estruturas & Estados | 🧮 3. Matemática & Gráficos | 🌐 4. Sistema, I/O & Rede |
|--------------------------|----------------------------|------------------------------|---------------------------|
| ✅`CharStdLib`           | ✅ `CompressStdLib`       | ✅ `FinStdLib`               | ✅ `ArchiveStdLib`        |
| ✅`ConvertStdLib`        | ✅ `DateTimeStdLib`       | ✅ `GraphPlotStdLib`         | ✅ `GfxStdLib`            |
| ✅`DebugStdLib`          | ✅ `DbStdLib`             | ✅ `HashStdLib`              | ✅ `GuiStdLib`            |
| ✅`DslStdLib`            | ✅ `FsmStdLib`            | ✅ `LinAlgStdLib`            | ✅ `IoStdLib`             |
| ✅`FileSignatureStdLib`  | ✅ `ListStdLib`           | ✅ `MathStdLib`              | ✅ `LowLevelStdLib`       |
| ✅`OoStdLib`             | ✅ `RandomStdLib`         | ✅ `SimdStdLib`              | ✅ `NativeGfxStdLib`      |
| ✅`FormatStdLib`         | ✅ `MapStdLib`            | ✅ `PhysStdLib`              | ✅ `NetStdLib`            |
| ✅`RegexStdLib`          | ✅ `SetStdLib`            | ✅ `StatStdLib`              | ✅ `OsStdLib`             |
| ✅`StringStdLib`         | ✅ `StructStdLib`         | ✅ `SymbolicStdLib`          | ✅ `RuntimeStdLib`        |
|                          |                            |                              | ✅ `ThreadStdLib`         |
|--------------------------|----------------------------|------------------------------|---------------------------|

*Total: 37 Bibliotecas Padrão em FDSL (`.fdsl`) com 100% de paridade multi-backend nos 6 alvos oficiais.*

---

## 🎯 1. Princípios Arquiteturais e Diretrizes de Design

### 1.1 Estrutura Física em Diretório Plano com Sufixo Mandatório `StdLib`
Cada biblioteca padrão é encapsulada em seu próprio diretório sob `stdlib/`, com o sufixo obrigatório `StdLib`. Todos os arquivos funcionais residem **estritamente no nível raiz da pasta**, sem subdiretórios intermediários (como `trig/` ou `io/`), garantindo simplicidade de navegação e resolução determinística:

```text
stdlib/
└── <Nome>StdLib/                       # Ex: MathStdLib, NetStdLib, TimeStdLib
    ├── <Nome>StdLib.fdsl               # Arquivo agregador mestre (Manifesto Declarativo)
    ├── <DominioA>.fdsl                 # Contrato + Storages + Ops do Domínio A
    ├── <DominioB>.fdsl                 # Contrato + Storages + Ops do Domínio B
    └── <DominioC>.fdsl                 # Contrato + Storages + Ops do Domínio C
```

### 1.2 O Arquivo Agregador Mestre como Manifesto, Tipos e Funções Gerais
O arquivo mestre deve se chamar obrigatoriamente `<Nome>StdLib/<Nome>StdLib.fdsl`. Ele atua como **Manifesto Declarativo, Interface Pública de Tipos e Provedor de Infraestrutura Base Compartilhada** da biblioteca, possuindo características cruciais:
1. **Declaração de Tipos Públicos Compartilhados**: Caso a biblioteca exponha estruturas (`struct`) ou enumerações (`enum`) utilizadas em múltiplos domínios (como `DecompressQuota` em `CompressStdLib`, `FinDecimal` em `FinStdLib` ou `SymbolicNode` em `SymbolicStdLib`), estas devem ser declaradas diretamente no topo do arquivo agregador mestre.
2. **Funções e Operações Utilitárias Gerais Compartilhadas (`op _*`)**: Operações auxiliares internas ou helpers consumidos por **dois ou mais arquivos `.fdsl`** (como `_fmtStrLen`, `_fmtCharAt`, `_listContains`, `_extractStructType`) residem diretamente no corpo do agente mestre: `agent (<Nome>StdLib) { op _... ==> { ... } }`.
3. **Declaração Explícita de Módulos**: Lista todos os módulos de domínio que integram a biblioteca através de diretivas `use <Modulo>` ou `use <Modulo>.fdsl`.
4. **Isolamento Total contra Arquivos Estranhos**: O compilador carrega **estritamente os módulos declarados no manifesto**. Qualquer arquivo colocado acidentalmente na pasta (por exemplo, um `net.fdsl` movido por engano, arquivos de rascunho ou backups) é **completamente ignorado**.
5. **Detecção e Validação Estrita de Typos**: Caso o desenvolvedor declare um módulo inexistente ou digite o nome incorretamente (ex.: `use Trignometry`), o compilador gera imediatamente um erro de importação (`ImportError`), evitando falhas silenciosas.

### 1.3 Contratos, Constantes e Operações Específicas nos Módulos de Domínio
Para máxima coesão, modularidade e independência funcional:
1. **Regra de Ouro dos Arquivos Filhos**: **Todo e qualquer arquivo filho de uma biblioteca modular (`.fdsl`) deve implementar formalmente um contrato de domínio** (`contract (<Dominio>Contract)` + `agent (<Nome>StdLib) impl <DominioContract> { ... }`). Não existem arquivos filhos "órfãos" sem contrato.
2. **Operações de Escopo Único no Próprio Arquivo**: Qualquer operação auxiliar interna (`op _*`) utilizada por **apenas um arquivo `.fdsl`** deve residir **estritamente dentro desse próprio arquivo** (por exemplo: `_fmtOrd` e `_fmtChr` em `FormatEncoding.fdsl`, ou `_fmtCharToHexDigit` em `FormatYaml.fdsl`).
3. **Constantes Pertencem ao Domínio**: Constantes e storages pertencem ao arquivo funcional que as rege (ex.: constantes matemáticas `PI64`, `E64`, etc. residem em `MathConstants.fdsl`). Na fusão, o compilador as unifica no agente compartilhado.
4. **Contratos Específicos e Autocontidos**: Cada arquivo `.fdsl` de domínio declara o seu respectivo contrato especializado e a sua respectiva implementação.

### 1.4 Mecanismo de Fusão Transparente (*Transparent Fusion*)
O motor de resolução do compilador ([`src/flux_proto/parser/import_resolver.py`](file:///D:/Projetos/TheFlux/src/flux_proto/parser/import_resolver.py)) implementa fusão estática transparente:
1. Detecta se o alvo do `use` corresponde a um diretório físico modular (`stdlib/<Nome>StdLib`).
2. Carrega e analisa o arquivo mestre `<Nome>StdLib/<Nome>StdLib.fdsl`.
3. Extrai a lista de módulos das diretivas `use` do manifesto.
4. Carrega cada módulo de domínio listado e executa a fusão (`_fuse_fdsl`):
   - **Operações (`ops`)**: Incorporadas ao corpo do agente unificado.
   - **Constantes (`storages`)**: Injetadas no corpo do agente e acessíveis a todas as operações.
   - **Contratos (`contracts` e `impl_contracts`)**: Registrados no arquivo mestre e no agente.
   - **Funções, Estruturas, Enumerações e Macros**: Fundidos transparentemente.
5. Limpa as diretivas `use` internas do manifesto no arquivo mestre (`master_file.use_decls = []`) para impedir que o resolver tente buscá-las externamente no escopo do programa chamador.
6. Registra o agente sob seu nome oficial, apelidos e sinônimos, garantindo geração correta em todos os 6 backends.

---

## 📐 2. Exemplo Canônico: `MathStdLib`

A biblioteca **`MathStdLib`** exemplifica a implementação completa desse padrão.

### 2.1 Estrutura de Arquivos de `stdlib/MathStdLib/`

```text
stdlib/
└── MathStdLib/
    ├── MathStdLib.fdsl                # Manifesto Puro: 10 declarações 'use' + agent base
    ├── MathConstants.fdsl             # MathConstantsContract + 45 constantes imut + operações
    ├── BasicArithmetic.fdsl           # BasicArithmeticContract + operações aritméticas canônicas
    ├── FloatElementary.fdsl           # FloatElementaryContract + módulos, sinais, mínimos e máximos
    ├── RootsAndRounding.fdsl          # RootsAndRoundingContract + raízes quadradas e arredondamentos
    ├── ExponentialLog.fdsl            # ExponentialLogContract + potenciação e logaritmos
    ├── Trigonometry.fdsl              # TrigonometryContract + funções trigonométricas completas
    ├── Hyperbolic.fdsl                # HyperbolicContract + funções hiperbólicas
    ├── AngleConversion.fdsl           # AngleConversionContract + conversões entre graus e radianos
    ├── Combinatorics.fdsl             # CombinatoricsContract + fatoriais, permutações e combinações
    └── SpecialFunctions.fdsl          # SpecialFunctionsContract + funções erro, gamma, beta, etc.
```

### 2.2 Código do Arquivo Agregador Mestre (`stdlib/MathStdLib/MathStdLib.fdsl`)
```flux
#L ==============================================================================
#L MathStdLib - Biblioteca Padrao Matematica 100% Nativa em TheFlux
#L Arquivo Agregador Mestre: Manifesto Declarativo de Modulos de Dominio
#L ==============================================================================

use MathConstants
use BasicArithmetic
use FloatElementary
use RootsAndRounding
use ExponentialLog
use Trigonometry
use Hyperbolic
use AngleConversion
use Combinatorics
use SpecialFunctions

agent (MathStdLib) {
}
```

> [!NOTE]
> O parser suporta tanto a sintaxe idiomática `use Trigonometry` quanto a sintaxe explícita com extensão `use Trigonometry.fdsl`.

### 2.3 Código de Arquivo de Domínio com Constantes (`stdlib/MathStdLib/MathConstants.fdsl`)
```flux
contract (MathConstantsContract) {
      op pi64 () as float64
      op pi32 () as float32
      op pi16 () as float16
      op e64 () as float64
      ...
}

agent (MathStdLib) impl MathConstantsContract {
      #B Constantes Matematicas Multi-Precisao (Derivadas por Cast da Ancora 64-bit) B#
      imut as float64: PI64 = 3.14159265358979323846264338327
      imut as float32: PI32 = PI64 as float32
      imut as float16: PI16 = PI64 as float16
      imut as float64: E64 = 2.71828182845904523536028747135
      ...
      imut as float16: PHI_16 = PHI_64 as float16

      op pi64 () as float64 ==> {
            imut as float64: res = PI64
            emit(nice, res, "ok")
      }
      op pi32 () as float32 ==> {
            imut as float32: res = PI32
            emit(nice, res, "ok")
      }
      ...
}
```

### 2.4 Código de Arquivo de Domínio Funcional (`stdlib/MathStdLib/Trigonometry.fdsl`)
```flux
contract (TrigonometryContract) {
      op sin64 (as float64: radians) as float64
      op cos64 (as float64: radians) as float64
      op sin32 (as float32: radians) as float32
      op cos32 (as float32: radians) as float32
      op sen64 (as float64: radians) as float64
      op sen32 (as float32: radians) as float32
      ...
}

agent (MathStdLib) impl TrigonometryContract {
      op sin64 (as float64: radians) as float64 ==> {
            ...
      }
      op cos64 (as float64: radians) as float64 ==> {
            mut as float64: res = (sin64(radians + 1.570796326794896557998981734272)).val
            emit(nice, res, "ok")
      }
      op sen64 (as float64: radians) as float64 ==> {
            mut as float64: res = (sin64(radians)).val
            emit(nice, res, "ok")
      }
      ...
}
```

---

## 🚀 3. Modalidades de Consumo pelo Usuário

A linguagem TheFlux oferece duas modalidades de importação flexíveis para bibliotecas modulares `*StdLib`:

### 3.1 Modalidade 1: Importação Ampla / Geral (`use MathStdLib`)
Importa a biblioteca completa. Todas as operações de todos os domínios declarados no manifesto tornam-se disponíveis para o programa chamador:

```flux
# Exemplo de Importação Ampla:
use MathStdLib

program (ExampleOfBroadImport) {
      println("==================================================")
      println("  Demonstracao de Importacao Geral: use MathStdLib")
      println("==================================================")

      #L Chamadas qualificadas ou diretas de qualquer dominio da biblioteca:
      mut as float64: c64 = MathStdLib::cos64(0.0)
      mut as float64: s64 = MathStdLib::sen64(0.0)
      mut as float32: c32 = MathStdLib::cos32(0.0)

      println("1. cos64(0.0) = " + c64)
      println("2. sen64(0.0) = " + s64)
      println("3. cos32(0.0) = " + c32)
}
```

### 3.2 Modalidade 2: Importação Específica por Domínio (`use MathStdLib::Trigonometry::cos64`)
Permite ao consumidor expressar com exatidão a procedência da operação, tornando o código auto-documentado e semanticamente límpido:

```flux
# Exemplo de Importação Específica:
use MathStdLib::Trigonometry::cos64

program (ExampleOfSpecificImport) {
      println("==================================================")
      println("  Demonstracao de Importacao Especifica")
      println("==================================================")

      #L A operacao importada fica exposta diretamente no escopo local:
      mut as float64: c64 = cos64(0.0)
      println("1. Operacao especifica resolvida: cos64(0.0) = " + c64)
}
```

Também é suportada a importação de grupos dentro de um domínio:
```flux
use MathStdLib::Trigonometry::{cos64, sin64, sen64}
```

---

## ⚙️ 4. Alterações Realizadas no Compilador

| Componente | Arquivo | Responsabilidade |
|---|---|---|
| **AST** | [`src/flux_proto/parser/ast.py`](file:///D:/Projetos/TheFlux/src/flux_proto/parser/ast.py) | Campo `path: list[str]` nos nós `UseOp` e `UseGroup` para suportar cadeias hierárquicas com múltiplos `::`. |
| **Parser** | [`src/flux_proto/parser/declarations.py`](file:///D:/Projetos/TheFlux/src/flux_proto/parser/declarations.py) | Suporte a caminhos multi-segmento em `_parse_use_target` e suporte a extensão opcional `.fdsl` em nomes de módulos. |
| **Import Resolver** | [`src/flux_proto/parser/import_resolver.py`](file:///D:/Projetos/TheFlux/src/flux_proto/parser/import_resolver.py) | - Detecção da pasta modular `<Dir>/<Dir>.fdsl`<br>- Extração e validação do manifesto `use`<br>- Isolamento estrito contra arquivos estranhos<br>- Fusão transparente de agentes e contratos (`_fuse_fdsl`)<br>- Limpeza de diretivas internas para evitar poluição global. |

---

## 🧪 5. Resultados de Conformidade Multi-Backend

Todos os 10 testes canônicos de contratos foram executados e homologados nos 6 backends oficiais com **100% de paridade** em relação ao interpretador de referência e **zero regressões**:

```text
arquivo                                                in   vm  vmr  llvm  wat  wasm
------------------------------------------------------------------------------------
ExampleOfUseMathStdLib_AngleConversionContract.flux     ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_BasicArithmeticContract.flux     ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_CombinatoricsContract.flux       ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_ExponentialLogContract.flux      ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_FloatElementaryContract.flux     ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_HyperbolicContract.flux          ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_MathConstantsContract.flux       ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_RootsAndRoundingContract.flux    ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_SpecialFunctionsContract.flux    ✓    ✓    ✓    ✓    ✓    ✓
ExampleOfUseMathStdLib_TrigonometryContract.flux        ✓    ✓    ✓    ✓    ✓    ✓
------------------------------------------------------------------------------------
10/10 arquivos OK (100% PASS) | 0 divergências | 0 regressões
```

---

## 📋 6. Checklist de Implementação e Histórico de Fases

- [x] **Fase 1: Suporte a Múltiplos Segmentos `::` no Parser**
  - Atualização de `_parse_use_target` e `_parse_use_group` em `declarations.py`.
  - Atualização dos nós `UseOp` e `UseGroup` em `ast.py`.
- [x] **Fase 2: Motor de Resolução Plana e Fusão no `import_resolver.py`**
  - Detecção da biblioteca modular com validação de `<Dir>/<Dir>.fdsl`.
  - Implementação do algoritmo de fusão transparente (`_fuse_fdsl`).
  - Suporte à importação ampla (`use MathStdLib`) e direcionada (`use MathStdLib::cos64`).
- [x] **Fase 3: Decomposição Modular da Biblioteca `MathStdLib/`**
  - Criação da pasta `stdlib/MathStdLib/` com arquivos planos diretamente.
  - Decomposição das 378 operações em seus blocos funcionais canônicos.
- [x] **Fase 4: Testes Canônicos de Validação**
  - Criação e validação de `ExampleOfModularMathLib.flux` e `ExampleOfModularMathLibSpecific.flux`.
  - 100% PASS nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`).
- [x] **Fase 5: Regressão e Remoção do Arquivo Monolítico Legado**
  - Validação dos 10 testes de conformidade `ExampleOfUseMathStdLib_*.flux`.
  - Remoção segura do arquivo legado `stdlib/MathStdLib.fdsl`.
- [x] **Fase 6: Organização por Domínio e Contratos Específicos**
  - Alocação dos 10 contratos especializados dentro de seus respectivos arquivos de domínio.
  - Declaração de `agent (MathStdLib) impl <DominioContract>` por arquivo.
  - Remoção de arquivos atômicos redundantes (`cos64.fdsl`, etc.), unificando-os no domínio `Trigonometry.fdsl`.
  - Atualização de `ExampleOfModularMathLibSpecific.flux` com sintaxe hierárquica `MathStdLib::Trigonometry::cos64`.
- [x] **Fase 7: Agregador Mestre como Manifesto Puro (`use`) e Constantes no Domínio**
  - Suporte a extensão opcional `.fdsl` em diretivas `use` no parser.
  - Atualização de `_load_modular_dir` para carregar estritamente os módulos listados no manifesto `use`.
  - Isolamento estrito de arquivos não declarados (ex.: `net.fdsl`).
  - Detecção e erro em caso de módulos declarados ausentes ou com erro de digitação.
  - Migração das 45 constantes multi-precisão para `MathConstants.fdsl`.
  - `MathStdLib.fdsl` como manifesto puro (zero constantes, zero contratos, zero ops).
  - Validação de 100% dos testes nos 6 backends.
- [x] **Fase 8: Migração Universal de 100% das Bibliotecas Padrão (37/37)**
  - Migração completa de todas as 36 bibliotecas restantes para pastas modulares dedicadas (`stdlib/<LibName>/`).
  - Criação de 254 módulos de domínio coesos implementando `agent (<LibName>) impl <Contract>`.
  - Criação de 37 manifestos agregadores mestres puros (`<LibName>.fdsl`), contendo apenas diretivas `use`.
  - Suporte e resolução de dependências externas (`use OtherLib`) nos manifestos e módulos.
  - Remoção de 100% dos arquivos monólitos legados da raiz de `stdlib/`.
  - Homologação completa nos 6 backends oficiais com zero regressões.

---

## 🏛️ 7. Inventário Completo das 37 Bibliotecas Padrão Modulares

| # | Biblioteca Padrão | Diretório Físico | Domínios Coesos | Manifesto Mestre |
|---|---|---|---|---|
| 1 | **`ArchiveStdLib`** | [`stdlib/ArchiveStdLib/`](file:///D:/Projetos/TheFlux/stdlib/ArchiveStdLib) | 1 domínio | [`ArchiveStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/ArchiveStdLib/ArchiveStdLib.fdsl) |
| 2 | **`CharStdLib`** | [`stdlib/CharStdLib/`](file:///D:/Projetos/TheFlux/stdlib/CharStdLib) | 6 domínios | [`CharStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/CharStdLib/CharStdLib.fdsl) |
| 3 | **`CompressStdLib`** | [`stdlib/CompressStdLib/`](file:///D:/Projetos/TheFlux/stdlib/CompressStdLib) | 8 domínios | [`CompressStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/CompressStdLib/CompressStdLib.fdsl) |
| 4 | **`ConvertStdLib`** | [`stdlib/ConvertStdLib/`](file:///D:/Projetos/TheFlux/stdlib/ConvertStdLib) | 6 domínios | [`ConvertStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/ConvertStdLib/ConvertStdLib.fdsl) |
| 5 | **`DateTimeStdLib`** | [`stdlib/DateTimeStdLib/`](file:///D:/Projetos/TheFlux/stdlib/DateTimeStdLib) | 6 domínios | [`DateTimeStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/DateTimeStdLib/DateTimeStdLib.fdsl) |
| 6 | **`DbStdLib`** | [`stdlib/DbStdLib/`](file:///D:/Projetos/TheFlux/stdlib/DbStdLib) | 7 domínios | [`DbStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/DbStdLib/DbStdLib.fdsl) |
| 7 | **`DebugStdLib`** | [`stdlib/DebugStdLib/`](file:///D:/Projetos/TheFlux/stdlib/DebugStdLib) | 8 domínios | [`DebugStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/DebugStdLib/DebugStdLib.fdsl) |
| 8 | **`DslStdLib`** | [`stdlib/DslStdLib/`](file:///D:/Projetos/TheFlux/stdlib/DslStdLib) | 6 domínios | [`DslStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/DslStdLib/DslStdLib.fdsl) |
| 9 | **`FileSignatureStdLib`** | [`stdlib/FileSignatureStdLib/`](file:///D:/Projetos/TheFlux/stdlib/FileSignatureStdLib) | 4 domínios | [`FileSignatureStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/FileSignatureStdLib/FileSignatureStdLib.fdsl) |
| 10 | **`FinStdLib`** | [`stdlib/FinStdLib/`](file:///D:/Projetos/TheFlux/stdlib/FinStdLib) | 7 domínios | [`FinStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/FinStdLib/FinStdLib.fdsl) |
| 11 | **`FormatStdLib`** | [`stdlib/FormatStdLib/`](file:///D:/Projetos/TheFlux/stdlib/FormatStdLib) | 5 domínios | [`FormatStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/FormatStdLib/FormatStdLib.fdsl) |
| 12 | **`FsmStdLib`** | [`stdlib/FsmStdLib/`](file:///D:/Projetos/TheFlux/stdlib/FsmStdLib) | 5 domínios | [`FsmStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/FsmStdLib/FsmStdLib.fdsl) |
| 13 | **`GfxStdLib`** | [`stdlib/GfxStdLib/`](file:///D:/Projetos/TheFlux/stdlib/GfxStdLib) | 9 domínios | [`GfxStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/GfxStdLib/GfxStdLib.fdsl) |
| 14 | **`GraphPlotStdLib`** | [`stdlib/GraphPlotStdLib/`](file:///D:/Projetos/TheFlux/stdlib/GraphPlotStdLib) | 12 domínios | [`GraphPlotStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/GraphPlotStdLib/GraphPlotStdLib.fdsl) |
| 15 | **`GuiStdLib`** | [`stdlib/GuiStdLib/`](file:///D:/Projetos/TheFlux/stdlib/GuiStdLib) | 9 domínios | [`GuiStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/GuiStdLib/GuiStdLib.fdsl) |
| 16 | **`HashStdLib`** | [`stdlib/HashStdLib/`](file:///D:/Projetos/TheFlux/stdlib/HashStdLib) | 6 domínios | [`HashStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/HashStdLib/HashStdLib.fdsl) |
| 17 | **`IoStdLib`** | [`stdlib/IoStdLib/`](file:///D:/Projetos/TheFlux/stdlib/IoStdLib) | 9 domínios | [`IoStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/IoStdLib/IoStdLib.fdsl) |
| 18 | **`LinAlgStdLib`** | [`stdlib/LinAlgStdLib/`](file:///D:/Projetos/TheFlux/stdlib/LinAlgStdLib) | 16 domínios | [`LinAlgStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/LinAlgStdLib/LinAlgStdLib.fdsl) |
| 19 | **`ListStdLib`** | [`stdlib/ListStdLib/`](file:///D:/Projetos/TheFlux/stdlib/ListStdLib) | 9 domínios | [`ListStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/ListStdLib/ListStdLib.fdsl) |
| 20 | **`LowLevelStdLib`** | [`stdlib/LowLevelStdLib/`](file:///D:/Projetos/TheFlux/stdlib/LowLevelStdLib) | 9 domínios | [`LowLevelStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/LowLevelStdLib/LowLevelStdLib.fdsl) |
| 21 | **`MapStdLib`** | [`stdlib/MapStdLib/`](file:///D:/Projetos/TheFlux/stdlib/MapStdLib) | 10 domínios | [`MapStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/MapStdLib/MapStdLib.fdsl) |
| 22 | **`MathStdLib`** | [`stdlib/MathStdLib/`](file:///D:/Projetos/TheFlux/stdlib/MathStdLib) | 10 domínios | [`MathStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/MathStdLib/MathStdLib.fdsl) |
| 23 | **`NativeGfxStdLib`** | [`stdlib/NativeGfxStdLib/`](file:///D:/Projetos/TheFlux/stdlib/NativeGfxStdLib) | 3 domínios | [`NativeGfxStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/NativeGfxStdLib/NativeGfxStdLib.fdsl) |
| 24 | **`NetStdLib`** | [`stdlib/NetStdLib/`](file:///D:/Projetos/TheFlux/stdlib/NetStdLib) | 4 domínios | [`NetStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/NetStdLib/NetStdLib.fdsl) |
| 25 | **`OoStdLib`** | [`stdlib/OoStdLib/`](file:///D:/Projetos/TheFlux/stdlib/OoStdLib) | 5 domínios | [`OoStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/OoStdLib/OoStdLib.fdsl) |
| 26 | **`OsStdLib`** | [`stdlib/OsStdLib/`](file:///D:/Projetos/TheFlux/stdlib/OsStdLib) | 4 domínios | [`OsStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/OsStdLib/OsStdLib.fdsl) |
| 27 | **`PhysStdLib`** | [`stdlib/PhysStdLib/`](file:///D:/Projetos/TheFlux/stdlib/PhysStdLib) | 10 domínios | [`PhysStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/PhysStdLib/PhysStdLib.fdsl) |
| 28 | **`RandomStdLib`** | [`stdlib/RandomStdLib/`](file:///D:/Projetos/TheFlux/stdlib/RandomStdLib) | 4 domínios | [`RandomStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/RandomStdLib/RandomStdLib.fdsl) |
| 29 | **`RegexStdLib`** | [`stdlib/RegexStdLib/`](file:///D:/Projetos/TheFlux/stdlib/RegexStdLib) | 5 domínios | [`RegexStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/RegexStdLib/RegexStdLib.fdsl) |
| 30 | **`RuntimeStdLib`** | [`stdlib/RuntimeStdLib/`](file:///D:/Projetos/TheFlux/stdlib/RuntimeStdLib) | 4 domínios | [`RuntimeStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/RuntimeStdLib/RuntimeStdLib.fdsl) |
| 31 | **`SetStdLib`** | [`stdlib/SetStdLib/`](file:///D:/Projetos/TheFlux/stdlib/SetStdLib) | 10 domínios | [`SetStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/SetStdLib/SetStdLib.fdsl) |
| 32 | **`SimdStdLib`** | [`stdlib/SimdStdLib/`](file:///D:/Projetos/TheFlux/stdlib/SimdStdLib) | 4 domínios | [`SimdStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/SimdStdLib/SimdStdLib.fdsl) |
| 33 | **`StatStdLib`** | [`stdlib/StatStdLib/`](file:///D:/Projetos/TheFlux/stdlib/StatStdLib) | 8 domínios | [`StatStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/StatStdLib/StatStdLib.fdsl) |
| 34 | **`StringStdLib`** | [`stdlib/StringStdLib/`](file:///D:/Projetos/TheFlux/stdlib/StringStdLib) | 8 domínios | [`StringStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/StringStdLib/StringStdLib.fdsl) |
| 35 | **`StructStdLib`** | [`stdlib/StructStdLib/`](file:///D:/Projetos/TheFlux/stdlib/StructStdLib) | 4 domínios | [`StructStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/StructStdLib/StructStdLib.fdsl) |
| 36 | **`SymbolicStdLib`** | [`stdlib/SymbolicStdLib/`](file:///D:/Projetos/TheFlux/stdlib/SymbolicStdLib) | 9 domínios | [`SymbolicStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/SymbolicStdLib/SymbolicStdLib.fdsl) |
| 37 | **`ThreadStdLib`** | [`stdlib/ThreadStdLib/`](file:///D:/Projetos/TheFlux/stdlib/ThreadStdLib) | 4 domínios | [`ThreadStdLib.fdsl`](file:///D:/Projetos/TheFlux/stdlib/ThreadStdLib/ThreadStdLib.fdsl) |
| **Total** | **37 Bibliotecas** | **37 Pastas Modulares** | **254 Domínios Coesos** | **291 Arquivos FDSL** |
