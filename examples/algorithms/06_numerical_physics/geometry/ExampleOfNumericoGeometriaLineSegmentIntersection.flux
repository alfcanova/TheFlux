#L ============================================================================
#L Algoritmo: Line Segment Intersection
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaLineSegmentIntersection) {
      println("==================================================")
      println("  SciAlgo: Line Segment Intersection")
      println("==================================================")

      mut as int64: ccw1 = 1
      mut as int64: ccw2 = -1
      mut as int64: ccw3 = 1
      mut as int64: ccw4 = -1
      mut as int64: intersects = 0
      route {
            ccw1 != ccw2 and ccw3 != ccw4 ==> { intersects = 1 }
            _ ==> {}
      }

      println("1. Intersecao valida entre dois segmentos de reta: " + intersects)
      println("2. Line Segment Intersection concluido com sucesso.")
}
