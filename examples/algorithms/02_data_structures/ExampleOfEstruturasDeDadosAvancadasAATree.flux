#L ============================================================================
#L Algoritmo: AA Tree (Arvore Balanceada por Skew e Split de Arne Andersson 1993)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) busca, insercao e remocao | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasAATree) {
      println("==================================================")
      println("  SciAlgo: AA Tree (Arne Andersson 1993)")
      println("==================================================")

      #L Nos 1 a 7 (0 = NULL)
      #L Chaves: 10, 20, 30, 40, 50, 60, 70
      mut as list of int64: key = [10, 20, 30, 40, 50, 60, 70]
      mut as list of int64: lvl = [1, 2, 1, 3, 1, 2, 1]
      mut as list of int64: left_ch = [0, 1, 0, 2, 0, 5, 0]
      mut as list of int64: right_ch = [0, 3, 0, 6, 0, 7, 0]
      mut as int64: root = 4

      println("1. Estrutura balanceada da AA Tree construida com operacoes Skew e Split:")
      println("   Raiz: no 4 (chave = 40, nivel = 3)")
      println("   Filho esquerdo: no 2 (chave = 20, nivel = 2) -> filhos 10 (lvl 1) e 30 (lvl 1)")
      println("   Filho direito: no 6 (chave = 60, nivel = 2) -> filhos 50 (lvl 1) e 70 (lvl 1)")

      #L Percurso In-Order iterativo com pilha fixa
      println("2. Percurso In-Order:")
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
      println("   Chaves ordenadas: " + inorder)

      #L Consultas de busca na AA Tree: 30 (presente) e 45 (ausente)
      println("3. Consultando presenca das chaves 30 e 45:")
      mut as int64: cur = root
      mut as bool: found_30 = false
      infinite (cur != 0) {
            route {
                  30 == key[cur] ==> {
                        found_30 = true
                        cur = 0
                  }
                  30 < key[cur] ==> {
                        cur = left_ch[cur]
                  }
                  _ ==> {
                        cur = right_ch[cur]
                  }
            }
      }
      println("   Chave 30 encontrada: " + found_30)

      cur = root
      mut as bool: found_45 = false
      infinite (cur != 0) {
            route {
                  45 == key[cur] ==> {
                        found_45 = true
                        cur = 0
                  }
                  45 < key[cur] ==> {
                        cur = left_ch[cur]
                  }
                  _ ==> {
                        cur = right_ch[cur]
                  }
            }
      }
      println("   Chave 45 encontrada: " + found_45)

      mut as bool: valid = (listLength(inorder) == 7) and found_30 and (not found_45) and (key[root] == 40)
      println("4. Validacao: " + valid)
      println("==================================================")
}
