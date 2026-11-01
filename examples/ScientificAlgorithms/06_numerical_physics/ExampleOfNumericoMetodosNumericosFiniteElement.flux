#L ============================================================================
#L Algoritmo: Finite Element Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosFiniteElement) {
      println("==================================================")
      println("  SciAlgo: Finite Element Method")
      println("==================================================")

      mut as int64: elem_len = 10
      mut as int64: k_stiff = 1000 /i elem_len

      println("1. Rigidez do elemento linear FEM: " + k_stiff)
      println("2. Finite Element Method concluido com sucesso.")
}
