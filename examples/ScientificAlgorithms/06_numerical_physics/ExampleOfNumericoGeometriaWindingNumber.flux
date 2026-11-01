#L ============================================================================
#L Algoritmo: Winding Number Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaWindingNumber) {
      println("==================================================")
      println("  SciAlgo: Winding Number Algorithm")
      println("==================================================")

      mut as int64: y1 = 2
      mut as int64: y2 = 10
      mut as int64: py = 5
      mut as int64: ccw_orient = 1
      mut as int64: wn = 0
      route {
            y1 <= py and y2 > py and ccw_orient > 0 ==> { wn = wn + 1 }
            _ ==> {}
      }

      println("1. Indice de voltas acumulado (Winding Number): " + wn)
      println("2. Winding Number Algorithm concluido com sucesso.")
}
