# 🗂️ TODO — Plano 3: Bibliotecas Hierárquicas de `agent/op` com Fusão Transparente

> **Status**: Em Planejamento / Pronto para Execução  
> **Objetivo**: Permitir a organização modular de bibliotecas e agentes em árvores hierárquicas de diretórios e subdiretórios, onde o arquivo agregador mestre possui obrigatoriamente o mesmo nome da pasta (`<Pasta>/<Pasta>.fdsl`), com fusão transparente de todas as operações em subpastas pelo compilador, suportando tanto importação ampla sem `::` (`use MathLib`) quanto importação específica com `::` (`use MathLib::op`).

---

## 🎯 1. Escopo e Diretrizes de Design

1. **Estrutura Física em Diretórios e Subdiretórios**:
   - Uma biblioteca pode ser definida como uma pasta física contendo subpastas temáticas (ex: por precisão de tipos, por domínio matemático ou por camada de arquitetura):
     ```text
     stdlib/ (ou fdsl/)
     └── MathLib/
         ├── trig_64/
         │   ├── cos_64.fdsl
         │   ├── sen_64.fdsl
         │   └── tan_64.fdsl
         ├── trig_32/
         │   ├── cos_32.fdsl
         │   ├── sen_32.fdsl
         │   └── tan_32.fdsl
         ├── algebra/
         │   └── matrix.fdsl
         └── MathLib.fdsl       # Nome OBRIGATORIAMENTE IDÊNTICO ao nome da pasta
     ```

2. **Convenção Mandatória de Nome do Arquivo Agregador**:
   - O arquivo mestre que amarra e orquestra a biblioteca deve se chamar exatamente como a pasta: para o diretório `MathLib/`, o arquivo é `MathLib/MathLib.fdsl`.
   - Esse arquivo declara os contratos centrais e a assinatura unificada do agente.

