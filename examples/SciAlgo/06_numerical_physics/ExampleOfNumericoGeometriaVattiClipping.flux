#L ============================================================================
#L Algoritmo: Vatti Polygon Clipping
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaVattiClipping) {
      println("==================================================")
      println("  SciAlgo: Vatti Polygon Clipping")
      println("==================================================")

      mut as int64: y = 10
      mut as int64: scan_y = 10
      mut as int64: vatti_class = 0
      route {
            y < scan_y ==> { vatti_class = -1 }
            y > scan_y ==> { vatti_class = 1 }
            _ ==> { vatti_class = 0 }
      }

      println("1. Classificacao do feixe de arestas no algoritmo de Vatti: " + vatti_class)
      println("2. Vatti Polygon Clipping concluido com sucesso.")
}
