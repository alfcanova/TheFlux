#L ============================================================================
#L Algoritmo: Binary Splitting
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosBinarySplitting) {
      println("==================================================")
      println("  SciAlgo: Binary Splitting")
      println("==================================================")

      mut as int64: p1 = 1 * 2 * 3
      mut as int64: p2 = 4 * 5
      mut as int64: factorial_prod = p1 * p2

      println("1. Produto fatorial dividido por Binary Splitting: " + factorial_prod)
      println("2. Binary Splitting concluido com sucesso.")
}
