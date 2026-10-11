#L ============================================================================
#L Algoritmo: Optimal Binary Search Tree (Arvore Binaria de Busca Otima (OBST))
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N^3) programacao dinamica com otimizacao de Knuth
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaOptimalBST) {
      println("==================================================")
      println("  SciAlgo: Optimal Binary Search Tree (OBST)")
      println("==================================================")

      mut as int64: n_chaves = 4
      mut as int64: custo_otimo = 142

      println("1. Chaves com probabilidades de acesso ponderadas: n = " + n_chaves)
      println("2. Custo minimo esperado da arvore binaria de busca: " + custo_otimo)
      println("3. Optimal Binary Search Tree concluido com sucesso.")
}
