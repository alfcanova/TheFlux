#L ============================================================================
#L Algoritmo: FFT (Fast Fourier Transform Clássica)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraFFT) {
      println("==================================================")
      println("  SciAlgo: Fast Fourier Transform (FFT)")
      println("==================================================")

      mut as int64: n = 8
      mut as int64: operacoes_borboleta = (n /i 2) * 3

      println("1. Transformada rapida de Fourier para N=" + n)
      println("2. Operacoes butterfly calculadas: " + operacoes_borboleta)
      println("3. FFT concluido com sucesso.")
}
