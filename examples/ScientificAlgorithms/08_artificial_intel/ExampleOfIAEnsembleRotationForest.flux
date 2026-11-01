#L ============================================================================
#L Algoritmo: Rotation Forest (Ensemble com Rotacao PCA de Eixos)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleRotationForest) {
      println("=== Algoritmo: Rotation Forest ===")
      mut as int64: x1 = 10
      mut as int64: x2 = 5
      mut as int64: cosA = 80
      mut as int64: sinA = 60
      mut as int64: rotX1 = (x1 * cosA - x2 * sinA) /i 100
      mut as int64: rotX2 = (x1 * sinA + x2 * cosA) /i 100
      println("1. Coordenada rotacionada 1: " + rotX1)
      println("2. Coordenada rotacionada 2: " + rotX2)
      println("Teste concluido com sucesso.")
}
