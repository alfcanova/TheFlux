#L ============================================================================
#L Algoritmo: Hierholzer (Circuito Euleriano em Grafos Direcionados)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeHierholzer) {
      println("==================================================")
      println("  SciAlgo: Hierholzer Algorithm (Directed Graph)  ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as list of int64: in_deg = [1, 2, 1, 1]
      mut as list of int64: out_deg = [1, 2, 1, 1]

      #L Grafo: 1->2, 2->3, 3->1, 2->4, 4->2
      mut as list of int64: adj = [
            0, 1, 0, 0,
            0, 0, 1, 1,
            1, 0, 0, 0,
            0, 1, 0, 0
      ]

      println("1. Graus de Entrada e Saida equilibrados:")
      mut as int64: i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + ": in=" + in_deg[i] + ", out=" + out_deg[i])
            i = i + 1
      }

      mut as list of int64: stk = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: stk_top = 1
      stk[1] = 1

      mut as list of int64: circuit = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: circuit_len = 0

      infinite (stk_top > 0) {
            mut as int64: u = stk[stk_top]
            mut as int64: next_v = 0
            mut as int64: v = 1
            infinite (v <= num_v and next_v == 0) {
                  mut as int64: has_e = adj[(u - 1) * num_v + v]
                  route {
                        has_e > 0 ==> {
                              next_v = v
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }

            route {
                  next_v > 0 ==> {
                        adj[(u - 1) * num_v + next_v] = adj[(u - 1) * num_v + next_v] - 1
                        stk_top = stk_top + 1
                        stk[stk_top] = next_v
                  }
                  _ ==> {
                        circuit_len = circuit_len + 1
                        circuit[circuit_len] = u
                        stk_top = stk_top - 1
                  }
            }
      }

      println("2. Circuito Euleriano Direcionado:")
      mut as string: res = ""
      mut as int64: idx = circuit_len
      infinite (idx >= 1) {
            res = res + circuit[idx] + " "
            idx = idx - 1
      }
      println("   Circuito: " + res)
}
