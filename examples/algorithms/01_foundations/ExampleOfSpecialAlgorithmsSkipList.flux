#L ============================================================================
#L Algoritmo: Skip List (Lista com Saltos Multinivel de William Pugh 1989)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(log N) tempo medio de busca | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsSkipList) {
      println("==================================================")
      println("  SciAlgo: Skip List Multi-Level Search")
      println("==================================================")

      #L Representacao dos 3 niveis de ponteiros da Skip List
      #L Nivel 3 (faixa expressa alta):  [Cabeca, 30, 70]
      #L Nivel 2 (faixa expressa media): [Cabeca, 20, 30, 50, 70]
      #L Nivel 1 (lista completa):       [10, 20, 30, 40, 50, 60, 70, 80]
      mut as list of int64: level3 = [30, 70]
      mut as list of int64: level2 = [20, 30, 50, 70]
      mut as list of int64: level1 = [10, 20, 30, 40, 50, 60, 70, 80]

      println("1. Nivel 3 (express lane 3): " + level3)
      println("2. Nivel 2 (express lane 2): " + level2)
      println("3. Nivel 1 (lista base):     " + level1)

      mut as int64: target = 60
      println("4. Alvo buscado: " + target)

      mut as int64: current_pos = 0
      mut as int64: jumps_l3 = 0
      mut as int64: jumps_l2 = 0
      mut as int64: jumps_l1 = 0

      #L Busca no Nivel 3: avanca enquanto elemento for <= target
      mut as int64: i3 = 1
      infinite (i3 <= listLength(level3)) {
            route {
                  level3[i3] <= target ==> {
                        current_pos = level3[i3]
                        jumps_l3 = jumps_l3 + 1
                  }
                  _ ==> {
                        break
                  }
            }
            i3 = i3 + 1
      }
      println("   Desce para Nivel 2 na posicao: " + current_pos + " (saltos no L3: " + jumps_l3 + ")")

      #L Busca no Nivel 2 a partir de current_pos
      mut as int64: i2 = 1
      infinite (i2 <= listLength(level2)) {
            route {
                  level2[i2] > current_pos and level2[i2] <= target ==> {
                        current_pos = level2[i2]
                        jumps_l2 = jumps_l2 + 1
                  }
                  level2[i2] > target ==> {
                        break
                  }
            }
            i2 = i2 + 1
      }
      println("   Desce para Nivel 1 na posicao: " + current_pos + " (saltos no L2: " + jumps_l2 + ")")

      #L Busca no Nivel 1 ate encontrar o alvo exato
      mut as bool: found = false
      mut as int64: i1 = 1
      infinite (i1 <= listLength(level1)) {
            route {
                  level1[i1] > current_pos and level1[i1] <= target ==> {
                        current_pos = level1[i1]
                        jumps_l1 = jumps_l1 + 1
                        route {
                              current_pos == target ==> {
                                    found = true
                                    break
                              }
                        }
                  }
            }
            i1 = i1 + 1
      }

      println("5. Elemento encontrado pela Skip List: " + found)
      println("6. Total de comparacoes na travessia multinivel: " + (jumps_l3 + jumps_l2 + jumps_l1))
      println("7. Validacao: " + (found and current_pos == 60 and jumps_l3 == 1 and jumps_l2 == 1 and jumps_l1 == 1))
      println("==================================================")
}
