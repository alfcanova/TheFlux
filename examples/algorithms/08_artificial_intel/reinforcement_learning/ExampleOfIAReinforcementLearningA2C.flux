#L ============================================================================
#L Algoritmo: A2C (Advantage Actor-Critic Sincrono)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningA2C) {
      println("=== Algoritmo: Advantage Actor-Critic A2C ===")
      mut as list of int64: envAdvantages = [10, 14, 8, 12]
      mut as int64: syncMeanAdv = (envAdvantages[1] + envAdvantages[2] + envAdvantages[3] + envAdvantages[4]) /i 4
      println("1. Vantagem media sincronizada dos ambientes paralelos: " + syncMeanAdv)
      println("Teste concluido com sucesso.")
}
