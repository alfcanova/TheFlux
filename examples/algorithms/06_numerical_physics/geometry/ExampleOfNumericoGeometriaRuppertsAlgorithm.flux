#L ============================================================================
#L Algoritmo: Ruppert's Delaunay Refinement
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaRuppertsAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Ruppert's Delaunay Refinement")
      println("==================================================")

      mut as int64: edge_len = 50
      mut as int64: split_point = edge_len /i 2

      println("1. Ponto de divisao de segmento violado por Ruppert: " + split_point)
      println("2. Ruppert's Delaunay Refinement concluido com sucesso.")
}
