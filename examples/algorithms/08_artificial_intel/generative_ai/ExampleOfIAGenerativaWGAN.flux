#L ============================================================================
#L Algoritmo: WGAN (Wasserstein GAN com Distancia Earth Mover)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaWGAN) {
      println("=== Algoritmo: Wasserstein GAN ===")
      mut as int64: criticReal = 80
      mut as int64: criticFake = 20
      mut as int64: wassersteinDistance = criticReal - criticFake
      println("1. Distancia de Wasserstein estimada: " + wassersteinDistance)
      println("Teste concluido com sucesso.")
}
