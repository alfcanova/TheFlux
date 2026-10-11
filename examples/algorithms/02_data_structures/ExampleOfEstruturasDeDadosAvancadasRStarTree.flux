#L ============================================================================
#L Algoritmo: R* Tree (R-Star Tree Otimizada com Minimizacao de Sobreposicao 1990)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) busca espacial por janela MBR | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRStarTree) {
      println("==================================================")
      println("  SciAlgo: R* Tree (R-Star Spatial Index)")
      println("==================================================")

      #L Vetores paralelos de MBR e nos hierarquicos (1-based, 0 = NULL)
      mut as list of int64: min_x = [0]
      mut as list of int64: min_y = [0]
      mut as list of int64: max_x = [0]
      mut as list of int64: max_y = [0]
      mut as list of bool: is_leaf = [false]
      mut as list of int64: child1 = [0]
      mut as list of int64: child2 = [0]
      mut as list of int64: obj_id = [0]

      println("1. Construindo R* Tree com separacao otimizada de clusters:")

      #L Cluster 1: [5, 5] a [8, 8]
      min_x = listPushBack(min_x, 5)
      min_y = listPushBack(min_y, 5)
      max_x = listPushBack(max_x, 8)
      max_y = listPushBack(max_y, 8)
      is_leaf = listPushBack(is_leaf, true)
      child1 = listPushBack(child1, 0)
      child2 = listPushBack(child2, 0)
      obj_id = listPushBack(obj_id, 501)
      mut as int64: c1 = listLength(min_x)

      #L Cluster 2: [20, 20] a [25, 25] (zero sobreposicao com Cluster 1)
      min_x = listPushBack(min_x, 20)
      min_y = listPushBack(min_y, 20)
      max_x = listPushBack(max_x, 25)
      max_y = listPushBack(max_y, 25)
      is_leaf = listPushBack(is_leaf, true)
      child1 = listPushBack(child1, 0)
      child2 = listPushBack(child2, 0)
      obj_id = listPushBack(obj_id, 502)
      mut as int64: c2 = listLength(min_x)

      #L No interno raiz unindo c1 e c2
      min_x = listPushBack(min_x, 5)
      min_y = listPushBack(min_y, 5)
      max_x = listPushBack(max_x, 25)
      max_y = listPushBack(max_y, 25)
      is_leaf = listPushBack(is_leaf, false)
      child1 = listPushBack(child1, c1)
      child2 = listPushBack(child2, c2)
      obj_id = listPushBack(obj_id, 0)
      mut as int64: root = listLength(min_x)

      println("2. Raiz MBR: [" + min_x[root] + "," + min_y[root] + "] ate [" + max_x[root] + "," + max_y[root] + "]")

      #L Consulta espacial por janela em regiao [18, 18] a [30, 30]
      mut as int64: q_min_x = 18
      mut as int64: q_min_y = 18
      mut as int64: q_max_x = 30
      mut as int64: q_max_y = 30

      println("3. Consulta espacial na janela [" + q_min_x + "," + q_min_y + "] ate [" + q_max_x + "," + q_max_y + "]:")

      mut as list of int64: hits = []
      mut as list of int64: queue = [root]
      mut as int64: q_head = 1

      infinite (q_head <= listLength(queue)) {
            mut as int64: curr = queue[q_head]
            q_head = q_head + 1

            mut as bool: no_overlap_x = (max_x[curr] < q_min_x or min_x[curr] > q_max_x)
            mut as bool: no_overlap_y = (max_y[curr] < q_min_y or min_y[curr] > q_max_y)

            route {
                  not no_overlap_x and not no_overlap_y ==> {
                        route {
                              is_leaf[curr] ==> {
                                    hits = listPushBack(hits, obj_id[curr])
                                    println("   Hit em objeto: " + obj_id[curr])
                              }
                              _ ==> {
                                    queue = listPushBack(queue, child1[curr])
                                    queue = listPushBack(queue, child2[curr])
                              }
                        }
                  }
            }
      }

      println("4. Resultados interceptados: " + hits)
      mut as bool: valid_rstar = (listLength(hits) == 1)
      route {
            valid_rstar ==> {
                  valid_rstar = (hits[1] == 502)
            }
      }
      println("5. Validacao: " + valid_rstar)
      println("==================================================")
}
