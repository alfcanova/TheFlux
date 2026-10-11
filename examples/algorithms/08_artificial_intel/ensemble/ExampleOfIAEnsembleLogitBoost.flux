#L ============================================================================
#L Algoritmo: LogitBoost (Boosting por Perda Logistica com Newton-Raphson)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleLogitBoost) {
      println("=== Algoritmo: LogitBoost ===")
      mut as int64: y = 1
      mut as int64: prob = 70
      mut as int64: workingResponse = ((y * 100 - prob) * 100) /i (prob * (100 - prob) /i 100 + 1)
      println("1. Probabilidade predita: " + prob)
      println("2. Resposta de trabalho Newton-Raphson z: " + workingResponse)
      println("Teste concluido com sucesso.")
}
