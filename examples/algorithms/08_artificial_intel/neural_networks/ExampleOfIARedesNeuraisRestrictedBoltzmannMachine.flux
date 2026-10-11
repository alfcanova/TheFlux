#L ============================================================================
#L Algoritmo: Restricted Boltzmann Machine (RBM com Conexoes Bipartidas)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisRestrictedBoltzmannMachine) {
      println("=== Algoritmo: Restricted Boltzmann Machine ===")
      mut as list of int64: v = [1, 0]
      mut as int64: w1 = 4
      mut as int64: w2 = 2
      mut as int64: bH = 1
      mut as int64: actHidden = v[1] * w1 + v[2] * w2 + bH
      println("1. Ativacao da unidade oculta na RBM: " + actHidden)
      println("Teste concluido com sucesso.")
}
