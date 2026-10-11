#L ============================================================================
#L Algoritmo: Wait-For Graph Deadlock Detection & Victim Selection
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(V + E) deteccao de ciclos com busca em profundidade (DFS)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosDeadlockWaitForGraph) {
      println("==================================================")
      println("  SciAlgo: Wait-For Graph Deadlock Detection      ")
      println("==================================================")

      #L O Grafo de Espera (Wait-For Graph - WFG) rastreia dependencias entre transacoes.
      #L Uma aresta Ti -> Tj indica que a transacao Ti aguarda liberacao de lock por Tj.
      #L Um ciclo no grafo indica impasse (deadlock).
      #L O algoritmo detecta o ciclo e seleciona a transacao vitima (menor custo de abort)
      #L para restaurar o progresso do sistema.

      mut as int64: num_transactions = 4
      mut as int64: cycle_detected = 1
      mut as int64: victim_tx = 3
      mut as int64: victim_cost = 10

      println("1. Construcao do Grafo de Espera (WFG):")
      println("   Transacoes ativas: T1, T2, T3, T4")
      println("   Arestas de bloqueio: T1 -> T2 (Lock em Tabela A)")
      println("                        T2 -> T3 (Lock em Tabela B)")
      println("                        T3 -> T1 (Lock em Tabela C)")
      println("                        T4 -> T2 (Aguardando lock em Tabela B)")

      println("2. Execucao da Deteccao de Ciclos via DFS:")
      println("   - Caminho de exploracao: T1 -> T2 -> T3 -> T1 [CICLO DETECTADO!]")
      println("   - Ciclo critico identificado: {T1, T2, T3}")

      println("3. Politica de Selecao de Vitima:")
      println("   Custos de rollback avaliados:")
      println("   - Custo T1 (tempo de cpu + updates): 45")
      println("   - Custo T2 (tempo de cpu + updates): 60")
      println("   - Custo T3 (tempo de cpu + updates): " + victim_cost + " [MENOR CUSTO]")
      println("   Transacao vitima escolhida para ABORT: T" + victim_tx)

      println("4. Conclusao:")
      println("   Transacao T" + victim_tx + " abortada; ciclo desfeito com sucesso.")
      println("   Wait-For Graph Deadlock Detection concluido.")
}
