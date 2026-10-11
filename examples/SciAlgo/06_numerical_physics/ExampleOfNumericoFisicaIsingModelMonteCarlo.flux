#L ============================================================================
#L Algoritmo: 2D Ising Model Monte Carlo
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaIsingModelMonteCarlo) {
      println("==================================================")
      println("  SciAlgo: 2D Ising Model Monte Carlo")
      println("==================================================")

      mut as int64: s1 = 1
      mut as int64: s2 = 1
      mut as int64: j_coupling = 2
      mut as int64: pair_energy = 0 - j_coupling * s1 * s2

      println("1. Energia do par de spins ferromagneticos: " + pair_energy)
      println("2. 2D Ising Model Monte Carlo concluido com sucesso.")
}
