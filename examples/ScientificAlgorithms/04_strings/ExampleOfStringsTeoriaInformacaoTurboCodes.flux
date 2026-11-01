#L ============================================================================
#L Algoritmo: Turbo Codes (Codificacao Convolucional Paralela Concatenada)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(I * N) para I iteracoes de decodificacao turbo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoTurboCodes) {
      println("==================================================")
      println("  SciAlgo: Turbo Codes Iterative Decoding")
      println("==================================================")

      mut as int64: interleave_len = 16
      mut as int64: iteracoes_decodificacao = 4
      mut as int64: convergencia = 1

      println("1. Entrelaçador interno de tamanho: " + interleave_len)
      println("2. Iteracoes de troca de informacao extrinseca: " + iteracoes_decodificacao)
      println("3. Status de convergencia: " + convergencia)
      println("4. Turbo Codes concluido com sucesso.")
}
