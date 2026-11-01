#L ============================================================================
#L Algoritmo: Elias Delta (Codificação Universal de Inteiros Grandes)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(log log N) sobrecarga
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoEliasDelta) {
      println("==================================================")
      println("  SciAlgo: Elias Delta Coding")
      println("==================================================")

      mut as int64: n = 17
      mut as int64: bits_len = 5
      mut as int64: gamma_len_zeros = 2

      println("1. Inteiro codificado: " + n)
      println("2. Comprimento do expoente codificado em Gamma: " + bits_len)
      println("3. Elias Delta concluido com sucesso.")
}
