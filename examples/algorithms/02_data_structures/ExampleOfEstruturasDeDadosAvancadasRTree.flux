#L ============================================================================
#L Algoritmo: R-Tree (Arvore de Indexacao Espacial Hierarquica de Antonin Guttman 1984)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) busca espacial por janela MBR | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRTree) {
      println("==================================================")
      println("  SciAlgo: R-Tree (Spatial Indexing MBR)")
      println("==================================================")

      #L Representacao dos nos e retangulos MBR (min_x, min_y, max_x, max_y)
      #L Inicializados com no 0 (sentinela dummy para 1-based index)
      mut as list of int64: min_x = [0]
      mut as list of int64: min_y = [0]
      mut as list of int64: max_x = [0]
      mut as list of int64: max_y = [0]
      mut as list of bool: is_leaf = [false]
      mut as list of int64: child1 = [0]
      mut as list of int64: child2 = [0]
      mut as list of int64: obj_id = [0]

      println("1. Construindo R-Tree com 2 clusters espaciais 2D...")

      #L Folha 1 (Cluster 1: objetos proximos na regiao [1, 1] a [4, 4])
      min_x = listPushBack(min_x, 1)
      min_y = listPushBack(min_y, 1)
      max_x = listPushBack(max_x, 4)
      max_y = listPushBack(max_y, 4)
      is_leaf = listPushBack(is_leaf, true)
      child1 = listPushBack(child1, 0)
      child2 = listPushBack(child2, 0)
      obj_id = listPushBack(obj_id, 101)
      mut as int64: leaf_a = listLength(min_x)

      #L Folha 2 (Cluster 2: objetos proximos na regiao [10, 10] a [13, 13])
      min_x = listPushBack(min_x, 10)
      min_y = listPushBack(min_y, 10)
      max_x = listPushBack(max_x, 13)
      max_y = listPushBack(max_y, 13)
      is_leaf = listPushBack(is_leaf, true)
      child1 = listPushBack(child1, 0)
      child2 = listPushBack(child2, 0)
      obj_id = listPushBack(obj_id, 202)
      mut as int64: leaf_b = listLength(min_x)

      #L Raiz (MBR global engloba Folha 1 e Folha 2: [1, 1] a [13, 13])
      min_x = listPushBack(min_x, 1)
      min_y = listPushBack(min_y, 1)
      max_x = listPushBack(max_x, 13)
      max_y = listPushBack(max_y, 13)
      is_leaf = listPushBack(is_leaf, false)
      child1 = listPushBack(child1, leaf_a)
      child2 = listPushBack(child2, leaf_b)
      obj_id = listPushBack(obj_id, 0)
      mut as int64: root = listLength(min_x)

      println("2. Raiz MBR: [" + min_x[root] + "," + min_y[root] + "] ate [" + max_x[root] + "," + max_y[root] + "]")
      println("   Filho esquerdo (Cluster 1): MBR [" + min_x[leaf_a] + "," + min_y[leaf_a] + "] ate [" + max_x[leaf_a] + "," + max_y[leaf_a] + "]")
      println("   Filho direito  (Cluster 2): MBR [" + min_x[leaf_b] + "," + min_y[leaf_b] + "] ate [" + max_x[leaf_b] + "," + max_y[leaf_b] + "]")

      #L Consulta espacial por janela (Window Query) na regiao [2, 2] a [5, 5]
      #L Deve interceptar apenas o Cluster 1 (id 101) e descartar o Cluster 2 (id 202)
      println("3. Executando busca espacial por janela [2, 2] a [5, 5]:")
      mut as int64: q_min_x = 2
      mut as int64: q_min_y = 2
      mut as int64: q_max_x = 5
      mut as int64: q_max_y = 5

      mut as list of int64: hits = []
      mut as list of int64: queue = [root]
      mut as int64: q_head = 1

      infinite (q_head <= listLength(queue)) {
            mut as int64: curr = queue[q_head]
            q_head = q_head + 1

            #L Intersecao de retangulos MBR: not (max1 < min2 or min1 > max2)
            mut as bool: no_overlap_x = (max_x[curr] < q_min_x or min_x[curr] > q_max_x)
            mut as bool: no_overlap_y = (max_y[curr] < q_min_y or min_y[curr] > q_max_y)

            route {
                  not no_overlap_x and not no_overlap_y ==> {
                        route {
                              is_leaf[curr] ==> {
                                    hits = listPushBack(hits, obj_id[curr])
                                    println("   Hit espacial na folha: objeto " + obj_id[curr])
                              }
                              _ ==> {
                                    queue = listPushBack(queue, child1[curr])
                                    queue = listPushBack(queue, child2[curr])
                              }
                        }
                  }
            }
      }

      println("4. Clusters interceptados: " + hits)
      mut as bool: valid_query = (listLength(hits) == 1)
      route {
            valid_query ==> {
                  valid_query = (hits[1] == 101)
            }
      }
      println("5. Validacao: " + valid_query)
      println("==================================================")
}
