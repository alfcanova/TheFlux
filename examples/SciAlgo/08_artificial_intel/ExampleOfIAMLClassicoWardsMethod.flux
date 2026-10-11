#L ============================================================================
#L Algoritmo: Ward's Method (Minimizacao do Incremento de Variancia / SSE)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoWardsMethod) {
      println("=== Algoritmo: Ward's Minimum Variance Method ===")
      mut as int64: nA = 5
      mut as int64: nB = 5
      mut as int64: distCentroidsSq = 16
      mut as int64: deltaSSE = (nA * nB * distCentroidsSq) /i (nA + nB)
      println("1. Incremento de soma dos erros quadraticos: " + deltaSSE)
      println("Teste concluido com sucesso.")
}
