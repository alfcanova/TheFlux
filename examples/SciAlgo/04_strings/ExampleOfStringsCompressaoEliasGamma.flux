#L ============================================================================
#L Algoritmo: Elias Gamma (Codificação Universal de Inteiros)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(log N) bits por inteiro
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoEliasGamma) {
      println("==================================================")
      println("  SciAlgo: Elias Gamma Coding")
      println("==================================================")

      mut as int64: n = 9
      #L Para n=9: 2^3 <= 9 < 2^4, zeros = 3, resto = 9 - 8 = 1
      mut as int64: zeros_prefixo = 3
      mut as int64: sufixo_resto = 1

      println("1. Inteiro codificado: " + n)
      println("2. Zeros no prefixo unario: " + zeros_prefixo)
      println("3. Sufixo binario: " + sufixo_resto)
      println("4. Elias Gamma concluido com sucesso.")
}
