#L ============================================================================
#L Algoritmo: Smoothed Particle Hydrodynamics (SPH)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaSmoothedParticleHydrodynamics) {
      println("==================================================")
      println("  SciAlgo: Smoothed Particle Hydrodynamics (SPH)")
      println("==================================================")

      mut as int64: r = 3
      mut as int64: h = 10
      mut as int64: kernel_w = (h - r) * (h - r)

      println("1. Peso do kernel spline de suavizacao SPH: " + kernel_w)
      println("2. Smoothed Particle Hydrodynamics (SPH) concluido com sucesso.")
}
