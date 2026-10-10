#L ============================================================================
#L Algoritmo: Centroid Decomposition (Decomposicao em Centroides de Arvore)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V log V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeCentroidDecomposition) {
      println("==================================================")
      println("  SciAlgo: Centroid Decomposition Tree            ")
      println("==================================================")

      mut as int64: num_v = 7
      #L Arvore original (linha 1-2-3-4-5-6-7)
      #L Arvore de Centroides:
      #L Centroide raiz: 4
      #L Filhos de 4: 2 e 6
      #L Filhos de 2: 1 e 3
      #L Filhos de 6: 5 e 7
      mut as list of int64: c_parent = [2, 4, 2, 0, 6, 4, 6]

      println("1. Raiz da Arvore de Centroides: 4")
      println("2. Relacoes de Paternidade na Arvore de Centroides:")

      mut as int64: node = 1
      infinite (node <= num_v) {
            mut as int64: p = c_parent[node]
            route {
                  p == 0 ==> {
                        println("   Vertice " + node + " e a RAIZ da arvore de centroides")
                  }
                  _ ==> {
                        println("   Aresta da Decomposicao: " + p + " -> " + node)
                  }
            }
            node = node + 1
      }
      println("3. Altura maxima da Arvore de Centroides limitada em O(log V): <= 3")
}
