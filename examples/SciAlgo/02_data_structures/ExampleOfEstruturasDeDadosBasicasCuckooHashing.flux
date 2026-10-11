#L ============================================================================
#L Algoritmo: Cuckoo Hashing (Hash com Desalojamento de Pagh & Rodler 2001)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados basicas
#L Complexidade: O(1) busca no pior caso | O(1) insercao amortizada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasCuckooHashing) {
      println("==================================================")
      println("  SciAlgo: Cuckoo Hashing (Estruturas Basicas)")
      println("==================================================")

      mut as int64: m = 7 #L Tamanho de cada tabela hash
      #L Duas tabelas independentes: T1 e T2 (0 = celula vazia)
      mut as list of int64: t1 = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: t2 = [0, 0, 0, 0, 0, 0, 0]

      #L Chaves para insercao: 15, 22, 29, 36
      #L h1(x) = ((x * 3 + 1) /r m) + 1
      #L h2(x) = ((x * 5 + 3) /r m) + 1
      mut as list of int64: keys = [15, 22, 29, 36]
      mut as int64: total_kicks = 0

      println("1. Inserindo chaves com Cuckoo Hashing: " + keys)
      mut as int64: ki = 1
      infinite (ki <= listLength(keys)) {
            mut as int64: curr_key = keys[ki]
            mut as int64: curr_table = 1
            mut as int64: loop_count = 0

            infinite (loop_count < 10) {
                  loop_count = loop_count + 1
                  route {
                        curr_table == 1 ==> {
                              mut as int64: pos1 = ((curr_key * 3 + 1) /r m) + 1
                              route {
                                    t1[pos1] == 0 ==> {
                                          t1[pos1] = curr_key
                                          break
                                    }
                                    _ ==> {
                                          total_kicks = total_kicks + 1
                                          mut as int64: displaced = t1[pos1]
                                          t1[pos1] = curr_key
                                          curr_key = displaced
                                          curr_table = 2
                                    }
                              }
                        }
                        _ ==> {
                              mut as int64: pos2 = ((curr_key * 5 + 3) /r m) + 1
                              route {
                                    t2[pos2] == 0 ==> {
                                          t2[pos2] = curr_key
                                          break
                                    }
                                    _ ==> {
                                          total_kicks = total_kicks + 1
                                          mut as int64: displaced2 = t2[pos2]
                                          t2[pos2] = curr_key
                                          curr_key = displaced2
                                          curr_table = 1
                                    }
                              }
                        }
                  }
            }
            ki = ki + 1
      }

      println("2. Tabela 1: " + t1)
      println("3. Tabela 2: " + t2)
      println("4. Total de expulsões (kicks): " + total_kicks)

      #L Teste de busca O(1) estrito no pior caso: verifica t1[h1] ou t2[h2]
      mut as list of int64: test_queries = [15, 22, 29, 36, 99]
      mut as int64: found_count = 0
      mut as int64: qi = 1
      infinite (qi <= listLength(test_queries)) {
            mut as int64: q = test_queries[qi]
            mut as int64: p1 = ((q * 3 + 1) /r m) + 1
            mut as int64: p2 = ((q * 5 + 3) /r m) + 1
            mut as bool: in_t1 = (t1[p1] == q)
            mut as bool: in_t2 = (t2[p2] == q)
            mut as bool: found = in_t1 or in_t2

            route {
                  found ==> {
                        found_count = found_count + 1
                        println("   Busca " + q + ": ENCONTRADA")
                  }
                  _ ==> {
                        println("   Busca " + q + ": NAO ENCONTRADA")
                  }
            }
            qi = qi + 1
      }

      println("5. Validacao de busca O(1): " + (found_count == 4 and total_kicks > 0))
      println("==================================================")
}
