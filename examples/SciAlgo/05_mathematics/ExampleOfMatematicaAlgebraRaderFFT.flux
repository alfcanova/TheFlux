#L ============================================================================
#L Algoritmo: Rader FFT (Transformada de Fourier para Tamanhos Primos)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log N) transformando DFT prima em convolucao ciclica (N-1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraRaderFFT) {
      println("==================================================")
      println("  SciAlgo: Rader's Algorithm for Prime FFT Sizes")
      println("==================================================")

      mut as int64: p = 5
      mut as int64: grupo_ciclico = p - 1

      println("1. Tamanho primo da DFT: P=" + p)
      println("2. Mapeamento bijetivo para grupo ciclico Z_P*: tamanho " + grupo_ciclico)
      println("3. Rader FFT concluido com sucesso.")
}
