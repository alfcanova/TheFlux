#L ============================================================================
#L Algoritmo: GCN (Graph Convolutional Network - Kipf & Welling)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosGraphConvolutionalNetwork) {
      println("=== Algoritmo: Graph Convolutional Network ===")
      mut as int64: h1 = 10
      mut as int64: h2 = 20
      mut as int64: weight = 3
      mut as int64: convOut = ((h1 + h2) * weight) /i 2
      mut as int64: reluOut = convOut
      route {
            convOut < 0 ==> { reluOut = 0 }
            _ ==> {}
      }
      println("1. Ativacao de convolucao em grafo: " + reluOut)
      println("Teste concluido com sucesso.")
}
