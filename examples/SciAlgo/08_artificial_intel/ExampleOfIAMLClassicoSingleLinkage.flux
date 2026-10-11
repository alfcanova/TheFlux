#L ============================================================================
#L Algoritmo: Single-Linkage (Distancia Minima entre Pares de Clusters)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoSingleLinkage) {
      println("=== Algoritmo: Single-Linkage ===")
      mut as list of int64: pairwiseDist = [18, 9, 25, 14]
      mut as int64: minD = pairwiseDist[1]
      mut as int64: i = 2
      infinite (i <= 4) {
            route {
                  pairwiseDist[i] < minD ==> { minD = pairwiseDist[i] }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Distancia single-linkage (minimo): " + minD)
      println("Teste concluido com sucesso.")
}
