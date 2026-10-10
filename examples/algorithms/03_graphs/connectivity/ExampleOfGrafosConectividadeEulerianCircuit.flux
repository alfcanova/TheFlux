#L ============================================================================
#L Algoritmo: Eulerian Circuit (Circuito Euleriano / Ciclo de Euler)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeEulerianCircuit) {
      println("==================================================")
      println("  SciAlgo: Eulerian Circuit (All Even Degrees)    ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as list of int64: deg = [2, 2, 2, 2] #L Ciclo 1-2-3-4-1 (todos graus pares)

      mut as list of int64: adj = [
            0, 1, 0, 1,
            1, 0, 1, 0,
            0, 1, 0, 1,
            1, 0, 1, 0
      ]

      mut as int64: odd_cnt = 0
      mut as int64: i = 1
      infinite (i <= num_v) {
            mut as int64: rem = deg[i] /r 2
            route {
                  rem != 0 ==> {
                        odd_cnt = odd_cnt + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Vertices de grau impar: " + odd_cnt)
      println("   Grafo Euleriano confirmado (todos os graus sao pares)")

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
                        adj[(next_v - 1) * num_v + u] = adj[(next_v - 1) * num_v + u] - 1
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

      println("2. Sequencia do Circuito Euleriano:")
      mut as string: res = ""
      mut as int64: idx = circuit_len
      infinite (idx >= 1) {
            res = res + circuit[idx] + " "
            idx = idx - 1
      }
      println("   Circuito: " + res)
}
