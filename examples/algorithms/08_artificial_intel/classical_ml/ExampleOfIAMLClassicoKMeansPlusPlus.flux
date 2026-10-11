#L ============================================================================
#L Algoritmo: K-Means++ (Inicializacao de Centroides Proporcional a D^2)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoKMeansPlusPlus) {
      println("=== Algoritmo: K-Means++ Inicializacao ===")
      mut as list of int64: dSq = [10, 50, 40]
      mut as int64: sumSq = dSq[1] + dSq[2] + dSq[3]
      mut as int64: prob2 = (dSq[2] * 100) /i sumSq
      println("1. Soma total das distancias quadraticas: " + sumSq)
      println("2. Probabilidade de selecao do ponto 2 como centroide: " + prob2)
      println("Teste concluido com sucesso.")
}
