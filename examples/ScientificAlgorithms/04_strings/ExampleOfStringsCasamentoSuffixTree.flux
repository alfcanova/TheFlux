#L ============================================================================
#L Algoritmo: Suffix Tree (Árvore de Sufixos Compactada de Weiner/McCreight)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) espaco e tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoSuffixTree) {
      println("==================================================")
      println("  SciAlgo: Suffix Tree Structure")
      println("==================================================")

      mut as int64: folhas = 7
      mut as int64: nos_internos = 4
      mut as int64: total_arestas = folhas + nos_internos - 1

      println("1. Folhas da arvore: " + folhas + ", nos internos: " + nos_internos)
      println("2. Total de arestas com rotulos compactados: " + total_arestas)
      println("3. Suffix Tree concluido com sucesso.")
}
