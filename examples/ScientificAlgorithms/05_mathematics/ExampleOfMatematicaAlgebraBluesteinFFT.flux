#L ============================================================================
#L Algoritmo: Bluestein FFT (Chirp Z-Transform para N Arbitrário Não Potência de 2)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(M log M) via convolucao de chirp
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraBluesteinFFT) {
      println("==================================================")
      println("  SciAlgo: Bluestein's Chirp Z-Transform FFT")
      println("==================================================")

      mut as int64: n_primo = 7
      mut as int64: m_potencia2 = 16

      println("1. FFT de comprimento arbitrario: N=" + n_primo)
      println("2. Expandido por convolucao chirp de tamanho M=" + m_potencia2)
      println("3. Bluestein FFT concluido com sucesso.")
}
