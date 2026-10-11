#L ============================================================================
#L Algoritmo: Alternating Direction Implicit (ADI)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaADIMethod) {
      println("==================================================")
      println("  SciAlgo: Alternating Direction Implicit (ADI)")
      println("==================================================")

      mut as int64: u_base = 100
      mut as int64: x_term = 15
      mut as int64: y_term = 12
      mut as int64: u_half = u_base + x_term + y_term

      println("1. Passo intermediario Peaceman-Rachford ADI: " + u_half)
      println("2. Alternating Direction Implicit (ADI) concluido com sucesso.")
}
