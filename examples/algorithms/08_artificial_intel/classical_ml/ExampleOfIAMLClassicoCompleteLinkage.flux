#L ============================================================================
#L Algoritmo: Complete-Linkage (Distancia Maxima entre Pares de Clusters)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoCompleteLinkage) {
      println("=== Algoritmo: Complete-Linkage ===")
      mut as list of int64: pairwiseDist = [18, 9, 25, 14]
      mut as int64: maxD = pairwiseDist[1]
      mut as int64: i = 2
      infinite (i <= 4) {
            route {
                  pairwiseDist[i] > maxD ==> { maxD = pairwiseDist[i] }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Distancia complete-linkage (diametro maximo): " + maxD)
      println("Teste concluido com sucesso.")
}
