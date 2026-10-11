#L ============================================================================
#L Algoritmo: Policy Gradient (Teorema do Gradiente de Politica Parametrica)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningPolicyGradient) {
      println("=== Algoritmo: Policy Gradient ===")
      mut as int64: gradLogPi = 4
      mut as int64: trajectoryReturnG = 50
      mut as int64: policyGrad = gradLogPi * trajectoryReturnG
      println("1. Gradiente log-probabilidade: " + gradLogPi)
      println("2. Gradiente da politica estimada: " + policyGrad)
      println("Teste concluido com sucesso.")
}
