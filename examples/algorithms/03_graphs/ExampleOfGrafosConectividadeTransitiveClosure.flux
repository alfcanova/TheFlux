#L ============================================================================
#L Algoritmo: Transitive Closure (Fecho Transitivo via Multiplicacao Booleana / Floyd-Warshall)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V^3) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTransitiveClosure) {
      println("==================================================")
      println("  SciAlgo: Transitive Closure Matrix              ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as list of int64: reach = [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
      ]

      #L Grafo direcionado: 1->2, 2->3, 3->1, 4->3
      reach[(1 - 1) * 4 + 2] = 1
      reach[(2 - 1) * 4 + 3] = 1
      reach[(3 - 1) * 4 + 1] = 1
      reach[(4 - 1) * 4 + 3] = 1

      mut as int64: k = 1
      infinite (k <= num_v) {
            mut as int64: i = 1
            infinite (i <= num_v) {
                  mut as int64: ik = reach[(i - 1) * 4 + k]
                  route {
                        ik == 1 ==> {
                              mut as int64: j = 1
                              infinite (j <= num_v) {
                                    mut as int64: kj = reach[(k - 1) * 4 + j]
                                    route {
                                          kj == 1 ==> {
                                                reach[(i - 1) * 4 + j] = 1
                                          }
                                          _ ==> {}
                                    }
                                    j = j + 1
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }
            k = k + 1
      }

      println("Matriz de Alcancabilidade:")
      mut as int64: r = 1
      infinite (r <= num_v) {
            mut as string: row_str = ""
            mut as int64: c = 1
            infinite (c <= num_v) {
                  mut as int64: val = reach[(r - 1) * 4 + c]
                  row_str = row_str + val + " "
                  c = c + 1
            }
            println("Vertice " + r + ": " + row_str)
            r = r + 1
      }
}
