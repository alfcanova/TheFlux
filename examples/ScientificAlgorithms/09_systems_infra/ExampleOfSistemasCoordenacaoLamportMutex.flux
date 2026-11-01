#L ============================================================================
#L Algoritmo: Lamport Distributed Mutual Exclusion Algorithm (1978)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: 3*(N - 1) mensagens por entrada na SC
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoLamportMutex) {
      println("==================================================")
      println("  SciAlgo: Lamport Distributed Mutual Exclusion")
      println("==================================================")

      #L O algoritmo classico de Lamport (1978) utiliza relogios logicos escalares
      #L para estabelecer uma ordem total de eventos (timestamp, process_id).
      #L Cada processo mantem uma fila local de requisicoes ordenada por prioridade.
      #L Mensagens: REQUEST, REPLY e RELEASE (total = 3*(N - 1) mensagens).

      mut as int64: num_nodes = 3

      mut as list of int64: clocks = [1, 1, 1]

      #L Fila de requisicoes de cada nó (armazenando o nó prioritario no topo)
      #L head_ts[i] e head_id[i]
      mut as list of int64: q_ts = [0, 0, 0]
      mut as list of int64: q_id = [0, 0, 0]

      println("1. Estado Inicial:")
      println("   Cluster de 3 nós. Relogios logicos iniciais = 1.")

      #L ======================================================================
      #L Cenario: Nó 1 deseja entrar na Secao Critica
      #L ======================================================================
      clocks[1] = clocks[1] + 1 #L C1 = 2
      mut as int64: req1_ts = clocks[1]
      mut as int64: req1_id = 1
      q_ts[1] = req1_ts
      q_id[1] = req1_id

      println("2. [Passo 1: Broadcast de REQUEST]")
      println("   No 1 incrementa relogio (C1 = " + req1_ts + ") e enfileira (TS=" + req1_ts + ", ID=" + req1_id + ")")
      println("   No 1 transmite REQUEST(" + req1_ts + ", 1) para No 2 e No 3.")

      #L ======================================================================
      #L Passo 2: Nós 2 e 3 recebem REQUEST e respondem REPLY
      #L ======================================================================
      println("3. [Passo 2: Recepcao de REQUEST e Envio de REPLY]")

      #L No 2 processa REQUEST
      route {
            req1_ts > clocks[2] ==> { clocks[2] = req1_ts }
            _ ==> {}
      }
      clocks[2] = clocks[2] + 1
      q_ts[2] = req1_ts
      q_id[2] = req1_id
      println("   -> No 2 atualiza relogio para " + clocks[2] + ", enfileira (2, 1) e envia REPLY(TS=" + clocks[2] + ")")

      #L No 3 processa REQUEST
      route {
            req1_ts > clocks[3] ==> { clocks[3] = req1_ts }
            _ ==> {}
      }
      clocks[3] = clocks[3] + 1
      q_ts[3] = req1_ts
      q_id[3] = req1_id
      println("   -> No 3 atualiza relogio para " + clocks[3] + ", enfileira (2, 1) e envia REPLY(TS=" + clocks[3] + ")")

      #L ======================================================================
      #L Passo 3: No 1 recebe todos os REPLYs e verifica condicao de entrada na SC
      #L ======================================================================
      println("4. [Passo 3: Verificacao de Entrada na Secao Critica]")
      println("   Condicao 1: A requisicao de No 1 esta no topo da sua fila local? SIM (TS=" + q_ts[1] + ", ID=" + q_id[1] + ")")
      println("   Condicao 2: No 1 recebeu mensagens com TS > 2 de todos os outros nós? SIM (REPLYs com TS=" + clocks[2] + ")")
      println("   ENTRADA CONCEDIDA: No 1 entra na Secao Critica!")
      println("   ... Executando secao critica compartilhada ...")

      #L ======================================================================
      #L Passo 4: No 1 sai da SC e envia RELEASE
      #L ======================================================================
      println("5. [Passo 4: Saida e Difusao de RELEASE]")
      q_ts[1] = 0
      q_id[1] = 0
      println("   No 1 remove sua requisicao da fila local e transmite RELEASE aos pares.")

      #L Pares removem requisicao
      q_ts[2] = 0
      q_id[2] = 0
      q_ts[3] = 0
      q_id[3] = 0
      println("   -> No 2 e No 3 removem (2, 1) de suas filas.")

      println("==================================================")
      println("6. Verificacao Final: Filas limpas e sincronizadas.")
      println("   Total de mensagens trocadas: 3*(N - 1) = 6.")
      println("==================================================")
}
