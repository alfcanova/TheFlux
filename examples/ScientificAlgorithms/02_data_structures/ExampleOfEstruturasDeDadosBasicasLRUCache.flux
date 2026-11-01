#L ============================================================================
#L Algoritmo: LRU Cache (Least Recently Used Cache O(1))
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: get O(1) | put O(1) | Espaco O(Capacidade)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasLRUCache) {
      println("==================================================")
      println("  SciAlgo: LRU Cache (Lista Duplamente Encadeada)")
      println("==================================================")

      mut as int64: cap = 3
      println("1. Criando LRU Cache com capacidade = " + cap)

      #L Representacao dos nos da lista duplamente encadeada (1-based, 0 = NULL)
      mut as list of int64: node_key = [0]
      mut as list of int64: node_val = [0]
      mut as list of int64: node_prev = [0]
      mut as list of int64: node_next = [0]
      mut as int64: head = 0 #L Mais recentemente usado (MRU)
      mut as int64: tail = 0 #L Menos recentemente usado (LRU - candidato a eviction)
      mut as int64: cur_size = 0

      #L Operacao Put (chave, valor)
      #L Inserindo chaves: (1, 10), (2, 20), (3, 30)
      mut as list of int64: put_k = [1, 2, 3, 4]
      mut as list of int64: put_v = [10, 20, 30, 40]

      println("2. Inserindo primeiras 3 chaves: (1, 10), (2, 20), (3, 30)...")

      mut as int64: pi = 1
      infinite (pi <= 3) {
            mut as int64: k = put_k[pi]
            mut as int64: v = put_v[pi]

            #L Aloca novo no
            node_key = listPushBack(node_key, k)
            node_val = listPushBack(node_val, v)
            node_prev = listPushBack(node_prev, 0)
            node_next = listPushBack(node_next, 0)
            mut as int64: new_node = listLength(node_key) - 1

            #L Insere na frente (Head)
            route {
                  head == 0 ==> {
                        head = new_node
                        tail = new_node
                  }
                  _ ==> {
                        node_next[new_node] = head
                        node_prev[head] = new_node
                        head = new_node
                  }
            }
            cur_size = cur_size + 1
            pi = pi + 1
      }
      println("   Cache preenchido. Tamanho atual: " + cur_size + ", Head (MRU): " + node_key[head] + ", Tail (LRU): " + node_key[tail])

      #L Operacao Get(1): Deve promover 1 para Head (Head vira 1, Tail permanece 2)
      println("3. Acessando Get(1)...")
      #L Procura no 1 na lista
      mut as int64: curr = head
      mut as int64: target_node = 0
      infinite (curr != 0) {
            route {
                  node_key[curr] == 1 ==> {
                        target_node = curr
                        break
                  }
                  _ ==> {
                        curr = node_next[curr]
                  }
            }
      }

      mut as int64: val_1 = -1
      route {
            target_node != 0 ==> {
                  val_1 = node_val[target_node]
                  #L Move target_node para a Head se nao for ja a Head
                  route {
                        target_node != head ==> {
                              mut as int64: p = node_prev[target_node]
                              mut as int64: nx = node_next[target_node]

                              node_next[p] = nx
                              route {
                                    nx != 0 ==> {
                                          node_prev[nx] = p
                                    }
                                    _ ==> {
                                          #L target_node era a tail
                                          tail = p
                                    }
                              }

                              #L Conecta target_node na head
                              node_prev[target_node] = 0
                              node_next[target_node] = head
                              node_prev[head] = target_node
                              head = target_node
                        }
                        _ ==> {
                        }
                  }
            }
            _ ==> {
            }
      }
      println("   Valor de Get(1): " + val_1 + " | Nova Head (MRU): " + node_key[head] + " | Nova Tail (LRU): " + node_key[tail])

      #L Operacao Put(4, 40): Como cur_size == cap (3), deve evictar a Tail (no chave 2)!
      println("4. Inserindo (4, 40) com cache cheio -> Deve evictar a Tail atual (" + node_key[tail] + ")...")
      mut as int64: evict_key = node_key[tail]

      #L Desconecta Tail antiga
      mut as int64: old_tail = tail
      tail = node_prev[old_tail]
      route {
            tail != 0 ==> {
                  node_next[tail] = 0
            }
            _ ==> {
                  head = 0
            }
      }
      cur_size = cur_size - 1

      #L Insere novo no (4, 40) na Head
      node_key = listPushBack(node_key, 4)
      node_val = listPushBack(node_val, 40)
      node_prev = listPushBack(node_prev, 0)
      node_next = listPushBack(node_next, 0)
      mut as int64: node_4 = listLength(node_key) - 1

      node_next[node_4] = head
      node_prev[head] = node_4
      head = node_4
      cur_size = cur_size + 1

      println("   Chave evictada com sucesso: " + evict_key)
      println("   Novo estado: Head (MRU): " + node_key[head] + ", Tail (LRU): " + node_key[tail])

      #L Verificacoes de Get:
      #L Get(2) deve falhar (-1, evictada)
      #L Get(1) deve retornar 10
      #L Get(3) deve retornar 30
      #L Get(4) deve retornar 40
      println("5. Consultando chaves restantes no cache:")

      #L Busca chave 2
      curr = head
      mut as int64: val_2 = -1
      infinite (curr != 0) {
            route {
                  node_key[curr] == 2 ==> {
                        val_2 = node_val[curr]
                        break
                  }
                  _ ==> {
                        curr = node_next[curr]
                  }
            }
      }
      println("   Get(2) (esperado -1): " + val_2)

      #L Busca chave 3
      curr = head
      mut as int64: val_3 = -1
      infinite (curr != 0) {
            route {
                  node_key[curr] == 3 ==> {
                        val_3 = node_val[curr]
                        break
                  }
                  _ ==> {
                        curr = node_next[curr]
                  }
            }
      }
      println("   Get(3) (esperado 30): " + val_3)

      #L Busca chave 4
      curr = head
      mut as int64: val_4 = -1
      infinite (curr != 0) {
            route {
                  node_key[curr] == 4 ==> {
                        val_4 = node_val[curr]
                        break
                  }
                  _ ==> {
                        curr = node_next[curr]
                  }
            }
      }
      println("   Get(4) (esperado 40): " + val_4)

      mut as bool: ok = (val_1 == 10) and (evict_key == 2) and (val_2 == -1) and (val_3 == 30) and (val_4 == 40) and (cur_size == 3)
      println("6. Verificacao geral do LRU Cache: " + ok)
      println("Concluido com Sucesso")
}
