#L ============================================================================
#L Algoritmo: Contrastive Learning (Perda InfoNCE)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaContrastiveLearning) {
      println("=== Algoritmo: Contrastive Learning InfoNCE ===")
      mut as int64: simPos = 90
      mut as int64: simNeg = 20
      mut as int64: temp = 10
      mut as int64: infoNceScore = (simPos - simNeg) /i temp
      println("1. Score contrastivo positivo vs negativo: " + infoNceScore)
      println("Teste concluido com sucesso.")
}
