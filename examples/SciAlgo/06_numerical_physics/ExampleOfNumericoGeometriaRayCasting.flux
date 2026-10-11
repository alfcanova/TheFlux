#L ============================================================================
#L Algoritmo: Ray Casting Crossing Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaRayCasting) {
      println("==================================================")
      println("  SciAlgo: Ray Casting Crossing Algorithm")
      println("==================================================")

      mut as int64: edge_y1 = 2
      mut as int64: edge_y2 = 8
      mut as int64: py = 5
      mut as int64: crosses = 0
      route {
            (edge_y1 <= py and edge_y2 > py) or (edge_y2 <= py and edge_y1 > py) ==> { crosses = 1 }
            _ ==> {}
      }

      println("1. Intersecao com raio horizontal de Jordan: " + crosses)
      println("2. Ray Casting Crossing Algorithm concluido com sucesso.")
}
