#L ============================================================================
#L Algoritmo: DDPM (Denoising Diffusion Probabilistic Models)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaDDPM) {
      println("=== Algoritmo: DDPM Sampling ===")
      mut as int64: xt = 60
      mut as int64: epsPred = 10
      mut as int64: beta = 5
      mut as int64: xPrev = xt - (beta * epsPred) /i 100
      println("1. Amostra desnoizada no passo anterior: " + xPrev)
      println("Teste concluido com sucesso.")
}
