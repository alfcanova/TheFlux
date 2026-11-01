#L ============================================================================
#L Algoritmo: Chandy-Lamport Distributed Snapshot Algorithm (1985)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(E) mensagens MARKER onde E e o numero de canais FIFO
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoChandyLamportSnapshot) {
      println("==================================================")
      println("  SciAlgo: Chandy-Lamport Global Snapshot")
      println("==================================================")

      #L O algoritmo de Chandy-Lamport captura um estado global consistente
      #L (corte consistente) de um sistema distribuido assincrono sem pausar
      #L as computacoes. Pressupoe canais confiaveis com ordenacao FIFO.
      #L O estado global e composto pelo estado local de cada processo mais
      #L o estado das mensagens em transito nos canais de comunicacao.

      #L Cenario: 2 processos bancarios P1 e P2.
      #L Canais: C12 (P1 -> P2) e C21 (P2 -> P1)
      mut as int64: p1_balance = 1000
      mut as int64: p2_balance = 500

      println("1. Estado Inicial do Sistema:")
      println("   Saldo P1: " + p1_balance + " | Saldo P2: " + p2_balance)
      println("   Total no Sistema: " + (p1_balance + p2_balance) + " (Invariante a ser preservado)")

      #L Evento de Aplicacao: P1 transfere 200 para P2
      p1_balance = p1_balance - 200
      println("2. [Transferencia Bancaria] P1 envia 200 para P2 via Canal C12 (Saldo P1 = " + p1_balance + ")")

      #L ======================================================================
      #L Disparo do Snapshot por P1
      #L ======================================================================
      println("--------------------------------------------------")
      println("3. [Inicio do Snapshot] Processo P1 inicia a captura global:")
      mut as int64: snap_p1 = p1_balance
      println("   -> P1 grava seu estado local: Snap_P1 = " + snap_p1)
      println("   -> P1 envia marcador MARKER pelo canal de saida C12.")

      #L A mensagem de 200 transita pelo canal FIFO antes do MARKER
      println("4. [Transito no Canal FIFO C12]")
      println("   -> P2 recebe transferencia de 200 antes do marcador: Saldo P2 = " + (p2_balance + 200))
      p2_balance = p2_balance + 200

      #L Agora P2 recebe o MARKER de P1
      println("5. [Recepcao do MARKER em P2]")
      println("   Como e o primeiro marcador visto por P2:")
      mut as int64: snap_p2 = p2_balance
      println("   -> P2 grava seu estado local: Snap_P2 = " + snap_p2)
      println("   -> P2 fecha canal C12 (mensagens capturadas em transito no canal C12 = 0)")
      mut as int64: snap_c12 = 0
      println("   -> P2 envia MARKER pelo seu canal de saida C21 para P1.")

      #L P1 recebe o MARKER vindo de P2 pelo canal C21
      println("6. [Recepcao do MARKER em P1 vindo de P2]")
      println("   P1 ja gravou seu estado -> fecha gravacao do canal C21.")
      mut as int64: snap_c21 = 0
      println("   -> Canal C21 fechado com 0 mensagens em transito.")

      #L ======================================================================
      #L Consolidacao do Snapshot Global
      #L ======================================================================
      println("==================================================")
      println("7. [Estado Global Consolidado]")
      println("   Estado Local Gravado P1: " + snap_p1)
      println("   Estado Local Gravado P2: " + snap_p2)
      println("   Estado do Canal C12:     " + snap_c12)
      println("   Estado do Canal C21:     " + snap_c21)
      mut as int64: total_snapshot = snap_p1 + snap_p2 + snap_c12 + snap_c21
      println("   Soma do Snapshot Global: " + total_snapshot)
      println("   Invariante Perfeito: Total do Snapshot == 1500 (Preservado!)")
      println("==================================================")
}
