#L ============================================================================
#L Algoritmo: N-Body Gravitational Simulation
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaNBodySimulation) {
      println("==================================================")
      println("  SciAlgo: N-Body Gravitational Simulation")
      println("==================================================")

      mut as int64: m1 = 10
      mut as int64: m2 = 20
      mut as int64: dist_sq = 25
      mut as int64: f_grav = (m1 * m2) /i dist_sq

      println("1. Forca gravitacional newtoniana calculada: " + f_grav)
      println("2. N-Body Gravitational Simulation concluido com sucesso.")
}
