#L ============================================================================
#L Algoritmo: TD(Lambda) (Elegibility Traces e Aprendizado por Diferenca Temporal)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningTDLambda) {
      println("=== Algoritmo: TD(Lambda) Eligibility Traces ===")
      mut as int64: traceE = 100
      mut as int64: gammaVal = 90
      mut as int64: lambdaVal = 80
      mut as int64: decayedTrace = (traceE * gammaVal * lambdaVal) /i 10000
      println("1. Traco de elegibilidade decaido: " + decayedTrace)
      println("Teste concluido com sucesso.")
}
