#L ============================================================================
#L Algoritmo: Sticky Sampling (Amostragem Adaptativa para Heavy Hitters)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados streaming
#L Complexidade: O(1) por atualizacao | Espaco O((1 / epsilon) * log(1 / delta))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingStickySampling) {
      println("==================================================")
      println("  SciAlgo: Sticky Sampling (Adaptive Stream Sampling)")
      println("==================================================")

      #L Taxa de amostragem inicial: r = 1 (amostra todos inicialmente)
      mut as int64: r_rate = 1

      #L Stream de 12 itens onde 88 e fortemente dominante
      mut as list of int64: stream = [88, 12, 88, 34, 88, 88, 56, 88, 78, 88, 88, 88]
      mut as int64: n = listLength(stream)

      mut as list of int64: items = []
      mut as list of int64: freqs = []

      println("1. Processando stream de " + n + " itens com amostragem Sticky Sampling:")
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: x = stream[i]

            #L Busca se x ja esta rastreado
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
                        #L Se ja esta na tabela, incrementa sempre
                        freqs[found_idx] = freqs[found_idx] + 1
                  }
                  _ ==> {
                        #L Novo item: aceita de acordo com a taxa de amostragem r_rate
                        route {
                              (i /r r_rate) == 0 ==> {
                                    items = listPushBack(items, x)
                                    freqs = listPushBack(freqs, 1)
                              }
                              _ ==> {
                              }
                        }
                  }
            }

            #L Ao atingir metade do stream (i == 6), a taxa dobra para r = 2 e decrementa contadores
            route {
                  i == 6 ==> {
                        r_rate = 2
                        mut as list of int64: surviving_items = []
                        mut as list of int64: surviving_freqs = []

                        mut as int64: p = 1
                        infinite (p <= listLength(items)) {
                              mut as int64: reduced = freqs[p] - 1
                              route {
                                    reduced > 0 ==> {
                                          surviving_items = listPushBack(surviving_items, items[p])
                                          surviving_freqs = listPushBack(surviving_freqs, reduced)
                                    }
                                    _ ==> {
                                    }
                              }
                              p = p + 1
                        }
                        items = surviving_items
                        freqs = surviving_freqs
                        println("   Apos epoca 1 (taxa dobra para 2): itens sobreviventes = " + listLength(items))
                  }
                  _ ==> {
                  }
            }

            i = i + 1
      }

      println("2. Itens retidos no Sticky Sampling:")
      mut as bool: dominant_detected = false
      mut as int64: k = 1
      infinite (k <= listLength(items)) {
            println("   Item: " + items[k] + " -> Frequencia estimada retida: " + freqs[k])
            route {
                  items[k] == 88 and freqs[k] >= 5 ==> {
                        dominant_detected = true
                  }
                  _ ==> {
                  }
            }
            k = k + 1
      }

      #L Validacao: o item 88 sobreviveu com frequencia retida >= 5
      mut as bool: valid = dominant_detected
      println("3. Validacao: " + valid)
      println("==================================================")
}
