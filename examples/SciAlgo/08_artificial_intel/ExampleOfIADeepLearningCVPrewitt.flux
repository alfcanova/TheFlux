#L ============================================================================
#L Algoritmo: Prewitt Operator (Filtro de Deteccao de Bordas Linear)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVPrewitt) {
      println("=== Algoritmo: Prewitt Operator ===")
      mut as int64: px1 = 10
      mut as int64: px3 = 25
      mut as int64: prewittGx = (px3 - px1) * 3
      println("1. Derivada aproximada Prewitt Gx: " + prewittGx)
      println("Teste concluido com sucesso.")
}
