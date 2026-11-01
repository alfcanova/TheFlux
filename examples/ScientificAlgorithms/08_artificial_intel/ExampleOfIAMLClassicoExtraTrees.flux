#L ============================================================================
#L Algoritmo: Extra Trees (Extremely Randomized Trees)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoExtraTrees) {
      println("=== Algoritmo: Extremely Randomized Trees ===")
      mut as int64: randomCutThreshold = 37
      mut as int64: sampleVal = 40
      mut as int64: leafNode = 0
      route {
            sampleVal > randomCutThreshold ==> { leafNode = 2 }
            _ ==> { leafNode = 1 }
      }
      println("1. Corte estocastico gerado: " + randomCutThreshold)
      println("2. Folha atingida: " + leafNode)
      println("Teste concluido com sucesso.")
}
