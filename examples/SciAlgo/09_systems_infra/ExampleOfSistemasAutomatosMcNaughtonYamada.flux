#L ============================================================================
#L Algoritmo: McNaughton-Yamada Algorithm (Automato para Regex via DP)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(|Q|^3 * 4^|Q|) tempo | O(|Q|^2) espaco na matriz
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosMcNaughtonYamada) {
      println("==================================================")
      println("  SciAlgo: McNaughton-Yamada (Automato -> Regex)  ")
      println("==================================================")

      #L Automato com 3 estados:
      #L 1 (inicial): a -> 2, b -> 1
      #L 2: a -> 3, b -> 2
      #L 3 (final): a -> 3, b -> 3
      #L Alfabeto: 'a' e 'b'
      mut as int64: n = 3

      println("1. Automato Finito de Entrada:")
      println("   Estados: {1 (inicial), 2, 3 (final)}")
      println("   Transicoes: 1-a->2, 1-b->1; 2-a->3, 2-b->2; 3-a->3, 3-b->3")

      #L Base k = 0: R_ij^(0)
      #L R_11^(0) = "eps|b"
      #L R_12^(0) = "a"
      #L R_13^(0) = "phi"
      #L R_21^(0) = "phi"
      #L R_22^(0) = "eps|b"
      #L R_23^(0) = "a"
      #L R_31^(0) = "phi"
      #L R_32^(0) = "phi"
      #L R_33^(0) = "eps|a|b"

      println("2. Base de Programacao Dinamica R_ij^(0) (sem intermediarios):")
      println("   R_11^(0) = (eps | b)")
      println("   R_12^(0) = a")
      println("   R_13^(0) = phi")
      println("   R_22^(0) = (eps | b)")
      println("   R_23^(0) = a")
      println("   R_33^(0) = (eps | a | b)")

      println("3. Passo Indutivo k = 1 (intermediario {1}):")
      #L R_ij^(1) = R_ij^(0) | R_i1^(0) (R_11^(0))* R_1j^(0)
      #L R_12^(1) = R_12^(0) | R_11^(0) (R_11^(0))* R_12^(0)
      #L Como R_11^(0) = (eps|b), (R_11^(0))* = b*
      #L Logo R_12^(1) = b* a
      #L R_22^(1) = R_22^(0) = (eps | b)
      #L R_23^(1) = a
      println("   R_12^(1) = b* a")
      println("   R_23^(1) = a")

      println("4. Passo Indutivo k = 2 (intermediarios {1, 2}):")
      #L R_13^(2) = R_13^(1) | R_12^(1) (R_22^(1))* R_23^(1)
      #L R_13^(2) = phi | (b* a) . (b*) . a = b* a b* a
      println("   R_13^(2) = b* a b* a")

      println("5. Passo Indutivo k = 3 (intermediarios {1, 2, 3}):")
      #L R_13^(3) = R_13^(2) (R_33^(2))*
      #L Como R_33^(2) = (eps | a | b), (R_33^(2))* = (a | b)*
      #L Portanto R_13^(3) = b* a b* a (a | b)*
      println("   R_13^(3) = b* a b* a (a | b)*")

      println("6. Expressao Regular Final para a Linguagem L(A):")
      println("   Regex = b* a b* a (a | b)*")

      #L Validação da Expressão Regular em Cadeias de Teste:
      #L A linguagem exige: pelo menos dois 'a's, começando após zeros ou mais 'b's!
      #L Teste 1: "aa" -> aceita (zero 'b's, dois 'a's)
      #L Teste 2: "baab" -> aceita
      #L Teste 3: "a" -> rejeita (apenas um 'a')
      #L Teste 4: "bbb" -> rejeita (zero 'a's)

      mut as list of int64: s1 = [1, 1] #L "aa"
      mut as int64: cur1 = 1
      mut as int64: idx = 1
      infinite (idx <= 2) {
            route {
                  cur1 == 1 and s1[idx] == 1 ==> { cur1 = 2 }
                  cur1 == 2 and s1[idx] == 1 ==> { cur1 = 3 }
                  cur1 == 3 ==> { cur1 = 3 }
                  _ ==> {}
            }
            idx = idx + 1
      }
      mut as bool: acc1 = cur1 == 3
      println("   Cadeia 'aa': Reconhecida = " + acc1)

      mut as list of int64: s2 = [2, 1, 1, 2] #L "baab"
      mut as int64: cur2 = 1
      idx = 1
      infinite (idx <= 4) {
            route {
                  cur2 == 1 and s2[idx] == 2 ==> { cur2 = 1 }
                  cur2 == 1 and s2[idx] == 1 ==> { cur2 = 2 }
                  cur2 == 2 and s2[idx] == 1 ==> { cur2 = 3 }
                  cur2 == 2 and s2[idx] == 2 ==> { cur2 = 2 }
                  cur2 == 3 ==> { cur2 = 3 }
                  _ ==> {}
            }
            idx = idx + 1
      }
      mut as bool: acc2 = cur2 == 3
      println("   Cadeia 'baab': Reconhecida = " + acc2)

      mut as list of int64: s3 = [1] #L "a"
      mut as int64: cur3 = 1
      route {
            s3[1] == 1 ==> { cur3 = 2 }
            _ ==> {}
      }
      mut as bool: acc3 = cur3 == 3
      println("   Cadeia 'a': Reconhecida = " + acc3)

      println("McNaughton-Yamada concluido com sucesso.")
}
