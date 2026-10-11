#L ============================================================================
#L Algoritmo: Flajolet-Martin Algorithm (FM-Sketch para Cardinalidade Distinta)
#L Dominio: 02_data_structures / Categoria: 3. Algoritmos de selecao e streaming (Adicoes Prioritarias)
#L Complexidade: O(1) espaco O(log N) | O(1) atualizacao por evento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingFlajoletMartin) {
      println("==================================================")
      println("  SciAlgo: Flajolet-Martin Algorithm (FM-Sketch)")
      println("==================================================")

      #L Bitmap de 16 bits para rastreamento de zeros a direita (1-based, 1..16)
      mut as list of int64: bitmap = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      #L Stream com 20 elementos distintos reais (1..20), com repeticoes
      mut as list of int64: stream = [
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
            1, 3, 5, 7, 9, 2, 4, 6, 8, 10,
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
            11, 15, 20, 12, 16, 14, 18, 13, 17, 19
      ]
      mut as int64: n_events = listLength(stream)
      mut as int64: true_distinct = 20

      println("1. Processando stream de " + n_events + " eventos com " + true_distinct + " itens distintos...")

      mut as int64: i = 1
      infinite (i <= n_events) {
            mut as int64: x = stream[i]

            #L Funcao hash deterministica 32-bit
            mut as int64: h = ((x * 2654435761) + 12345) /r 65536
            route {
                  h == 0 ==> { h = 1 }
            }

            #L Conta zeros a direita (trailing zeros: 0..15)
            mut as int64: r = 0
            mut as int64: temp = h
            infinite (temp > 0) {
                  mut as int64: bit = temp /r 2
                  route {
                        bit == 0 ==> {
                              r = r + 1
                              temp = temp /i 2
                        }
                        _ ==> {
                              break
                        }
                  }
            }

            #L Marca posicao r + 1 no bitmap (1-based)
            mut as int64: pos = r + 1
            route {
                  pos <= 16 ==> {
                        bitmap[pos] = 1
                  }
            }

            i = i + 1
      }
      println("   Stream processado e bitmap populado.")

      #L 2. Encontra o menor indice 0-based R onde bitmap[R+1] == 0
      mut as int64: r_zero = 0
      infinite (r_zero < 16) {
            mut as int64: check_pos = r_zero + 1
            route {
                  bitmap[check_pos] == 0 ==> {
                        break
                  }
            }
            r_zero = r_zero + 1
      }
      println("2. Primeiro zero no FM-Sketch (R): " + r_zero)

      #L 3. Estimativa de Flajolet-Martin:
      #L E = 2^R / phi onde phi = 0.77351
      #L E = (2^R * 1000) / 774
      mut as int64: p2 = 1
      mut as int64: k = 1
      infinite (k <= r_zero) {
            p2 = p2 * 2
            k = k + 1
      }

      mut as int64: estimate = (p2 * 1000) /i 774
      println("3. Estimativa de Cardinalidade FM: " + estimate)
      println("   Cardinalidade Real: " + true_distinct)

      #L Verificacao de intervalo estatistico razoavel para FM
      mut as bool: ok = (estimate >= 10) and (estimate <= 60) and (r_zero >= 3)
      println("4. Verificacao geral do Flajolet-Martin: " + ok)
      println("Concluido com Sucesso")
}
