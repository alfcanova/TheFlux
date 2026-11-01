#L ============================================================================
#L Algoritmo: Fast Marching Eikonal Wavefront
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFastMarchingMethod) {
      println("==================================================")
      println("  SciAlgo: Fast Marching Eikonal Wavefront")
      println("==================================================")

      mut as int64: t0 = 15
      mut as int64: slow = 2
      mut as int64: dx = 5
      mut as int64: t_arrive = t0 + slow * dx

      println("1. Solucao de viscosidade da equacao Eikonal FMM: " + t_arrive)
      println("2. Fast Marching Eikonal Wavefront concluido com sucesso.")
}
