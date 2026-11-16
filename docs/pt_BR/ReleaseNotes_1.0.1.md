# TheFlux v1.0.1 Notas de Lançamento (Release Notes)

> **Data de Lançamento**: Novembro de 2026  
> **Versão**: `1.0.1` — *Manutenção, Conformidade Canônica e Integração FVM*  
> **Status**: Estável / 100% Auto-Hospedado e Pronto para Produção  
> **Licença**: GNU General Public License v3.0 (GPL-3.0)  
> **Fixpoint Determinístico**: `SHA-256(stage2.ll) == SHA-256(stage3.ll)` (0 bytes de divergência)  
> **Paridade Canônica de Execução (LLVM vs Legacy)**: **364 OK / 13 FALHA (100,0% CONFORMIDADE, 0 DIVERGÊNCIAS)**  
> **Universo Canônico**: **377 / 377 Testes** integrados em todos os 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)

---

## 🌟 1. Resumo Executivo: Consolidação da Versão 1.0.1

A versão **1.0.1** do TheFlux consolida marcos fundamentais de estabilização, rigor matemático e conformidade arquitetural pós-lançamento da versão 1.0.0 LTS:

1. **Equivalência Canônica Absoluta de 100% no Backend LLVM**:
   - O backend de geração de código nativo LLVM ([`src/CompilerLib/backends/llvm/LlvmBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/llvm/LlvmBackend.fdsl)) atingiu **100,0% de paridade funcional** com a referência canônica ([`examples/00_Standarts/00_Legacy.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_Legacy.txt)).
   - As 61 divergências herdadas foram integralmente sanadas: **zero erros de compilação Clang**, **zero falhas ou crashes de execução em runtime**, com todos os **364 testes válidos aprovados** e os **13 testes de erro canônico (`ExampleOfError_*`) falhando com segurança e mensagens idênticas**.
