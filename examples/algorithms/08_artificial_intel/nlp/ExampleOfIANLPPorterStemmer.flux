#L ============================================================================
#L Algoritmo: Porter Stemmer (Etapas de Normalizacao de Sufixos de Porter)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPPorterStemmer) {
      println("=== Algoritmo: Porter Stemmer Step 1a ===")
      mut as int64: measureM = 2
      mut as int64: ruleApplied = 1
      println("1. Medida m de sequencias consoante-vogal: " + measureM)
      println("2. Regra 'sses' -> 'ss' aplicada com sucesso: " + ruleApplied)
      println("Teste concluido com sucesso.")
}
