#L ============================================================================
#L Algoritmo: Particle-in-Cell (PIC) Plasma Grid
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaParticleInCell) {
      println("==================================================")
      println("  SciAlgo: Particle-in-Cell (PIC) Plasma Grid")
      println("==================================================")

      mut as int64: charge_q = 50
      mut as int64: dist_pct = 20
      mut as int64: deposited = (charge_q * (100 - dist_pct)) /i 100

      println("1. Interpolacao linear de carga na malha PIC: " + deposited)
      println("2. Particle-in-Cell (PIC) Plasma Grid concluido com sucesso.")
}
