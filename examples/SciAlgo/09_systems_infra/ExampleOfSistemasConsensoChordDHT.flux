#L ============================================================================
#L Algoritmo: Chord Distributed Hash Table (Chord DHT)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(log N) saltos de roteamento com tabela Finger de tamanho m
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (inHalfOpen) (as int64: x, as int64: a, as int64: b) as bool {
      #L Verifica se x pertence ao intervalo circular (a, b]
      mut as bool: res = false
      route {
            a < b ==> {
                  res = (x > a) and (x <= b)
            }
            a > b ==> {
                  res = (x > a) or (x <= b)
            }
            _ ==> {
                  res = true
            }
      }
      emit(nice, res, "ok")
}

function (inOpen) (as int64: x, as int64: a, as int64: b) as bool {
      #L Verifica se x pertence ao intervalo circular aberto (a, b)
      mut as bool: res = false
      route {
            a < b ==> {
                  res = (x > a) and (x < b)
            }
            a > b ==> {
                  res = (x > a) or (x < b)
            }
            _ ==> {
                  res = false
            }
      }
      emit(nice, res, "ok")
}

function (findSuccessorOfPos) (as int64: pos, as list of int64: nodes, as int64: numNodes) as int64 {
      mut as int64: res = nodes[1]
      mut as bool: found = false
      mut as int64: i = 1
      infinite (i <= numNodes) {
            route {
                  nodes[i] >= pos ==> {
                        res = nodes[i]
                        found = true
                        break
                  }
            }
            i = i + 1
      }
      route {
            not found ==> {
                  res = nodes[1]
            }
      }
      emit(nice, res, "ok")
}

program (ExampleOfSistemasConsensoChordDHT) {
      println("==================================================")
      println("  SciAlgo: Chord Distributed Hash Table (DHT)")
      println("==================================================")

      #L Espaco de identificadores: 2^m com m=6, anel modulo M=64
      mut as int64: m = 6
      mut as int64: ring_mod = 64

      #L Nos ativos no anel Chord
      mut as list of int64: nodes = [4, 12, 22, 35, 48, 58]
      mut as int64: num_nodes = 6

      #L Potencias de 2: 2^(i-1) para i=1..6
      mut as list of int64: powers = [1, 2, 4, 8, 16, 32]

      #L Tabela Finger achatada: num_nodes x m = 6 x 6 = 36 celulas
      mut as list of int64: fingers = []
      mut as int64: c = 1
      infinite (c <= 36) {
            fingers = listPushBack(fingers, 0)
            c = c + 1
      }

      #L Construcao das tabelas Finger para cada no
      println("1. Construindo Tabelas Finger (m=6, Modulo 64):")
      mut as int64: n_idx = 1
      infinite (n_idx <= num_nodes) {
            mut as int64: node_id = nodes[n_idx]
            print("   Node " + node_id + " Fingers: [")
            mut as int64: f_idx = 1
            infinite (f_idx <= m) {
                  mut as int64: p = powers[f_idx]
                  mut as int64: start = (node_id + p) /r ring_mod
                  route {
                        start < 0 ==> {
                              start = start + ring_mod
                        }
                  }
                  mut as int64: succ = findSuccessorOfPos(start, nodes, num_nodes)
                  fingers[(n_idx - 1) * m + f_idx] = succ
                  print(" " + succ)
                  f_idx = f_idx + 1
            }
            println(" ]")
            n_idx = n_idx + 1
      }

      #L ------------------------------------------------------------------------
      #L Roteamento de Consultas de Chaves no Anel Chord
      #L ------------------------------------------------------------------------
      println("2. Consultas e Roteamento de Chaves:")

      mut as list of int64: test_queries_start = [4, 12, 48]
      mut as list of int64: test_queries_key = [20, 45, 2]
      mut as int64: q = 1
      infinite (q <= 3) {
            mut as int64: start_node = test_queries_start[q]
            mut as int64: target_key = test_queries_key[q]
            println("   Consulta " + q + ": Origem = Node " + start_node + ", Chave Alvo = " + target_key)

            #L Percorrendo o anel atraves das tabelas Finger
            mut as int64: curr = start_node
            mut as int64: hops = 0
            mut as int64: max_hops = 10
            infinite (hops < max_hops) {
                  #L Encontra indice de curr na lista de nos
                  mut as int64: curr_idx = 1
                  mut as int64: idx_search = 1
                  infinite (idx_search <= num_nodes) {
                        route {
                              nodes[idx_search] == curr ==> {
                                    curr_idx = idx_search
                                    break
                              }
                        }
                        idx_search = idx_search + 1
                  }

                  mut as int64: curr_succ = fingers[(curr_idx - 1) * m + 1]

                  #L Se target_key in (curr, curr_succ], encontramos o no responsavel
                  mut as bool: reached = inHalfOpen(target_key, curr, curr_succ)
                  route {
                        reached ==> {
                              hops = hops + 1
                              println("      Salto " + hops + ": Node " + curr + " -> Sucessor Final = Node " + curr_succ)
                              break
                        }
                  }

                  #L Caso contrario, encaminha para o maior finger predecessor mais proximo
                  mut as int64: next_hop = curr_succ
                  mut as int64: f = m
                  infinite (f >= 1) {
                        mut as int64: f_node = fingers[(curr_idx - 1) * m + f]
                        mut as bool: is_closer = inOpen(f_node, curr, target_key)
                        route {
                              is_closer ==> {
                                    next_hop = f_node
                                    break
                              }
                        }
                        f = f - 1
                  }

                  hops = hops + 1
                  println("      Salto " + hops + ": Node " + curr + " encaminha para Node " + next_hop)
                  curr = next_hop
            }
            q = q + 1
      }

      println("3. Roteamento Chord finalizado com complexidade O(log N).")
}
