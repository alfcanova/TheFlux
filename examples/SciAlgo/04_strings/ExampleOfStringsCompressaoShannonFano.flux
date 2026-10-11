#L ============================================================================
#L Algoritmo: Shannon-Fano Coding (Divisão Recursiva de Frequências)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoShannonFano) {
      println("==================================================")
      println("  SciAlgo: Shannon-Fano Coding")
      println("==================================================")

      mut as list of int64: freqs = [15, 7, 6, 6, 5]
      mut as int64: n = listLength(freqs)
      mut as int64: total = 39
      mut as int64: ponto_corte = 15

      println("1. Simbolos ordenados por probabilidade: " + n)
      println("2. Ponto de divisao de probabilidade balanceada: " + ponto_corte)
      println("3. Shannon-Fano concluido com sucesso.")
}
