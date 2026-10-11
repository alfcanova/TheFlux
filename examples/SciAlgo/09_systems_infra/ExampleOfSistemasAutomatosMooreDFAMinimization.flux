#L ============================================================================
#L Algoritmo: Moore DFA Minimization (Refinamento por Assinaturas)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(|Q|^2 * |Sigma|) tempo | O(|Q|) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosMooreDFAMinimization) {
      println("==================================================")
      println("  SciAlgo: Moore DFA Minimization Algorithm       ")
      println("==================================================")

      mut as int64: num_states = 6
      mut as int64: num_symbols = 2

      #L Transicoes: delta[(s - 1) * 2 + sym]
      #L 1: a -> 2, b -> 3
      #L 2: a -> 1, b -> 4
      #L 3: a -> 5, b -> 6
      #L 4: a -> 5, b -> 6
      #L 5 (final): a -> 5, b -> 5
      #L 6 (final): a -> 5, b -> 5
      mut as list of int64: delta = [
            2, 3, #L 1
            1, 4, #L 2
            5, 6, #L 3
            5, 6, #L 4
            5, 5, #L 5 (final)
            5, 5  #L 6 (final)
      ]

      mut as list of bool: is_accept = [
            false, false, false, false, true, true
      ]

      println("1. DFA de Entrada para Moore:")
      println("   Estados: 1..6 | Finais: {5, 6}")

      #L Particao inicial de Moore (0-equivalencia):
      #L Grupo 1: Nao-finais {1, 2, 3, 4}
      #L Grupo 2: Finais {5, 6}
      mut as list of int64: group = [1, 1, 1, 1, 2, 2]
      mut as int64: num_groups = 2

      println("2. Executando Iteracoes de Moore...")
      println("   Iteracao 0: 2 grupos iniciais")

      mut as bool: converged = false
      mut as int64: iter = 1

      infinite (not converged and iter <= 10) {
            #L Calcula nova classificacao baseada na assinatura:
            #L Assinatura de s = (group[s], group[delta(s, 1)], group[delta(s, 2)])
            mut as list of int64: new_group = [0, 0, 0, 0, 0, 0]
            mut as int64: next_num_groups = 0

            mut as int64: i = 1
            infinite (i <= num_states) {
                  route {
                        new_group[i] == 0 ==> {
                              next_num_groups = next_num_groups + 1
                              new_group[i] = next_num_groups
                              #L Procura outros estados j que compartilham a mesma assinatura
                              mut as int64: j = i + 1
                              infinite (j <= num_states) {
                                    route {
                                          new_group[j] == 0 ==> {
                                                mut as bool: same_sig = true
                                                #L 1. Mesmo grupo atual
                                                route { group[i] != group[j] ==> { same_sig = false } _ ==> {} }
                                                #L 2. Mesmo grupo de destino para simbolo 'a'
                                                mut as int64: dest_i_a = delta[(i - 1) * 2 + 1]
                                                mut as int64: dest_j_a = delta[(j - 1) * 2 + 1]
                                                route { group[dest_i_a] != group[dest_j_a] ==> { same_sig = false } _ ==> {} }
                                                #L 3. Mesmo grupo de destino para simbolo 'b'
                                                mut as int64: dest_i_b = delta[(i - 1) * 2 + 2]
                                                mut as int64: dest_j_b = delta[(j - 1) * 2 + 2]
                                                route { group[dest_i_b] != group[dest_j_b] ==> { same_sig = false } _ ==> {} }

                                                route {
                                                      same_sig ==> {
                                                            new_group[j] = next_num_groups
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    j = j + 1
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            println("   Iteracao " + iter + ": " + next_num_groups + " grupos formados")

            route {
                  next_num_groups == num_groups ==> {
                        converged = true
                  }
                  _ ==> {
                        group = new_group
                        num_groups = next_num_groups
                        iter = iter + 1
                  }
            }
      }

      println("3. Ponto Fixo Atingido na Iteracao " + iter + ":")
      println("   Total de Estados Minimos: " + num_groups)

      mut as int64: g = 1
      infinite (g <= num_groups) {
            mut as string: membros = ""
            mut as int64: s = 1
            infinite (s <= num_states) {
                  route {
                        group[s] == g ==> {
                              membros = membros + s + " "
                        }
                        _ ==> {}
                  }
                  s = s + 1
            }
            println("   Grupo " + g + ": Estados { " + membros + "}")
            g = g + 1
      }

      println("4. Transicoes do DFA Reduzido de Moore:")
      g = 1
      infinite (g <= num_groups) {
            mut as int64: rep = 1
            infinite (rep <= num_states and group[rep] != g) {
                  rep = rep + 1
            }
            mut as int64: t_a = group[delta[(rep - 1) * 2 + 1]]
            mut as int64: t_b = group[delta[(rep - 1) * 2 + 2]]
            mut as bool: f_st = is_accept[rep]
            println("   Grupo " + g + " (Final: " + f_st + ") -- 'a' -> Grupo " + t_a + ", 'b' -> Grupo " + t_b)
            g = g + 1
      }

      println("Moore DFA Minimization concluido com sucesso.")
}
