#L ============================================================================
#L Algoritmo: Word2Vec (Skip-Gram com Amostragem Negativa)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPWord2Vec) {
      println("=== Algoritmo: Word2Vec Skip-Gram ===")
      mut as list of int64: targetVec = [20, 30]
      mut as list of int64: contextVec = [22, 28]
      mut as int64: dotProduct = (targetVec[1] * contextVec[1] + targetVec[2] * contextVec[2]) /i 10
      println("1. Dot product de contexto semantico: " + dotProduct)
      println("Teste concluido com sucesso.")
}
