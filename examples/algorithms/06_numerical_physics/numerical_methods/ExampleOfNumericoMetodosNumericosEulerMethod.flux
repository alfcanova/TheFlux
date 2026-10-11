#L ============================================================================
#L Algoritmo: Euler's Forward Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosEulerMethod) {
      println("==================================================")
      println("  SciAlgo: Euler's Forward Method")
      println("==================================================")

      mut as int64: y = 100
      mut as int64: dt = 10
      mut as int64: i = 1
      infinite (i <= 5) {
            mut as int64: dydt = 2 * y
            y = y + (dydt * dt) /i 100
            i = i + 1
      }

      println("1. Valor final de y apos passos de Euler: " + y)
      println("2. Euler's Forward Method concluido com sucesso.")
}
