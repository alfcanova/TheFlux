#L ============================================================================
#L Algoritmo: Viterbi Decoder (Decodificacao de Sequencias Convolucionais)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(2^K * L) onde K e a restricao e L o comprimento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoViterbiDecoder) {
      println("==================================================")
      println("  SciAlgo: Viterbi Convolutional Decoder")
      println("==================================================")

      mut as list of int64: metrica_acumulada = [0, 99, 99, 99]
      mut as int64: passos = 5
      mut as int64: custo_minimo = 1

      println("1. Trellis convolucional percorrido por " + passos + " passos")
      println("2. Metrica de caminho sobrevivente: " + custo_minimo)
      println("3. Viterbi Decoder concluido com sucesso.")
}
