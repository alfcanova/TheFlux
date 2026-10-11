#L ============================================================================
#L Algoritmo: Level Set Two-Phase Fluid Interface
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaLevelSetMethod) {
      println("==================================================")
      println("  SciAlgo: Level Set Two-Phase Fluid Interface")
      println("==================================================")

      mut as int64: phi = 100
      mut as int64: vn = 5
      mut as int64: grad_phi = 20
      mut as int64: phi_new = phi - (vn * grad_phi) /i 100

      println("1. Evolucao da interface livre por Level Set: " + phi_new)
      println("2. Level Set Two-Phase Fluid Interface concluido com sucesso.")
}
