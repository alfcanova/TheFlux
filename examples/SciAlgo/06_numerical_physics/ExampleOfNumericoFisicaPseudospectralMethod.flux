#L ============================================================================
#L Algoritmo: Pseudospectral Collocation Method
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaPseudospectralMethod) {
      println("==================================================")
      println("  SciAlgo: Pseudospectral Collocation Method")
      println("==================================================")

      mut as int64: u_grid = 12
      mut as int64: v_grid = 15
      mut as int64: nonlin_term = u_grid * v_grid

      println("1. Termo nao-linear colocalizado no espaco fisico: " + nonlin_term)
      println("2. Pseudospectral Collocation Method concluido com sucesso.")
}
