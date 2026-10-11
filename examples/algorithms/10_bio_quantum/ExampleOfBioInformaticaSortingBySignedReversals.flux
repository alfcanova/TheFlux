#L ============================================================================
#L Algoritmo: Sorting by Signed Reversals (Rearranjo Genomico por Inversoes)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N^2) tempo | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaSortingBySignedReversals) {
      println("==================================================")
      println("  SciAlgo: Sorting by Signed Reversals")
      println("==================================================")

      #L Permutacao com Sinal representando 4 blocos de sintenia genomica:
      #L Pi = [-3, +1, +4, -2]
      #L O objetivo e transformar Pi na identidade [+1, +2, +3, +4]
      mut as int64: n = 4
      mut as list of int64: perm = [-3, 1, 4, -2]

      println("1. Cromossomo Inicial (Blocos Sintenicos com Orientacao):")
      println("   Pi: [" + perm[1] + ", " + perm[2] + ", " + perm[3] + ", " + perm[4] + "]")

      println("==================================================")
      println("2. Execucao de Inversoes Assinadas Sucessivas:")

      mut as int64: reversals_count = 0

      #L Algoritmo guloso de inversao por prefixo ordenado:
      #L Para cada posicao i de 1 ate n, localiza onde esta o bloco 'i' (ou '-i')
      mut as int64: i = 1
      infinite (i <= n) {
            #L Se perm[i] ja e +i, ja esta na posicao e orientacao corretas
            route {
                  perm[i] == i ==> {
                        #L Ja correto
                  }
                  _ ==> {
                        #L Localiza o bloco i ou -i
                        mut as int64: target_pos = i
                        mut as int64: k = i
                        infinite (k <= n) {
                              mut as int64: val = perm[k]
                              route {
                                    val == i or val == (0 - i) ==> {
                                          target_pos = k
                                    }
                                    _ ==> {}
                              }
                              k = k + 1
                        }

                        #L Executa inversao assinada rho(i, target_pos)
                        #L Inverte o subsegmento de i ate target_pos e troca o sinal de cada elemento
                        reversals_count = reversals_count + 1
                        println("   Inversao " + reversals_count + ": rho(" + i + ", " + target_pos + ")")

                        mut as list of int64: new_perm = []
                        #L 1. Elementos antes de i
                        mut as int64: p1 = 1
                        infinite (p1 < i) {
                              new_perm = listPushBack(new_perm, perm[p1])
                              p1 = p1 + 1
                        }
                        #L 2. Elementos de target_pos descendo ate i com sinal invertido
                        mut as int64: p2 = target_pos
                        infinite (p2 >= i) {
                              new_perm = listPushBack(new_perm, 0 - perm[p2])
                              p2 = p2 - 1
                        }
                        #L 3. Elementos apos target_pos
                        mut as int64: p3 = target_pos + 1
                        infinite (p3 <= n) {
                              new_perm = listPushBack(new_perm, perm[p3])
                              p3 = p3 + 1
                        }
                        perm = new_perm

                        println("      Novo Estado: [" + perm[1] + ", " + perm[2] + ", " + perm[3] + ", " + perm[4] + "]")

                        #L Se perm[i] ficou -i, faz uma inversao pontual rho(i, i) para corrigir o sinal
                        route {
                              perm[i] == (0 - i) ==> {
                                    reversals_count = reversals_count + 1
                                    println("   Inversao " + reversals_count + ": rho(" + i + ", " + i + ") [Ajuste de Sinal]")
                                    perm[i] = i
                                    println("      Novo Estado: [" + perm[1] + ", " + perm[2] + ", " + perm[3] + ", " + perm[4] + "]")
                              }
                              _ ==> {}
                        }
                  }
            }
            i = i + 1
      }

      println("==================================================")
      println("3. Resumo da Distancia de Rearranjo Genomico:")
      println("   Distancia de Inversao Calculada (Reversal Distance): " + reversals_count)
      println("   Configuracao Final Ordenada: [" + perm[1] + ", " + perm[2] + ", " + perm[3] + ", " + perm[4] + "]")
      println("   Sorting by Signed Reversals concluido com sucesso!")
      println("==================================================")
}
