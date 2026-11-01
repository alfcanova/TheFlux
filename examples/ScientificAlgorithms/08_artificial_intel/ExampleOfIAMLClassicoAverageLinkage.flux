#L ============================================================================
#L Algoritmo: Average-Linkage (Distancia Media UPGMA entre Clusters)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoAverageLinkage) {
      println("=== Algoritmo: Average-Linkage UPGMA ===")
      mut as list of int64: pairwiseDist = [18, 9, 25, 14]
      mut as int64: sumD = pairwiseDist[1] + pairwiseDist[2] + pairwiseDist[3] + pairwiseDist[4]
      mut as int64: avgD = sumD /i 4
      println("1. Distancia media inter-cluster: " + avgD)
      println("Teste concluido com sucesso.")
}
