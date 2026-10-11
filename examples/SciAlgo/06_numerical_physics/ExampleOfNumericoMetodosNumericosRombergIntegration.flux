#L ============================================================================
#L Algoritmo: Romberg Integration
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosRombergIntegration) {
      println("==================================================")
      println("  SciAlgo: Romberg Integration")
      println("==================================================")

      mut as int64: t0 = 150
      mut as int64: t1 = 160
      mut as int64: r11 = (4 * t1 - t0) /i 3

      println("1. Extrapolacao de Richardson R(1,1) de Romberg: " + r11)
      println("2. Romberg Integration concluido com sucesso.")
}
