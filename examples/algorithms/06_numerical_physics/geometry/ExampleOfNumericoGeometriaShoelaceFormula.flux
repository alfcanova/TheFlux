#L ============================================================================
#L Algoritmo: Shoelace Formula (Gauss Area)
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaShoelaceFormula) {
      println("==================================================")
      println("  SciAlgo: Shoelace Formula (Gauss Area)")
      println("==================================================")

      mut as list of int64: x_p = [0, 4, 4, 0]
      mut as list of int64: y_p = [0, 0, 3, 3]
      mut as int64: det1 = x_p[1] * y_p[2] - x_p[2] * y_p[1]
      mut as int64: det2 = x_p[2] * y_p[3] - x_p[3] * y_p[2]
      mut as int64: det3 = x_p[3] * y_p[4] - x_p[4] * y_p[3]
      mut as int64: det4 = x_p[4] * y_p[1] - x_p[1] * y_p[4]
      mut as int64: total_area2 = det1 + det2 + det3 + det4
      route { total_area2 < 0 ==> { total_area2 = 0 - total_area2 } _ ==> {} }
      mut as int64: poly_area = total_area2 /i 2

      println("1. Area poligonal calculada pela formula Shoelace: " + poly_area)
      println("2. Shoelace Formula (Gauss Area) concluido com sucesso.")
}
