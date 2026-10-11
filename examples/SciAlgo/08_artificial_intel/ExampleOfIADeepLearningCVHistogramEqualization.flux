#L ============================================================================
#L Algoritmo: Histogram Equalization (Equalizacao Global por Funcao CDF)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVHistogramEqualization) {
      println("=== Algoritmo: Histogram Equalization ===")
      mut as int64: cdfVal = 500
      mut as int64: totalPixels = 1000
      mut as int64: maxL = 255
      mut as int64: equalizedIntensity = (cdfVal * maxL) /i totalPixels
      println("1. Intensidade equalizada (CDF normalizada): " + equalizedIntensity)
      println("Teste concluido com sucesso.")
}
