#L ============================================================================
#L Algoritmo: KLL Sketch (Sketch Otimo de Quantis com Compactadores)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados streaming
#L Complexidade: O(1) amortizado por item | Espaco O(K * log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingKLLSketch) {
      println("==================================================")
      println("  SciAlgo: KLL Sketch (Optimal Quantile Sketch)")
      println("==================================================")

      #L Dois niveis: nivel 0 (peso 1, cap = 4) e nivel 1 (peso 2, cap = 4)
      mut as list of int64: lvl0 = []
      mut as list of int64: lvl1 = []
      mut as int64: cap = 4

      #L Stream de 8 itens
      mut as list of int64: stream = [12, 5, 8, 20, 15, 3, 7, 25]
      mut as int64: n = listLength(stream)

      println("1. Inserindo stream de 8 itens com compactacao de buffers (cap = 4):")
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: item = stream[i]
            lvl0 = listPushBack(lvl0, item)

            #L Se buffer lvl0 encheu (tamanho == 4), ordena por bubble sort simples e compacta
            route {
                  listLength(lvl0) == cap ==> {
                        #L Ordenacao do buffer lvl0
                        mut as int64: a = 1
                        infinite (a <= cap) {
                              mut as int64: b = 1
                              infinite (b <= cap - a) {
                                    route {
                                          lvl0[b] > lvl0[b + 1] ==> {
                                                mut as int64: tmp = lvl0[b]
                                                lvl0[b] = lvl0[b + 1]
                                                lvl0[b + 1] = tmp
                                          }
                                          _ ==> {
                                          }
                                    }
                                    b = b + 1
                              }
                              a = a + 1
                        }

                        #L Compactacao: pega indices 2 e 4 (metade dos itens) e promove para lvl1
                        lvl1 = listPushBack(lvl1, lvl0[2])
                        lvl1 = listPushBack(lvl1, lvl0[4])
                        println("   Buffer lvl0 compactou: promoveu [" + lvl0[2] + ", " + lvl0[4] + "] para lvl1 (peso 2)")
                        lvl0 = []
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      println("2. Estado final dos niveis do KLL Sketch:")
      println("   Itens no nivel 0 (peso 1): " + listLength(lvl0))
      println("   Itens no nivel 1 (peso 2): " + listLength(lvl1))

      #L Consulta de Rank estimado para o valor 15:
      #L Soma os pesos de todos os itens em lvl0 e lvl1 menores ou iguais a 15
      println("3. Estimando rank do item 15:")
      mut as int64: target = 15
      mut as int64: est_rank = 0
      mut as int64: p0 = 1
      infinite (p0 <= listLength(lvl0)) {
            route {
                  lvl0[p0] <= target ==> {
                        est_rank = est_rank + 1
                  }
                  _ ==> {
                  }
            }
            p0 = p0 + 1
      }

      mut as int64: p1 = 1
      infinite (p1 <= listLength(lvl1)) {
            route {
                  lvl1[p1] <= target ==> {
                        est_rank = est_rank + 2
                  }
                  _ ==> {
                  }
            }
            p1 = p1 + 1
      }

      println("   Rank estimado de 15: " + est_rank + " de 8 itens")

      #L Validacao: os itens promovidos para lvl1 existem e rank esta na faixa esperada
      mut as bool: valid = (listLength(lvl1) == 4) and (est_rank >= 4 and est_rank <= 6)
      println("4. Validacao: " + valid)
      println("==================================================")
}
