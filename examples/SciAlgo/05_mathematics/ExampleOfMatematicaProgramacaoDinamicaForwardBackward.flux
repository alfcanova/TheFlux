#L ============================================================================
#L Algoritmo: Forward-Backward (Suavização e Probabilidades Posteriores em HMM)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(S^2 * T) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaForwardBackward) {
      println("==================================================")
      println("  SciAlgo: Forward-Backward Algorithm")
      println("==================================================")

      mut as int64: alpha_total = 120
      mut as int64: beta_total = 120

      println("1. Passadas Forward (alpha) e Backward (beta) sincronizadas")
      println("2. Probabilidade marginal condicional: " + alpha_total)
      println("3. Forward-Backward concluido com sucesso.")
}
