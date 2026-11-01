#L ============================================================================
#L Algoritmo: LFU Cache (Least Frequently Used Cache com Desempate LRU)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: get O(C) | put O(C) | Espaco O(Capacidade)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasLFUCache) {
      println("==================================================")
      println("  SciAlgo: LFU Cache (Least Frequently Used)")
      println("==================================================")

      mut as int64: cap = 3
      println("1. Inicializando LFU Cache com capacidade = " + cap)

      #L Representacao em arrays paralelos (1-based, tamanho max = cap)
      mut as list of int64: cache_keys = [0]
      mut as list of int64: cache_vals = [0]
      mut as list of int64: cache_freq = [0]
      mut as list of int64: cache_time = [0]

      mut as int64: cur_size = 0
      mut as int64: timer = 0

      #L --- Insercoes iniciais: (1, 10), (2, 20), (3, 30) ---
      println("2. Inserindo elementos iniciais: (1, 10), (2, 20), (3, 30)...")

      #L Put (1, 10)
      timer = timer + 1
      cache_keys = listPushBack(cache_keys, 1)
      cache_vals = listPushBack(cache_vals, 10)
      cache_freq = listPushBack(cache_freq, 1)
      cache_time = listPushBack(cache_time, timer)
      cur_size = cur_size + 1

      #L Put (2, 20)
      timer = timer + 1
      cache_keys = listPushBack(cache_keys, 2)
      cache_vals = listPushBack(cache_vals, 20)
      cache_freq = listPushBack(cache_freq, 1)
      cache_time = listPushBack(cache_time, timer)
      cur_size = cur_size + 1

      #L Put (3, 30)
      timer = timer + 1
      cache_keys = listPushBack(cache_keys, 3)
      cache_vals = listPushBack(cache_vals, 30)
      cache_freq = listPushBack(cache_freq, 1)
      cache_time = listPushBack(cache_time, timer)
      cur_size = cur_size + 1

      println("   Tamanho atual do cache: " + cur_size)

      #L --- Consultas Get(1) e Get(2) para aumentar frequencias ---
      println("3. Acessando chaves 1 e 2 para aumentar contadores de frequencia...")

      #L Get(1)
      timer = timer + 1
      mut as int64: val_1 = -1
      mut as int64: i = 2
      infinite (i <= cur_size + 1) {
            route {
                  cache_keys[i] == 1 ==> {
                        val_1 = cache_vals[i]
                        cache_freq[i] = cache_freq[i] + 1
                        cache_time[i] = timer
                        break
                  }
                  _ ==> {
                        i = i + 1
                  }
            }
      }
      println("   Get(1) -> valor: " + val_1 + " (freq agora: 2)")

      #L Get(2)
      timer = timer + 1
      mut as int64: val_2 = -1
      i = 2
      infinite (i <= cur_size + 1) {
            route {
                  cache_keys[i] == 2 ==> {
                        val_2 = cache_vals[i]
                        cache_freq[i] = cache_freq[i] + 1
                        cache_time[i] = timer
                        break
                  }
                  _ ==> {
                        i = i + 1
                  }
            }
      }
      println("   Get(2) -> valor: " + val_2 + " (freq agora: 2)")

      #L --- Insercao (4, 40) que forca Eviction por Menor Frequencia ---
      println("4. Inserindo (4, 40) com cache cheio -> deve expulsar chave 3 (freq=1)...")
      timer = timer + 1

      #L Localiza candidato a eviction: menor frequencia, tiebreak menor tempo
      mut as int64: victim_idx = 2
      mut as int64: min_f = cache_freq[2]
      mut as int64: min_t = cache_time[2]

      i = 3
      infinite (i <= cur_size + 1) {
            mut as int64: cf = cache_freq[i]
            mut as int64: ct = cache_time[i]
            route {
                  cf < min_f ==> {
                        min_f = cf
                        min_t = ct
                        victim_idx = i
                  }
                  cf == min_f ==> {
                        route {
                              ct < min_t ==> {
                                    min_t = ct
                                    victim_idx = i
                              }
                        }
                  }
            }
            i = i + 1
      }

      mut as int64: evict_key1 = cache_keys[victim_idx]
      println("   Chave expulsa: " + evict_key1 + " (esperado: 3)")

      #L Substitui vitima pela nova chave 4
      cache_keys[victim_idx] = 4
      cache_vals[victim_idx] = 40
      cache_freq[victim_idx] = 1
      cache_time[victim_idx] = timer

      #L --- Verifica Get(3) -> -1 e Get(4) -> 40 ---
      mut as int64: get_3 = -1
      i = 2
      infinite (i <= cur_size + 1) {
            route {
                  cache_keys[i] == 3 ==> {
                        get_3 = cache_vals[i]
                        break
                  }
                  _ ==> {
                        i = i + 1
                  }
            }
      }
      println("   Get(3) apos eviction (esperado -1): " + get_3)

      #L Get(4) -> incrementa freq(4) para 2
      timer = timer + 1
      mut as int64: get_4 = -1
      i = 2
      infinite (i <= cur_size + 1) {
            route {
                  cache_keys[i] == 4 ==> {
                        get_4 = cache_vals[i]
                        cache_freq[i] = cache_freq[i] + 1
                        cache_time[i] = timer
                        break
                  }
                  _ ==> {
                        i = i + 1
                  }
            }
      }
      println("   Get(4) (esperado 40): " + get_4)

      #L Agora todas as chaves 1, 2, 4 possuem freq = 2!
      #L Tempos:
      #L chave 1: timer = 4
      #L chave 2: timer = 5
      #L chave 4: timer = 7
      #L --- Insercao (5, 50) deve desempacar por LRU -> expulsar chave 1 (mais antiga) ---
      println("5. Inserindo (5, 50) com empate de frequencia (todas freq=2) -> deve expulsar chave 1...")
      timer = timer + 1

      victim_idx = 2
      min_f = cache_freq[2]
      min_t = cache_time[2]

      i = 3
      infinite (i <= cur_size + 1) {
            mut as int64: cf2 = cache_freq[i]
            mut as int64: ct2 = cache_time[i]
            route {
                  cf2 < min_f ==> {
                        min_f = cf2
                        min_t = ct2
                        victim_idx = i
                  }
                  cf2 == min_f ==> {
                        route {
                              ct2 < min_t ==> {
                                    min_t = ct2
                                    victim_idx = i
                              }
                        }
                  }
            }
            i = i + 1
      }

      mut as int64: evict_key2 = cache_keys[victim_idx]
      println("   Chave expulsa: " + evict_key2 + " (esperado: 1)")

      #L Substitui vitima por (5, 50)
      cache_keys[victim_idx] = 5
      cache_vals[victim_idx] = 50
      cache_freq[victim_idx] = 1
      cache_time[victim_idx] = timer

      #L Verifica Get(1) -> -1 e Get(5) -> 50
      mut as int64: get_1_final = -1
      i = 2
      infinite (i <= cur_size + 1) {
            route {
                  cache_keys[i] == 1 ==> {
                        get_1_final = cache_vals[i]
                        break
                  }
                  _ ==> {
                        i = i + 1
                  }
            }
      }
      println("   Get(1) final (esperado -1): " + get_1_final)

      mut as int64: get_5_final = -1
      i = 2
      infinite (i <= cur_size + 1) {
            route {
                  cache_keys[i] == 5 ==> {
                        get_5_final = cache_vals[i]
                        break
                  }
                  _ ==> {
                        i = i + 1
                  }
            }
      }
      println("   Get(5) final (esperado 50): " + get_5_final)

      #L Assercoes finais
      mut as bool: ok = (val_1 == 10) and (val_2 == 20) and (evict_key1 == 3) and (get_3 == -1) and (get_4 == 40) and (evict_key2 == 1) and (get_1_final == -1) and (get_5_final == 50)
      println("6. Verificacao geral do LFU Cache: " + ok)
      println("Concluido com Sucesso")
}
