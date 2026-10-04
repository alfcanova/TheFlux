#L ============================================================================
#L Algoritmo: Misra-Gries (Detecção de Heavy Hitters em Streaming)
#L Domínio: 02_data_structures / Categoria: Algoritmos de Streaming e Sketches
#L Complexidade: Tempo O(N log k) | Espaço O(k)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (mgProcess) (as list of string: stream, as int64: k) as map {
      mut as map: counters = map{}
      mut as list of string: keys = []
      mut as int64: max_keys = k - 1
      
      mut as int64: n = listLength(stream)
      mut as int64: i = 1
      infinite (i <= n) {
            mut as string: item = stream[i]
            
            #L Caso 1: Item já está no resumo
            route {
                  item in counters ==> {
                        mut as int64: cur_c = counters[item] as int64
                        counters[item] = cur_c + 1
                  }
                  #L Caso 2: Espaço disponível no resumo (< k - 1)
                  listLength(keys) < max_keys ==> {
                        counters[item] = 1
                        keys = listPushBack(keys, item)
                  }
                  #L Caso 3: Resumo cheio e item novo -> decrementa todos e reconstrói
                  _ ==> {
                        mut as map: new_counters = map{}
                        mut as list of string: new_keys = []
                        mut as int64: j = 1
                        mut as int64: num_keys = listLength(keys)
                        infinite (j <= num_keys) {
                              mut as string: key_j = keys[j]
                              mut as int64: val_j = (counters[key_j] as int64) - 1
                              route {
                                    val_j > 0 ==> {
                                          new_counters[key_j] = val_j
                                          new_keys = listPushBack(new_keys, key_j)
                                    }
                              }
                              j = j + 1
                        }
                        counters = new_counters
                        keys = new_keys
                  }
            }
            i = i + 1
      }
      
      mut as map: res = map{
            "keys": keys,
            "counters": counters,
            "k": k,
            "n": n
      }
      emit(nice, res, "ok")
}

program (ExampleOfMisraGriesStreaming) {
      println("==================================================")
      println("  SciAlgo: Misra-Gries (Heavy Hitters Streaming)")
      println("==================================================")

      #L Fluxo de 16 elementos com forte dominância de 'A' e 'B'
      mut as list of string: stream = [
            "A", "B", "A", "C", "A", "D", "A", "B",
            "A", "E", "A", "B", "A", "F", "A", "B"
      ]
      mut as int64: n = listLength(stream)
      mut as int64: k = 4
      mut as int64: limiar = n /i k

      println("1. Tamanho do fluxo N: " + n)
      println("2. Parametro k: " + k + " (Capacidade maxima de contadores: " + (k - 1) + ")")
      println("3. Limiar teorico (N / k): " + limiar)

      mut as map: mg_res = mgProcess(stream, k)
      mut as list of string: candidatos = mg_res["keys"] as list of string
      mut as map: contadores = mg_res["counters"] as map

      println("4. Candidatos a Heavy Hitters retidos no resumo:")
      mut as int64: i = 1
      mut as int64: num_cand = listLength(candidatos)
      infinite (i <= num_cand) {
            mut as string: c_name = candidatos[i]
            println("   Item: '" + c_name + "' | Contador residual: " + contadores[c_name])
            i = i + 1
      }

      #L Segunda passagem: contagem exata dos candidatos para confirmar frequência > N/k
      println("5. Verificacao exata da frequencia real no stream:")
      mut as list of string: heavy_hitters = []
      i = 1
      infinite (i <= num_cand) {
            mut as string: c_cand = candidatos[i]
            mut as int64: freq_real = 0
            mut as int64: s_idx = 1
            infinite (s_idx <= n) {
                  route {
                        stream[s_idx] == c_cand ==> {
                              freq_real = freq_real + 1
                        }
                  }
                  s_idx = s_idx + 1
            }
            
            mut as bool: eh_hh = freq_real > limiar
            println("   Item '" + c_cand + "': frequencia real = " + freq_real + " (Supera limiar " + limiar + "? " + eh_hh + ")")
            route {
                  eh_hh ==> {
                        heavy_hitters = listPushBack(heavy_hitters, c_cand)
                  }
            }
            i = i + 1
      }

      mut as bool: contem_a = false
      infinite (hh in heavy_hitters) {
            route {
                  hh == "A" ==> {
                        contem_a = true
                        break
                  }
            }
      }

      mut as bool: ok = contem_a and (listLength(candidatos) <= (k - 1))
      println("6. Verificacao do Algoritmo Misra-Gries: " + ok)
      println("==================================================")
}
