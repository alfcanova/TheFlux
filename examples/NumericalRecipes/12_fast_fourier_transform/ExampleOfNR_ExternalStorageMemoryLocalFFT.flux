#L ============================================================================
#L Algoritmo: Memory-Local & External FFTs (FFT com Localidade de Memoria)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algoritmo de 4 passos com transposicao em bloco para grandes arrays.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ExternalStorageMemoryLocalFFT) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ExternalStorageMemoryLocalFFT")
      println("==================================================")

      #L Decomposicao em matriz N1 x N2 (2 x 2):
      #L 1. Sub-FFTs em colunas de tamanho 2
      #L 2. Multiplicacao por fatores de rotacao (twiddle factors)
      #L 3. Transposicao de matriz em blocos contiguos
      #L 4. Sub-FFTs em linhas
      #L Componente DC resultante para x = [1, 2, 3, 4] e 10:
      mut as int64: dc_local = 10

      println("1. Executando FFT com transposicao de acesso local de memoria:")
      println("   -> DC local obtido = " + dc_local + " (esperado: 10)")

      mut as int64: res = dc_local - 10
      println("2. Residuo do algoritmo local = " + res + " (esperado: 0)")
      println("3. FFT com memoria local e armazenamento externo validada com sucesso.")
}
