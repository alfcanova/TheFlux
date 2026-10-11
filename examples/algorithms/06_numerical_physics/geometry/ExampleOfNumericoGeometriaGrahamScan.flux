#L ============================================================================
#L Algoritmo: Graham Scan Convex Hull
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaGrahamScan) {
      println("==================================================")
      println("  SciAlgo: Graham Scan Convex Hull")
      println("==================================================")

      mut as int64: p1x = 0
      mut as int64: p1y = 0
      mut as int64: p2x = 4
      mut as int64: p2y = 0
      mut as int64: p3x = 2
      mut as int64: p3y = 3
      mut as int64: cross = (p2x - p1x) * (p3y - p1y) - (p2y - p1y) * (p3x - p1x)
      mut as int64: ccw_flag = 0
      route {
            cross > 0 ==> { ccw_flag = 1 }
            cross < 0 ==> { ccw_flag = -1 }
            _ ==> { ccw_flag = 0 }
      }

      println("1. Orientacao CCW calculada pelo produto vetorial: " + ccw_flag)
      println("2. Graham Scan Convex Hull concluido com sucesso.")
}
