#L ============================================================================
#L Algoritmo: Pairwise Summation
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosPairwiseSummation) {
      println("==================================================")
      println("  SciAlgo: Pairwise Summation")
      println("==================================================")

      mut as list of int64: arr_p = [1, 2, 3, 4, 5, 6, 7, 8]
      mut as int64: s1 = arr_p[1] + arr_p[2] + arr_p[3] + arr_p[4]
      mut as int64: s2 = arr_p[5] + arr_p[6] + arr_p[7] + arr_p[8]
      mut as int64: total_pair = s1 + s2

      println("1. Soma binaria balanceada em arvore Pairwise: " + total_pair)
      println("2. Pairwise Summation concluido com sucesso.")
}
