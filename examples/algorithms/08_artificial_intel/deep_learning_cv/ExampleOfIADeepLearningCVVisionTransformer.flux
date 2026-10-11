#L ============================================================================
#L Algoritmo: Vision Transformer (ViT - Imagens como Sequencias de Patches 16x16)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVVisionTransformer) {
      println("=== Algoritmo: Vision Transformer ViT ===")
      mut as int64: imgH = 224
      mut as int64: patchSize = 16
      mut as int64: patchesCount = (imgH /i patchSize) * (imgH /i patchSize)
      mut as int64: seqLenWithCLS = patchesCount + 1
      println("1. Patches lineares gerados: " + patchesCount)
      println("2. Comprimento da sequencia com token [CLS]: " + seqLenWithCLS)
      println("Teste concluido com sucesso.")
}
