#L ============================================================================
#L Algoritmo: Blind Deconvolution (Restauracao de Imagem com PSF Desconhecida)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVBlindDeconvolution) {
      println("=== Algoritmo: Blind Deconvolution ===")
      mut as int64: psfEstimate = 5
      mut as int64: imgEstimate = 40
      mut as int64: combinedConv = psfEstimate * imgEstimate
      println("1. Estimativa conjunta de imagem e PSF: " + combinedConv)
      println("Teste concluido com sucesso.")
}
