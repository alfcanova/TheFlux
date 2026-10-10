#L ============================================================================
#L Algoritmo: Kademlia Distributed Hash Table (Kademlia DHT)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(log N) saltos de roteamento baseado na métrica XOR
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (xorDistance) (as int64: a, as int64: b) as int64 {
      mut as int64: dist = a ^ b
      emit(nice, dist, "ok")
}

program (ExampleOfSistemasConsensoKademlia) {
      println("==================================================")
      println("  SciAlgo: Kademlia DHT (Métrica de Distância XOR)")
      println("==================================================")

      #L Espaço de identificadores de 6 bits (0 a 63)
      mut as int64: my_id = 18
      mut as int64: target_key = 45

      println("1. Identificador local: " + my_id + " (Binário: 010010)")
      println("   Chave alvo de busca: " + target_key + " (Binário: 101101)")
      mut as int64: initial_dist = xorDistance(my_id, target_key)
      println("   Distância XOR inicial d(" + my_id + ", " + target_key + ") = " + initial_dist)

      #L Nós da rede conhecidos pelo roteador
      mut as list of int64: peer_ids = [5, 14, 25, 34, 42, 53, 60]
      mut as int64: num_peers = listLength(peer_ids)

      #L Cálculo das distâncias XOR de todos os pares para o nó local (distribuição em k-buckets)
      println("2. Alocação em k-buckets com base em d(my_id, peer):")
      mut as int64: p = 1
      infinite (p <= num_peers) {
            mut as int64: pid = peer_ids[p]
            mut as int64: d_local = xorDistance(my_id, pid)
            #L Prefixo comum determina o índice do bucket (1 a 6)
            mut as int64: bucket_idx = 1
            mut as int64: temp = d_local
            infinite (temp > 1) {
                  temp = temp /i 2
                  bucket_idx = bucket_idx + 1
            }
            println("   No " + pid + " -> Dist local = " + d_local + " => Alocado no Bucket " + bucket_idx)
            p = p + 1
      }

      #L ------------------------------------------------------------------------
      #L Busca iterativa de nós (Node Lookup) em direção a target_key
      #L ------------------------------------------------------------------------
      println("3. Executando Busca Iterativa (α=1 por simplificação didática):")

      #L Estado do lookup: nó atual no salto
      mut as int64: current_node = my_id
      mut as int64: current_dist = initial_dist
      mut as int64: hop = 0

      #L Lista de candidatos conhecidos no início
      mut as list of int64: candidates = [18, 5, 14, 25, 34, 42, 53, 60]
      mut as int64: num_cand = listLength(candidates)

      #L No salto 2, a rede revela nó 44 (que estava na tabela de 42)
      #L No salto 3, a rede revela nó 45 (o próprio detentor da chave)
      mut as bool: reached = false

      infinite (hop < 5) {
            hop = hop + 1

            #L Encontra o candidato mais próximo ao target_key na lista de candidatos
            mut as int64: best_cand = candidates[1]
            mut as int64: min_dist = xorDistance(best_cand, target_key)

            mut as int64: c_idx = 2
            infinite (c_idx <= num_cand) {
                  mut as int64: cand = candidates[c_idx]
                  mut as int64: d_cand = xorDistance(cand, target_key)
                  route {
                        d_cand < min_dist ==> {
                              min_dist = d_cand
                              best_cand = cand
                        }
                  }
                  c_idx = c_idx + 1
            }

            println("   [Salto " + hop + "] Consultando No mais proximo: " + best_cand + " (distancia XOR = " + min_dist + ")")

            route {
                  best_cand == target_key ==> {
                        println("   -> Chave exata " + target_key + " encontrada no No " + best_cand + "!")
                        reached = true
                  }
            }

            route {
                  reached ==> {
                        break
                  }
            }

            #L Descoberta de novos vizinhos no roteamento distribuido
            route {
                  best_cand == 42 ==> {
                        println("      -> No 42 retorna novo vizinho: No 44 (distancia " + xorDistance(44, target_key) + ")")
                        candidates = listPushBack(candidates, 44)
                        candidates = listPushBack(candidates, 45)
                        num_cand = listLength(candidates)
                  }
            }

            #L Remove o candidato já consultado marcando distância infinita
            c_idx = 1
            infinite (c_idx <= num_cand) {
                  route {
                        candidates[c_idx] == best_cand ==> {
                              candidates[c_idx] = 9999
                        }
                  }
                  c_idx = c_idx + 1
            }
      }

      println("4. Convergência Kademlia concluída com sucesso em " + hop + " saltos.")
}
