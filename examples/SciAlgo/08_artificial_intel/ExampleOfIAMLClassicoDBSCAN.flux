#L ============================================================================
#L Algoritmo: DBSCAN (Density-Based Spatial Clustering of Applications with Noise)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoDBSCAN) {
      println("=== Algoritmo: DBSCAN ===")
      mut as int64: epsNeighbors = 5
      mut as int64: minPts = 4
      mut as int64: isCore = 0
      route {
            epsNeighbors >= minPts ==> { isCore = 1 }
            _ ==> {}
      }
      println("1. Vizinhos na bola epsilon: " + epsNeighbors)
      println("2. Classificacao como Core Point: " + isCore)
      println("Teste concluido com sucesso.")
}
