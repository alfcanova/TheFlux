#L ============================================================================
#L Algoritmo: Glauber Dynamics Spin Flip
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaGlauberDynamics) {
      println("==================================================")
      println("  SciAlgo: Glauber Dynamics Spin Flip")
      println("==================================================")

      mut as int64: field = 2
      mut as int64: temp = 10
      mut as int64: flip_prob = 50 + (field * 25) /i temp

      println("1. Probabilidade de flip de spin termico de Glauber: " + flip_prob)
      println("2. Glauber Dynamics Spin Flip concluido com sucesso.")
}
