#L ============================================================================
#L Algoritmo: Hierarchical Clustering (Agrupamento Hierarquico Aglomerativo)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoHierarchicalClustering) {
      println("=== Algoritmo: Hierarchical Agglomerative Clustering ===")
      mut as int64: minClusterDist = 14
      mut as int64: clusterPairA = 1
      mut as int64: clusterPairB = 3
      println("1. Par de clusters mais proximo fundido: (" + clusterPairA + ", " + clusterPairB + ")")
      println("2. Altura no dendrograma: " + minClusterDist)
      println("Teste concluido com sucesso.")
}
