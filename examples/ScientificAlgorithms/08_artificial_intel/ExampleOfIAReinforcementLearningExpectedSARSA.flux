#L ============================================================================
#L Algoritmo: Expected SARSA (Esperanca sob a Politica no Proximo Estado)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningExpectedSARSA) {
      println("=== Algoritmo: Expected SARSA ===")
      mut as int64: probA1 = 70
      mut as int64: qNextA1 = 50
      mut as int64: probA2 = 30
      mut as int64: qNextA2 = 20
      mut as int64: expectedQ = (probA1 * qNextA1 + probA2 * qNextA2) /i 100
      mut as int64: reward = 10
      mut as int64: gammaVal = 90
      mut as int64: targetExp = reward + (gammaVal * expectedQ) /i 100
      println("1. Valor esperado E[Q(s', a')]: " + expectedQ)
      println("2. Target Expected SARSA: " + targetExp)
      println("Teste concluido com sucesso.")
}
