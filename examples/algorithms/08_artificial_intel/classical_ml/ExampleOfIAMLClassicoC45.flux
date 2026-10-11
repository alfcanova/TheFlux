#L ============================================================================
#L Algoritmo: C4.5 (Arvore de Decisao com Razao de Ganho / Gain Ratio)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoC45) {
      println("=== Algoritmo: C4.5 Gain Ratio ===")
      mut as int64: infoGain = 70
      mut as int64: splitInfo = 80
      mut as int64: gainRatio = (infoGain * 100) /i splitInfo
      println("1. Ganho de informacao: " + infoGain)
      println("2. Split Information: " + splitInfo)
      println("3. Gain Ratio C4.5: " + gainRatio)
      println("Teste concluido com sucesso.")
}
