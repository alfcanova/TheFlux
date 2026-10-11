#L ============================================================================
#L Algoritmo: SURF (Speeded-Up Robust Features com Imagens Integrais e Filtros Box)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVSURF) {
      println("=== Algoritmo: SURF Fast Hessian ===")
      mut as int64: dxx = 15
      mut as int64: dyy = 12
      mut as int64: dxy = 8
      mut as int64: detHessian = dxx * dyy - (9 * dxy * dxy) /i 10
      println("1. Determinante aproximado da matriz Hessiana: " + detHessian)
      println("Teste concluido com sucesso.")
}
