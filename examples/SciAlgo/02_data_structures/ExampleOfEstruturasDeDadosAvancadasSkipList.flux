#L ============================================================================
#L Algoritmo: Skip List (Lista com Saltos Multinivel de William Pugh)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) busca, insercao e remocao media | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSkipList) {
      println("==================================================")
      println("  SciAlgo: Skip List (Estruturas de Dados Avancadas)")
      println("==================================================")

      #L Representacao dos niveis de encaminhamento (3 niveis expressos)
      #L Nivel 3 (faixa de alta velocidade): [30, 70]
      #L Nivel 2 (faixa intermediaria):      [20, 30, 50, 70]
      #L Nivel 1 (lista base completa):      [10, 20, 30, 40, 50, 60, 70, 80]
      mut as list of int64: level3 = [30, 70]
      mut as list of int64: level2 = [20, 30, 50, 70]
      mut as list of int64: level1 = [10, 20, 30, 40, 50, 60, 70, 80]

      println("1. Nivel 3 (L3): " + level3)
      println("2. Nivel 2 (L2): " + level2)
      println("3. Nivel 1 (L1): " + level1)

      mut as list of int64: queries = [20, 50, 60, 80, 95]
      mut as int64: q_idx = 1
      mut as int64: total_found = 0

      println("4. Executando buscas multinivel:")
      infinite (q_idx <= listLength(queries)) {
            mut as int64: target = queries[q_idx]
            mut as int64: curr_val = 0
            mut as int64: jumps = 0

            #L Busca no Nivel 3
            mut as int64: i3 = 1
            infinite (i3 <= listLength(level3)) {
                  route {
                        level3[i3] <= target ==> {
                              curr_val = level3[i3]
                              jumps = jumps + 1
                        }
                        _ ==> {
                              break
                        }
                  }
                  i3 = i3 + 1
            }

            #L Desce para Nivel 2
            mut as int64: i2 = 1
            infinite (i2 <= listLength(level2)) {
                  route {
                        level2[i2] > curr_val and level2[i2] <= target ==> {
                              curr_val = level2[i2]
                              jumps = jumps + 1
                        }
                        level2[i2] > target ==> {
                              break
                        }
                  }
                  i2 = i2 + 1
            }

            #L Desce para Nivel 1
            mut as int64: i1 = 1
            mut as bool: found = false
            infinite (i1 <= listLength(level1)) {
                  route {
                        level1[i1] > curr_val and level1[i1] <= target ==> {
                              curr_val = level1[i1]
                              jumps = jumps + 1
                              route {
                                    level1[i1] == target ==> {
                                          found = true
                                          break
                                    }
                              }
                        }
                        level1[i1] > target ==> {
                              break
                        }
                  }
                  i1 = i1 + 1
            }

            route {
                  curr_val == target ==> {
                        found = true
                  }
            }

            route {
                  found ==> {
                        total_found = total_found + 1
                        println("   Chave " + target + ": ENCONTRADA (saltos: " + jumps + ")")
                  }
                  _ ==> {
                        println("   Chave " + target + ": NAO ENCONTRADA")
                  }
            }

            q_idx = q_idx + 1
      }

      println("5. Total de chaves encontradas: " + total_found + " de " + listLength(queries))
      println("6. Validacao: " + (total_found == 4))
      println("==================================================")
}
