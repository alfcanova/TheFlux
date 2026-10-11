#L ============================================================================
#L Algoritmo: GloVe (Global Vectors for Word Representation)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPGloVe) {
      println("=== Algoritmo: GloVe Co-occurrence ===")
      mut as int64: wI = 15
      mut as int64: wJ = 12
      mut as int64: bI = 2
      mut as int64: bJ = 3
      mut as int64: logCooccur = 185
      mut as int64: predLog = wI * wJ + bI + bJ
      mut as int64: diff = predLog - logCooccur
      println("1. Predicao da matriz log-coocorrencia: " + predLog)
      println("2. Residuo da fatoracao GloVe: " + diff)
      println("Teste concluido com sucesso.")
}
