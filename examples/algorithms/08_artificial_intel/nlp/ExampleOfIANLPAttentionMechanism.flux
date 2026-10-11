#L ============================================================================
#L Algoritmo: Attention Mechanism (Bahdanau Additive / Luong Multiplicative)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPAttentionMechanism) {
      println("=== Algoritmo: Attention Mechanism ===")
      mut as int64: queryState = 10
      mut as int64: keyState1 = 8
      mut as int64: keyState2 = 12
      mut as int64: score1 = queryState * keyState1
      mut as int64: score2 = queryState * keyState2
      mut as int64: sumScores = score1 + score2
      mut as int64: weight1 = (score1 * 100) /i sumScores
      mut as int64: weight2 = (score2 * 100) /i sumScores
      println("1. Peso de alinhamento Token 1: " + weight1)
      println("2. Peso de alinhamento Token 2: " + weight2)
      println("Teste concluido com sucesso.")
}
