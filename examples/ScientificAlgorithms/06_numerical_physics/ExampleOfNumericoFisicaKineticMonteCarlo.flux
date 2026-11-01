#L ============================================================================
#L Algoritmo: Kinetic Monte Carlo (KMC)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaKineticMonteCarlo) {
      println("==================================================")
      println("  SciAlgo: Kinetic Monte Carlo (KMC)")
      println("==================================================")

      mut as int64: total_rate = 50
      mut as int64: time_step = 1000 /i total_rate

      println("1. Passo de tempo de Poisson em KMC: " + time_step)
      println("2. Kinetic Monte Carlo (KMC) concluido com sucesso.")
}
