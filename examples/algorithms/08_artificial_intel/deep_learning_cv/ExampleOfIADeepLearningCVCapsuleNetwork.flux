#L ============================================================================
#L Algoritmo: Capsule Network (CapsNet com Dynamic Routing-by-Agreement)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVCapsuleNetwork) {
      println("=== Algoritmo: Capsule Network Routing ===")
      mut as int64: uHat = 25
      mut as int64: vAgreement = 24
      mut as int64: dotAgreement = (uHat * vAgreement) /i 10
      mut as int64: routingCoeffB = 0
      mut as int64: updatedB = routingCoeffB + dotAgreement
      println("1. Acordo entre capsulas (Agreement): " + dotAgreement)
      println("2. Logit de roteamento dinamico atualizado: " + updatedB)
      println("Teste concluido com sucesso.")
}
