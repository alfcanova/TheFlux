#L ============================================================================
#L Algoritmo: Spectral Clustering (Agrupamento Espectral via Matriz Laplaciana)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoSpectralClustering) {
      println("=== Algoritmo: Spectral Clustering ===")
      mut as list of int64: fiedlerVector = [0 - 45, 0 - 30, 20, 55]
      mut as int64: clusterAssignment = 1
      route {
            fiedlerVector[3] >= 0 ==> { clusterAssignment = 2 }
            _ ==> {}
      }
      println("1. Auto-vetor de Fiedler projetado: " + fiedlerVector[3])
      println("2. Particao bipartida espectral: " + clusterAssignment)
      println("Teste concluido com sucesso.")
}
