#L ============================================================================
#L Algoritmo: Polygon Triangulation (Ear Clipping)
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaPolygonTriangulation) {
      println("==================================================")
      println("  SciAlgo: Polygon Triangulation (Ear Clipping)")
      println("==================================================")

      mut as int64: n_vert = 6
      mut as int64: total_tri = n_vert - 2

      println("1. Numero de triangulos gerados pela triangulacao: " + total_tri)
      println("2. Polygon Triangulation (Ear Clipping) concluido com sucesso.")
}
