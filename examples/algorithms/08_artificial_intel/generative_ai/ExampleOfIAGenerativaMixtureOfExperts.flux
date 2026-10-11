#L ============================================================================
#L Algoritmo: Mixture of Experts (MoE com Top-K Gating)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaMixtureOfExperts) {
      println("=== Algoritmo: Mixture of Experts ===")
      mut as int64: gateExpert1 = 80
      mut as int64: gateExpert2 = 20
      mut as int64: outExpert1 = 45
      mut as int64: outExpert2 = 10
      mut as int64: moeOut = (gateExpert1 * outExpert1 + gateExpert2 * outExpert2) /i 100
      println("1. Saida agregada do bloco MoE: " + moeOut)
      println("Teste concluido com sucesso.")
}
