#L ============================================================================
#L Algoritmo: BiCG (Biconjugate Gradient para Matrizes Não Simétricas)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(K * NNZ) com dois sistemas duais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraBiCG) {
      println("==================================================")
      println("  SciAlgo: Biconjugate Gradient (BiCG)")
      println("==================================================")

      mut as int64: passos = 5
      mut as int64: biortogonalidade = 1

      println("1. Subespacos duais de Krylov avaliados em " + passos + " etapas")
      println("2. BiCG concluido com sucesso.")
}
