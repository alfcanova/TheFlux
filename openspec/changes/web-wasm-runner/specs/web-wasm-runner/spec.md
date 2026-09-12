## ADDED Requirements

### Requirement: Listagem de arquivos em tempo real
O servidor SHALL expor `GET /api/files` retornando um documento JSON contendo a lista de todos os arquivos presentes em `t_wasm-1.0/` (relativo à raiz do projeto), ordenada por nome. A página SHALL consultar esse endpoint a cada 2 segundos e renderizar os nomes no painel esquerdo, preservando a seleção atual quando o conteúdo não muda.

#### Scenario: Lista inicial vazia e depois preenchida
- **WHEN** a pasta `t_wasm-1.0/` está vazia e a página carrega
- **THEN** o painel esquerdo mostra a lista vazia
- **AND** quando um arquivo é adicionado à pasta, a lista passa a exibi-lo em até 2 segundos

#### Scenario: Seleção preservada durante atualização
- **WHEN** um arquivo está selecionado na lista
- **AND** uma atualização periódica re-renderiza a lista
- **THEN** o mesmo arquivo permanece selecionado

#### Scenario: Resposta sem cache
- **WHEN** o browser consulta `/api/files` ou baixa um `.wasm`
- **THEN** o servidor responde com `Cache-Control: no-store`

### Requirement: Execução de módulo WASM selecionado
Ao selecionar um arquivo `.wasm` da lista, a página SHALL baixar o binário via HTTP, instanciá-lo com `WebAssembly.instantiate` e invocar a função exportada `_start`. A saída de `wasi_snapshot_preview1.fd_write` para os file descriptors 1 e 2 SHALL ser capturada via memória exportada e exibida como texto UTF-8 no painel direito. Itens sem extensão `.wasm` SHALL ser exibidos, porém desabilitados para seleção.

#### Scenario: Execução bem-sucedida
- **WHEN** o usuário clica em `ExampleOfPrint.wasm`
- **THEN** o módulo é instanciado e `_start` é invocado
- **AND** a saída capturada é exibida no painel direito
- **AND** o status mostra "concluído" junto ao tempo decorrido

#### Scenario: Módulo inválido
- **WHEN** o usuário seleciona um arquivo `.wasm` que não é um módulo WebAssembly válido
- **THEN** o painel direito exibe uma mensagem de erro
- **AND** o status mostra "erro"

#### Scenario: Arquivo não executável
- **WHEN** o usuário clica em um item listado que não termina em `.wasm`
- **THEN** nenhuma execução é iniciada e o item permanece desabilitado

### Requirement: Interface com shim WASI
O shim WASI fornecido à instanciação SHALL implementar `wasi_snapshot_preview1.fd_write(fd, iovsPtr, iovsLen, nwrittenPtr)`, lendo os pares (ponteiro, comprimento) do iovec a partir da memória exportada do módulo, concatenando os bytes e decodificando-os como UTF-8. O shim SHALL gravar o total de bytes escritos em `nwrittenPtr` e retornar errno 0 para fds válidos.

#### Scenario: Escrita de múltiplos buffers
- **WHEN** `fd_write` recebe um iovec com dois buffers contendo `"Ola"` e `", TheFlux!"` para o fd 1
- **THEN** a saída exibida é `"Ola, TheFlux!"`
- **AND** `nwrittenPtr` recebe o total de bytes escritos
- **AND** o retorno é 0

#### Scenario: Descritor de arquivo inválido
- **WHEN** `fd_write` é chamado com um fd diferente de 1 ou 2
- **THEN** o shim retorna errno 8 (EBADF)

### Requirement: Limpeza e recarga da listagem
A página SHALL oferecer um botão para limpar o conteúdo do painel de saída e um botão para recarregar imediatamente a listagem de arquivos.

#### Scenario: Limpar console
- **WHEN** o usuário clica no botão de limpar
- **THEN** o painel direito é esvaziado

#### Scenario: Recarregar listagem
- **WHEN** o usuário clica no botão de recarregar
- **THEN** o painel esquerdo é re-populado imediatamente com o estado atual de `t_wasm-1.0/`, sem aguardar o próximo polling
