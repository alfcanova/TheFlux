#L ============================================================================
#L Algoritmo: Robin Hood Hashing (Enderecamento Aberto com Balanceamento PSL)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: Insercao O(1) amortizado | Busca O(1) com Saida Antecipada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasRobinHoodHashing) {
      println("==================================================")
      println("  SciAlgo: Robin Hood Hashing (PSL Displacement)")
      println("==================================================")

      mut as int64: cap = 8
      println("1. Inicializando Hash Table com capacidade = " + cap + "...")

      #L Tabela (1-based, indices 1..8)
      #L 0 = slot livre
      mut as list of int64: table_key = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: table_val = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: table_psl = [-1, -1, -1, -1, -1, -1, -1, -1]

      #L Chaves e valores a inserir
      mut as list of int64: in_keys = [10, 20, 30, 40, 50]
      mut as list of int64: in_vals = [100, 200, 300, 400, 500]
      mut as int64: n_items = listLength(in_keys)

      println("2. Inserindo 5 elementos na tabela com Robin Hood swaps...")

      mut as int64: idx = 1
      infinite (idx <= n_items) {
            mut as int64: cur_k = in_keys[idx]
            mut as int64: cur_v = in_vals[idx]
            mut as int64: cur_psl = 0

            #L Hash inicial: 1..8
            mut as int64: slot = (((cur_k * 13) + 7) /r cap) + 1

            infinite (true) {
                  #L Se slot esta vazio
                  route {
                        table_key[slot] == 0 ==> {
                              table_key[slot] = cur_k
                              table_val[slot] = cur_v
                              table_psl[slot] = cur_psl
                              break
                        }
                  }

                  #L Se chave ja existe
                  route {
                        table_key[slot] == cur_k ==> {
                              table_val[slot] = cur_v
                              break
                        }
                  }

                  #L Se elemento existente tem PSL MENOR que o elemento atual
                  #L Rouba dos ricos (menor PSL) e da aos pobres (maior PSL)
                  route {
                        table_psl[slot] < cur_psl ==> {
                              #L Faz swap entre atual e ocupante
                              mut as int64: tmp_k = table_key[slot]
                              mut as int64: tmp_v = table_val[slot]
                              mut as int64: tmp_p = table_psl[slot]

                              table_key[slot] = cur_k
                              table_val[slot] = cur_v
                              table_psl[slot] = cur_psl

                              cur_k = tmp_k
                              cur_v = tmp_v
                              cur_psl = tmp_p
                        }
                  }

                  #L Avanca para proximo slot
                  cur_psl = cur_psl + 1
                  slot = (slot /r cap) + 1
            }

            println("   Item (" + in_keys[idx] + ", " + in_vals[idx] + ") inserido com sucesso.")
            idx = idx + 1
      }

      #L 3. Consultas com Saida Antecipada (Early Exit via PSL)
      println("3. Executando buscas na Robin Hood Hash Table:")

      #L Busca chave 10
      mut as int64: q10_slot = (((10 * 13) + 7) /r cap) + 1
      mut as int64: q10_psl = 0
      mut as int64: res_10 = -1
      infinite (q10_psl < cap) {
            route {
                  table_key[q10_slot] == 0 ==> { break }
                  table_psl[q10_slot] < q10_psl ==> { break }
                  table_key[q10_slot] == 10 ==> {
                        res_10 = table_val[q10_slot]
                        break
                  }
            }
            q10_psl = q10_psl + 1
            q10_slot = (q10_slot /r cap) + 1
      }
      println("   Get(10) [esperado 100]: " + res_10)

      #L Busca chave 30
      mut as int64: q30_slot = (((30 * 13) + 7) /r cap) + 1
      mut as int64: q30_psl = 0
      mut as int64: res_30 = -1
      infinite (q30_psl < cap) {
            route {
                  table_key[q30_slot] == 0 ==> { break }
                  table_psl[q30_slot] < q30_psl ==> { break }
                  table_key[q30_slot] == 30 ==> {
                        res_30 = table_val[q30_slot]
                        break
                  }
            }
            q30_psl = q30_psl + 1
            q30_slot = (q30_slot /r cap) + 1
      }
      println("   Get(30) [esperado 300]: " + res_30)

      #L Busca chave 50
      mut as int64: q50_slot = (((50 * 13) + 7) /r cap) + 1
      mut as int64: q50_psl = 0
      mut as int64: res_50 = -1
      infinite (q50_psl < cap) {
            route {
                  table_key[q50_slot] == 0 ==> { break }
                  table_psl[q50_slot] < q50_psl ==> { break }
                  table_key[q50_slot] == 50 ==> {
                        res_50 = table_val[q50_slot]
                        break
                  }
            }
            q50_psl = q50_psl + 1
            q50_slot = (q50_slot /r cap) + 1
      }
      println("   Get(50) [esperado 500]: " + res_50)

      #L Busca chave 99 (ausente - saida antecipada rapida)
      mut as int64: q99_slot = (((99 * 13) + 7) /r cap) + 1
      mut as int64: q99_psl = 0
      mut as int64: res_99 = -1
      infinite (q99_psl < cap) {
            route {
                  table_key[q99_slot] == 0 ==> { break }
                  table_psl[q99_slot] < q99_psl ==> { break }
                  table_key[q99_slot] == 99 ==> {
                        res_99 = table_val[q99_slot]
                        break
                  }
            }
            q99_psl = q99_psl + 1
            q99_slot = (q99_slot /r cap) + 1
      }
      println("   Get(99 ausente) [esperado -1]: " + res_99)

      #L 4. Calculo do Maximo PSL (balanceamento da tabela)
      mut as int64: max_psl = 0
      mut as int64: s = 1
      infinite (s <= cap) {
            route {
                  table_psl[s] > max_psl ==> {
                        max_psl = table_psl[s]
                  }
            }
            s = s + 1
      }
      println("4. Maior Probe Sequence Length (PSL max): " + max_psl)

      mut as bool: ok = (res_10 == 100) and (res_30 == 300) and (res_50 == 500) and (res_99 == -1) and (max_psl <= 3)
      println("5. Verificacao geral do Robin Hood Hashing: " + ok)
      println("Concluido com Sucesso")
}
