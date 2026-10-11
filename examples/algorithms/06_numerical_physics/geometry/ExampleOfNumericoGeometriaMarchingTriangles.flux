#L ============================================================================
#L Algoritmo: Marching Triangles
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaMarchingTriangles) {
      println("==================================================")
      println("  SciAlgo: Marching Triangles")
      println("==================================================")

      mut as int64: v1 = 12
      mut as int64: v2 = 4
      mut as int64: v3 = 18
      mut as int64: iso_val = 10
      mut as int64: triangle_state = 0
      route { v1 > iso_val ==> { triangle_state = triangle_state + 1 } _ ==> {} }
      route { v2 > iso_val ==> { triangle_state = triangle_state + 2 } _ ==> {} }
      route { v3 > iso_val ==> { triangle_state = triangle_state + 4 } _ ==> {} }

      println("1. Estado de corte topologico Marching Triangles: " + triangle_state)
      println("2. Marching Triangles concluido com sucesso.")
}
