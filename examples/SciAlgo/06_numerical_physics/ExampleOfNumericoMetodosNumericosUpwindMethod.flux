#L ============================================================================
#L Algoritmo: Upwind Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosUpwindMethod) {
      println("==================================================")
      println("  SciAlgo: Upwind Method")
      println("==================================================")

      mut as int64: u_curr = 50
      mut as int64: u_prev = 40
      mut as int64: vel = 20
      mut as int64: u_next = u_curr - (vel * (u_curr - u_prev)) /i 100

      println("1. Transporte de adveccao calculado por Upwind: " + u_next)
      println("2. Upwind Method concluido com sucesso.")
}
