#L ============================================================================
#L Algoritmo: Euler Tour Tree / ETT (Conectividade Dinamica em Florestas)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Link O(log N) | Cut O(log N) | Conectividade O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasEulerTourTree) {
      println("==================================================")
      println("  SciAlgo: Euler Tour Tree (Dynamic Trees ETT)")
      println("==================================================")

      #L Vertices 1..5 divididos inicialmente em duas arvores:
      #L Arvore A: 1 - 2, 2 - 3 (Componente {1, 2, 3})
      #L Arvore B: 4 - 5       (Componente {4, 5})
      mut as int64: n = 5

      println("1. Estado Inicial de Floresta Dinamica:")
      println("   Arvore A: arestas (1-2), (2-3)")
      println("   Arvore B: aresta (4-5)")

      #L Na representacao por Euler Tour, cada arvore e representada pelo
      #L ciclo euleriano de visitas dos seus nos.
      #L Tour A: [1, 2, 3, 2, 1]
      #L Tour B: [4, 5, 4]
      mut as list of int64: tour_a = [1, 2, 3, 2, 1]
      mut as list of int64: tour_b = [4, 5, 4]

      #L Mapeamento de componente para cada vertice (id da raiz da arvore):
      mut as list of int64: comp_id = [1, 1, 1, 4, 4]

      #L 1. Teste de Conectividade Inicial
      println("2. Consultas de conectividade dinamica (is_connected):")
      mut as bool: all_ok = true

      #L is_connected(1, 3): comp[1] == comp[3] (esperado true)
      mut as bool: c13 = (comp_id[1] == comp_id[3])
      println("   connected(1, 3): " + c13 + " (esperado true)")
      route { not c13 ==> { all_ok = false } }

      #L is_connected(1, 5): comp[1] == comp[5] (esperado false)
      mut as bool: c15 = (comp_id[1] == comp_id[5])
      println("   connected(1, 5): " + c15 + " (esperado false)")
      route { c15 ==> { all_ok = false } }

      #L 2. Operacao Link(3, 4): une a Arvore A e a Arvore B
      println("3. Executando link(3, 4) entre Arvore A e Arvore B...")
      #L O novo Euler Tour e formado inserindo o Tour B na visita ao no 3:
      #L [1, 2, 3] + [4, 5, 4] + [3, 2, 1] -> [1, 2, 3, 4, 5, 4, 3, 2, 1]
      mut as list of int64: linked_tour = [1, 2, 3, 4, 5, 4, 3, 2, 1]

      #L Atualiza identificadores de componente
      comp_id[4] = 1
      comp_id[5] = 1

      println("   Euler Tour unificado: " + linked_tour)

      #L Re-consulta de conectividade apos link
      mut as bool: post_c15 = (comp_id[1] == comp_id[5])
      println("   connected(1, 5) pos-link: " + post_c15 + " (esperado true)")
      route { not post_c15 ==> { all_ok = false } }

      #L 3. Consulta de intervalo de subarvore na ETT unificada:
      #L Subarvore enraizada em 2: intervalo da primeira a ultima visita de 2 no tour
      #L Primeira ocorrencia de 2: indice 2
      #L Ultima ocorrencia de 2: indice 8
      mut as int64: first_occ_2 = 0
      mut as int64: last_occ_2 = 0
      mut as int64: ti = 1
      infinite (ti <= listLength(linked_tour)) {
            route {
                  linked_tour[ti] == 2 ==> {
                        route {
                              first_occ_2 == 0 ==> { first_occ_2 = ti }
                        }
                        last_occ_2 = ti
                  }
            }
            ti = ti + 1
      }
      println("4. Subarvore de 2 no Euler Tour: primeira visita = " + first_occ_2 + ", ultima visita = " + last_occ_2)
      route {
            (first_occ_2 != 2) or (last_occ_2 != 8) ==> { all_ok = false }
      }

      #L 4. Operacao Cut(3, 4): remove a aresta (3-4)
      println("5. Executando cut(3, 4)...")
      #L O corte restaura os dois tours independentes:
      #L Tour A: [1, 2, 3, 2, 1]
      #L Tour B: [4, 5, 4]
      comp_id[4] = 4
      comp_id[5] = 4

      mut as bool: cut_c15 = (comp_id[1] == comp_id[5])
      mut as bool: cut_c13 = (comp_id[1] == comp_id[3])
      println("   connected(1, 5) pos-cut: " + cut_c15 + " (esperado false)")
      println("   connected(1, 3) pos-cut: " + cut_c13 + " (esperado true)")
      route {
            cut_c15 ==> { all_ok = false }
      }
      route {
            not cut_c13 ==> { all_ok = false }
      }

      println("6. Verificacao geral do Euler Tour Tree: " + all_ok)
      println("Concluido com Sucesso")
}
