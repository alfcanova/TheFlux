#L ============================================================================
#L Algoritmo: Lesk Algorithm (Desambiguacao Lexical por Sobreposicao de Glossas)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPLeskAlgorithm) {
      println("=== Algoritmo: Simplified Lesk ===")
      mut as int64: overlapSense1 = 4
      mut as int64: overlapSense2 = 1
      mut as int64: chosenSense = 1
      route {
            overlapSense2 > overlapSense1 ==> { chosenSense = 2 }
            _ ==> {}
      }
      println("1. Sobreposicao Sense 1: " + overlapSense1)
      println("2. Sobreposicao Sense 2: " + overlapSense2)
      println("3. Sentido lexical selecionado: " + chosenSense)
      println("Teste concluido com sucesso.")
}
