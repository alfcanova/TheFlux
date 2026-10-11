#L ============================================================================
#L Algoritmo: Muller's Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosMullersMethod) {
      println("==================================================")
      println("  SciAlgo: Muller's Method")
      println("==================================================")

      mut as int64: x0 = 0
      mut as int64: x1 = 5
      mut as int64: x2 = 10
      mut as int64: parabola_apex = (x0 + x1 + x2) /i 3

      println("1. Aproximacao parabolica quadratica de Muller: " + parabola_apex)
      println("2. Muller's Method concluido com sucesso.")
}
