#L ============================================================================
#L Algoritmo: Lasso (Least Absolute Shrinkage and Selection Operator L1)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoLasso) {
      println("=== Algoritmo: Lasso L1 Soft-Thresholding ===")
      mut as int64: rho = 35
      mut as int64: lambdaVal = 10
      mut as int64: softThresh = 0
      route {
            rho > lambdaVal ==> { softThresh = rho - lambdaVal }
            rho < (0 - lambdaVal) ==> { softThresh = rho + lambdaVal }
            _ ==> {}
      }
      println("1. Coeficiente esparso pos-limiarizacao: " + softThresh)
      println("Teste concluido com sucesso.")
}
