#L ============================================================================
#L Algoritmo: Bulk Synchronous Parallel (BSP Model - Leslie Valiant 1990)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(W + h*g + l) por superpasso
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteBSP) {
      println("==================================================")
      println("  SciAlgo: Bulk Synchronous Parallel (BSP Model)  ")
      println("==================================================")

      #L O Modelo BSP divide a execucao em Superpassos (Supersteps), cada qual com:
      #L 1. Computacao Local (usando apenas dados locais de cada processador)
      #L 2. Comunicacao Global (envio de mensagens/dados entre processadores)
      #L 3. Barreira de Sincronizacao (garante entrega antes do proximo superpasso)
      #L
      #L Sistema com P = 4 Processadores em anel trocando e atualizando valores:
      #L P1 (10), P2 (20), P3 (30), P4 (40)
      mut as int64: p = 4
      mut as list of int64: local_val = [10, 20, 30, 40]

      println("1. Configuracao Inicial do Sistema BSP (P = 4 Processadores):")
      mut as int64: id = 1
      infinite (id <= p) {
            println("   Processador P" + id + ": Valor Local = " + local_val[id])
            id = id + 1
      }

      #L Superpasso 1: Difusao de mensagens para o vizinho da direita no anel
      println("2. Superpasso 1 (Computacao Local, Troca de Mensagens e Barreira):")
      #L Buffer de comunicacao para mensagens recebidas (inbox)
      mut as list of int64: inbox = [0, 0, 0, 0]

      #L Fase de Comunicacao: Pi envia para P(i % p + 1)
      #L P1 -> P2, P2 -> P3, P3 -> P4, P4 -> P1
      inbox[2] = local_val[1] #L P2 recebe de P1 (10)
      inbox[3] = local_val[2] #L P3 recebe de P2 (20)
      inbox[4] = local_val[3] #L P4 recebe de P3 (30)
      inbox[1] = local_val[4] #L P1 recebe de P4 (40)

      println("   [BARREIRA] Sincronizacao global concluida. Todas as mensagens entregues.")

      #L Superpasso 2: Computacao local consumindo a mensagem recebida
      println("3. Superpasso 2 (Atualizacao Local pos-Barreira):")
      id = 1
      infinite (id <= p) {
            #L Cada processador atualiza seu valor local somando o que recebeu
            local_val[id] = local_val[id] + inbox[id]
            println("   Processador P" + id + ": Novo Valor Local = " + local_val[id] + " (Recebeu: " + inbox[id] + ")")
            id = id + 1
      }

      println("4. Estado Final dos Processadores:")
      #L Valores esperados:
      #L P1: 10 + 40 = 50
      #L P2: 20 + 10 = 30
      #L P3: 30 + 20 = 50
      #L P4: 40 + 30 = 70
      mut as bool: correct = (local_val[1] == 50) and (local_val[2] == 30) and (local_val[3] == 50) and (local_val[4] == 70)
      println("   Consistencia Global BSP Confirmada: " + correct)

      println("Bulk Synchronous Parallel concluido com sucesso.")
}
