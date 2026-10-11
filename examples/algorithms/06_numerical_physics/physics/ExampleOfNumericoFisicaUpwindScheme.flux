#L ============================================================================
#L Algoritmo: Upwind Convection Scheme
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaUpwindScheme) {
      println("==================================================")
      println("  SciAlgo: Upwind Convection Scheme")
      println("==================================================")

      mut as int64: u_i = 100
      mut as int64: u_im1 = 80
      mut as int64: cfl = 20
      mut as int64: u_up = u_i - (cfl * (u_i - u_im1)) /i 100

      println("1. Solucao de adveccao conservativa Upwind: " + u_up)
      println("2. Upwind Convection Scheme concluido com sucesso.")
}
