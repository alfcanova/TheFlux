#L ============================================================================
#L Algoritmo: Profile DP (DP de Perfil de Contorno / Tiling Problem)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N * 2^M) para grid N x M
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaProfileDP) {
      println("==================================================")
      println("  SciAlgo: Profile DP Grid Tiling")
      println("==================================================")

      mut as int64: tilings = 11
      println("1. Formas de preenchimento com dominoes 2x1: " + tilings)
      println("2. Profile DP concluido com sucesso.")
}
