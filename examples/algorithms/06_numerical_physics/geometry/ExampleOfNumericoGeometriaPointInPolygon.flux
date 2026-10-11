#L ============================================================================
#L Algoritmo: Point in Polygon (PIP)
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaPointInPolygon) {
      println("==================================================")
      println("  SciAlgo: Point in Polygon (PIP)")
      println("==================================================")

      mut as int64: px = 5
      mut as int64: py = 5
      mut as int64: min_x = 0
      mut as int64: max_x = 10
      mut as int64: min_y = 0
      mut as int64: max_y = 10
      mut as int64: inside = 0
      route {
            px >= min_x and px <= max_x and py >= min_y and py <= max_y ==> { inside = 1 }
            _ ==> {}
      }

      println("1. Ponto contido no poligono: " + inside)
      println("2. Point in Polygon (PIP) concluido com sucesso.")
}
