#L ============================================================================
#L Algoritmo: Finite Difference Diffusion
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFiniteDifference) {
      println("==================================================")
      println("  SciAlgo: Finite Difference Diffusion")
      println("==================================================")

      mut as int64: u_prev = 20
      mut as int64: u_curr = 50
      mut as int64: u_next = 20
      mut as int64: alpha = 25
      mut as int64: laplacian = u_next - 2 * u_curr + u_prev
      mut as int64: u_diffused = u_curr + (alpha * laplacian) /i 100

      println("1. Difusao termica calculada por diferencas finitas: " + u_diffused)
      println("2. Finite Difference Diffusion concluido com sucesso.")
}
