#L ============================================================================
#L Algoritmo: Anel de Hashing Consistente com Nós Virtuais (Consistent Hashing)
#L Domínio: 09_systems_infra / Categoria: Roteamento Distribuído e DHTs
#L Complexidade: Roteamento O(log V) ou O(V) no anel; Migração O(K/N) na reconfiguração
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (vnodeHash) (as int64: nodeId, as int64: rep) as int64 {
      mut as int64: m = 360
      mut as int64: raw = (nodeId * 107) + (rep * 79) + 31
      mut as int64: res = raw /r m
      emit(nice, res, "ok")
}

function (keyHash) (as int64: k) as int64 {
      mut as int64: m = 360
      mut as int64: raw = (k * 137) + 17
      mut as int64: res = raw /r m
      emit(nice, res, "ok")
}

function (findOwnerNode) (as int64: k, as list of int64: ringPos, as list of int64: ringNode) as int64 {
      mut as int64: kh = keyHash(k)
      mut as int64: total = listLength(ringPos)
      mut as int64: selected_node = ringNode[1]
      mut as bool: found = false
      mut as int64: i = 1
      infinite (i <= total) {
            route {
                  ringPos[i] >= kh ==> {
                        selected_node = ringNode[i]
                        found = true
                        break
                  }
            }
            i = i + 1
      }
      #L Se der a volta no anel (kh maior que todos os vnodes), retorna o primeiro no
      route {
            not found ==> {
                  selected_node = ringNode[1]
            }
      }
      emit(nice, selected_node, "ok")
}

program (ExampleOfSistemasConsensoConsistentHashingRing) {
      println("==================================================")
      println("  SciAlgo: Anel de Hashing Consistente (VNodes)")
      println("==================================================")

      #L Inicialmente 3 servidores fisicos (Node 1, Node 2, Node 3)
      #L Cada servidor possui 3 replicas virtuais (vnodes) no anel
      mut as list of int64: ring_pos = []
      mut as list of int64: ring_node = []

      mut as int64: n_id = 1
      infinite (n_id <= 3) {
            mut as int64: rep = 1
            infinite (rep <= 3) {
                  mut as int64: p = vnodeHash(n_id, rep)
                  ring_pos = listPushBack(ring_pos, p)
                  ring_node = listPushBack(ring_node, n_id)
                  rep = rep + 1
            }
            n_id = n_id + 1
      }

      #L Ordena anel por posicao angular (Bubble sort conjunto)
      mut as int64: v_count = listLength(ring_pos)
      mut as int64: a = 1
      infinite (a <= v_count) {
            mut as int64: b = 1
            infinite (b < v_count) {
                  route {
                        ring_pos[b] > ring_pos[b + 1] ==> {
                              mut as int64: tmp_p = ring_pos[b]
                              ring_pos[b] = ring_pos[b + 1]
                              ring_pos[b + 1] = tmp_p

                              mut as int64: tmp_n = ring_node[b]
                              ring_node[b] = ring_node[b + 1]
                              ring_node[b + 1] = tmp_n
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      println("1. Total de nos virtuais no anel inicial: " + v_count)
      println("   Posicoes no anel: " + ring_pos)
      println("   Nos correspondentes: " + ring_node)

      #L Roteia 12 chaves de aplicacao no anel inicial
      mut as list of int64: init_owners = []
      mut as int64: k = 1
      infinite (k <= 12) {
            mut as int64: owner = findOwnerNode(k, ring_pos, ring_node)
            init_owners = listPushBack(init_owners, owner)
            k = k + 1
      }
      println("2. Mapeamento inicial das chaves (1..12): " + init_owners)

      #L Adiciona Servidor 4 (Node 4) com 3 novos vnodes
      mut as int64: r4 = 1
      infinite (r4 <= 3) {
            mut as int64: p4 = vnodeHash(4, r4)
            ring_pos = listPushBack(ring_pos, p4)
            ring_node = listPushBack(ring_node, 4)
            r4 = r4 + 1
      }

      #L Reordena anel com o novo no
      v_count = listLength(ring_pos)
      a = 1
      infinite (a <= v_count) {
            mut as int64: b = 1
            infinite (b < v_count) {
                  route {
                        ring_pos[b] > ring_pos[b + 1] ==> {
                              mut as int64: tmp_p = ring_pos[b]
                              ring_pos[b] = ring_pos[b + 1]
                              ring_pos[b + 1] = tmp_p

                              mut as int64: tmp_n = ring_node[b]
                              ring_node[b] = ring_node[b + 1]
                              ring_node[b + 1] = tmp_n
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      #L Roteia as mesmas 12 chaves apos a expansao
      mut as list of int64: new_owners = []
      mut as int64: migradas = 0
      k = 1
      infinite (k <= 12) {
            mut as int64: new_owner = findOwnerNode(k, ring_pos, ring_node)
            new_owners = listPushBack(new_owners, new_owner)
            route {
                  new_owner != init_owners[k] ==> {
                        migradas = migradas + 1
                  }
            }
            k = k + 1
      }

      println("3. Mapeamento apos adicao do No 4: " + new_owners)
      println("4. Quantidade de chaves migradas: " + migradas + " de 12")

      #L Verificacoes de corretude:
      #L - Apenas uma fracao minoritaria (~1/N = 3 de 12) deve migrar
      #L - As chaves migradas devem ter ido especificamente para o No 4 recem-adicionado
      mut as bool: migracao_valida = (migradas == 3)
      mut as bool: apenas_para_novo_no = true
      k = 1
      infinite (k <= 12) {
            route {
                  init_owners[k] != new_owners[k] ==> {
                        route {
                              new_owners[k] != 4 ==> {
                                    apenas_para_novo_no = false
                              }
                        }
                  }
            }
            k = k + 1
      }

      mut as bool: hashing_correto = migracao_valida and apenas_para_novo_no
      println("5. Verificacao de estabilidade do Hashing Consistente: " + hashing_correto)
      println("==================================================")
}
