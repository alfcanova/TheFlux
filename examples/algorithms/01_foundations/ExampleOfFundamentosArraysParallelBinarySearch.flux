#L ============================================================================
#L Algoritmo: Parallel Binary Search (Busca Binaria Paralela)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O((N + Q) * log M) tempo | O(N + Q) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysParallelBinarySearch) {
      println("==================================================")
      println("  SciAlgo: Parallel Binary Search")
      println("==================================================")

      #L M = 5 rodadas de eventos distribuindo pontuacao para 3 usuarios
      #L Pontuacoes concedidas por rodada [u1, u2, u3]
      mut as list of int64: r1 = [10, 0, 5]
      mut as list of int64: r2 = [5, 20, 15]
      mut as list of int64: r3 = [0, 10, 25]
      mut as list of int64: r4 = [30, 5, 0]
      mut as list of int64: r5 = [10, 10, 10]

      #L Metas de pontuacao a atingir
      mut as list of int64: targets = [40, 25, 30]
      mut as int64: num_q = 3
      println("1. Metas dos usuarios [U1, U2, U3]: " + targets)

      #L Intervalos de busca binaria para cada consulta [low, high]
      #L Universo de rodadas: 1..5
      mut as list of int64: low = [1, 1, 1]
      mut as list of int64: high = [5, 5, 5]
      mut as list of int64: answer = [0, 0, 0]

      #L Realiza log2(5) + 1 = 3 rodadas de bisseccao paralela
      mut as int64: iter = 1
      infinite (iter <= 4) {
            #L Para cada consulta ativa, calcula o ponto medio
            mut as list of int64: mid = [0, 0, 0]
            mut as int64: active_queries = 0
            mut as int64: q = 1
            infinite (q <= num_q) {
                  route {
                        low[q] <= high[q] ==> {
                              mid[q] = low[q] + ((high[q] - low[q]) /i 2)
                              active_queries = active_queries + 1
                        }
                        _ ==> {
                              mid[q] = 0
                        }
                  }
                  q = q + 1
            }

            route {
                  active_queries == 0 ==> {
                        iter = 99 #L Termina cedo
                  }
                  _ ==> {
                        #L Avalia pontuacao acumulada para cada consulta no seu respectivo mid[q]
                        q = 1
                        infinite (q <= num_q) {
                              mut as int64: m = mid[q]
                              route {
                                    m > 0 ==> {
                                          mut as int64: accum = 0
                                          route {
                                                m >= 1 ==> { accum = accum + r1[q] }
                                                _ ==> {}
                                          }
                                          route {
                                                m >= 2 ==> { accum = accum + r2[q] }
                                                _ ==> {}
                                          }
                                          route {
                                                m >= 3 ==> { accum = accum + r3[q] }
                                                _ ==> {}
                                          }
                                          route {
                                                m >= 4 ==> { accum = accum + r4[q] }
                                                _ ==> {}
                                          }
                                          route {
                                                m >= 5 ==> { accum = accum + r5[q] }
                                                _ ==> {}
                                          }

                                          route {
                                                accum >= targets[q] ==> {
                                                      answer[q] = m
                                                      high[q] = m - 1
                                                }
                                                _ ==> {
                                                      low[q] = m + 1
                                                }
                                          }
                                    }
                                    _ ==> {
                                    }
                              }
                              q = q + 1
                        }
                  }
            }
            iter = iter + 1
      }

      println("2. Primeira rodada em que a meta foi alcancada:")
      println("   U1 (meta 40): Rodada " + answer[1] + " (acumulado em R4 = 10+5+0+30 = 45 >= 40)")
      println("   U2 (meta 25): Rodada " + answer[2] + " (acumulado em R2 = 0+20 = 20 < 25; em R3 = 20+10 = 30 >= 25)")
      println("   U3 (meta 30): Rodada " + answer[3] + " (acumulado em R2 = 5+15 = 20 < 30; em R3 = 5+15+25 = 45 >= 30)")
}
