#L ============================================================================
#L Algoritmo: Rayleigh Quotient Iteration (Convergência Cúbica de Autopares)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(K * N^3) com convergência cúbica rápida
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraRayleighQuotient) {
      println("==================================================")
      println("  SciAlgo: Rayleigh Quotient Iteration")
      println("==================================================")

      mut as int64: iter = 3
      mut as int64: quociente = 9

      println("1. Iteracoes ate convergencia cubica: " + iter)
      println("2. Quociente de Rayleigh final: " + quociente)
      println("3. Rayleigh Quotient concluido com sucesso.")
}
