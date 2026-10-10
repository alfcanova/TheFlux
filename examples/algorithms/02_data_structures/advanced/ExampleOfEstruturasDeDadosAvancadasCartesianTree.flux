#L ============================================================================
#L Algoritmo: Cartesian Tree (Construcao Linear O(N) com Pilha Monotonica)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao O(N) tempo | O(N) espaco | RMQ via LCA
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasCartesianTree) {
      println("==================================================")
      println("  SciAlgo: Cartesian Tree (Min-Heap + In-Order)")
      println("==================================================")

      #L Sequencia de entrada (1-based, N = 11)
      mut as list of int64: arr = [9, 3, 7, 1, 8, 12, 10, 20, 15, 18, 5]
      mut as int64: n = listLength(arr)
      println("1. Sequencia de entrada com N = " + n + ": [9, 3, 7, 1, 8, 12, 10, 20, 15, 18, 5]")

      #L Estrutura da arvore: ponteiros left, right e parent (1-based, 0 = NULL)
      mut as list of int64: tree_left = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: tree_right = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: tree_parent = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      #L Pilha da espinha direita (Right Spine)
      mut as list of int64: stack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 0

      println("2. Construindo Cartesian Tree em tempo linear O(N)...")

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: last_popped = 0

            #L Enquanto pilha nao vazia e topo > arr[i]
            infinite (top > 0) {
                  mut as int64: top_node = stack[top]
                  route {
                        arr[top_node] > arr[i] ==> {
                              last_popped = top_node
                              top = top - 1
                        }
                        _ ==> {
                              break
                        }
                  }
            }

            #L O ultimo no desempilhado se torna filho esquerdo de i
            route {
                  last_popped != 0 ==> {
                        tree_left[i] = last_popped
                        tree_parent[last_popped] = i
                  }
            }

            #L Se a pilha ainda contem elementos, i se torna filho direito do novo topo
            route {
                  top > 0 ==> {
                        mut as int64: parent_node = stack[top]
                        tree_right[parent_node] = i
                        tree_parent[i] = parent_node
                  }
            }

            #L Empilha no i
            top = top + 1
            stack[top] = i

            i = i + 1
      }

      #L A raiz da arvore e o no no fundo da pilha (espinha direita)
      mut as int64: root = stack[1]
      println("   Construcao concluida. Raiz = indice " + root + " (valor = " + arr[root] + ")")

      #L 3. Verificacao da Propriedade de Min-Heap
      println("3. Verificando propriedade de Min-Heap para todos os nos...")
      mut as bool: heap_ok = true

      mut as int64: u = 1
      infinite (u <= n) {
            mut as int64: l = tree_left[u]
            mut as int64: r = tree_right[u]

            route {
                  l != 0 ==> {
                        route {
                              arr[u] > arr[l] ==> { heap_ok = false }
                        }
                  }
            }

            route {
                  r != 0 ==> {
                        route {
                              arr[u] > arr[r] ==> { heap_ok = false }
                        }
                  }
            }

            u = u + 1
      }
      println("   Propriedade de Min-Heap valida: " + heap_ok)

      #L 4. Verificacao do Percurso In-Order (deve recuperar a sequencia original)
      println("4. Verificando percurso In-Order iterativo...")
      mut as list of int64: inorder_res = []
      mut as list of int64: s = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: s_top = 0
      mut as int64: curr = root

      infinite ((curr != 0) or (s_top > 0)) {
            infinite (curr != 0) {
                  s_top = s_top + 1
                  s[s_top] = curr
                  curr = tree_left[curr]
            }

            curr = s[s_top]
            s_top = s_top - 1

            inorder_res = listPushBack(inorder_res, arr[curr])
            curr = tree_right[curr]
      }

      mut as bool: inorder_ok = true
      mut as int64: k = 1
      infinite (k <= n) {
            route {
                  inorder_res[k] != arr[k] ==> {
                        inorder_ok = false
                  }
            }
            k = k + 1
      }
      println("   Percurso In-Order recupera perfeitamente o vetor original: " + inorder_ok)

      mut as bool: ok = heap_ok and inorder_ok and (root == 4) and (arr[root] == 1)
      println("5. Verificacao geral da Cartesian Tree: " + ok)
      println("Concluido com Sucesso")
}
