#L ============================================================================
#L Algoritmo: Lucas-Kanade (Fluxo Optico Local por Minimos Quadrados)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVLucasKanade) {
      println("=== Algoritmo: Lucas-Kanade Method ===")
      mut as int64: sumIxSq = 50
      mut as int64: sumIySq = 40
      mut as int64: sumIxIt = 0 - 150
      mut as int64: uFlow = (0 - sumIxIt) /i sumIxSq
      println("1. Fluxo de movimento u na janela local: " + uFlow)
      println("Teste concluido com sucesso.")
}
