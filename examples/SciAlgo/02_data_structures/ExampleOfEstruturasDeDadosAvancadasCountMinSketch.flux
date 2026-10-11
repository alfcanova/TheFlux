#L ============================================================================
#L Algoritmo: Count-Min Sketch com Atualizacao Conservadora (Conservative Update)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(d) tempo por operacao onde d = profundidade | Espaco O(w * d)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasCountMinSketch) {
      println("==================================================")
      println("  SciAlgo: Count-Min Sketch (Conservative Update)")
      println("==================================================")

      #L Matriz d x w de contadores (d = 4 linhas de hash, w = 8 colunas)
      #L Representada em lista linear de d * w = 32 celulas (1-based)
      mut as int64: depth = 4
      mut as int64: width = 8
      mut as list of int64: table = []
      mut as int64: t_init = 1
      infinite (t_init <= depth * width) {
            table = listPushBack(table, 0)
            t_init = t_init + 1
      }

      #L Coeficientes deterministicos das 4 funcoes de hash lineares: (a_i * x + b_i) % width + 1
      mut as list of int64: hash_a = [3, 5, 7, 11]
      mut as list of int64: hash_b = [1, 3, 5, 7]

      #L Fluxo de entrada com repeticoes deliberadas:
      #L 100 aparece 5 vezes
      #L 200 aparece 3 vezes
      #L 300 aparece 2 vezes
      #L 400 aparece 1 vez
      mut as list of int64: stream = [100, 200, 100, 300, 100, 200, 400, 100, 300, 200, 100]
      mut as int64: stream_len = listLength(stream)

      println("1. Inserindo fluxo de " + stream_len + " eventos com Conservative Update...")

      mut as int64: s_idx = 1
      infinite (s_idx <= stream_len) {
            mut as int64: item = stream[s_idx]

            #L Passo 1: Consulta a estimativa atual min_row
            mut as int64: cur_min = 999999
            mut as int64: row = 1
            infinite (row <= depth) {
                  mut as int64: col = ((item * hash_a[row] + hash_b[row]) /r width) + 1
                  mut as int64: cell_idx = (row - 1) * width + col
                  route {
                        table[cell_idx] < cur_min ==> {
                              cur_min = table[cell_idx]
                        }
                  }
                  row = row + 1
            }

            #L Passo 2: Atualizacao Conservadora (incrementa apenas as celulas iguais a cur_min)
            mut as int64: target_val = cur_min + 1
            row = 1
            infinite (row <= depth) {
                  mut as int64: col = ((item * hash_a[row] + hash_b[row]) /r width) + 1
                  mut as int64: cell_idx = (row - 1) * width + col
                  route {
                        table[cell_idx] < target_val ==> {
                              table[cell_idx] = target_val
                        }
                  }
                  row = row + 1
            }

            s_idx = s_idx + 1
      }

      #L Passo 3: Consultas pontuais de frequencia estimada
      mut as list of int64: query_items = [100, 200, 300, 400, 500]
      mut as list of int64: true_counts = [5, 3, 2, 1, 0]
      mut as int64: q_len = listLength(query_items)

      println("2. Consultas pontuais de frequencia:")
      mut as int64: qi = 1
      mut as bool: all_accurate = true
      infinite (qi <= q_len) {
            mut as int64: q = query_items[qi]
            mut as int64: est = 999999
            mut as int64: r = 1
            infinite (r <= depth) {
                  mut as int64: c = ((q * hash_a[r] + hash_b[r]) /r width) + 1
                  mut as int64: idx = (r - 1) * width + c
                  route {
                        table[idx] < est ==> {
                              est = table[idx]
                        }
                  }
                  r = r + 1
            }

            mut as int64: expected = true_counts[qi]
            println("   Item " + q + ": estimado = " + est + " | real = " + expected)
            route {
                  est < expected ==> {
                        all_accurate = false
                  }
            }
            qi = qi + 1
      }

      println("3. Validacao: " + (all_accurate and table[1] >= 0))
      println("==================================================")
}
