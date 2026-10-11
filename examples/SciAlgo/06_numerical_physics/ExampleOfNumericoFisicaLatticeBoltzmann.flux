#L ============================================================================
#L Algoritmo: Lattice Boltzmann Method (LBM D2Q9)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaLatticeBoltzmann) {
      println("==================================================")
      println("  SciAlgo: Lattice Boltzmann Method (LBM D2Q9)")
      println("==================================================")

      mut as int64: f_now = 120
      mut as int64: f_eq = 100
      mut as int64: tau = 2
      mut as int64: f_collided = f_now - (f_now - f_eq) /i tau

      println("1. Operador de colisao BGK relaxado no LBM: " + f_collided)
      println("2. Lattice Boltzmann Method (LBM D2Q9) concluido com sucesso.")
}
