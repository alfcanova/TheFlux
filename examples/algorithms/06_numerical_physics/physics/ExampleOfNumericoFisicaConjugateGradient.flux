#L ============================================================================
#L Algoritmo: Conjugate Gradient Descent
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaConjugateGradient) {
      println("==================================================")
      println("  SciAlgo: Conjugate Gradient Descent")
      println("==================================================")

      mut as int64: r_dot_r = 50
      mut as int64: p_dot_ap = 20
      mut as int64: alpha = (r_dot_r * 100) /i p_dot_ap

      println("1. Comprimento do passo alpha no Gradiente Conjugado: " + alpha)
      println("2. Conjugate Gradient Descent concluido com sucesso.")
}
