#L ============================================================================
#L Algoritmo: Optical Flow (Equacao de Fluxo Optico Ix*u + Iy*v + It = 0)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVOpticalFlow) {
      println("=== Algoritmo: Optical Flow Constraint ===")
      mut as int64: gradX = 5
      mut as int64: gradY = 5
      mut as int64: diffT = 0 - 10
      mut as int64: velocityU = (0 - diffT) /i (gradX + gradY)
      println("1. Componente de velocidade estimada: " + velocityU)
      println("Teste concluido com sucesso.")
}
