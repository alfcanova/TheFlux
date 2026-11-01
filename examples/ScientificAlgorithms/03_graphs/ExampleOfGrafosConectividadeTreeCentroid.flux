#L ============================================================================
#L Algoritmo: Tree Centroid (Centroide de Arvore via Tamanho de Subarvores)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTreeCentroid) {
      println("==================================================")
      println("  SciAlgo: Tree Centroid (Subtree Size Bound)     ")
      println("==================================================")

      mut as int64: num_v = 5
      #L Arvore: 1-2-3-4-5
      #L Subarvores enraizadas no vertice 1:
      #L sz: node 1 = 5, node 2 = 4, node 3 = 3, node 4 = 2, node 5 = 1
      mut as list of int64: sz = [5, 4, 3, 2, 1]
      mut as list of int64: max_child_sz = [4, 3, 2, 1, 0]

      mut as int64: half_n = num_v /i 2
      println("1. Tamanho maximo permitido para qualquer componente (N/2): " + half_n)

      println("2. Verificacao de Centroides:")
      mut as int64: node = 1
      infinite (node <= num_v) {
            mut as int64: up_size = num_v - sz[node]
            mut as int64: max_comp = max_child_sz[node]
            route {
                  up_size > max_comp ==> {
                        max_comp = up_size
                  }
                  _ ==> {}
            }

            route {
                  max_comp <= half_n ==> {
                        println("   Vertice " + node + " e um centroide da arvore (maior componente = " + max_comp + ")")
                  }
                  _ ==> {}
            }
            node = node + 1
      }
}
