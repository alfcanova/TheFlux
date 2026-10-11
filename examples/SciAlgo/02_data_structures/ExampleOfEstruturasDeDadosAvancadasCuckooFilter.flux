#L ============================================================================
#L Algoritmo: Cuckoo Filter (Filtro Probabilistico com Suporte a Remocao)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: insert O(1) amortizado | lookup O(1) | delete O(1) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasCuckooFilter) {
      println("==================================================")
      println("  SciAlgo: Cuckoo Filter (Fingerprints & Eviction)")
      println("==================================================")

      #L Parametros: 8 baldes, cada balde com 2 slots
      mut as int64: num_buckets = 8
      mut as int64: max_kicks = 20
      println("1. Inicializando Cuckoo Filter: " + num_buckets + " baldes com 2 slots cada...")

      #L Baldes: 0 = vazio (1-based indices 1..8)
      mut as list of int64: slot1 = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: slot2 = [0, 0, 0, 0, 0, 0, 0, 0]

      #L Funcao auxiliar inline de hash para fingerprint: 1..255
      #L fp(x) = ((x * 37 + 11) /r 255) + 1
      #L h1(x) = ((x * 101 + 17) /r num_buckets) + 1
      #L h_fp(fp) = ((fp * 67 + 23) /r num_buckets) + 1

      #L 2. Insercao de chaves: 101, 202, 303, 404, 505
      mut as list of int64: to_insert = [101, 202, 303, 404, 505]
      mut as int64: n_keys = listLength(to_insert)
      println("2. Inserindo chaves: 101, 202, 303, 404, 505...")

      mut as int64: ki = 1
      infinite (ki <= n_keys) {
            mut as int64: key = to_insert[ki]

            mut as int64: fp = (((key * 37) + 11) /r 255) + 1
            mut as int64: i1 = (((key * 101) + 17) /r num_buckets) + 1
            mut as int64: h_fp = (((fp * 67) + 23) /r num_buckets)

            #L i2 = ((i1 - 1) ^ h_fp) /r num_buckets + 1
            mut as int64: i2 = (((i1 - 1) ^ h_fp) /r num_buckets) + 1

            #L Tenta inserir no balde i1
            mut as bool: inserted = false
            route {
                  slot1[i1] == 0 ==> {
                        slot1[i1] = fp
                        inserted = true
                  }
                  slot2[i1] == 0 ==> {
                        slot2[i1] = fp
                        inserted = true
                  }
                  _ ==> {
                        #L Tenta inserir no balde i2
                        route {
                              slot1[i2] == 0 ==> {
                                    slot1[i2] = fp
                                    inserted = true
                              }
                              slot2[i2] == 0 ==> {
                                    slot2[i2] = fp
                                    inserted = true
                              }
                        }
                  }
            }

            #L Se ambos estiverem cheios, executa cuckoo kick-out
            route {
                  inserted == false ==> {
                        mut as int64: curr_b = i1
                        mut as int64: curr_fp = fp
                        mut as int64: k = 1
                        infinite (k <= max_kicks) {
                              #L Chuta slot1 de curr_b
                              mut as int64: evicted_fp = slot1[curr_b]
                              slot1[curr_b] = curr_fp
                              curr_fp = evicted_fp

                              #L Novo balde da vitima: curr_b = ((curr_b - 1) ^ hash(curr_fp)) /r num_buckets + 1
                              mut as int64: vict_h = (((curr_fp * 67) + 23) /r num_buckets)
                              curr_b = (((curr_b - 1) ^ vict_h) /r num_buckets) + 1

                              #L Verifica se novo balde tem espaco
                              route {
                                    slot1[curr_b] == 0 ==> {
                                          slot1[curr_b] = curr_fp
                                          inserted = true
                                          break
                                    }
                                    slot2[curr_b] == 0 ==> {
                                          slot2[curr_b] = curr_fp
                                          inserted = true
                                          break
                                    }
                              }
                              k = k + 1
                        }
                  }
            }

            println("   Chave " + key + " inserida (fp=" + fp + ", i1=" + i1 + ", i2=" + i2 + ")")
            ki = ki + 1
      }

      #L 3. Teste de Busca (Lookup)
      println("3. Verificando presenca das chaves...")

      #L Busca 101
      mut as int64: q101_fp = (((101 * 37) + 11) /r 255) + 1
      mut as int64: q101_i1 = (((101 * 101) + 17) /r num_buckets) + 1
      mut as int64: q101_hfp = (((q101_fp * 67) + 23) /r num_buckets)
      mut as int64: q101_i2 = (((q101_i1 - 1) ^ q101_hfp) /r num_buckets) + 1
      mut as bool: has_101 = (slot1[q101_i1] == q101_fp) or (slot2[q101_i1] == q101_fp) or (slot1[q101_i2] == q101_fp) or (slot2[q101_i2] == q101_fp)
      println("   Lookup 101: " + has_101)

      #L Busca 202
      mut as int64: q202_fp = (((202 * 37) + 11) /r 255) + 1
      mut as int64: q202_i1 = (((202 * 101) + 17) /r num_buckets) + 1
      mut as int64: q202_hfp = (((q202_fp * 67) + 23) /r num_buckets)
      mut as int64: q202_i2 = (((q202_i1 - 1) ^ q202_hfp) /r num_buckets) + 1
      mut as bool: has_202 = (slot1[q202_i1] == q202_fp) or (slot2[q202_i1] == q202_fp) or (slot1[q202_i2] == q202_fp) or (slot2[q202_i2] == q202_fp)
      println("   Lookup 202: " + has_202)

      #L Busca 999 (ausente)
      mut as int64: q999_fp = (((999 * 37) + 11) /r 255) + 1
      mut as int64: q999_i1 = (((999 * 101) + 17) /r num_buckets) + 1
      mut as int64: q999_hfp = (((q999_fp * 67) + 23) /r num_buckets)
      mut as int64: q999_i2 = (((q999_i1 - 1) ^ q999_hfp) /r num_buckets) + 1
      mut as bool: has_999 = (slot1[q999_i1] == q999_fp) or (slot2[q999_i1] == q999_fp) or (slot1[q999_i2] == q999_fp) or (slot2[q999_i2] == q999_fp)
      println("   Lookup 999 (ausente): " + has_999)

      #L 4. Remocao da chave 202
      println("4. Removendo chave 202 do Cuckoo Filter...")
      mut as bool: deleted_202 = false
      route {
            slot1[q202_i1] == q202_fp ==> {
                  slot1[q202_i1] = 0
                  deleted_202 = true
            }
            slot2[q202_i1] == q202_fp ==> {
                  slot2[q202_i1] = 0
                  deleted_202 = true
            }
            slot1[q202_i2] == q202_fp ==> {
                  slot1[q202_i2] = 0
                  deleted_202 = true
            }
            slot2[q202_i2] == q202_fp ==> {
                  slot2[q202_i2] = 0
                  deleted_202 = true
            }
      }
      println("   Remocao de 202 efetuada: " + deleted_202)

      #L Re-busca de 202 apos delecao -> deve ser false
      mut as bool: has_202_after = (slot1[q202_i1] == q202_fp) or (slot2[q202_i1] == q202_fp) or (slot1[q202_i2] == q202_fp) or (slot2[q202_i2] == q202_fp)
      println("   Lookup 202 apos remocao (esperado false): " + has_202_after)

      #L Verificacao de que 101 continua intacto
      mut as bool: has_101_after = (slot1[q101_i1] == q101_fp) or (slot2[q101_i1] == q101_fp) or (slot1[q101_i2] == q101_fp) or (slot2[q101_i2] == q101_fp)
      println("   Lookup 101 permanece intacto: " + has_101_after)

      mut as bool: ok = has_101 and has_202 and (has_999 == false) and deleted_202 and (has_202_after == false) and has_101_after
      println("5. Verificacao geral do Cuckoo Filter: " + ok)
      println("Concluido com Sucesso")
}
