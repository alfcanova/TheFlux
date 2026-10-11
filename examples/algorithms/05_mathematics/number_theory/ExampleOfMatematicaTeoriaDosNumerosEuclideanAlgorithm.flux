#L ============================================================================
#L Algoritmo: Euclidean Algorithm (MDC Euclidiano Clássico)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log(min(A, B))) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosEuclideanAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Euclidean Algorithm for GCD")
      println("==================================================")

      mut as int64: a = 252
      mut as int64: b = 105

      infinite (b != 0) {
            mut as int64: rem = a /r b
            a = b
            b = rem
      }

      println("1. MDC calculado: " + a)
      println("2. Euclidean Algorithm concluido com sucesso.")
}
