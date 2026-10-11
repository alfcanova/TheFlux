#L ============================================================================
#L Algoritmo: Warshall Algorithm (Fecho Transitivo Booleano)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V^3) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeWarshall) {
      println("==================================================")
      println("  SciAlgo: Warshall Algorithm (Transitive Closure)")
      println("==================================================")

      mut as int64: num_v = 4
      mut as list of int64: w = [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
      ]

      #L Grafo: 1->2, 2->3, 3->4, 4->2
      w[(1 - 1) * 4 + 2] = 1
      w[(2 - 1) * 4 + 3] = 1
      w[(3 - 1) * 4 + 4] = 1
      w[(4 - 1) * 4 + 2] = 1

      mut as int64: k = 1
      mut as int64: i = 1
      mut as int64: j = 1

      infinite (k <= num_v) {
            i = 1
            infinite (i <= num_v) {
                  mut as int64: ik = w[(i - 1) * 4 + k]
                  route {
                        ik == 1 ==> {
                              j = 1
                              infinite (j <= num_v) {
                                    mut as int64: kj = w[(k - 1) * 4 + j]
                                    route {
                                          kj == 1 ==> {
                                                w[(i - 1) * 4 + j] = 1
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

      println("Matriz de Fecho Transitivo:")
      i = 1
      infinite (i <= num_v) {
            mut as string: row_str = ""
            j = 1
            infinite (j <= num_v) {
                  mut as int64: val = w[(i - 1) * 4 + j]
                  row_str = row_str + val + " "
                  j = j + 1
            }
            println("Linha " + i + ": " + row_str)
            i = i + 1
      }
}
