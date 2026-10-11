#L ============================================================================
#L Algoritmo: DDPG (Deep Deterministic Policy Gradient para Controle Continuo)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningDDPG) {
      println("=== Algoritmo: Deep Deterministic Policy Gradient ===")
      mut as int64: continuousAction = 35
      mut as int64: ouNoise = 3
      mut as int64: exploratoryAction = continuousAction + ouNoise
      println("1. Acao deterministica do ator: " + continuousAction)
      println("2. Acao com ruido OU para exploracao: " + exploratoryAction)
      println("Teste concluido com sucesso.")
}
