#L ============================================================================
#L Algoritmo: Seq2Seq (Sequence-to-Sequence Encoder-Decoder)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPSeq2Seq) {
      println("=== Algoritmo: Seq2Seq Encoder-Decoder ===")
      mut as int64: encFinalState = 88
      mut as int64: decInitState = encFinalState
      mut as int64: decStep1 = decInitState + 5
      println("1. Vetor de contexto transferido pelo encoder: " + decInitState)
      println("2. Primeiro estado oculto do decoder: " + decStep1)
      println("Teste concluido com sucesso.")
}
