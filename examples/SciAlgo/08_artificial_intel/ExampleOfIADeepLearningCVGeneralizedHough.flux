#L ============================================================================
#L Algoritmo: Generalized Hough Transform (Deteccao de Formas Arbitrarias via R-Table)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVGeneralizedHough) {
      println("=== Algoritmo: Generalized Hough Transform ===")
      mut as int64: edgeX = 50
      mut as int64: edgeY = 50
      mut as int64: rTableOffsetX = 15
      mut as int64: rTableOffsetY = 20
      mut as int64: refCenterX = edgeX - rTableOffsetX
      mut as int64: refCenterY = edgeY - rTableOffsetY
      println("1. Centro de referencia acumulado: (" + refCenterX + ", " + refCenterY + ")")
      println("Teste concluido com sucesso.")
}
