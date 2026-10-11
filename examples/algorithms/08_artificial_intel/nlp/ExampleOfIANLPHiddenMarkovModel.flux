#L ============================================================================
#L Algoritmo: Hidden Markov Model (HMM para Etiquetagem Sequencial)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPHiddenMarkovModel) {
      println("=== Algoritmo: HMM Forward Trellis ===")
      mut as int64: prevAlpha = 30
      mut as int64: aTrans = 70
      mut as int64: bEmiss = 80
      mut as int64: currentAlpha = (prevAlpha * aTrans * bEmiss) /i 10000
      println("1. Variavel Forward alfa calculada: " + currentAlpha)
      println("Teste concluido com sucesso.")
}
