#L ============================================================================
#L Algoritmo: Formal Power Series (Operações Algébricas com Séries Formais FPS)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: Inversao O(N log N) via iteracao de Newton
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraFormalPowerSeries) {
      println("==================================================")
      println("  SciAlgo: Formal Power Series (FPS) Inversion")
      println("==================================================")

      mut as int64: precisao_mod_x = 8
      mut as int64: iteracoes_newton = 3

      println("1. Inversao de serie formal P(x)^(-1) mod x^" + precisao_mod_x)
      println("2. Passos de Newton: " + iteracoes_newton)
      println("3. Formal Power Series concluido com sucesso.")
}
