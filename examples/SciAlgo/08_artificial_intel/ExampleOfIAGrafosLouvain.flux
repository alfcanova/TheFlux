#L ============================================================================
#L Algoritmo: Louvain (Otimizacao de Modularidade de Grafos)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosLouvain) {
      println("=== Algoritmo: Louvain Modularity Optimization ===")
      mut as int64: deltaQ1 = 35
      mut as int64: deltaQ2 = 12
      mut as int64: chosenComm = 0
      route {
            deltaQ1 > deltaQ2 and deltaQ1 > 0 ==> { chosenComm = 1 }
            deltaQ2 > deltaQ1 and deltaQ2 > 0 ==> { chosenComm = 2 }
            _ ==> {}
      }
      println("1. Ganho delta Q Comunidade 1: " + deltaQ1)
      println("2. Ganho delta Q Comunidade 2: " + deltaQ2)
      println("3. Comunidade Selecionada: " + chosenComm)
      println("Teste concluido com sucesso.")
}
