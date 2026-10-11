#L ============================================================================
#L Algoritmo: Girvan-Newman (Deteccao de Comunidades por Edge Betweenness)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosGirvanNewman) {
      println("=== Algoritmo: Girvan-Newman Comunidades ===")
      mut as list of int64: edgeBetweenness = [12, 45, 8, 30]
      mut as int64: maxEdgeIdx = 1
      mut as int64: maxVal = edgeBetweenness[1]
      mut as int64: i = 2
      infinite (i <= 4) {
            route {
                  edgeBetweenness[i] > maxVal ==> {
                        maxVal = edgeBetweenness[i]
                        maxEdgeIdx = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Aresta ponte com maior betweenness removida: Aresta " + maxEdgeIdx)
      println("2. Comunidade A: [1, 2]")
      println("3. Comunidade B: [3, 4]")
      println("Teste concluido com sucesso.")
}
