#L ============================================================================
#L Algoritmo: Matrix Factorization (Fatoracao de Matrizes com Fatores Latentes)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoMatrixFactorization) {
      println("=== Algoritmo: Matrix Factorization ===")
      mut as list of int64: userFactor = [2, 3]
      mut as list of int64: itemFactor = [4, 1]
      mut as int64: predR = userFactor[1] * itemFactor[1] + userFactor[2] * itemFactor[2]
      println("1. Predicao de interacao r_ui: " + predR)
      println("Teste concluido com sucesso.")
}
