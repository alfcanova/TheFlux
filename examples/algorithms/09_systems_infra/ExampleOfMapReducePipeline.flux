#L ============================================================================
#L Algoritmo: Pipeline Distribuído MapReduce (Map, Shuffle/Partition, Reduce)
#L Domínio: 09_systems_infra / Categoria: Computação Distribuída e Processamento em Lote
#L Complexidade: O(N log N) por partição para ordenação e agrupamento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMapReducePipeline) {
      println("==================================================")
      println("  SciAlgo: Pipeline MapReduce (Map-Shuffle-Reduce)")
      println("==================================================")

      #L Documentos de entrada particionados em 3 chunks
      #L Dicionario de tokens:
      #L 1: flux, 2: distributed, 3: map, 4: reduce, 5: parallel, 6: pipeline
      mut as list of int64: doc1 = [1, 2, 3, 4]
      mut as list of int64: doc2 = [1, 5, 6, 3]
      mut as list of int64: doc3 = [2, 6, 1, 4]

      #L ----------------------------------------------------
      #L Fase 1: MAP
      #L Emite pares intermediarios (chave=token, valor=1, doc_id)
      #L ----------------------------------------------------
      mut as list of int64: map_keys = []
      mut as list of int64: map_vals = []
      mut as list of int64: map_docs = []

      #L Mapper 1
      mut as int64: i1 = 1
      infinite (i1 <= listLength(doc1)) {
            map_keys = listPushBack(map_keys, doc1[i1])
            map_vals = listPushBack(map_vals, 1)
            map_docs = listPushBack(map_docs, 1)
            i1 = i1 + 1
      }

      #L Mapper 2
      mut as int64: i2 = 1
      infinite (i2 <= listLength(doc2)) {
            map_keys = listPushBack(map_keys, doc2[i2])
            map_vals = listPushBack(map_vals, 1)
            map_docs = listPushBack(map_docs, 2)
            i2 = i2 + 1
      }

      #L Mapper 3
      mut as int64: i3 = 1
      infinite (i3 <= listLength(doc3)) {
            map_keys = listPushBack(map_keys, doc3[i3])
            map_vals = listPushBack(map_vals, 1)
            map_docs = listPushBack(map_docs, 3)
            i3 = i3 + 1
      }

      mut as int64: total_map_emits = listLength(map_keys)
      println("1. [Fase Map] Total de pares (chave, valor) emitidos: " + total_map_emits)

      #L ----------------------------------------------------
      #L Fase 2: SHUFFLE & PARTITION
      #L Distribui os pares entre 2 Reducers via hashing da chave
      #L ----------------------------------------------------
      mut as int64: num_reducers = 2
      mut as list of int64: part1_k = []
      mut as list of int64: part1_v = []
      mut as list of int64: part2_k = []
      mut as list of int64: part2_v = []

      mut as int64: p_idx = 1
      infinite (p_idx <= total_map_emits) {
            mut as int64: tk = map_keys[p_idx]
            mut as int64: tv = map_vals[p_idx]
            mut as int64: rid = ((tk * 17) /r num_reducers) + 1

            route {
                  rid == 1 ==> {
                        part1_k = listPushBack(part1_k, tk)
                        part1_v = listPushBack(part1_v, tv)
                  }
                  _ ==> {
                        part2_k = listPushBack(part2_k, tk)
                        part2_v = listPushBack(part2_v, tv)
                  }
            }
            p_idx = p_idx + 1
      }

      println("2. [Fase Shuffle] Particao 1 (Reducer 1): " + listLength(part1_k) + " pares")
      println("   [Fase Shuffle] Particao 2 (Reducer 2): " + listLength(part2_k) + " pares")

      #L Ordenacao local por chave dentro de cada particao (Shuffle-Sort)
      mut as int64: len1 = listLength(part1_k)
      mut as int64: a = 1
      infinite (a <= len1) {
            mut as int64: b = 1
            infinite (b < len1) {
                  route {
                        part1_k[b] > part1_k[b + 1] ==> {
                              mut as int64: tmp_k = part1_k[b]
                              part1_k[b] = part1_k[b + 1]
                              part1_k[b + 1] = tmp_k

                              mut as int64: tmp_v = part1_v[b]
                              part1_v[b] = part1_v[b + 1]
                              part1_v[b + 1] = tmp_v
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      mut as int64: len2 = listLength(part2_k)
      a = 1
      infinite (a <= len2) {
            mut as int64: b = 1
            infinite (b < len2) {
                  route {
                        part2_k[b] > part2_k[b + 1] ==> {
                              mut as int64: tmp_k = part2_k[b]
                              part2_k[b] = part2_k[b + 1]
                              part2_k[b + 1] = tmp_k

                              mut as int64: tmp_v = part2_v[b]
                              part2_v[b] = part2_v[b + 1]
                              part2_v[b + 1] = tmp_v
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      #L ----------------------------------------------------
      #L Fase 3: REDUCE (Agregacao por Chave)
      #L ----------------------------------------------------
      mut as list of int64: final_keys = []
      mut as list of int64: final_counts = []

      #L Processa Reducer 1
      mut as int64: r1_idx = 1
      infinite (r1_idx <= len1) {
            mut as int64: cur_k = part1_k[r1_idx]
            mut as int64: sum_v = 0
            infinite (r1_idx <= len1) {
                  route {
                        part1_k[r1_idx] == cur_k ==> {
                              sum_v = sum_v + part1_v[r1_idx]
                              r1_idx = r1_idx + 1
                        }
                        _ ==> {
                              break
                        }
                  }
            }
            final_keys = listPushBack(final_keys, cur_k)
            final_counts = listPushBack(final_counts, sum_v)
      }

      #L Processa Reducer 2
      mut as int64: r2_idx = 1
      infinite (r2_idx <= len2) {
            mut as int64: cur_k = part2_k[r2_idx]
            mut as int64: sum_v = 0
            infinite (r2_idx <= len2) {
                  route {
                        part2_k[r2_idx] == cur_k ==> {
                              sum_v = sum_v + part2_v[r2_idx]
                              r2_idx = r2_idx + 1
                        }
                        _ ==> {
                              break
                        }
                  }
            }
            final_keys = listPushBack(final_keys, cur_k)
            final_counts = listPushBack(final_counts, sum_v)
      }

      println("3. [Fase Reduce] Chaves reduzidas: " + final_keys)
      println("   [Fase Reduce] Contagens agregadas: " + final_counts)

      #L ----------------------------------------------------
      #L Verificação do Resultado Global
      #L ----------------------------------------------------
      mut as int64: total_words_counted = 0
      mut as int64: fi = 1
      mut as int64: num_res = listLength(final_counts)
      infinite (fi <= num_res) {
            total_words_counted = total_words_counted + final_counts[fi]
            fi = fi + 1
      }

      mut as bool: soma_correta = (total_words_counted == 12)
      mut as bool: reducers_balanceados = (len1 == 6) and (len2 == 6)
      mut as bool: pipeline_valido = soma_correta and reducers_balanceados

      println("4. Total de palavras computadas pelo pipeline: " + total_words_counted + " (Esperado: 12)")
      println("5. Verificacao de integridade e balanco do MapReduce: " + pipeline_valido)
      println("==================================================")
}
