#L ============================================================================
#L Algoritmo: Count-Sketch (Estimador Nao Enviesado de Frequencia em Streams)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados streaming
#L Complexidade: O(d) por atualizacao e consulta | Espaco O(d * w)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingCountSketch) {
      println("==================================================")
      println("  SciAlgo: Count-Sketch (Unbiased Stream Frequency)")
      println("==================================================")

      #L Matriz 3 linhas (d = 3) x 8 colunas (w = 8) linearizada (24 slots)
      mut as int64: d = 3
      mut as int64: w = 8
      mut as list of int64: table = [
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
      ]

      #L Stream de dados com item 42 repetido 5 vezes, item 17 repetido 3 vezes, item 9 repetido 1 vez
      mut as list of int64: stream = [42, 17, 42, 9, 42, 17, 42, 17, 42]
      mut as int64: stream_len = listLength(stream)

      println("1. Processando stream de " + stream_len + " itens no Count-Sketch:")
      mut as int64: s = 1
      infinite (s <= stream_len) {
            mut as int64: item = stream[s]

            #L Linha 1: hash1 = (item * 7) % 8 + 1, sign1 = if (item % 2 == 0) 1 else -1
            mut as int64: c1 = ((item * 7) /r w) + 1
            mut as int64: s1 = 1
            route {
                  (item /r 2) != 0 ==> {
                        s1 = 0 - 1
                  }
                  _ ==> {
                  }
            }
            mut as int64: idx1 = c1
            table[idx1] = table[idx1] + s1

            #L Linha 2: hash2 = (item * 13) % 8 + 1, sign2
            mut as int64: c2 = ((item * 13) /r w) + 1
            mut as int64: s2 = 1
            route {
                  ((item /i 2) /r 2) != 0 ==> {
                        s2 = 0 - 1
                  }
                  _ ==> {
                  }
            }
            mut as int64: idx2 = w + c2
            table[idx2] = table[idx2] + s2

            #L Linha 3: hash3 = (item * 29) % 8 + 1, sign3
            mut as int64: c3 = ((item * 29) /r w) + 1
            mut as int64: s3 = 1
            route {
                  ((item /i 4) /r 2) != 0 ==> {
                        s3 = 0 - 1
                  }
                  _ ==> {
                  }
            }
            mut as int64: idx3 = 2 * w + c3
            table[idx3] = table[idx3] + s3

            s = s + 1
      }
      println("   Stream processado com sucesso.")

      #L Estimativa para item 42 (frequencia real = 5)
      println("2. Consultando estimativa de frequencia para o item 42:")
      mut as int64: q_item = 42
      mut as int64: qc1 = ((q_item * 7) /r w) + 1
      mut as int64: qs1 = 1
      route {
            (q_item /r 2) != 0 ==> {
                  qs1 = 0 - 1
            }
            _ ==> {
            }
      }
      mut as int64: est1 = qs1 * table[qc1]

      mut as int64: qc2 = ((q_item * 13) /r w) + 1
      mut as int64: qs2 = 1
      route {
            ((q_item /i 2) /r 2) != 0 ==> {
                  qs2 = 0 - 1
            }
            _ ==> {
            }
      }
      mut as int64: est2 = qs2 * table[w + qc2]

      mut as int64: qc3 = ((q_item * 29) /r w) + 1
      mut as int64: qs3 = 1
      route {
            ((q_item /i 4) /r 2) != 0 ==> {
                  qs3 = 0 - 1
            }
            _ ==> {
            }
      }
      mut as int64: est3 = qs3 * table[2 * w + qc3]

      println("   Estimativas das 3 linhas: [" + est1 + ", " + est2 + ", " + est3 + "]")

      #L Mediana dos 3 valores
      mut as int64: median_est = est1
      route {
            (est1 <= est2 and est2 <= est3) or (est3 <= est2 and est2 <= est1) ==> {
                  median_est = est2
            }
            (est1 <= est3 and est3 <= est2) or (est2 <= est3 and est3 <= est1) ==> {
                  median_est = est3
            }
            _ ==> {
                  median_est = est1
            }
      }
      println("   Frequencia estimada (mediana): " + median_est)

      #L Validacao: frequencia estimada do item 42 deve ser 5 (ou muito proxima)
      mut as bool: valid = (median_est == 5)
      println("3. Validacao: " + valid)
      println("==================================================")
}
