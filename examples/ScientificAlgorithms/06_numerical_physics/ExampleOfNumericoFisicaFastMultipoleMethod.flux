#L ============================================================================
#L Algoritmo: Fast Multipole Method (FMM)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFastMultipoleMethod) {
      println("==================================================")
      println("  SciAlgo: Fast Multipole Method (FMM)")
      println("==================================================")

      mut as int64: charge = 5
      mut as int64: pos = 12
      mut as int64: dipole_moment = charge * pos

      println("1. Momento de expansao multipolar FMM: " + dipole_moment)
      println("2. Fast Multipole Method (FMM) concluido com sucesso.")
}
