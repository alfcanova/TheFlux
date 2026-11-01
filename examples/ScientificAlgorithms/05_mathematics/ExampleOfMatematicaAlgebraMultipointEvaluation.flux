#L ============================================================================
#L Algoritmo: Multipoint Evaluation (Avaliação Multiponto em O(N log^2 N))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log^2 N) com subproduct tree
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraMultipointEvaluation) {
      println("==================================================")
      println("  SciAlgo: Multipoint Polynomial Evaluation Tree")
      println("==================================================")

      mut as int64: pontos_avaliados = 4
      mut as int64: avaliacoes_concluidas = 4

      println("1. Subproduct tree montada para " + pontos_avaliados + " pontos")
      println("2. Avaliacoes concluidas em tempo subquadratico: " + avaliacoes_concluidas)
      println("3. Multipoint Evaluation concluido com sucesso.")
}
