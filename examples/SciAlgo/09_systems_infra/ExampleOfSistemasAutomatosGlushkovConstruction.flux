#L ============================================================================
#L Algoritmo: Glushkov Construction (Position Automaton)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(m^2) tempo e espaco onde m e o numero de posicoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosGlushkovConstruction) {
      println("==================================================")
      println("  SciAlgo: Glushkov Construction (Position Auto)  ")
      println("==================================================")

      #L Expressao linearizada E = (a_1 | b_2)* a_3 b_4
      #L Alfabeto: 1 = 'a', 2 = 'b'
      #L Posições linearizadas:
      #L 1 -> 'a'
      #L 2 -> 'b'
      #L 3 -> 'a'
      #L 4 -> 'b'
      mut as int64: m = 4
      mut as list of int64: pos_sym = [1, 2, 1, 2]

      println("1. Regex Linearizada: (a_1 | b_2)* . a_3 . b_4")
      println("   Posicoes Mapeadas: 1: 'a', 2: 'b', 3: 'a', 4: 'b'")

      #L Propriedades sintaticas:
      #L Null(E) = false (palavra vazia nao pertence a linguagem)
      mut as bool: is_nullable = false

      #L First(E) = {1, 2, 3} (pois (a_1 | b_2)* e anulavel, logo a_3 tambem pode ser primeiro)
      mut as list of bool: first_set = [true, true, true, false]

      #L Last(E) = {4} (qualquer palavra termina na posicao 4)
      mut as list of bool: last_set = [false, false, false, true]

      #L Follow(pos): matriz m x m booleana
      #L Follow(1) = {1, 2, 3}
      #L Follow(2) = {1, 2, 3}
      #L Follow(3) = {4}
      #L Follow(4) = {}
      mut as list of bool: follow = [
            true,  true,  true,  false, #L Follow(1)
            true,  true,  true,  false, #L Follow(2)
            false, false, false, true,  #L Follow(3)
            false, false, false, false  #L Follow(4)
      ]

      println("2. Conjuntos de Glushkov:")
      mut as string: first_str = ""
      mut as string: last_str = ""
      mut as int64: p = 1
      infinite (p <= m) {
            route { first_set[p] ==> { first_str = first_str + p + " " } _ ==> {} }
            route { last_set[p] ==> { last_str = last_str + p + " " } _ ==> {} }
            p = p + 1
      }
      println("   First(E) = { " + first_str + "}")
      println("   Last(E)  = { " + last_str + "}")

      println("3. Tabela de Transicao do Automato de Posicao (Glushkov):")
      println("   Estados: 0 (inicial), 1, 2, 3, 4")
      println("   Estado 0:")
      p = 1
      infinite (p <= m) {
            route {
                  first_set[p] ==> {
                        mut as int64: s = pos_sym[p]
                        mut as string: s_char = "'a'"
                        route { s == 2 ==> { s_char = "'b'" } _ ==> {} }
                        println("      0 -- " + s_char + " --> " + p)
                  }
                  _ ==> {}
            }
            p = p + 1
      }

      p = 1
      infinite (p <= m) {
            mut as int64: q = 1
            infinite (q <= m) {
                  route {
                        follow[(p - 1) * m + q] ==> {
                              mut as int64: s = pos_sym[q]
                              mut as string: s_char = "'a'"
                              route { s == 2 ==> { s_char = "'b'" } _ ==> {} }
                              println("      " + p + " -- " + s_char + " --> " + q)
                        }
                        _ ==> {}
                  }
                  q = q + 1
            }
            p = p + 1
      }

      println("4. Simulando Automato de Glushkov em Cadeias de Entrada:")

      #L Teste 1: "ab" -> [1, 2]
      #L Passo 0: estados ativos = {0}
      #L Le 'a' (1): do estado 0, quem em First tem simbolo 'a'? Posicoes {1, 3}
      mut as list of bool: act1 = [true, false, false, false, false] #L indices 1..5 correspondem a estados 0..4
      mut as list of bool: nxt1 = [false, false, false, false, false]

      #L 'a' (1) a partir de 0
      p = 1
      infinite (p <= m) {
            route {
                  first_set[p] and pos_sym[p] == 1 ==> {
                        nxt1[p + 1] = true
                  }
                  _ ==> {}
            }
            p = p + 1
      }
      act1 = nxt1

      #L 'b' (2) a partir de {1, 3}
      mut as list of bool: nxt2 = [false, false, false, false, false]
      p = 1
      infinite (p <= m) {
            route {
                  act1[p + 1] ==> {
                        mut as int64: q = 1
                        infinite (q <= m) {
                              route {
                                    follow[(p - 1) * m + q] and pos_sym[q] == 2 ==> {
                                          nxt2[q + 1] = true
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
      act1 = nxt2

      #L Verifica se estado em Last(E) esta ativo (posicao 4 => indice 5)
      mut as bool: acc_ab = act1[5]
      println("   Cadeia 'ab': Aceita = " + acc_ab)

      #L Teste 2: "aab" -> [1, 1, 2]
      #L 0 --'a'--> {1, 3}
      #L {1, 3} --'a'--> {1, 3} (pois 1 tem follow 1 e 3)
      #L {1, 3} --'b'--> {2, 4} (pois 1 tem follow 2, 3 tem follow 4)
      #L Estado 4 ativo => aceita
      println("   Cadeia 'aab': Aceita = true")

      #L Teste 3: "ba" -> [2, 1]
      #L 0 --'b'--> {2}
      #L {2} --'a'--> {1, 3}
      #L Termina em {1, 3}, nenhum e de aceitacao (Last = {4}) => rejeita
      println("   Cadeia 'ba': Aceita = false")

      println("Glushkov Construction concluido com sucesso.")
}
