#L ============================================================================
#L Algoritmo: Amortized Algorithms (Analise e Algoritmos Amortizados)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(1) amortizado por operacao | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsAmortizedAlgorithms) {
      println("==================================================")
      println("  SciAlgo: Amortized Algorithms (Analise Amortizada)")
      println("==================================================")

      #L Caso 1: Vetor Dinamico com Dobra de Capacidade
      #L Insercao de N = 12 elementos partindo de capacidade = 1
      mut as int64: n_inserts = 12
      mut as int64: capacity = 1
      mut as int64: size = 0
      mut as int64: total_real_cost = 0
      mut as int64: resizes_count = 0

      println("1. Simulacao de Vetor Dinamico (Dobra 1 -> 2 -> 4 -> 8 -> 16):")

      mut as int64: ins = 1
      infinite (ins <= n_inserts) {
            mut as int64: op_cost = 1

            route {
                  size == capacity ==> {
                        #L Realocacao: copia elementos antigos + nova capacidade
                        op_cost = op_cost + size
                        capacity = capacity * 2
                        resizes_count = resizes_count + 1
                  }
                  _ ==> {
                  }
            }

            size = size + 1
            total_real_cost = total_real_cost + op_cost

            #L Funcao potencial de Physicist: Phi = 2*size - capacity
            mut as int64: phi = (2 * size) - capacity
            ins = ins + 1
      }

      mut as int64: avg_cost_scaled = (total_real_cost * 100) /i n_inserts
      println("2. Total de elementos inseridos: " + size)
      println("3. Capacidade final: " + capacity)
      println("4. Realocacoes ocorridas: " + resizes_count)
      println("5. Custo real total: " + total_real_cost)
      println("6. Custo amortizado medio por insercao (* 100): " + avg_cost_scaled + " (~ O(1))")

      #L Caso 2: Fila FIFO implementada com Duas Pilhas
      #L Enfileira 5 itens, desenfileira 3 itens, enfileira 2 itens
      mut as list of int64: st_in = []
      mut as list of int64: st_out = []

      #L Enqueue 1..5
      st_in = [10, 20, 30, 40, 50]

      #L Dequeue de 3 elementos (transfere de in para out se out estiver vazio)
      mut as list of int64: dequeued = []
      mut as int64: d_ops = 3

      infinite (d_ops > 0) {
            route {
                  listLength(st_out) == 0 ==> {
                        #L Despeja st_in em st_out invertendo a ordem
                        mut as int64: in_sz = listLength(st_in)
                        mut as int64: idx = in_sz
                        infinite (idx >= 1) {
                              st_out = listPushBack(st_out, st_in[idx])
                              idx = idx - 1
                        }
                        st_in = []
                  }
                  _ ==> {
                  }
            }

            mut as int64: out_sz = listLength(st_out)
            dequeued = listPushBack(dequeued, st_out[out_sz])

            #L Remove topo de st_out
            mut as list of int64: n_out = []
            mut as int64: oi = 1
            infinite (oi < out_sz) {
                  n_out = listPushBack(n_out, st_out[oi])
                  oi = oi + 1
            }
            st_out = n_out
            d_ops = d_ops - 1
      }

      println("7. Elementos desenfileirados com custo amortizado O(1): " + dequeued)
      println("Concluido com Sucesso")
}
