#L ============================================================================
#L Algoritmo: Richardson-Lucy Deconvolution (Desconvolucao Iterativa Bayesiana)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVRichardsonLucyDeconvolution) {
      println("=== Algoritmo: Richardson-Lucy Deconvolution ===")
      mut as int64: blurredObs = 60
      mut as int64: reblurredEst = 50
      mut as int64: currentEst = 48
      mut as int64: ratioVal = (blurredObs * 100) /i reblurredEst
      mut as int64: updatedEst = (currentEst * ratioVal) /i 100
      println("1. Estimativa desconvolvida atualizada: " + updatedEst)
      println("Teste concluido com sucesso.")
}
