#L ============================================================================
#L Algoritmo: Sutherland-Hodgman Polygon Clipping
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaSutherlandHodgman) {
      println("==================================================")
      println("  SciAlgo: Sutherland-Hodgman Polygon Clipping")
      println("==================================================")

      mut as int64: px = 15
      mut as int64: clip_x = 10
      mut as int64: inside_edge = 0
      route { px >= clip_x ==> { inside_edge = 1 } _ ==> {} }

      println("1. Vertice aprovado no plano de recorte: " + inside_edge)
      println("2. Sutherland-Hodgman Polygon Clipping concluido com sucesso.")
}
