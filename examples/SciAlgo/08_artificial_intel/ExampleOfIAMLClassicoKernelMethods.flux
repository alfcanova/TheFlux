#L ============================================================================
#L Algoritmo: Kernel Methods (Kernel RBF Gaussiano)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoKernelMethods) {
      println("=== Algoritmo: Kernel RBF Gaussiano ===")
      mut as int64: distSq = 12
      mut as int64: gammaParam = 2
      mut as int64: approxRbf = 100 - distSq * gammaParam
      route {
            approxRbf < 0 ==> { approxRbf = 0 }
            _ ==> {}
      }
      println("1. Similaridade no espaco de Hilbert: " + approxRbf)
      println("Teste concluido com sucesso.")
}
