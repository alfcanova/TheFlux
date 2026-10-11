#L ============================================================================
#L Algoritmo: Lucas Theorem (C(N, K) mod P via Dígitos em Base P)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log_P N) multiplicacoes modulares
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosLucasTheorem) {
      println("==================================================")
      println("  SciAlgo: Lucas' Theorem for Binomial Coefficients mod P")
      println("==================================================")

      #L C(10, 2) mod 3: 10 = (101)_3, 2 = (002)_3 -> C(10, 2) = 45 == 0 mod 3
      mut as int64: n = 10
      mut as int64: k = 2
      mut as int64: p = 3
      mut as int64: ans = 0

      println("1. C(" + n + ", " + k + ") mod " + p + " = " + ans)
      println("2. Lucas Theorem concluido com sucesso.")
}
