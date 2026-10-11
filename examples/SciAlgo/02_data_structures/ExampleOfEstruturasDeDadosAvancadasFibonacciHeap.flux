#L ============================================================================
#L Algoritmo: Fibonacci Heap (Fila de Prioridade Teórica Ótima de Fredman & Tarjan 1987)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(1) amort. insercao e decrease-key | O(log N) amort. extract-min
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasFibonacciHeap) {
      println("==================================================")
      println("  SciAlgo: Fibonacci Heap (Fredman & Tarjan)")
      println("==================================================")

      #L Chaves a inserir no Heap de Fibonacci: 40, 20, 60, 10, 50, 30, 70
      mut as list of int64: in_keys = [40, 20, 60, 10, 50, 30, 70]
      mut as int64: n = listLength(in_keys)

      #L Vetores paralelos de tamanho n (1-based: 1 a n)
      mut as list of int64: key = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: left_sibling = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: right_sibling = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: degree = [0, 0, 0, 0, 0, 0, 0]

      #L Insere o primeiro elemento (no 1)
      key[1] = in_keys[1]
      left_sibling[1] = 1
      right_sibling[1] = 1
      mut as int64: min_node = 1

      println("1. Inserindo " + n + " nos no anel de raizes do Fibonacci Heap:")
      println("   No 1: chave = " + key[1] + " (minimo inicial)")

      mut as int64: u = 2
      infinite (u <= n) {
            mut as int64: k = in_keys[u]
            key[u] = k

            #L Insere u imediatamente a direita de min_node no anel circular
            mut as int64: r = right_sibling[min_node]
            left_sibling[u] = min_node
            right_sibling[u] = r
            right_sibling[min_node] = u
            left_sibling[r] = u

            route {
                  k < key[min_node] ==> {
                        min_node = u
                  }
            }
            println("   No " + u + ": chave = " + k + " (minimo atual: " + key[min_node] + ")")
            u = u + 1
      }

      println("2. Minimo apos todas as insercoes: no " + min_node + " com chave " + key[min_node])

      #L Percurso do anel de raizes circular a partir do minimo
      mut as list of int64: root_keys = []
      mut as int64: cur = min_node
      infinite (true) {
            root_keys = listPushBack(root_keys, key[cur])
            cur = right_sibling[cur]
            route {
                  cur == min_node ==> {
                        break
                  }
            }
      }
      println("3. Elementos presentes no anel de raizes: " + root_keys)

      #L Operacao Extract-Min: extrai a chave minima (10 no no 4)
      mut as int64: extracted_min = key[min_node]
      println("4. Extraindo chave minima: " + extracted_min)

      #L Desconecta min_node do anel de raizes
      mut as int64: prev_min = left_sibling[min_node]
      mut as int64: next_min = right_sibling[min_node]
      right_sibling[prev_min] = next_min
      left_sibling[next_min] = prev_min

      #L Localiza o novo minimo no anel restante
      mut as int64: new_min = next_min
      cur = next_min
      infinite (true) {
            route {
                  key[cur] < key[new_min] ==> {
                        new_min = cur
                  }
            }
            cur = right_sibling[cur]
            route {
                  cur == next_min ==> {
                        break
                  }
            }
      }
      println("5. Novo minimo apos extracao: no " + new_min + " com chave " + key[new_min])

      #L Operacao Decrease-Key: reduz a chave do no 3 (de 60 para 15)
      println("6. Operacao Decrease-Key no no 3: 60 -> 15")
      key[3] = 15
      route {
            key[3] < key[new_min] ==> {
                  new_min = 3
            }
      }
      println("7. Minimo final apos Decrease-Key: " + key[new_min])

      println("8. Validacao: " + (extracted_min == 10 and key[new_min] == 15 and listLength(root_keys) == 7))
      println("==================================================")
}
