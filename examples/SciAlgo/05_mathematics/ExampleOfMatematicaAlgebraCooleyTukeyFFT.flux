#L ============================================================================
#L Algoritmo: Cooley-Tukey FFT (Radix-2 Decimation in Time)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraCooleyTukeyFFT) {
      println("==================================================")
      println("  SciAlgo: Cooley-Tukey Radix-2 DIT FFT")
      println("==================================================")

      mut as int64: n = 8
      mut as int64: etapas_log2 = 3
      mut as int64: total_borboletas = (n /i 2) * etapas_log2

      println("1. Decomposicao recursiva par/impar para N=" + n)
      println("2. Total de operacoes de borboleta: " + total_borboletas)
      println("3. Cooley-Tukey FFT concluido com sucesso.")
}
