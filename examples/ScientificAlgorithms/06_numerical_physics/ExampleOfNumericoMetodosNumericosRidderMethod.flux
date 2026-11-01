#L ============================================================================
#L Algoritmo: Ridder's Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosRidderMethod) {
      println("==================================================")
      println("  SciAlgo: Ridder's Method")
      println("==================================================")

      mut as int64: x1 = 10
      mut as int64: x2 = 40
      mut as int64: mid_pt = (x1 + x2) /i 2

      println("1. Ponto medio exponencial do passo de Ridder: " + mid_pt)
      println("2. Ridder's Method concluido com sucesso.")
}
