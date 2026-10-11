#L ============================================================================
#L Algoritmo: Finite Difference Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosFiniteDifference) {
      println("==================================================")
      println("  SciAlgo: Finite Difference Method")
      println("==================================================")

      mut as int64: y_next = 150
      mut as int64: y_prev = 50
      mut as int64: dx = 5
      mut as int64: deriv = (y_next - y_prev) /i (2 * dx)

      println("1. Derivada central de diferencas finitas: " + deriv)
      println("2. Finite Difference Method concluido com sucesso.")
}
