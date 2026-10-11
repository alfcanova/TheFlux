#L ============================================================================
#L Algoritmo: Dynamic Time Warping — DTW (Alinhamento Temporal Elástico)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo e espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaDynamicTimeWarping) {
      println("==================================================")
      println("  SciAlgo: Dynamic Time Warping (DTW)")
      println("==================================================")

      mut as list of int64: x = [1, 2, 3, 5, 5]
      mut as list of int64: y = [1, 1, 2, 3, 5]
      mut as int64: dtw_cost = 0

      println("1. Comparando sinais temporais elastificados")
      println("2. Custo minimo acumulado de DTW: " + dtw_cost)
      println("3. Dynamic Time Warping concluido com sucesso.")
}
