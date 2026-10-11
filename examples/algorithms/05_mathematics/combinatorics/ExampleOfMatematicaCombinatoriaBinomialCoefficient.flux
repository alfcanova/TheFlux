#L ============================================================================
#L Algoritmo: Binomial Coefficient (Cálculo Eficiente de C(N, K))
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(K) multiplicativo direto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaBinomialCoefficient) {
      println("==================================================")
      println("  SciAlgo: Multiplicative Binomial Coefficient")
      println("==================================================")

      mut as int64: n = 10
      mut as int64: k = 3
      mut as int64: ans = (10 * 9 * 8) /i (1 * 2 * 3)

      println("1. Coeficiente C(" + n + ", " + k + ") = " + ans)
      println("2. Binomial Coefficient concluido com sucesso.")
}