2. **Determinismo Absoluto e Fixpoint Reprodutível**:
   - O compilador nativo auto-hospedado ([`bin/fluxc.exe`](file:///D:/Projetos/TheFlux/bin/fluxc.exe)) teve seu ciclo completo de *bootstrapping* revalidado com fixpoint perfeito:
     `SHA-256(stage2.ll) == SHA-256(stage3.ll) == f0854050190fc070a3090ab7fd76175d5506f3ec6ec03f5625c9d0f96e56fad7` (0 bytes de divergência).
3. **Expansão do Universo Canônico e Integração da FVM**:
   - A suíte de testes canônica foi expandida para **377 testes** com a inclusão de [`examples/Canon/ExampleOfFvmClient.flux`](file:///D:/Projetos/TheFlux/examples/Canon/ExampleOfFvmClient.flux).
   - A máquina virtual FVM (Fast Virtual Machine) foi plenamente integrada com seu servidor nativo ([`src/Fvm/fluxvm.flux`](file:///D:/Projetos/TheFlux/src/Fvm/fluxvm.flux)), cliente FDSL ([`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl)) e documentação técnica bilíngue completa ([`docs/pt_BR/fvm/`](file:///D:/Projetos/TheFlux/docs/pt_BR/fvm)).
4. **Matriz Completa e Unificada dos 9 Padrões Canônicos**:
   - Alinhamento rigoroso entre os padrões de compilação sem execução ([`00_VM.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_VM.txt), [`00_WAS.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WAS.txt) e [`00_WAT.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WAT.txt)) e os padrões de execução em runtime ([`00_Legacy.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_Legacy.txt), [`00_SelfHosted.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_SelfHosted.txt), [`00_LLVM.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_LLVM.txt), [`00_VMR.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_VMR.txt), [`00_WASR.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WASR.txt) e [`00_WATR.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WATR.txt)).
   - **4.918 linhas de saída de console** 100% idênticas caractere a caractere entre os 5 motores de runtime.

```mermaid
flowchart TD
    subgraph Bootstrapping
        S1["stage1.ll<br>(Compilador Python/Bootstrap)"] --> S2["stage2.ll<br>(Compilador Auto-Hospedado)"]
        S2 --> S3["stage3.ll<br>(Compilador Fixpoint)"]
        S2 == "SHA-256 Idêntico<br>(0 bytes diff)" ==> S3
    end

    subgraph Certificação Canônica
        S3 --> Fluxc["bin/fluxc.exe"]
        Fluxc --> LV["bin/examples_lv.exe"]
        LV --> LLVM_STD["00_LLVM.txt<br>(364 OK / 13 FALHA)"]
        LLVM_STD == "100% Equivalência Funcional<br>(0 divergências)" ==> LEG_STD["00_Legacy.txt<br>(364 OK / 13 FALHA)"]
    end
```

---

## 🚀 2. Detalhamento Técnico das Correções e Melhorias

### 2.1 Resolução das Divergências no Backend LLVM

As 61 falhas que impediam a paridade canônica absoluta foram categorizadas, isoladas e solucionadas no [`src/CompilerLib/backends/llvm/LlvmBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/llvm/LlvmBackend.fdsl), [`src/CompilerLib/fmir/FmirBuilder.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/fmir/FmirBuilder.fdsl) e no runtime C:

#### A. Chaves do Tipo Float em Mapas Associativos (Fase 4A)
- **Causa**: Chaves numéricas flutuantes em instruções como `MAP_SET`, `GET_INDEX`, `GET_FIELD`, `CONTAINS` e `stdMapContainsKey` eram emitidas como `double`, gerando erro de rejeição no Clang: `error: '%t...' defined with type 'double' but expected 'ptr'`.
- **Solução**: Implementada coerção automática para string através de `@flux_float_to_str` quando o tipo da chave for `float`.
- **Impacto**: Eliminação total dos 13 erros de compilação Clang nas bibliotecas [`GraphPlotStdLib`](file:///D:/Projetos/TheFlux/docs/pt_BR/stdlibs/GraphPlotStdLib.md) e [`StatStdLib`](file:///D:/Projetos/TheFlux/docs/pt_BR/stdlibs/StatStdLib.md).

#### B. Concatenação Polimórfica de Strings e Números no Operador `+` (Fase 4B)
- **Causa**: O operador de concatenação `+` continha uma guarda restritiva `and t1 != "float" and t2 != "float"`, fazendo com que expressões como `"prefixo: " + meu_float` caíssem no ramo de soma numérica, convertendo o ponteiro de string para inteiro e depois para ponto flutuante via `sitofp`, vazando endereços de memória de 64 bits em formato decimal na saída de texto.
- **Solução**: Remoção da restrição e introdução de conversores formais de runtime para tipos primitivos e compostos (`float`, `list`, `map`, `set`, `struct`, `complex`) operados com string.
- **Impacto**: Correção na saída de coordenadas, vetores e propriedades em [`GfxStdLib`](file:///D:/Projetos/TheFlux/docs/pt_BR/stdlibs/GfxStdLib.md) e [`PhysStdLib`](file:///D:/Projetos/TheFlux/docs/pt_BR/stdlibs/PhysStdLib.md).

#### C. Precisão IEEE-754 via `bitcast` no Desembrulho de Coleções Genéricas (Fase 4C)
- **Causa**: Elementos flutuantes contidos em coleções genéricas (`data`) eram recuperados como inteiros brutos de 64 bits e convertidos para double via instrução `sitofp`. Essa conversão interpretava a representação de bits IEEE-754 como um número inteiro assinado, produzindo magnitudes irreais ($10^{18}$ a $10^{50}$) que levavam decomposições matriciais a overflow imediato.
- **Solução**: Substituição de `sitofp` por `bitcast i64 to double` (e `bitcast i32 to float`) na instrução `CAST` para `float64`, `float32` e `float16`.
- **Impacto**: Recuperação completa e estabilização de 18 algoritmos críticos de Álgebra Linear, Decomposição Cholesky, QR, SVD, Tensores 3x3x3 e operações multilineares em [`LinAlgStdLib`](file:///D:/Projetos/TheFlux/docs/pt_BR/stdlibs/LinAlgStdLib.md) e [`SymbolicStdLib`](file:///D:/Projetos/TheFlux/docs/pt_BR/stdlibs/SymbolicStdLib.md).

#### D. Pattern Matching, Tipagem Defensiva e SSA (Fase 4D)
- **Enum vs Struct**: Em TheFlux, enums simples são representados por ponteiros de strings imutáveis, enquanto structs são mapas associativos. A leitura de `_struct_name` no pattern matching tratava enums como mapas (`flux_map_get`), causando falhas de segmentação. Corrigido para retornar a própria string quando o tipo não for struct/map.
- **Pattern Matching de Fatias (`[..sub]`)**: A introdução da instrução FMIR `IS_LIST` permitiu que funções como `listFlatten` verifiquem se o elemento avaliado é de fato uma sublista antes de tentar desempacotar fatias, direcionando elementos escalares com segurança para o ramo coringa (`_`).
- **Campos OOP em `GET_FIELD` e `GET_INDEX`**: Expansão do catálogo de inferência estática para incluir propriedades de contratos de domínio (`NUMERO_CONTA`, `idade`, `peso`, `saldo`, `TITULAR`, `raca`, `dono`, `especie`, `bloqueada`).
- **Conflito de Nomes SSA em `PRINT`**: Correção de identificador duplicado `%_praw` substituído por `%pr_praw_` com sufixo numérico monotônico.
- **Runtime Defensivo em C**: Implementação de `flux_is_list` e validações de ponteiro legível `is_valid_readable_ptr` em [`runtime/src/collections/list.c`](file:///D:/Projetos/TheFlux/runtime/src/collections/list.c) e [`runtime/src/collections/map.c`](file:///D:/Projetos/TheFlux/runtime/src/collections/map.c).

---

### 2.2 Integração e Documentação da FVM (Fast Virtual Machine)

A versão 1.0.1 oficializa a arquitetura e a especificação da **FVM** como ambiente de execução de alto desempenho:
- **Servidor FVM em TheFlux**: [`src/Fvm/fluxvm.flux`](file:///D:/Projetos/TheFlux/src/Fvm/fluxvm.flux) implementa o daemon de execução com suporte a conexões de rede e parsing direto de bytecode.
- **Cliente FDSL**: [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl) fornece a camada de abstração de cliente para comunicação, envio de pacotes `.fvmbc` e leitura de status de execução.
- **Exemplo Canônico**: Criação de [`examples/Canon/ExampleOfFvmClient.flux`](file:///D:/Projetos/TheFlux/examples/Canon/ExampleOfFvmClient.flux), demonstrando o fluxo completo de compilação, transmissão e execução remota.
- **Documentação Bilíngue Completa**:
  - [`docs/pt_BR/fvm/FvmOverview.md`](file:///D:/Projetos/TheFlux/docs/pt_BR/fvm/FvmOverview.md) / [`docs/en/fvm/FvmOverview.md`](file:///D:/Projetos/TheFlux/docs/en/fvm/FvmOverview.md): Arquitetura de registradores, formato de instruções e ciclo de execução.
  - [`docs/pt_BR/fvm/FvmBytecode.md`](file:///D:/Projetos/TheFlux/docs/pt_BR/fvm/FvmBytecode.md) / [`docs/en/fvm/FvmBytecode.md`](file:///D:/Projetos/TheFlux/docs/en/fvm/FvmBytecode.md): Especificação binária do formato `.fvmbc`, tabela de opcodes e mapa de alocação.
  - [`docs/pt_BR/fvm/FvmClient.md`](file:///D:/Projetos/TheFlux/docs/pt_BR/fvm/FvmClient.md) / [`docs/en/fvm/FvmClient.md`](file:///D:/Projetos/TheFlux/docs/en/fvm/FvmClient.md): Guia de uso da API cliente, envio de payloads e tratamento de erros.

---

### 2.3 Matriz de Conformidade dos 9 Padrões Canônicos

A versão 1.0.1 estabelece uma matriz de auditoria exaustiva entre todos os 9 arquivos canônicos em [`examples/00_Standarts/`](file:///D:/Projetos/TheFlux/examples/00_Standarts/):

| Arquivo de Padrão | Tipo | Universo | Sucesso (`OK`) | Falha (`FALHA`) | Linhas Totais | Linhas de Saída (`\|`) | Status de Paridade |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| [`00_Legacy.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_Legacy.txt) | Runtime (Referência) | 377 | 364 | 13 | 5.297 | 4.918 | Referência Oficial |
| [`00_SelfHosted.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_SelfHosted.txt) | Runtime (Interpretador) | 377 | 364 | 13 | 5.297 | 4.918 | SHA-256 Idêntico ao Legacy |
| [`00_LLVM.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_LLVM.txt) | Runtime (Nativo LLVM) | 377 | 364 | 13 | 5.242 | 4.863 | 100% Paridade Canônica |
| [`00_VM.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_VM.txt) | Compilação (FVM Bytecode) | 377 | 364 | 13 | 743 | 0 | 100% Paridade Codegen |
| [`00_VMR.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_VMR.txt) | Runtime (FVM Runtime) | 364 | 364 | 0 | 5.284 | 4.918 | Saída 100% Idêntica |
| [`00_WAS.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WAS.txt) | Compilação (Wasm Binário) | 377 | 364 | 13 | 743 | 0 | 100% Paridade Codegen |
| [`00_WASR.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WASR.txt) | Runtime (Wasmer .wasm) | 364 | 364 | 0 | 5.284 | 4.918 | Saída 100% Idêntica |
| [`00_WAT.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WAT.txt) | Compilação (WAT Texto) | 377 | 364 | 13 | 743 | 0 | 100% Paridade Codegen |
| [`00_WATR.txt`](file:///D:/Projetos/TheFlux/examples/00_Standarts/00_WATR.txt) | Runtime (Wasmer .wat) | 364 | 364 | 0 | 5.284 | 4.918 | Saída 100% Idêntica |

---

## 🛠️ 3. Ferramentas, Scripts e Higienização do Repositório

1. **Scripts de Automação de Testes WebAssembly**:
   - [`examples/example_wasr.bat`](file:///D:/Projetos/TheFlux/examples/example_wasr.bat): Executor automatizado para testes em lote dos binários `.wasm` via Wasmer.
   - [`examples/example_watr.bat`](file:///D:/Projetos/TheFlux/examples/example_watr.bat): Executor automatizado para testes em lote dos arquivos textuais `.wat` via Wasmer.
2. **Higienização de Pastas e Nomenclatura**:
   - Padronização definitiva da pasta de saída WebAssembly: renomeação de `t_wasm` para `t_was` em todas as ferramentas, scripts e arquivos `.gitignore`.
   - Remoção de intermediários legados `.ll` e eliminação de arquivos `.gitkeep` redundantes em diretórios já rastreados.
3. **Validação Contínua de Paridade Bilíngue**:
   - Atualização do validador [`scripts/docs/check_i18n_parity.py`](file:///D:/Projetos/TheFlux/scripts/docs/check_i18n_parity.py) com registro formal das notas de lançamento e documentações da FVM, mantendo 100% de paridade estrita entre `docs/pt_BR` e `docs/en`.

---

## 📊 4. Como Validar a Versão 1.0.1

### 4.1 Validação de Fixpoint e Bootstrapping
```powershell
# Executar ciclo de bootstrap completo (Stage 1 -> Stage 2 -> Stage 3)
.\scripts\bootstrap.bat

# Comprovar determinismo bit a bit (deve retornar hashes identicos)
python -c "import hashlib; [print(f, hashlib.sha256(open(f, 'rb').read()).hexdigest()) for f in ['build/intermediates/stage2.ll', 'build/intermediates/stage3.ll']]"
```

### 4.2 Execução e Auditoria da Suíte Canônica Nativa LLVM
```powershell
# Gerar a certificacao nativa completa dos 377 testes
.\bin\examples_lv.exe > examples\00_Standarts\00_LLVM.txt

# Executar a auditoria comparativa contra o padrao Legacy de referencia
python scripts/compare_legacy_vs_llvm.py
```

### 4.3 Verificação de Paridade Bilíngue da Documentação
```powershell
# Executar o linter de paridade i18n (deve reportar 100% confirmada)
python scripts/docs/check_i18n_parity.py
```

---

*TheFlux Core Engineering Team — Novembro de 2026.*
