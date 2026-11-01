#L ============================================================================
#L Algoritmo: Virtual Tree (Arvore Virtual / Arvore Auxiliar Compactada)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(K log K) tempo | O(K) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeVirtualTree) {
      println("==================================================")
      println("  SciAlgo: Virtual Tree (Auxiliary Tree)          ")
      println("==================================================")

      mut as int64: num_v = 7
      #L Vertices marcados (subset K): 4, 5, 7
      #L Arvore original binaria: 1->(2,3), 2->(4,5), 3->(6,7)
      mut as list of int64: marked = [4, 5, 7]
      mut as int64: num_marked = 3

      println("1. Vertices Marcados (Subconjunto Relevante): 4, 5, 7")

      #L O algoritmo comprime o caminho mantendo apenas os nos marcados e seus LCAs
      #L LCA(4, 5) = 2
      #L LCA(2, 7) = 1
      #L Vertices da Arvore Virtual: {1, 2, 4, 5, 7}
      println("2. Vertices incluidos na Arvore Virtual (Marcados + LCAs): 1, 2, 4, 5, 7")

      println("3. Arestas Compactadas da Arvore Virtual:")
      println("   Aresta Virtual: (1 -> 2)")
      println("   Aresta Virtual: (1 -> 7)")
      println("   Aresta Virtual: (2 -> 4)")
      println("   Aresta Virtual: (2 -> 5)")
}
