#L ============================================================================
#L Algoritmo: Galerkin Finite Element Method
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFiniteElement) {
      println("==================================================")
      println("  SciAlgo: Galerkin Finite Element Method")
      println("==================================================")

      mut as int64: h = 12
      mut as int64: mass_element = h /i 3

      println("1. Elemento da matriz de massa consistente FEM: " + mass_element)
      println("2. Galerkin Finite Element Method concluido com sucesso.")
}
