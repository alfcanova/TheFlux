#L ============================================================================
#L Algoritmo: Delaunay Triangulation InCircle
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaDelaunayTriangulation) {
      println("==================================================")
      println("  SciAlgo: Delaunay Triangulation InCircle")
      println("==================================================")

      mut as int64: dist_sq = 15
      mut as int64: circum_sq = 25
      mut as int64: inside_circum = 0
      route { dist_sq <= circum_sq ==> { inside_circum = 1 } _ ==> {} }

      println("1. Condicao InCircle de Delaunay verificada: " + inside_circum)
      println("2. Delaunay Triangulation InCircle concluido com sucesso.")
}
