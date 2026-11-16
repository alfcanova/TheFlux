# 🔌 Conector FDSL e Interface de Agente FvmClient

> **Código-Fonte do Agente**: [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl)  
> **Contrato Canônico**: [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl)  
> **Versão Oficial**: `v1.0.0`  
> **Status**: ✅ Componente Canônico Oficial do TheFlux v1.0.0

---

## 1. Visão Geral e Papel do Conector FDSL

O módulo [`src/Fvm`](file:///D:/Projetos/TheFlux/src/Fvm) implementa o conector oficial de alto nível da linguagem TheFlux para interação direta com a máquina virtual **Fast Virtual Machine (`bin/fluxvm.exe`)**. Seguindo o paradigma orientado a contratos e agentes de TheFlux, o conector expõe uma API limpa e declarativa que abstrai:

- Detecção de atividade do serviço residente Windows ou daemon local.
- Execução protegida de arquivos de bytecode `.fvmbc` locais.
- Injeção atômica de bytecodes em memória no serviço residente via Named Pipe (`\\.\pipe\theflux_fvm`) com fallback automático.

---

## 2. Especificação do Contrato `FvmContract`

O contrato canônico é definido em [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl):

```flux
contract (FvmContract) {
      #L Injeta bytecode .fvmbc no servico residente Windows via Named Pipe
      op fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map

      #L Executa arquivo de bytecode localmente
      op fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map

      #L Checa se o servico Windows fluxvm esta ativo e respondendo
      op fvmIsServiceActive () as bool
}
```

### 2.1 `fvmIsServiceActive () as bool`
- **Propósito**: Consulta se o servidor residente da FVM (Serviço Windows ou Daemon) está ativo e respondendo conexões IPC.
- **Retorno**: `true` se o canal Named Pipe `\\.\pipe\theflux_fvm` estiver aberto ou o serviço estiver ativo no SCM; `false` caso contrário.
- **Implementação**: Invoca `fluxvm.exe --status`, retornando imediatamente sem timeouts bloqueantes.

### 2.2 `fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map`
- **Propósito**: Executa um arquivo de bytecode `.fvmbc` existente no disco local em modo standalone.
- **Entradas**:
  - `fvmbc_path`: Caminho para o arquivo compilado `.fvmbc` (com tratamento de aspas para caminhos com espaços).
  - `stdin_text`: Texto a ser fornecido como entrada padrão (repassado via `--stdin` caso não seja vazio).
- **Retorno (`map`)**:
  - `res["success"]`: Booleano indicando término da execução (`true`).
  - `res["stdout"]`: String contendo a saída capturada do processo.

### 2.3 `fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map`
- **Propósito**: Injeta uma representação em JSON de bytecode compilado diretamente no motor residente.
- **Entradas**:
  - `bytecode_json`: Conteúdo serializado do programa `.fvmbc`.
  - `stdin_text`: Texto de entrada padrão opcional.
- **Comportamento**: Grava o payload em arquivo temporário seguro em `temp/fvm_inject_<timestamp>.fvmbc`, invoca `fluxvm.exe --inject` e remove o arquivo temporário após o retorno. Se o serviço residente estiver ativo, a injeção ocorre via IPC Named Pipe; se estiver inativo, ocorre o fallback local transparente.
- **Retorno (`map`)**:
  - `res["success"]`: Booleano de sucesso (`true`).
  - `res["stdout"]`: Saída completa da execução.

---

## 3. Implementação do Agente `FvmClient`

O agente [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl) implementa o contrato `FvmContract`:

```flux
use RuntimeStdLib
use IoStdLib
use FvmContract.fdsl

agent (FvmClient) impl FvmContract {
      #L Implementacoes de fvmInjectBytecode, fvmExecuteFile e fvmIsServiceActive
}
```

### Características Técnicas de Segurança
- **Resolução Dinâmica do Binário**: Detecta automaticamente a presença de `bin/fluxvm.exe` tanto em execuções relativas (`.\bin\fluxvm.exe`), locais (`bin\fluxvm.exe`) ou globais (`fluxvm.exe` no PATH).
- **Proteção de Argumentos**: Todos os caminhos de arquivos e textos de entrada são protegidos por aspas escapadas contra espaços e caracteres especiais de shell.
- **Gerenciamento Seguro de Arquivos Temporários**: Criação sob demanda do diretório `temp/` e remoção garantida de artefatos efêmeros.

---

## 4. Exemplo Canônico de Código TheFlux

O exemplo oficial demonstrando o consumo do agente está disponível em [`examples/Canon/ExampleOfFvmClient.flux`](file:///D:/Projetos/TheFlux/examples/Canon/ExampleOfFvmClient.flux):

```flux
use src::Fvm::FvmClient as FC

program (ExampleOfFvmClient) {
      print("=== FVM Client: Verificando status do servico ===")
      mut as bool: active = FC::fvmIsServiceActive()
      print("Servico FVM ativo: " + active)

      print("=== FVM Client: Execucao de arquivo de bytecode local ===")
      mut as map: res_exec = FC::fvmExecuteFile("t_fvmbc/test_acc.fvmbc", "")
      print("Sucesso: " + res_exec["success"])
      print("Saida:")
      print(res_exec["stdout"])

      print("=== FVM Client: Injecao de bytecode no servico ou fallback local ===")
      mut as string: bc_content = stdIoReadFile("t_fvmbc/test_acc.fvmbc")
      mut as map: res_inj = FC::fvmInjectBytecode(bc_content, "")
      print("Injecao sucesso: " + res_inj["success"])
      print("Injecao saida:")
      print(res_inj["stdout"])
}
```
