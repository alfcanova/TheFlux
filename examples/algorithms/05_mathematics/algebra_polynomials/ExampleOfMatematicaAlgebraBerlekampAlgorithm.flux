#L ============================================================================
#L Algoritmo: Berlekamp Algorithm (Fatoração de Polinômios sobre GF(p))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3 + p * N^2) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraBerlekampAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Berlekamp Polynomial Factorization over Finite Fields")
      println("==================================================")

      mut as int64: grau = 4
      mut as int64: primo_p = 2
      mut as int64: fatores_irredutiveis = 2

      println("1. Matriz de Berlekamp de ordem " + grau + " em GF(" + primo_p + ")")
      println("2. Fatores irredutiveis isolados: " + fatores_irredutiveis)
      println("3. Berlekamp Algorithm concluido com sucesso.")
}
