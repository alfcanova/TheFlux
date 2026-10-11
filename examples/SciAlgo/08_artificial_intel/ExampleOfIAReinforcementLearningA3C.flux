#L ============================================================================
#L Algoritmo: A3C (Asynchronous Advantage Actor-Critic com Workers Paralelos)
#L Dominio: 08_artificial_intel / Subdominio: ReinforcementLearning
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningA3C) {
      println("=== Algoritmo: A3C Asynchronous Workers ===")
      mut as int64: globalParam = 100
      mut as int64: workerGrad = 5
      mut as int64: updatedGlobal = globalParam + workerGrad
      println("1. Parametro global mestre atualizado assincronamente: " + updatedGlobal)
      println("Teste concluido com sucesso.")
}
