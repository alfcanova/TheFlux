#L ============================================================================
#L Algoritmo: Autoregressive Models (Modelagem Sequencial Causal)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaAutoregressiveModels) {
      println("=== Algoritmo: Autoregressive Model ===")
      mut as list of int64: history = [10, 20, 30]
      mut as int64: nextToken = (history[1] + history[2] + history[3]) /i 3
      println("1. Proximo token condicionado no historico: " + nextToken)
      println("Teste concluido com sucesso.")
}
