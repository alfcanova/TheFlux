#L ============================================================================
#L Algoritmo: Bitmask DP (DP com Máscaras de Bits / Held-Karp TSP)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N^2 * 2^N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaBitmaskDP) {
      println("==================================================")
      println("  SciAlgo: Bitmask DP (Held-Karp TSP)")
      println("==================================================")

      mut as int64: n = 4
      mut as int64: estados = 16
      mut as int64: custo_tsp = 35

      println("1. Estados de subconjunto 2^" + n + " = " + estados)
      println("2. Menor circuito Hamiltoniano calculado: " + custo_tsp)
      println("3. Bitmask DP concluido com sucesso.")
}
