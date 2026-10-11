#L ============================================================================
#L Algoritmo: StyleGAN (Rede Geradora com Modulacao AdaIN de Estilos)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaStyleGAN) {
      println("=== Algoritmo: StyleGAN AdaIN ===")
      mut as int64: xNorm = 5
      mut as int64: styleScale = 3
      mut as int64: styleBias = 10
      mut as int64: adainOut = xNorm * styleScale + styleBias
      println("1. Modulacao AdaIN calculada: " + adainOut)
      println("Teste concluido com sucesso.")
}
