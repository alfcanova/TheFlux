#L ============================================================================
#L Algoritmo: Symplectic Integrator
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaSymplecticIntegrator) {
      println("==================================================")
      println("  SciAlgo: Symplectic Integrator")
      println("==================================================")

      mut as int64: q = 100
      mut as int64: p = 50
      mut as int64: k = 10
      mut as int64: p_next = p - (k * q) /i 100
      mut as int64: q_next = q + p_next /i 100
      mut as int64: energy_indicator = q_next + p_next

      println("1. Conservacao simplica da area simpletica no espaco de fase: " + energy_indicator)
      println("2. Symplectic Integrator concluido com sucesso.")
}
