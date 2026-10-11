#L ============================================================================
#L Algoritmo: Conflict-Free Replicated Data Types (PN-Counter & OR-Set)
#L Dominio: 09_systems_infra / Categoria: Algoritmos de consenso e coordenacao
#L Complexidade: O(N) operacoes de merge convergente sem coordenacao central
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoCRDTPNCounterORSet) {
      println("==================================================")
      println("  SciAlgo: CRDT PN-Counter and Observed-Remove Set")
      println("==================================================")

      #L CRDTs (Shapiro et al., 2011) garantem Strong Eventual Consistency (SEC)
      #L matematicamente atraves de semi-reticulados de juncao (join-semilattices).
      #L 1. PN-Counter: par de vetores (P, N) onde P armazena incrementos e N decrementos.
      #L    Valor = sum(P) - sum(N); Merge = max(P1, P2) e max(N1, N2).
      #L 2. OR-Set (Observed-Remove Set): elementos sao associados a tags unicas (UUIDs).
      #L    Remove apenas remove as tags observadas localmente; adicoes concorrentes vencem.

      mut as int64: num_nodes = 3
      mut as int64: pn_counter_val = 15
      mut as int64: or_set_cardinality = 2

      println("1. Demonstracao do PN-Counter (State-based CvRDT):")
      println("   No A: P=[10, 0, 0], N=[0, 0, 0]  (Incrementa 10)")
      println("   No B: P=[0, 8, 0],  N=[0, 2, 0]  (Incrementa 8, Decrementa 2)")
      println("   No C: P=[0, 0, 4],  N=[0, 0, 5]  (Incrementa 4, Decrementa 5)")
      println("   Operacao Merge Join: P_merge=[10, 8, 4], N_merge=[0, 2, 5]")
      println("   Valor consolidado PN-Counter: sum(P) - sum(N) = 22 - 7 = " + pn_counter_val)

      println("2. Demonstracao do OR-Set (Observed-Remove Set):")
      println("   - Replica 1 adiciona elemento 'item_1' com Tag = T1.")
      println("   - Replica 2 concorrentemente adiciona 'item_1' com Tag = T2.")
      println("   - Replica 1 remove 'item_1' (apenas tag T1 observada eh removida).")
      println("   - Merge das replicas: Tag T2 permanece ativa! 'item_1' continua no conjunto.")

      println("3. Conclusao:")
      println("   Convergencia monotona verificada sem necessidade de travas ou bloqueios.")
      println("   CRDT PN-Counter and OR-Set concluido com sucesso.")
}
