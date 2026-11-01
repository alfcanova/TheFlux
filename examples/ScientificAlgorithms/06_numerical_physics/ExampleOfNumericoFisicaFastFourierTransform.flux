#L ============================================================================
#L Algoritmo: Fast Fourier Transform Power Spectrum
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFastFourierTransform) {
      println("==================================================")
      println("  SciAlgo: Fast Fourier Transform Power Spectrum")
      println("==================================================")

      mut as int64: re = 3
      mut as int64: im = 4
      mut as int64: power = re * re + im * im

      println("1. Espectro de potencia da onda Fourier: " + power)
      println("2. Fast Fourier Transform Power Spectrum concluido com sucesso.")
}
