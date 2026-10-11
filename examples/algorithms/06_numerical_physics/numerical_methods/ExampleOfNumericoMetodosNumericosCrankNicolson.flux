#L ============================================================================
#L Algoritmo: Crank-Nicolson Scheme
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosCrankNicolson) {
      println("==================================================")
      println("  SciAlgo: Crank-Nicolson Scheme")
      println("==================================================")

      mut as int64: expl_val = 120
      mut as int64: impl_val = 100
      mut as int64: cn_avg = (expl_val + impl_val) /i 2

      println("1. Media semi-implicita Crank-Nicolson: " + cn_avg)
      println("2. Crank-Nicolson Scheme concluido com sucesso.")
}
