#L ============================================================================
#L Algoritmo: Boltzmann Machine (Rede Estocastica de Energia)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisBoltzmannMachine) {
      println("=== Algoritmo: Boltzmann Machine ===")
      mut as int64: deltaE = 0 - 10
      mut as int64: temp = 5
      mut as int64: probTurnOn = 50 - (deltaE * 10) /i temp
      route {
            probTurnOn > 100 ==> { probTurnOn = 100 }
            _ ==> {}
      }
      println("1. Probabilidade de ativacao termica: " + probTurnOn)
      println("Teste concluido com sucesso.")
}
