#L ============================================================================
#L Algoritmo: Online Algorithm (Algoritmo Online)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N * K) tempo | O(K) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsOnlineAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Online Algorithm (Paginacao LRU e FIFO)")
      println("==================================================")

      mut as list of int64: stream = [1, 2, 3, 4, 1, 2, 5, 1, 2, 3, 4, 5]
      mut as int64: cache_cap = 3
      mut as int64: n_requests = listLength(stream)

      println("1. Fluxo continuo de requisicoes: " + stream)
      println("2. Capacidade da memoria cache: " + cache_cap)

      #L Algoritmo Online 1: FIFO (First-In First-Out)
      mut as list of int64: fifo_cache = []
      mut as int64: fifo_faults = 0
      mut as int64: req_i = 1

      infinite (req_i <= n_requests) {
            mut as int64: page = stream[req_i]
            mut as bool: in_cache = false
            mut as int64: c_idx = 1
            mut as int64: cur_sz = listLength(fifo_cache)
            infinite (c_idx <= cur_sz) {
                  route {
                        fifo_cache[c_idx] == page ==> {
                              in_cache = true
                        }
                        _ ==> {
                        }
                  }
                  c_idx = c_idx + 1
            }

            route {
                  not in_cache ==> {
                        fifo_faults = fifo_faults + 1
                        route {
                              cur_sz >= cache_cap ==> {
                                    #L Remove o primeiro inserido (posicao 1)
                                    mut as list of int64: n_c = []
                                    mut as int64: k = 2
                                    infinite (k <= cur_sz) {
                                          n_c = listPushBack(n_c, fifo_cache[k])
                                          k = k + 1
                                    }
                                    fifo_cache = n_c
                              }
                              _ ==> {
                              }
                        }
                        fifo_cache = listPushBack(fifo_cache, page)
                  }
                  _ ==> {
                  }
            }
            req_i = req_i + 1
      }
      println("3. Faltas de pagina no FIFO Online: " + fifo_faults)

      #L Algoritmo Online 2: LRU (Least Recently Used)
      mut as list of int64: lru_cache = []
      mut as int64: lru_faults = 0
      mut as int64: lru_hits = 0
      req_i = 1

      infinite (req_i <= n_requests) {
            mut as int64: page = stream[req_i]
            mut as int64: found_pos = 0
            mut as int64: c_idx = 1
            mut as int64: cur_sz = listLength(lru_cache)
            infinite (c_idx <= cur_sz) {
                  route {
                        lru_cache[c_idx] == page ==> {
                              found_pos = c_idx
                        }
                        _ ==> {
                        }
                  }
                  c_idx = c_idx + 1
            }

            route {
                  found_pos > 0 ==> {
                        #L Hit: move a pagina para o final (mais recente)
                        lru_hits = lru_hits + 1
                        mut as list of int64: n_lru = []
                        mut as int64: m = 1
                        infinite (m <= cur_sz) {
                              route {
                                    m != found_pos ==> {
                                          n_lru = listPushBack(n_lru, lru_cache[m])
                                    }
                                    _ ==> {
                                    }
                              }
                              m = m + 1
                        }
                        n_lru = listPushBack(n_lru, page)
                        lru_cache = n_lru
                  }
                  _ ==> {
                        #L Fault: insere nova pagina, descartando a menos recente
                        lru_faults = lru_faults + 1
                        route {
                              cur_sz >= cache_cap ==> {
                                    mut as list of int64: n_lru2 = []
                                    mut as int64: m2 = 2
                                    infinite (m2 <= cur_sz) {
                                          n_lru2 = listPushBack(n_lru2, lru_cache[m2])
                                          m2 = m2 + 1
                                    }
                                    lru_cache = n_lru2
                              }
                              _ ==> {
                              }
                        }
                        lru_cache = listPushBack(lru_cache, page)
                  }
            }
            req_i = req_i + 1
      }
      println("4. Faltas de pagina no LRU Online: " + lru_faults)
      println("5. Acertos (Hits) no LRU Online: " + lru_hits)
      println("Concluido com Sucesso")
}
