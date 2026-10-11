#L ============================================================================
#L Algoritmo: SIFT (Scale-Invariant Feature Transform - DoG e Orientacao)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVSIFT) {
      println("=== Algoritmo: SIFT Difference of Gaussians ===")
      mut as int64: scaleSpace1 = 85
      mut as int64: scaleSpace2 = 60
      mut as int64: dogExtremum = scaleSpace1 - scaleSpace2
      println("1. Valor DoG no espaco de escala: " + dogExtremum)
      println("Teste concluido com sucesso.")
}
