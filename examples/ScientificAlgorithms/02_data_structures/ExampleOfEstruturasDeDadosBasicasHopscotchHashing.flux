#L ============================================================================
#L Algoritmo: Hopscotch Hashing (Enderecamento Aberto com Vizinhança H Limitada)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: Busca O(1) Pior Caso no raio H | Insercao O(1) amortizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasHopscotchHashing) {
      println("==================================================")
      println("  SciAlgo: Hopscotch Hashing (Bounded Hop H=4)")
      println("==================================================")

      #L Capacidade da tabela = 16, raio de vizinhança H = 4
      mut as int64: cap = 16
      mut as int64: h_bound = 4
      println("1. Inicializando Hopscotch Hash Table com cap = " + cap + ", H = " + h_bound + "...")

      #L Tabelas de armazenamento (1-based, 1..16)
      #L 0 = slot livre
      mut as list of int64: slot_key = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: slot_val = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      #L Balde de origem para cada slot ocupado (para rastrear deslocamentos)
      mut as list of int64: slot_home = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      #L Itens a inserir
      mut as list of int64: in_keys = [10, 26, 42, 58, 15, 31]
      mut as list of int64: in_vals = [100, 260, 420, 580, 150, 310]
      mut as int64: n_items = listLength(in_keys)

      #L Funcao hash: ((k * 7 + 3) /r cap) + 1 (1..16)
      println("2. Inserindo " + n_items + " elementos com garantia de vizinhança Hopscotch...")

      mut as int64: idx = 1
      infinite (idx <= n_items) {
            mut as int64: k = in_keys[idx]
            mut as int64: v = in_vals[idx]
            mut as int64: home = (((k * 7) + 3) /r cap) + 1

            #L 1. Encontra primeiro slot livre via sondagem linear
            mut as int64: free_slot = home
            mut as int64: probe_steps = 0
            infinite (probe_steps < cap) {
                  route {
                        slot_key[free_slot] == 0 ==> { break }
                  }
                  probe_steps = probe_steps + 1
                  free_slot = (free_slot /r cap) + 1
            }

            #L 2. Desloca slot livre ate que a distancia de 'home' seja < H (h_bound)
            infinite (true) {
                  #L Calcula distancia circular de home ate free_slot
                  mut as int64: dist = 0
                  route {
                        free_slot >= home ==> { dist = free_slot - home }
                        _ ==> { dist = (free_slot + cap) - home }
                  }

                  route {
                        dist < h_bound ==> {
                              #L Slot livre esta dentro da vizinhança aceitavel!
                              slot_key[free_slot] = k
                              slot_val[free_slot] = v
                              slot_home[free_slot] = home
                              break
                        }
                  }

                  #L Precisa deslocar um elemento anterior para free_slot
                  #L Procura candidato a swap nos H-1 slots anteriores a free_slot
                  mut as int64: cand_offset = h_bound - 1
                  mut as int64: swapped_slot = 0

                  infinite (cand_offset > 0) {
                        mut as int64: cand_slot = free_slot - cand_offset
                        route {
                              cand_slot <= 0 ==> { cand_slot = cand_slot + cap }
                        }

                        mut as int64: cand_home = slot_home[cand_slot]
                        #L Verifica se cand_home consegue cobrir free_slot (dist < H)
                        mut as int64: dist_to_free = 0
                        route {
                              free_slot >= cand_home ==> { dist_to_free = free_slot - cand_home }
                              _ ==> { dist_to_free = (free_slot + cap) - cand_home }
                        }

                        route {
                              dist_to_free < h_bound ==> {
                                    #L Realiza hop: move candidato para free_slot
                                    slot_key[free_slot] = slot_key[cand_slot]
                                    slot_val[free_slot] = slot_val[cand_slot]
                                    slot_home[free_slot] = slot_home[cand_slot]

                                    slot_key[cand_slot] = 0
                                    slot_val[cand_slot] = 0
                                    slot_home[cand_slot] = 0

                                    swapped_slot = cand_slot
                                    break
                              }
                        }
                        cand_offset = cand_offset - 1
                  }

                  #L Novo slot livre e o slot que cedeu o elemento
                  free_slot = swapped_slot
            }

            println("   Chave " + k + " inserida (home = " + home + ", final_slot = " + free_slot + ")")
            idx = idx + 1
      }

      #L 3. Consultas Garantidas em O(H) passos (H = 4 comparacoes maximo)
      println("3. Executando buscas O(1) no raio de vizinhança H = 4:")

      #L Busca chave 10
      mut as int64: q10_home = (((10 * 7) + 3) /r cap) + 1
      mut as int64: res10 = -1
      mut as int64: step = 0
      mut as int64: cur_s = q10_home
      infinite (step < h_bound) {
            route {
                  slot_key[cur_s] == 10 ==> {
                        res10 = slot_val[cur_s]
                        break
                  }
            }
            step = step + 1
            cur_s = (cur_s /r cap) + 1
      }
      println("   Get(10) [esperado 100]: " + res10)

      #L Busca chave 42
      mut as int64: q42_home = (((42 * 7) + 3) /r cap) + 1
      mut as int64: res42 = -1
      step = 0
      cur_s = q42_home
      infinite (step < h_bound) {
            route {
                  slot_key[cur_s] == 42 ==> {
                        res42 = slot_val[cur_s]
                        break
                  }
            }
            step = step + 1
            cur_s = (cur_s /r cap) + 1
      }
      println("   Get(42) [esperado 420]: " + res42)

      #L Busca chave 31
      mut as int64: q31_home = (((31 * 7) + 3) /r cap) + 1
      mut as int64: res31 = -1
      step = 0
      cur_s = q31_home
      infinite (step < h_bound) {
            route {
                  slot_key[cur_s] == 31 ==> {
                        res31 = slot_val[cur_s]
                        break
                  }
            }
            step = step + 1
            cur_s = (cur_s /r cap) + 1
      }
      println("   Get(31) [esperado 310]: " + res31)

      #L Busca chave 99 (ausente - verificado em no maximo H comparacoes)
      mut as int64: q99_home = (((99 * 7) + 3) /r cap) + 1
      mut as int64: res99 = -1
      step = 0
      cur_s = q99_home
      infinite (step < h_bound) {
            route {
                  slot_key[cur_s] == 99 ==> {
                        res99 = slot_val[cur_s]
                        break
                  }
            }
            step = step + 1
            cur_s = (cur_s /r cap) + 1
      }
      println("   Get(99 ausente) [esperado -1]: " + res99)

      #L 4. Validacao de que todos os itens respeitam a distancia < H de seus baldes home
      mut as bool: all_bounded = true
      mut as int64: s = 1
      infinite (s <= cap) {
            route {
                  slot_key[s] != 0 ==> {
                        mut as int64: sh = slot_home[s]
                        mut as int64: s_dist = 0
                        route {
                              s >= sh ==> { s_dist = s - sh }
                              _ ==> { s_dist = (s + cap) - sh }
                        }
                        route {
                              s_dist >= h_bound ==> { all_bounded = false }
                        }
                  }
            }
            s = s + 1
      }
      println("4. Todos os itens alocados estao a distancia < H da origem: " + all_bounded)

      mut as bool: ok = (res10 == 100) and (res42 == 420) and (res31 == 310) and (res99 == -1) and all_bounded
      println("5. Verificacao geral do Hopscotch Hashing: " + ok)
      println("Concluido com Sucesso")
}
