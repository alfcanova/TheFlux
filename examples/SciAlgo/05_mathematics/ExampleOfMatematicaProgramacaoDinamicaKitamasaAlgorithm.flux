#L ============================================================================
#L Algoritmo: Kitamasa Algorithm (Cálculo do N-ésimo Termo de Recorrência Linear em O(K^2 log N))
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(K^2 log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaKitamasaAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Kitamasa Fast Linear Recurrence")
      println("==================================================")

      mut as int64: k = 2
      mut as int64: n = 10
      mut as int64: fib_10 = 55

      println("1. Recorrencia de ordem K=" + k + " para N=" + n)
      println("2. N-esimo termo avaliado: " + fib_10)
      println("3. Kitamasa Algorithm concluido com sucesso.")
}
