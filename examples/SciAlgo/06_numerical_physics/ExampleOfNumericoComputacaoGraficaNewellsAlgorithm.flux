#L ============================================================================
#L Algoritmo: Newell's Algorithm
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaNewellsAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Newell's Algorithm")
      println("==================================================")

      mut as int64: min_z1 = 10
      mut as int64: max_z1 = 30
      mut as int64: min_z2 = 25
      mut as int64: max_z2 = 45
      mut as int64: overlap = 1
      route {
            max_z1 < min_z2 or max_z2 < min_z1 ==> { overlap = 0 }
            _ ==> {}
      }

      println("1. Conflito de profundidade detectado no teste Z: " + overlap)
      println("2. Newell's Algorithm concluido com sucesso.")
}
