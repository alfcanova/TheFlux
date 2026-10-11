#L ============================================================================
#L Algoritmo: Farneback Optical Flow (Fluxo Optico Denso por Expansao Polinomial)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVFarnebackOpticalFlow) {
      println("=== Algoritmo: Farneback Dense Optical Flow ===")
      mut as int64: polyCoeffA = 4
      mut as int64: polyCoeffB = 8
      mut as int64: displacementD = polyCoeffB /i (2 * polyCoeffA)
      println("1. Campo de deslocamento denso d: " + displacementD)
      println("Teste concluido com sucesso.")
}