3. **Fusão Transparente no Compilador (*Transparent Fusion*)**:
   - Ao importar `use MathLib`, o [`import_resolver.py`](file:///D:/Projetos/TheFlux/src/flux_proto/parser/import_resolver.py) carrega `MathLib.fdsl`, varre recursivamente todas as subpastas e funde de forma automática e transparente todas as declarações de `op`, `struct` e `enum` no agente principal (`MathAgent`).
   - O desenvolvedor que cria a biblioteca não precisa listar manualmente cada arquivo filho em uma lista de includes.
   - O desenvolvedor que consome a biblioteca não precisa conhecer em qual subpasta física cada operação reside.

4. **Semântica das Duas Modalidades de Importação**:
   - **Modalidade 1: Sem `::` (`use MathLib` ou `use MathAgent`) — Geral / Ampla**:
     - Toda a biblioteca fica disponível para o programa.
     - As funções são resolvidas e expostas no escopo do código `.flux`, permitindo tanto chamadas qualificadas (`MathAgent::cos64(...)`) quanto chamadas diretas de funções do módulo.
     - Ideal quando o programa utilizará diversas funções da biblioteca.
   - **Modalidade 2: Com `::` (`use MathLib::cos64` ou `use MathLib::trig_64::cos_64`) — Específica / Direcionada**:
     - Resolução pontual orientada para o resolver.
     - Apenas as operações explicitamente indicadas são vinculadas e exportadas no escopo.
     - O resolver pode carregar estritamente o arquivo folha correspondente na hierarquia de subpastas, sem sobrecarga de processamento do restante da árvore.
     - Ideal para programas que necessitam de apenas uma ou poucas funções pontuais de uma biblioteca extensa.

---

## 📐 2. Especificação de Código e Exemplos

### 2.1 Arquivo Mestre Agregador (`stdlib/MathLib/MathLib.fdsl`)
```flux
# Contrato unificado da biblioteca
contract MathLibContract {
      op cos64 (as float64: x) as float64
      op sen64 (as float64: x) as float64
      op cos32 (as float32: x) as float32
      op sen32 (as float32: x) as float32
}

# Agente que recebe a fusão transparente das operações das subpastas
agent (MathAgent) impl MathLibContract {
      # As operações definidas nas subpastas trig_64 e trig_32 
      # são fundidas automaticamente e de forma transparente aqui.
}
```

### 2.2 Operações Atômicas em Subpastas

```flux
# stdlib/MathLib/trig_64/cos_64.fdsl
agent (MathAgent) {
      op cos64 (as float64: x) as float64 ==> {
            # Aproximação de Taylor para cos(x) em 64-bit
            mut as float64: res = 1.0 - (x * x) /f 2.0
            emit(nice, res, "ok")
      }
}
```

```flux
# stdlib/MathLib/trig_64/sen_64.fdsl
agent (MathAgent) {
      op sen64 (as float64: x) as float64 ==> {
            # Aproximação de Taylor para sen(x) em 64-bit
            mut as float64: res = x - (x * x * x) /f 6.0
            emit(nice, res, "ok")
      }
}
```

```flux
# stdlib/MathLib/trig_32/cos_32.fdsl
agent (MathAgent) {
      op cos32 (as float32: x) as float32 ==> {
            # Versão em float32
            mut as float32: res = 1.0 - (x * x) /f 2.0
            emit(nice, res, "ok")
      }
}
```

### 2.3 Programa Consumidor: Modalidade Geral Sem `::` (`flux/ExampleOfModularMathLib.flux`)
```flux
use MathLib

program (ExampleOfModularMathLib) {
      println("==================================================")
      println("  Demonstração de Importação Geral: use MathLib")
      println("==================================================")

      # Múltiplas funções de diferentes subpastas disponíveis no mesmo agente:
      mut as float64: c64 = MathAgent::cos64(0.0)
      mut as float64: s64 = MathAgent::sen64(0.0)
      mut as float32: c32 = MathAgent::cos32(0.0)

      println("1. cos64(0.0) = " + c64)
      println("2. sen64(0.0) = " + s64)
      println("3. cos32(0.0) = " + c32)
}
```

### 2.4 Programa Consumidor: Modalidade Específica Com `::` (`flux/ExampleOfModularMathLibSpecific.flux`)
```flux
use MathLib::cos64

program (ExampleOfModularMathLibSpecific) {
      println("==================================================")
      println("  Demonstração de Importação Específica: use MathLib::cos64")
      println("==================================================")

      # Apenas a operação importada especificamente é exposta:
      mut as float64: c64 = cos64(0.0)
      println("1. Operação específica resolvida: cos64(0.0) = " + c64)
}
```

---

## ⚙️ 3. Alterações Técnicas no Compilador

### 3.1 [`src/flux_proto/parser/declarations.py`](declarations.py)
- Aprimorar a função `_parse_use_target`:
  - Permitir cadeias de múltiplos identificadores separados por `::` (ex: `['MathLib', 'trig_64', 'cos_64']`).
  - Representar caminhos no nó `UseOp` ou `UsePath` preservando o caminho da pasta e a operação-alvo.

### 3.2 [`src/flux_proto/parser/import_resolver.py`](import_resolver.py)
- Aprimorar `_search_fdsl`:
  - Detectar se `name` corresponde a um diretório físico em `stdlib/`, `fdsl/` ou caminhos relativos ao arquivo chamador.
  - Verificar a existência mandatória de `<dir>/<dir>.fdsl`.
- Implementar `_load_modular_directory`:
  - Efetuar varredura recursiva via `os.walk` em todas as subpastas.
  - Efetuar o parse de todos os arquivos `.fdsl` secundários.
  - **Mecanismo de Fusão de ASTs**:
    - Unificar instâncias de `AgentDef` que compartilham o mesmo nome.
    - Anexar as listas de `body.ops` no agente principal.
    - Validar detecção de duplicidades acidentais (mesmo nome e mesma assinatura em arquivos diferentes) emitindo `SEM_OP_DUPLICATE`.
    - Integrar todos os `contracts`, `structs` e `enums` no objeto `FdslFile` final.
- Implementar resolução direcionada para importações com `::`:
  - Quando a importação especificar `MathLib::op_name`, filtrar a exposição dos símbolos para apenas a `op` requerida.

---

## 📋 4. Lista de Tarefas (Checklist de Execução)

- [ ] **Fase 1: Suporte a Múltiplos Segmentos `::` no Parser**
  - [ ] Atualizar `_parse_use_target` em `src/flux_proto/parser/declarations.py` para suportar caminhos com mais de 2 segmentos `::`.
  - [ ] Atualizar classes da AST em `src/flux_proto/parser/ast.py` se necessário para representar caminhos hierárquicos.
- [ ] **Fase 2: Motor de Resolução Hierárquica e Fusão no `import_resolver.py`**
  - [ ] Implementar detecção de diretório de biblioteca e validação mandatória de `<Dir>/<Dir>.fdsl`.
  - [ ] Implementar varredura recursiva de subpastas e carregamento dos arquivos `.fdsl` atômicos.
  - [ ] Implementar algoritmo de fusão transparente de `AgentDef` (`ops`, `contracts`, `structs`).
  - [ ] Implementar diferenciação semântica entre importação ampla (sem `::`) e importação específica (com `::`).
- [ ] **Fase 3: Criação da Biblioteca Canônica de Teste `MathLib/`**
  - [ ] Criar diretório `stdlib/MathLib/`.
  - [ ] Criar `stdlib/MathLib/MathLib.fdsl`.
  - [ ] Criar subpasta `stdlib/MathLib/trig_64/` com `cos_64.fdsl` e `sen_64.fdsl`.
  - [ ] Criar subpasta `stdlib/MathLib/trig_32/` com `cos_32.fdsl` e `sen_32.fdsl`.
- [ ] **Fase 4: Criação e Validação dos Testes Canônicos**
  - [ ] Criar `flux/ExampleOfModularMathLib.flux` (teste amplo sem `::`).
  - [ ] Criar `flux/ExampleOfModularMathLibSpecific.flux` (teste específico com `::`).
  - [ ] Executar ambos os testes nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`).
- [ ] **Fase 5: Regressão e Validação da Suíte Existente**
  - [ ] Rodar `backend_compliance.py` garantindo que os 360 testes pré-existentes permaneçam 100% PASS sem qualquer regressão.
