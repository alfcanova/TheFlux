#L ============================================================================
#L Algoritmo: Midpoint Circle Algorithm
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaMidpointCircle) {
      println("==================================================")
      println("  SciAlgo: Midpoint Circle Algorithm")
      println("==================================================")

      mut as int64: r = 5
      mut as int64: x = 0
      mut as int64: y = r
      mut as int64: d = 1 - r
      mut as int64: octant_pts = 0
      infinite (x <= y) {
            octant_pts = octant_pts + 8
            route {
                  d < 0 ==> { d = d + 2 * x + 3 }
                  _ ==> {
                        d = d + 2 * (x - y) + 5
                        y = y - 1
                  }
            }
            x = x + 1
      }

      println("1. Total de pixels simetricos do circulo: " + octant_pts)
      println("2. Midpoint Circle Algorithm concluido com sucesso.")
}
