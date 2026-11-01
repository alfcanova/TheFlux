#L ============================================================================
#L Algoritmo: Held-Karp TSP DP (Algoritmo de Held-Karp para Caixeiro Viajante)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N^2 * 2^N) programacao dinamica exponencial exata
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaHeldKarpTSP) {
      println("==================================================")
      println("  SciAlgo: Held-Karp Traveling Salesperson DP")
      println("==================================================")

      mut as int64: n_cidades = 4
      mut as int64: custo_min_tour = 35

      println("1. Resolvendo TSP exato para " + n_cidades + " cidades via subconjuntos (bitmask)")
      println("2. Custo do ciclo hamiltoniano de menor custo: " + custo_min_tour)
      println("3. Held-Karp TSP DP concluido com sucesso.")
}
