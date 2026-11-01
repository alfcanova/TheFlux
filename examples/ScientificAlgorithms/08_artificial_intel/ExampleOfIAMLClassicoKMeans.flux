#L ============================================================================
#L Algoritmo: K-Means (Agrupamento por Minimizacao de Inercia Intra-Cluster)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoKMeans) {
      println("=== Algoritmo: K-Means Clustering ===")
      mut as int64: pX = 12
      mut as int64: c1X = 5
      mut as int64: c2X = 20
      mut as int64: d1 = (pX - c1X) * (pX - c1X)
      mut as int64: d2 = (pX - c2X) * (pX - c2X)
      mut as int64: assignedCluster = 1
      route {
            d2 < d1 ==> { assignedCluster = 2 }
            _ ==> {}
      }
      println("1. Distancia ao centroide 1: " + d1)
      println("2. Distancia ao centroide 2: " + d2)
      println("3. Cluster mais proximo atribuido: " + assignedCluster)
      println("Teste concluido com sucesso.")
}
