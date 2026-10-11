#L ============================================================================
#L Algoritmo: Spectral Method (Fourier Transform)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaSpectralMethod) {
      println("==================================================")
      println("  SciAlgo: Spectral Method (Fourier Transform)")
      println("==================================================")

      mut as int64: k_wave = 3
      mut as int64: u_k = 40
      mut as int64: spectral_deriv = 0 - k_wave * u_k

      println("1. Derivada espacial no espaco de modos de Fourier: " + spectral_deriv)
      println("2. Spectral Method (Fourier Transform) concluido com sucesso.")
}
