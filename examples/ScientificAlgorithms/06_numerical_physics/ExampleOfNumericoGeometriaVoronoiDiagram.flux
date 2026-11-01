#L ============================================================================
#L Algoritmo: Voronoi Diagram
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaVoronoiDiagram) {
      println("==================================================")
      println("  SciAlgo: Voronoi Diagram")
      println("==================================================")

      mut as int64: d1_sq = 25
      mut as int64: d2_sq = 49
      mut as int64: cell_owner = 2
      route { d1_sq < d2_sq ==> { cell_owner = 1 } _ ==> {} }

      println("1. Celula de Voronoi mais proxima: " + cell_owner)
      println("2. Voronoi Diagram concluido com sucesso.")
}
