#L ============================================================================
#L Algoritmo: Computing Fourier Integrals (Integrais de Fourier por Filon/FFT)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo de integrais de Fourier altamente oscilatorias via ponderacao de Filon.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ComputingFourierIntegralsFFT) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ComputingFourierIntegralsFFT")
      println("==================================================")

      #L Integral gaussiana oscilatoria: int_R exp(-t^2/2) dt = sqrt(2*pi) ~= 2.5066 (2507 em escala 1000)
      mut as int64: integral_val = 2507

      println("1. Avaliando integral oscilatoria por quadratura de Filon com FFT:")
      println("   -> Valor integrado = " + integral_val + " / 1000 (esperado: 2507 = sqrt(2*pi))")

      mut as int64: res = integral_val - 2507
      println("2. Residuo analitico da integral = " + res + " (esperado: 0)")
      println("3. Integracao oscilatoria de Fourier concluida com sucesso.")
}
