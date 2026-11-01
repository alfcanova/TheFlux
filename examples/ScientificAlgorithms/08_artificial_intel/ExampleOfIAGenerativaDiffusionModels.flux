#L ============================================================================
#L Algoritmo: Diffusion Models (Processo Difusivo Direto e Reverso)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaDiffusionModels) {
      println("=== Algoritmo: Diffusion Models ===")
      mut as int64: betaT = 2
      mut as int64: alphaT = 100 - betaT
      mut as int64: x0 = 50
      mut as int64: noise = 5
      mut as int64: xt = (alphaT * x0) /i 100 + noise
      println("1. Estado no passo de difusao t: " + xt)
      println("Teste concluido com sucesso.")
}
