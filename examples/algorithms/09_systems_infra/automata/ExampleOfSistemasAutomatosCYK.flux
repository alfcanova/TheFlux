#L ============================================================================
#L Algoritmo: Cocke-Younger-Kasami (CYK Algorithm para Parsing em CNF)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(n^3 * |G|) tempo | O(n^2 * |V|) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosCYK) {
      println("==================================================")
      println("  SciAlgo: CYK Parsing Algorithm (Chomsky Form)   ")
      println("==================================================")

      #L Gramatica em Forma Normal de Chomsky (CNF):
      #L Variaveis: 1 = S (inicial), 2 = A, 3 = B, 4 = C
      #L Terminais: 1 = 'a', 2 = 'b'
      mut as int64: num_vars = 4

      #L Regras Terminais (A -> terminal):
      #L A -> a (2 -> 1)
      #L B -> b (3 -> 2)
      #L C -> a (4 -> 1)
      #L term_rules[(var - 1) * 2 + term] = true
      mut as list of bool: term_rules = [
            false, false, #L S -> a?, S -> b?
            true,  false, #L A -> a (sim), A -> b (nao)
            false, true,  #L B -> a (nao), B -> b (sim)
            true,  false  #L C -> a (sim), C -> b (nao)
      ]

      #L Regras Nao-Terminais (A -> B C):
      #L 1: S -> A B
      #L 2: S -> B C
      #L 3: A -> B A
      #L 4: B -> C C
      #L 5: C -> A B
      mut as int64: num_binary_rules = 5
      mut as list of int64: bin_lhs = [1, 1, 2, 3, 4]
      mut as list of int64: bin_rhs1 = [2, 3, 3, 4, 2]
      mut as list of int64: bin_rhs2 = [3, 4, 2, 4, 3]

      println("1. Gramatica CNF Definida:")
      println("   Variaveis: {1: S (start), 2: A, 3: B, 4: C}")
      println("   Regras Terminais: A -> 'a', B -> 'b', C -> 'a'")
      println("   Regras Binarias: S -> AB | BC, A -> BA, B -> CC, C -> AB")

      #L Cadeia de teste: w = "baaba" (n = 5)
      #L simbolos: [2, 1, 1, 2, 1]
      mut as int64: n = 5
      mut as list of int64: w = [2, 1, 1, 2, 1]

      println("2. Cadeia de Entrada: 'baaba' (Comprimento = 5)")

      #L Tabela CYK tridimensional linearizada: P[len, start, var]
      #L Dimensoes: len in 1..n, start in 1..n, var in 1..num_vars
      #L Indice = ((len - 1) * n + (start - 1)) * num_vars + var
      #L Tamanho total = 5 * 5 * 4 = 100
      mut as list of bool: cyk_table = [
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false
      ]

      #L Passo 1: Preenchimento base para subcadeias de comprimento 1
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: t = w[i]
            mut as int64: v = 1
            infinite (v <= num_vars) {
                  route {
                        term_rules[(v - 1) * 2 + t] ==> {
                              mut as int64: offset = ((1 - 1) * n + (i - 1)) * num_vars + v
                              cyk_table[offset] = true
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
            i = i + 1
      }

      println("3. Executando Algoritmo CYK via Programacao Dinamica...")

      #L Passo 2: Preenchimento para comprimentos l = 2..n
      mut as int64: l = 2
      infinite (l <= n) {
            i = 1
            infinite (i <= n - l + 1) {
                  #L Particao k divide subcadeia em (i .. i+k-1) e (i+k .. i+l-1)
                  mut as int64: k = 1
                  infinite (k <= l - 1) {
                        #L Avalia cada regra binaria A -> B C
                        mut as int64: r = 1
                        infinite (r <= num_binary_rules) {
                              mut as int64: lhs = bin_lhs[r]
                              mut as int64: rhs1 = bin_rhs1[r]
                              mut as int64: rhs2 = bin_rhs2[r]

                              mut as int64: off1 = ((k - 1) * n + (i - 1)) * num_vars + rhs1
                              mut as int64: off2 = (((l - k) - 1) * n + (i + k - 1)) * num_vars + rhs2

                              route {
                                    cyk_table[off1] and cyk_table[off2] ==> {
                                          mut as int64: off_lhs = ((l - 1) * n + (i - 1)) * num_vars + lhs
                                          cyk_table[off_lhs] = true
                                    }
                                    _ ==> {}
                              }
                              r = r + 1
                        }
                        k = k + 1
                  }
                  i = i + 1
            }
            l = l + 1
      }

      #L Verificacao se variavel inicial S (1) gera toda a cadeia w (len = n, start = 1)
      mut as int64: root_offset = ((n - 1) * n + (1 - 1)) * num_vars + 1
      mut as bool: accepted = cyk_table[root_offset]

      println("4. Resultado do Parsing CYK:")
      route {
            accepted ==> {
                  println("   A cadeia 'baaba' pertence a linguagem gerada pela gramatica! (Aceita = true)")
            }
            _ ==> {
                  println("   A cadeia 'baaba' NAO pertence a linguagem. (Aceita = false)")
            }
      }

      #L Teste com cadeia invalida: "bb" (len = 2, start = 1)
      #L B gera 'b', mas nao ha regra que combine BB ou derive 'bb' a partir de S
      mut as int64: test2_off = ((2 - 1) * n + (1 - 1)) * num_vars + 1
      mut as bool: acc_bb = cyk_table[test2_off]
      println("   Subcadeia inicial 'ba' aceita como sentenca completa? " + acc_bb)

      println("CYK Parsing concluido com sucesso.")
}
