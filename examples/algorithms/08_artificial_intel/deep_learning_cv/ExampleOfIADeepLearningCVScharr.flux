#L ============================================================================
#L Algoritmo: Scharr Operator (Kernel com Invariancia Rotacional Aprimorada)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVScharr) {
      println("=== Algoritmo: Scharr Operator ===")
      mut as int64: pTop = 5
      mut as int64: pMid = 12
      mut as int64: pBot = 4
      mut as int64: scharrFiltered = 3 * pTop + 10 * pMid + 3 * pBot
      println("1. Resposta do operador de Scharr: " + scharrFiltered)
      println("Teste concluido com sucesso.")
}
