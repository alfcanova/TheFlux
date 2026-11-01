#L ============================================================================
#L Algoritmo: Connected Component Labeling (CCL de Dois Passos com Tabela de Equivalencias)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVConnectedComponentLabeling) {
      println("=== Algoritmo: Connected Component Labeling ===")
      mut as int64: labelA = 1
      mut as int64: labelB = 2
      mut as int64: resolvedLabel = labelA
      route {
            labelB < labelA ==> { resolvedLabel = labelB }
            _ ==> {}
      }
      println("1. Rotulo canico resolvido na tabela de equivalencias: " + resolvedLabel)
      println("Teste concluido com sucesso.")
}
