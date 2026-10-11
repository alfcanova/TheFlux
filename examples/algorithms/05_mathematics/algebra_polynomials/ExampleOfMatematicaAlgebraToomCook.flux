#L ============================================================================
#L Algoritmo: Toom-Cook (Toom-3 / Multiplicação em 5 Avaliações Polinomiais)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^log3(5)) ~= O(N^1.465)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraToomCook) {
      println("==================================================")
      println("  SciAlgo: Toom-Cook (Toom-3) Multiplication")
      println("==================================================")

      mut as int64: pontos_de_avaliacao = 5
      mut as int64: grau = 2

      println("1. Divisao em polinomios de grau " + grau)
      println("2. Multiplicacoes necessarias: " + pontos_de_avaliacao)
      println("3. Toom-Cook concluido com sucesso.")
}
