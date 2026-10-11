#L ============================================================================
#L Algoritmo: Leapfrog Wave Scheme
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaLeapfrogScheme) {
      println("==================================================")
      println("  SciAlgo: Leapfrog Wave Scheme")
      println("==================================================")

      mut as int64: u_prev = 40
      mut as int64: u_curr = 50
      mut as int64: c2 = 100
      mut as int64: lap = 2
      mut as int64: u_next = 2 * u_curr - u_prev + (c2 * lap) /i 100

      println("1. Propagacao de onda no meio continuo por Leapfrog: " + u_next)
      println("2. Leapfrog Wave Scheme concluido com sucesso.")
}
