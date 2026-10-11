#L ============================================================================
#L Algoritmo: Rice Coding (Caso Especial de Golomb com M = 2^K)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(1) via shifts binários
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoRiceCoding) {
      println("==================================================")
      println("  SciAlgo: Rice Coding")
      println("==================================================")

      mut as int64: x = 27
      mut as int64: k = 3
      mut as int64: m = 8

      mut as int64: q = x /i m
      mut as int64: r = x /r m

      println("1. Valor x: " + x + ", potencia k=" + k + " (M=" + m + ")")
      println("2. Parte unaria: " + q + ", parte residual: " + r)
      println("3. Rice Coding concluido com sucesso.")
}
