#L ============================================================================
#L Algoritmo: DeepFM (Deep Factorization Machine com Componentes Linear, FM e Deep)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoDeepFM) {
      println("=== Algoritmo: DeepFM Architecture ===")
      mut as int64: fmOrder1 = 15
      mut as int64: fmOrder2 = 25
      mut as int64: deepOut = 40
      mut as int64: deepFmLogit = fmOrder1 + fmOrder2 + deepOut
      println("1. Logit integrado DeepFM: " + deepFmLogit)
      println("Teste concluido com sucesso.")
}
