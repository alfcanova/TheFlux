#L ============================================================================
#L Algoritmo: Cuckoo Hashing (Pagh & Rodler 2001)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(1) busca no pior caso | O(1) insercao amortizada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisCuckoo) {
      println("==================================================")
      println("  SciAlgo: Cuckoo Hashing")
      println("==================================================")

      mut as int64: m = 7 #L Tamanho de cada tabela
      #L Duas tabelas independentes: T1 e T2 (0 = vazio)
      mut as list of int64: t1 = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: t2 = [0, 0, 0, 0, 0, 0, 0]

      #L Chaves a inserir: 15, 22, 29, 36
      #L h1(x) = ((x * 3 + 1) % 7) + 1
      #L h2(x) = ((x * 7 + 5) % 7) + 1  -> usamos h2(x) = ((x * 5 + 3) % 7) + 1
      mut as list of int64: keys = [15, 22, 29, 36]
      mut as int64: total_kicks = 0

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
                                          #L Expulsa o ocupante anterior (kicking)
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
                                          #L Expulsa de t2 para t1
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

      println("1. Tabela T1 final: " + t1)
      println("2. Tabela T2 final: " + t2)
      println("3. Total de expulsoes (cuckoo kicks) executadas: " + total_kicks)

      #L Busca O(1): checa apenas t1[h1] e t2[h2]
      mut as int64: query_key = 22
      mut as int64: p1 = ((query_key * 3 + 1) /r m) + 1
      mut as int64: p2 = ((query_key * 5 + 3) /r m) + 1
      mut as bool: found = (t1[p1] == query_key or t2[p2] == query_key)

      println("4. Busca O(1) pela chave " + query_key + ": encontrada = " + found)
      println("5. Validacao: " + (found and total_kicks > 0))
      println("==================================================")
}
