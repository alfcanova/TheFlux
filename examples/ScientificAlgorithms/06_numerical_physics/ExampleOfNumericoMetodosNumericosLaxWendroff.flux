#L ============================================================================
#L Algoritmo: Lax-Wendroff Scheme
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosLaxWendroff) {
      println("==================================================")
      println("  SciAlgo: Lax-Wendroff Scheme")
      println("==================================================")

      mut as int64: u = 100
      mut as int64: d1 = 10
      mut as int64: d2 = 4
      mut as int64: lw_step = u - d1 + d2 /i 2

      println("1. Avanço de 2a ordem no tempo por Lax-Wendroff: " + lw_step)
      println("2. Lax-Wendroff Scheme concluido com sucesso.")
}
