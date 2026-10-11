#L ============================================================================
#L Algoritmo: Masked Autoencoder (MAE - Autoencoder com Mascaramento Assimetrico)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaMaskedAutoencoder) {
      println("=== Algoritmo: Masked Autoencoder ===")
      mut as int64: totalPatches = 16
      mut as int64: maskRatio = 75
      mut as int64: visiblePatches = (totalPatches * (100 - maskRatio)) /i 100
      mut as int64: maskedPatches = totalPatches - visiblePatches
      println("1. Patches visiveis processados pelo encoder: " + visiblePatches)
      println("2. Patches reconstruidos pelo decoder: " + maskedPatches)
      println("Teste concluido com sucesso.")
}
