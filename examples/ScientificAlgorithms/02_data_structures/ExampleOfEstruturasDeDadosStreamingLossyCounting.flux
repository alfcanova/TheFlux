#L ============================================================================
#L Algoritmo: Lossy Counting (Deteccao de Heavy Hitters com Erro Controlado)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados streaming
#L Complexidade: O(1) amortizado por item | Espaco O((1 / epsilon) * log(epsilon * N))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingLossyCounting) {
      println("==================================================")
      println("  SciAlgo: Lossy Counting (Frequent Items in Stream)")
      println("==================================================")

      #L Parametro de bucket: w = 4 (epsilon = 0.25)
      mut as int64: w = 4
      mut as int64: b_current = 1

      #L Stream com 12 itens (3 buckets):
      #L O item 10 aparece 7 vezes ao longo dos 3 buckets
      mut as list of int64: stream = [10, 20, 10, 30,  10, 40, 10, 20,  10, 10, 50, 10]
      mut as int64: n = listLength(stream)

      #L Tabela de entradas: itens, frequencias e delta
      mut as list of int64: items = []
      mut as list of int64: freqs = []
      mut as list of int64: deltas = []

      println("1. Processando stream de " + n + " itens em buckets de tamanho " + w + ":")
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: x = stream[i]

            #L Busca x na tabela
            mut as int64: found_idx = 0
            mut as int64: j = 1
            infinite (j <= listLength(items) and found_idx == 0) {
                  route {
                        items[j] == x ==> {
                              found_idx = j
                        }
                        _ ==> {
                        }
                  }
                  j = j + 1
            }

            route {
                  found_idx > 0 ==> {
                        freqs[found_idx] = freqs[found_idx] + 1
                  }
                  _ ==> {
                        items = listPushBack(items, x)
                        freqs = listPushBack(freqs, 1)
                        deltas = listPushBack(deltas, b_current - 1)
                  }
            }

            #L Ao atingir fronteira de bucket (i % w == 0), executa poda (prune)
            route {
                  (i /r w) == 0 ==> {
                        mut as list of int64: new_items = []
                        mut as list of int64: new_freqs = []
                        mut as list of int64: new_deltas = []

                        mut as int64: p = 1
                        infinite (p <= listLength(items)) {
                              route {
                                    (freqs[p] + deltas[p]) > b_current ==> {
                                          new_items = listPushBack(new_items, items[p])
                                          new_freqs = listPushBack(new_freqs, freqs[p])
                                          new_deltas = listPushBack(new_deltas, deltas[p])
                                    }
                                    _ ==> {
                                    }
                              }
                              p = p + 1
                        }

                        items = new_items
                        freqs = new_freqs
                        deltas = new_deltas
                        println("   Fim do Bucket " + b_current + ": itens ativos mantidos = " + listLength(items))
                        b_current = b_current + 1
                  }
                  _ ==> {
                  }
            }

            i = i + 1
      }

      println("2. Itens frequentes finais identificados:")
      mut as bool: heavy_hitter_found = false
      mut as int64: final_freq_10 = 0
      mut as int64: k = 1
      infinite (k <= listLength(items)) {
            println("   Item: " + items[k] + " -> Frequencia estimada: " + freqs[k] + ", Delta: " + deltas[k])
            route {
                  items[k] == 10 ==> {
                        heavy_hitter_found = true
                        final_freq_10 = freqs[k]
                  }
                  _ ==> {
                  }
            }
            k = k + 1
      }

      #L Validacao: o item 10 foi detectado com frequencia >= 5
      mut as bool: valid = heavy_hitter_found and (final_freq_10 >= 5)
      println("3. Validacao: " + valid)
      println("==================================================")
}
