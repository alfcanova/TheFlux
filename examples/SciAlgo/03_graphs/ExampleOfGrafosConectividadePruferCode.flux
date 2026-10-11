#L ============================================================================
#L Algoritmo: Prufer Code (Codificacao e Decodificacao de Sequencias de Prufer)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V^2) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadePruferCode) {
      println("==================================================")
      println("  SciAlgo: Prufer Code (Tree Bijection)           ")
      println("==================================================")

      mut as int64: num_v = 5
      #L Arvore com 5 vertices: 1-2, 1-3, 2-4, 2-5
      mut as list of int64: deg = [2, 3, 1, 1, 1]
      mut as list of int64: adj = [
            0, 1, 1, 0, 0,
            1, 0, 0, 1, 1,
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 1, 0, 0, 0
      ]

      mut as list of int64: code = [0, 0, 0]
      mut as int64: code_len = 0

      mut as int64: step = 1
      infinite (step <= num_v - 2) {
            mut as int64: leaf = 0
            mut as int64: k = 1
            infinite (k <= num_v and leaf == 0) {
                  route {
                        deg[k] == 1 ==> {
                              leaf = k
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            mut as int64: nbr = 0
            k = 1
            infinite (k <= num_v and nbr == 0) {
                  mut as int64: has_e = adj[(leaf - 1) * num_v + k]
                  route {
                        has_e == 1 ==> {
                              nbr = k
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            code_len = code_len + 1
            code[code_len] = nbr

            deg[leaf] = 0
            deg[nbr] = deg[nbr] - 1
            adj[(leaf - 1) * num_v + nbr] = 0
            adj[(nbr - 1) * num_v + leaf] = 0

            step = step + 1
      }

      println("1. Sequencia de Prufer Codificada:")
      mut as string: p_str = ""
      mut as int64: idx = 1
      infinite (idx <= code_len) {
            p_str = p_str + code[idx] + " "
            idx = idx + 1
      }
      println("   Prufer: " + p_str)

      println("2. Decodificacao da Sequencia:")
      mut as list of int64: dec_deg = [1, 1, 1, 1, 1]
      idx = 1
      infinite (idx <= code_len) {
            mut as int64: val = code[idx]
            dec_deg[val] = dec_deg[val] + 1
            idx = idx + 1
      }

      step = 1
      infinite (step <= code_len) {
            mut as int64: nbr = code[step]
            mut as int64: leaf = 0
            mut as int64: k = 1
            infinite (k <= num_v and leaf == 0) {
                  route {
                        dec_deg[k] == 1 ==> {
                              leaf = k
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            println("   Aresta recuperada: (" + leaf + " - " + nbr + ")")
            dec_deg[leaf] = dec_deg[leaf] - 1
            dec_deg[nbr] = dec_deg[nbr] - 1
            step = step + 1
      }

      mut as int64: u1 = 0
      mut as int64: u2 = 0
      mut as int64: k = 1
      infinite (k <= num_v) {
            route {
                  dec_deg[k] == 1 ==> {
                        route {
                              u1 == 0 ==> {
                                    u1 = k
                              }
                              _ ==> {
                                    u2 = k
                              }
                        }
                  }
                  _ ==> {}
            }
            k = k + 1
      }
      println("   Ultima aresta recuperada: (" + u1 + " - " + u2 + ")")
}
