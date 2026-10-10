#L ============================================================================
#L Algoritmo: Tolerância a Falhas Bizantinas (Byzantine Fault Tolerance - OM(1))
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(N^2) trocas de mensagens para N = 3m + 1 nós com m=1 traidor
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (majorityVote3) (as int64: v1, as int64: v2, as int64: v3) as int64 {
      mut as int64: sum = v1 + v2 + v3
      mut as int64: dec = 0
      route {
            sum >= 2 ==> {
                  dec = 1
            }
      }
      emit(nice, dec, "ok")
}

program (ExampleOfSistemasConsensoByzantineFaultTolerance) {
      println("==================================================")
      println("  SciAlgo: Consenso dos Generais Bizantinos (OM(1))")
      println("==================================================")
      println("Condicao de Lamport-Shostak-Pease: N >= 3m + 1 (N=4, m=1 traidor)")

      #L ========================================================================
      #L Cenario 1: Comandante Honesto e Tenente 4 Traidor (Bizantino)
      #L ========================================================================
      println("")
      println("--- Cenário 1: Comandante Honesto (Ordem = 1 [ATACAR]), Tenente 4 Traidor ---")
      mut as int64: cmd_order1 = 1

      #L Comandante envia ordem 1 para L2, L3, L4
      println("1. [Rodada 1] Comandante 1 envia ATACAR (1) para todos os tenentes.")
      mut as int64: l2_from_cmd = cmd_order1
      mut as int64: l3_from_cmd = cmd_order1
      mut as int64: l4_from_cmd = cmd_order1

      #L Na Rodada 2, os tenentes retransmitem a ordem recebida aos seus pares:
      #L Tenentes honestos L2 e L3 retransmitem fielmente 1
      #L Tenente bizantino L4 sabota e transmite 0 (RECUAR) para L2 e L3
      println("2. [Rodada 2] Tenentes trocam ordens entre si:")
      mut as int64: l2_from_l3 = 1
      mut as int64: l2_from_l4 = 0 #L L4 mente para L2!
      println("   -> L2 recebe: do Comandante=1, de L3=1, de L4 (traidor)=0")

      mut as int64: l3_from_l2 = 1
      mut as int64: l3_from_l4 = 0 #L L4 mente para L3!
      println("   -> L3 recebe: do Comandante=1, de L2=1, de L4 (traidor)=0")

      #L Decisao por votacao majoritaria:
      mut as int64: dec_l2 = majorityVote3(l2_from_cmd, l2_from_l3, l2_from_l4)
      mut as int64: dec_l3 = majorityVote3(l3_from_cmd, l3_from_l2, l3_from_l4)

      println("3. Votacao Majoritaria:")
      println("   -> Decisao de L2: " + dec_l2 + " (ATACAR)")
      println("   -> Decisao de L3: " + dec_l3 + " (ATACAR)")
      println("   Consenso preservado: Todos os tenentes leais concordam com a ordem do Comandante.")

      #L ========================================================================
      #L Cenario 2: Comandante Traidor (Envia Ordens Conflitantes)
      #L ========================================================================
      println("")
      println("--- Cenário 2: Comandante Traidor (Ordens Contraditórias), Tenentes Leais ---")
      #L Comandante envia 1 para L2, e 0 para L3 e L4
      println("1. [Rodada 1] Comandante traidor envia ATACAR (1) para L2, mas RECUAR (0) para L3 e L4.")
      mut as int64: l2_rec = 1
      mut as int64: l3_rec = 0
      mut as int64: l4_rec = 0

      #L Rodada 2: Todos os tenentes sao leais e retransmitem honestamente o que receberam
      println("2. [Rodada 2] Tenentes leais trocam ordens honestamente:")
      #L L2 recebe: Comandante=1, L3=0, L4=0
      mut as int64: dec2 = majorityVote3(l2_rec, l3_rec, l4_rec)
      println("   -> L2 vetor = [1, 0, 0] => Decisao Majoritaria = " + dec2 + " (RECUAR)")

      #L L3 recebe: Comandante=0, L2=1, L4=0
      mut as int64: dec3 = majorityVote3(l3_rec, l2_rec, l4_rec)
      println("   -> L3 vetor = [0, 1, 0] => Decisao Majoritaria = " + dec3 + " (RECUAR)")

      #L L4 recebe: Comandante=0, L2=1, L3=0
      mut as int64: dec4 = majorityVote3(l4_rec, l2_rec, l3_rec)
      println("   -> L4 vetor = [0, 1, 0] => Decisao Majoritaria = " + dec4 + " (RECUAR)")

      println("3. Resultado:")
      println("   Todos os generais leais chegam ao exato mesmo consenso (" + dec2 + "), neutralizando o traidor.")
}
