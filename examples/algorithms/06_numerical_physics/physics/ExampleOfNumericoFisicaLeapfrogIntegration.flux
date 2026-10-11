#L ============================================================================
#L Algoritmo: Leapfrog Orbital Integration
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaLeapfrogIntegration) {
      println("==================================================")
      println("  SciAlgo: Leapfrog Orbital Integration")
      println("==================================================")

      mut as int64: pos = 100
      mut as int64: vel_half = 15
      mut as int64: dt = 2
      mut as int64: pos_next = pos + vel_half * dt

      println("1. Posicao apos integracao Leapfrog sincronizada: " + pos_next)
      println("2. Leapfrog Orbital Integration concluido com sucesso.")
}
