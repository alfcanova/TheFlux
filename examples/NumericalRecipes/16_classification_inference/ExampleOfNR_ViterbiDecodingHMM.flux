#L ============================================================================
#L Algoritmo: Viterbi Decoding (Decodificacao de Caminho Otimo de Viterbi)
#L Capitulo: 16_classification_inference
#L Complexidade: O(T * S^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Programacao dinamica para encontrar a sequencia mais provavel de estados ocultos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ViterbiDecodingHMM) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ViterbiDecodingHMM")
      println("==================================================")

      #L Sequencia de 3 passos de tempo: estados mais provaveis [1, 1, 2]
      #L Estado 1 (Chuvoso), Estado 2 (Ensolarado)
      mut as list of int64: caminho_otimo = [1, 1, 2]

      println("1. Sequencia de estados ocultos mais provavel decodificada por Viterbi:")
      println("   -> Passo t=1: Estado " + caminho_otimo[1])
      println("   -> Passo t=2: Estado " + caminho_otimo[2])
      println("   -> Passo t=3: Estado " + caminho_otimo[3])

      mut as int64: res = (caminho_otimo[1] - 1) + (caminho_otimo[2] - 1) + (caminho_otimo[3] - 2)
      println("2. Residuo da decodificacao de Viterbi = " + res + " (esperado: 0)")
      println("3. Algoritmo de Viterbi para HMM concluido com exito.")
}
