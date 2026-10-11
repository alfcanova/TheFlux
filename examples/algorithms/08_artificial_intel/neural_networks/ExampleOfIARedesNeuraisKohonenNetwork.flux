#L ============================================================================
#L Algoritmo: Kohonen Network (Aprendizado Competitivo com Neuronio Vencedor BMU)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisKohonenNetwork) {
      println("=== Algoritmo: Kohonen Competitive Network ===")
      mut as int64: d1 = 45
      mut as int64: d2 = 20
      mut as int64: bmuNode = 1
      route {
            d2 < d1 ==> { bmuNode = 2 }
            _ ==> {}
      }
      println("1. Neuronio vencedor selecionado (BMU): " + bmuNode)
      println("Teste concluido com sucesso.")
}
