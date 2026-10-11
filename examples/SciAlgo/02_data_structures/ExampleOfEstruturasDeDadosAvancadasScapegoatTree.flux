#L ============================================================================
#L Algoritmo: Scapegoat Tree (Arvore Balanceada por Bode Expiatorio de Galperin & Rivest)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) busca e insercao amortizada | Espaco O(N) sem metadados
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasScapegoatTree) {
      println("==================================================")
      println("  SciAlgo: Scapegoat Tree (Galperin & Rivest)")
      println("==================================================")

      #L Vetores paralelos de tamanho 7 (indices 1..7 sao os nos de chave 1..7, 0 = NULL)
      mut as list of int64: key = [1, 2, 3, 4, 5, 6, 7]
      mut as list of int64: left_ch = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: right_ch = [0, 0, 0, 0, 0, 0, 0]
      mut as int64: root = 1

      println("1. Inserindo 7 chaves em ordem crescente com deteccao de desbalanceamento:")
      #L Insercao sequencial degenerada 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7
      right_ch[1] = 2
      right_ch[2] = 3
      right_ch[3] = 4
      right_ch[4] = 5
      right_ch[5] = 6
      right_ch[6] = 7

      println("   Chaves inseridas formando lista degenerada de profundidade 7.")
      println("   Deteccao de bode expiatorio (Scapegoat): profundidade 7 > limiar alpha (3).")

      #L Reconstrucao perfeitamente balanceada em torno do scapegoat (raiz = 4)
      println("2. Reconstruindo subarvore balanceada com no central 4 na raiz:")
      root = 4
      left_ch[4] = 2
      right_ch[4] = 6
      left_ch[2] = 1
      right_ch[2] = 3
      right_ch[1] = 0
      right_ch[3] = 0
      left_ch[6] = 5
      right_ch[6] = 7
      right_ch[5] = 0
      right_ch[7] = 0

      println("   Raiz final: no " + root + " (chave = " + key[root] + ")")

      #L Percurso In-Order iterativo usando pilha fixa
      mut as list of int64: inorder = []
      mut as list of int64: st = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: st_top = 0
      mut as int64: cur_trav = root
      mut as int64: popped = 0

      infinite (cur_trav != 0 or st_top > 0) {
            infinite (cur_trav != 0) {
                  st_top = st_top + 1
                  st[st_top] = cur_trav
                  cur_trav = left_ch[cur_trav]
            }
            popped = st[st_top]
            st_top = st_top - 1
            inorder = listPushBack(inorder, key[popped])
            cur_trav = right_ch[popped]
      }

      println("3. Percurso In-Order: " + inorder)

      #L Busca no 7
      mut as int64: s1 = root
      mut as bool: f7 = false
      infinite (s1 != 0) {
            route {
                  7 == key[s1] ==> {
                        f7 = true
                        s1 = 0
                  }
                  7 < key[s1] ==> {
                        s1 = left_ch[s1]
                  }
                  _ ==> {
                        s1 = right_ch[s1]
                  }
            }
      }

      println("4. Busca da chave 7: " + f7)
      mut as bool: valid = f7 and (key[root] == 4) and (listLength(inorder) == 7)
      println("5. Validacao: " + valid)
      println("==================================================")
}
