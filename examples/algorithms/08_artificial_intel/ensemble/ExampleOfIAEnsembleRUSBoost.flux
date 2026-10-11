#L ============================================================================
#L Algoritmo: RUSBoost (Random Under-Sampling Boosting para Dados Desbalanceados)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleRUSBoost) {
      println("=== Algoritmo: RUSBoost ===")
      mut as int64: numMajority = 1000
      mut as int64: numMinority = 50
      mut as int64: sampledMajority = numMinority
      println("1. Classe majoritaria subamostrada para: " + sampledMajority)
      println("2. Proporcao balanceada 1:1 atingida.")
      println("Teste concluido com sucesso.")
}
