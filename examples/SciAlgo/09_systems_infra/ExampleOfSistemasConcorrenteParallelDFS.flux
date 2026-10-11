#L ============================================================================
#L Algoritmo: Parallel DFS (Subtree Stack Splitting / Concurrent Search)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(V + E) trabalho | O(H) profundidade de busca
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteParallelDFS) {
      println("==================================================")
      println("  SciAlgo: Parallel DFS (Subtree Stack Splitting) ")
      println("==================================================")

      #L Arvore com V = 7 vertices:
      #L 1 (raiz) -> Filhos: 2 (subarvore esquerda) e 3 (subarvore direita)
      #L 2 -> Filhos: 4, 5
      #L 3 -> Filhos: 6, 7
      mut as int64: v = 7
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0, 0, #L 1: -> 2, 3
            0, 0, 0, 1, 1, 0, 0, #L 2: -> 4, 5
            0, 0, 0, 0, 0, 1, 1, #L 3: -> 6, 7
            0, 0, 0, 0, 0, 0, 0, #L 4
            0, 0, 0, 0, 0, 0, 0, #L 5
            0, 0, 0, 0, 0, 0, 0, #L 6
            0, 0, 0, 0, 0, 0, 0  #L 7
      ]

      println("1. Arvore Definida com 7 Vertices:")
      println("   Raiz: 1")
      println("   Subarvore Esquerda (Ramo 2): {4, 5}")
      println("   Subarvore Direita (Ramo 3): {6, 7}")

      #L Alvo de busca distribuida: Procurar vertice 5 e vertice 7
      mut as int64: target_a = 5
      mut as int64: target_b = 7

      mut as bool: found_by_t1 = false
      mut as bool: found_by_t2 = false

      println("2. Stack Splitting na Raiz: Atribuicao de Ramos as Threads:")
      println("   Thread 1 recebe Subarvore Enraizada em 2")
      println("   Thread 2 recebe Subarvore Enraizada em 3")

      #L Thread 1 executa DFS na subarvore 2 (pilha local com capacidade 10)
      mut as list of int64: stack1 = [2, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top1 = 1
      mut as int64: visited_count_t1 = 0

      infinite (top1 > 0) {
            mut as int64: curr = stack1[top1]
            top1 = top1 - 1
            visited_count_t1 = visited_count_t1 + 1

            route {
                  curr == target_a ==> {
                        found_by_t1 = true
                  }
                  _ ==> {}
            }

            #L Empilha filhos de curr
            mut as int64: child = 1
            infinite (child <= v) {
                  route {
                        adj[(curr - 1) * v + child] == 1 ==> {
                              top1 = top1 + 1
                              stack1[top1] = child
                        }
                        _ ==> {}
                  }
                  child = child + 1
            }
      }

      #L Thread 2 executa DFS na subarvore 3 (pilha local)
      mut as list of int64: stack2 = [3, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top2 = 1
      mut as int64: visited_count_t2 = 0

      infinite (top2 > 0) {
            mut as int64: curr = stack2[top2]
            top2 = top2 - 1
            visited_count_t2 = visited_count_t2 + 1

            route {
                  curr == target_b ==> {
                        found_by_t2 = true
                  }
                  _ ==> {}
            }

            mut as int64: child = 1
            infinite (child <= v) {
                  route {
                        adj[(curr - 1) * v + child] == 1 ==> {
                              top2 = top2 + 1
                              stack2[top2] = child
                        }
                        _ ==> {}
                  }
                  child = child + 1
            }
      }

      println("3. Resultados da Busca Concorrente:")
      println("   Thread 1 visitou " + visited_count_t1 + " vertices | Encontrou alvo 5: " + found_by_t1)
      println("   Thread 2 visitou " + visited_count_t2 + " vertices | Encontrou alvo 7: " + found_by_t2)

      #L Verificacao deterministica
      mut as bool: success = found_by_t1 and found_by_t2 and (visited_count_t1 == 3) and (visited_count_t2 == 3)
      println("4. Verificacao de Integridade da Busca Paralela: " + success)

      println("Parallel DFS concluido com sucesso.")
}
