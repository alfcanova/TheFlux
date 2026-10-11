#L ============================================================================
#L Algoritmo: Floyd-Warshall (Caminhos Minimos Entre Todos os Pares / APSP)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V^3) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosFloydWarshall) {
      println("==================================================")
      println("  SciAlgo: Floyd-Warshall (All-Pairs Shortest Path)")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: inf_c = 999999

      #L Matriz de distancias inicial 4x4
      #L 1->3: -2
      #L 2->1: 4, 2->3: 3
      #L 3->4: 2
      #L 4->2: -1
      mut as list of int64: dist = [
            0,     inf_c, -2,    inf_c,
            4,     0,      3,    inf_c,
            inf_c, inf_c,  0,     2,
            inf_c, -1,     inf_c, 0
      ]

      println("1. Grafo de Entrada com 4 Vertices e Pesos:")
      println("   (1->3: -2), (2->1: 4), (2->3: 3), (3->4: 2), (4->2: -1)")

      #L Algoritmo de Floyd-Warshall: O(V^3)
      mut as int64: k = 1
      mut as int64: i = 1
      mut as int64: j = 1

      infinite (k <= num_v) {
            i = 1
            infinite (i <= num_v) {
                  j = 1
                  infinite (j <= num_v) {
                        mut as int64: dik = dist[(i - 1) * num_v + k]
                        mut as int64: dkj = dist[(k - 1) * num_v + j]
                        mut as int64: dij = dist[(i - 1) * num_v + j]

                        route {
                              (dik < inf_c) and (dkj < inf_c) ==> {
                                    route {
                                          dik + dkj < dij ==> {
                                                dist[(i - 1) * num_v + j] = dik + dkj
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        j = j + 1
                  }
                  i = i + 1
            }
            k = k + 1
      }

      #L Verificacao de ciclos negativos na diagonal
      mut as bool: has_neg_cycle = false
      i = 1
      infinite (i <= num_v) {
            route {
                  dist[(i - 1) * num_v + i] < 0 ==> {
                        has_neg_cycle = true
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      route {
            has_neg_cycle ==> {
                  println("2. Alerta: Ciclo negativo detectado!")
            }
            _ ==> {
                  println("2. Matriz de Distancias Finais (Todos os Pares):")
                  i = 1
                  infinite (i <= num_v) {
                        println("   De " + i + ": [" + dist[(i - 1) * num_v + 1] + ", " + dist[(i - 1) * num_v + 2] + ", " + dist[(i - 1) * num_v + 3] + ", " + dist[(i - 1) * num_v + 4] + "]")
                        i = i + 1
                  }
            }
      }

      println("Floyd-Warshall concluido com sucesso.")
}
