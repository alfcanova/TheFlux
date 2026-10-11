#L ============================================================================
#L Algoritmo: Binary Space Partitioning (BSP)
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaBSP) {
      println("==================================================")
      println("  SciAlgo: Binary Space Partitioning (BSP)")
      println("==================================================")

      mut as list of int64: pts = [10, 35, 5, 80, 22, 60]
      mut as int64: plane_z = 30
      mut as int64: front = 0
      mut as int64: n = listLength(pts)
      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  pts[i] > plane_z ==> { front = front + 1 }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Poligonos no semi-espaco frontal da arvore BSP: " + front)
      println("2. Binary Space Partitioning (BSP) concluido com sucesso.")
}
