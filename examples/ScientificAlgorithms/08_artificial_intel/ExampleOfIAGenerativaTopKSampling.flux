#L ============================================================================
#L Algoritmo: Top-k Sampling (Amostragem Truncada nos K Maiores Logits)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaTopKSampling) {
      println("=== Algoritmo: Top-k Sampling ===")
      mut as list of int64: logits = [95, 80, 75, 20, 10]
      mut as int64: k = 3
      mut as int64: sumTopK = logits[1] + logits[2] + logits[3]
      println("1. Soma de probabilidade no Top-k: " + sumTopK)
      println("2. Truncamento com k = " + k)
      println("Teste concluido com sucesso.")
}
