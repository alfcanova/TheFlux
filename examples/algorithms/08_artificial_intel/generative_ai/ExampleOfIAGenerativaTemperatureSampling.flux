#L ============================================================================
#L Algoritmo: Temperature Sampling (Calibracao Termica da Distribuicao Softmax)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaTemperatureSampling) {
      println("=== Algoritmo: Temperature Sampling ===")
      mut as int64: logit = 80
      mut as int64: temp = 2
      mut as int64: scaledLogit = logit /i temp
      println("1. Logit original: " + logit)
      println("2. Logit escalonado com T = " + temp + ": " + scaledLogit)
      println("Teste concluido com sucesso.")
}
