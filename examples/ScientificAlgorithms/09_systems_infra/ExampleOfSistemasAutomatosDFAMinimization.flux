#L ============================================================================
#L Algoritmo: DFA Minimization (Table-Filling / Myhill-Nerode)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(|Sigma| * |Q|^2) tempo | O(|Q|^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosDFAMinimization) {
      println("==================================================")
      println("  SciAlgo: DFA Minimization (Table-Filling)        ")
      println("==================================================")

      mut as int64: num_states = 6
      mut as int64: num_symbols = 2

      #L Estados: 1..6
      #L Transicoes: delta[(s - 1) * 2 + sym]
      #L 1: a -> 2, b -> 3
      #L 2: a -> 1, b -> 4
      #L 3: a -> 5, b -> 6
      #L 4: a -> 5, b -> 6
      #L 5 (final): a -> 5, b -> 5
      #L 6 (final): a -> 5, b -> 5
      mut as list of int64: delta = [
            2, 3, #L Estado 1
            1, 4, #L Estado 2
            5, 6, #L Estado 3
            5, 6, #L Estado 4
            5, 5, #L Estado 5 (final)
            5, 5  #L Estado 6 (final)
      ]

      mut as list of bool: is_accept = [
            false, false, false, false, true, true
      ]

      println("1. DFA Original (6 Estados, Estados Finais: {5, 6}):")
      mut as int64: s_idx = 1
      infinite (s_idx <= num_states) {
            mut as int64: ta = delta[(s_idx - 1) * 2 + 1]
            mut as int64: tb = delta[(s_idx - 1) * 2 + 2]
            mut as bool: f = is_accept[s_idx]
            println("   Estado " + s_idx + " (Final: " + f + ") -- 'a' -> " + ta + ", 'b' -> " + tb)
            s_idx = s_idx + 1
      }

      #L Matriz triangular de distinguibilidade: distinct[(p - 1) * num_states + q]
      mut as list of bool: distinct = [
            false, false, false, false, false, false,
            false, false, false, false, false, false,
            false, false, false, false, false, false,
            false, false, false, false, false, false,
            false, false, false, false, false, false,
            false, false, false, false, false, false
      ]

      #L Passo 1: Marcar pares (p, q) onde um e de aceitacao e o outro nao
      mut as int64: p = 1
      infinite (p <= num_states) {
            mut as int64: q = p + 1
            infinite (q <= num_states) {
                  route {
                        (is_accept[p] and (not is_accept[q])) or ((not is_accept[p]) and is_accept[q]) ==> {
                              distinct[(p - 1) * num_states + q] = true
                              distinct[(q - 1) * num_states + p] = true
                        }
                        _ ==> {}
                  }
                  q = q + 1
            }
            p = p + 1
      }

      println("2. Executando Algoritmo de Preenchimento de Tabela (Myhill-Nerode)...")

      #L Passo 2: Ponto fixo de refinamento
      mut as bool: changed = true
      infinite (changed) {
            changed = false
            p = 1
            infinite (p <= num_states) {
                  mut as int64: q = p + 1
                  infinite (q <= num_states) {
                        route {
                              not distinct[(p - 1) * num_states + q] ==> {
                                    mut as int64: sym = 1
                                    infinite (sym <= num_symbols) {
                                          mut as int64: tp = delta[(p - 1) * 2 + sym]
                                          mut as int64: tq = delta[(q - 1) * 2 + sym]
                                          route {
                                                distinct[(tp - 1) * num_states + tq] ==> {
                                                      distinct[(p - 1) * num_states + q] = true
                                                      distinct[(q - 1) * num_states + p] = true
                                                      changed = true
                                                }
                                                _ ==> {}
                                          }
                                          sym = sym + 1
                                    }
                              }
                              _ ==> {}
                        }
                        q = q + 1
                  }
                  p = p + 1
            }
      }

      #L Identificacao de classes de equivalencia
      mut as list of int64: comp = [0, 0, 0, 0, 0, 0]
      mut as int64: num_classes = 0

      p = 1
      infinite (p <= num_states) {
            route {
                  comp[p] == 0 ==> {
                        num_classes = num_classes + 1
                        comp[p] = num_classes
                        mut as int64: q = p + 1
                        infinite (q <= num_states) {
                              route {
                                    (not distinct[(p - 1) * num_states + q]) and (comp[q] == 0) ==> {
                                          comp[q] = num_classes
                                    }
                                    _ ==> {}
                              }
                              q = q + 1
                        }
                  }
                  _ ==> {}
            }
            p = p + 1
      }

      println("3. Classes de Equivalencia Encontradas:")
      mut as int64: c = 1
      infinite (c <= num_classes) {
            mut as string: membros = ""
            p = 1
            infinite (p <= num_states) {
                  route {
                        comp[p] == c ==> {
                              membros = membros + p + " "
                        }
                        _ ==> {}
                  }
                  p = p + 1
            }
            println("   Classe " + c + ": Estados { " + membros + "}")
            c = c + 1
      }

      println("4. DFA Minimo Resultante:")
      println("   Total de Estados: " + num_classes + " (Original: " + num_states + ")")

      #L Transicoes do DFA reduzido
      c = 1
      infinite (c <= num_classes) {
            #L Pega primeiro representante da classe
            mut as int64: rep = 1
            infinite (rep <= num_states and comp[rep] != c) {
                  rep = rep + 1
            }
            mut as int64: dest_a = comp[delta[(rep - 1) * 2 + 1]]
            mut as int64: dest_b = comp[delta[(rep - 1) * 2 + 2]]
            mut as bool: cls_final = is_accept[rep]
            println("   Classe " + c + " (Final: " + cls_final + ") -- 'a' -> Classe " + dest_a + ", 'b' -> Classe " + dest_b)
            c = c + 1
      }

      println("DFA Minimization concluido com sucesso.")
}
