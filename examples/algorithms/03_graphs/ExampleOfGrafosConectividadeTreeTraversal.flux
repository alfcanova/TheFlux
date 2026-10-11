#L ============================================================================
#L Algoritmo: Tree Traversal (Travessias em Arvore: Pre-Ordem, Em-Ordem, Pos-Ordem e Nivel)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTreeTraversal) {
      println("==================================================")
      println("  SciAlgo: Tree Traversals (Binary Tree)          ")
      println("==================================================")

      mut as int64: num_v = 7
      mut as list of int64: left_c = [2, 4, 6, 0, 0, 0, 0]
      mut as list of int64: right_c = [3, 5, 7, 0, 0, 0, 0]

      #L Pre-ordem (Iterativa com pilha)
      mut as list of int64: stk = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 1
      stk[1] = 1
      mut as string: pre_str = ""

      infinite (top > 0) {
            mut as int64: cur = stk[top]
            top = top - 1
            pre_str = pre_str + cur + " "

            mut as int64: rc = right_c[cur]
            route {
                  rc > 0 ==> {
                        top = top + 1
                        stk[top] = rc
                  }
                  _ ==> {}
            }

            mut as int64: lc = left_c[cur]
            route {
                  lc > 0 ==> {
                        top = top + 1
                        stk[top] = lc
                  }
                  _ ==> {}
            }
      }
      println("1. Pre-ordem: " + pre_str)

      #L Em-ordem (Iterativa)
      mut as string: in_str = ""
      top = 0
      mut as int64: cur_node = 1

      infinite (cur_node > 0 or top > 0) {
            infinite (cur_node > 0) {
                  top = top + 1
                  stk[top] = cur_node
                  cur_node = left_c[cur_node]
            }

            cur_node = stk[top]
            top = top - 1
            in_str = in_str + cur_node + " "
            cur_node = right_c[cur_node]
      }
      println("2. Em-ordem: " + in_str)

      #L Pos-ordem (2 pilhas)
      mut as string: post_str = ""
      mut as list of int64: stk1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: stk2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top1 = 1
      mut as int64: top2 = 0
      stk1[1] = 1

      infinite (top1 > 0) {
            mut as int64: cur = stk1[top1]
            top1 = top1 - 1
            top2 = top2 + 1
            stk2[top2] = cur

            mut as int64: lc = left_c[cur]
            route {
                  lc > 0 ==> {
                        top1 = top1 + 1
                        stk1[top1] = lc
                  }
                  _ ==> {}
            }

            mut as int64: rc = right_c[cur]
            route {
                  rc > 0 ==> {
                        top1 = top1 + 1
                        stk1[top1] = rc
                  }
                  _ ==> {}
            }
      }

      infinite (top2 > 0) {
            mut as int64: cur = stk2[top2]
            top2 = top2 - 1
            post_str = post_str + cur + " "
      }
      println("3. Pos-ordem: " + post_str)

      #L Nivel (BFS com fila)
      mut as string: lvl_str = ""
      mut as list of int64: q = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: q_h = 1
      mut as int64: q_t = 1
      q[1] = 1

      infinite (q_h <= q_t) {
            mut as int64: cur = q[q_h]
            q_h = q_h + 1
            lvl_str = lvl_str + cur + " "

            mut as int64: lc = left_c[cur]
            route {
                  lc > 0 ==> {
                        q_t = q_t + 1
                        q[q_t] = lc
                  }
                  _ ==> {}
            }

            mut as int64: rc = right_c[cur]
            route {
                  rc > 0 ==> {
                        q_t = q_t + 1
                        q[q_t] = rc
                  }
                  _ ==> {}
            }
      }
      println("4. Em Nivel: " + lvl_str)
}
