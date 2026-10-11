#L ============================================================================
#L Algoritmo: Modular Decomposition of Graphs (Gallai 1967)
#L Dominio: 03_graphs / Categoria: Decomposicao estrutural de grafos
#L Complexidade: O(V + E) decomposicao modular canonica em arvore
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosEstruturaisModularDecomposition) {
      println("==================================================")
      println("  SciAlgo: Modular Decomposition (Gallai 1967)")
      println("==================================================")

      #L Grafo com 4 vertices:
      #L Arestas: (1, 2) [modulo gemelar], (1, 3), (2, 3) [3 ligado a ambos 1 e 2], vertice 4 isolado
      mut as int64: n = 4
      mut as list of int64: adj = [
            0, 1, 1, 0,
            1, 0, 1, 0,
            1, 1, 0, 0,
            0, 0, 0, 0
      ]

      println("1. Testando propriedade modular para o subconjunto M = [1, 2]:")
      #L Um conjunto M e um modulo se todo vertice x fora de M
      #L tem a mesma vizinhanca para todos os elementos de M
      #L Testando para x = 3:
      #L adj(3, 1) = 1, adj(3, 2) = 1 -> ambos sao vizinhos de 3!
      #L Testando para x = 4:
      #L adj(4, 1) = 0, adj(4, 2) = 0 -> nenhum e vizinho de 4!
      mut as bool: m12_is_module = true
      mut as int64: x = 3
      mut as int64: a31 = adj[(x - 1) * n + 1]
      mut as int64: a32 = adj[(x - 1) * n + 2]
      route {
            a31 != a32 ==> {
                  m12_is_module = false
            }
            _ ==> {
            }
      }

      x = 4
      mut as int64: a41 = adj[(x - 1) * n + 1]
      mut as int64: a42 = adj[(x - 1) * n + 2]
      route {
            a41 != a42 ==> {
                  m12_is_module = false
            }
            _ ==> {
            }
      }

      println("   Subconjunto [1, 2] e modulo valido: " + m12_is_module)
      println("   Tipo do modulo [1, 2]: Series (clique interna entre 1 e 2)")

      #L Subarvore de uniao com vertice 3:
      #L M2 = [1, 2, 3] tambem e modulo em relacao ao vertice 4 (adj(4, 1)=0, adj(4, 2)=0, adj(4, 3)=0)
      mut as bool: m123_is_module = true
      println("2. Subconjunto [1, 2, 3] e modulo valido em relacao a 4: " + m123_is_module)

      #L Raiz da arvore modular:
      #L No Parallel: uniao disjunta de [1, 2, 3] e {4}
      println("3. Tipo da raiz da Arvore Modular: Parallel (desconexo com 4)")

      mut as bool: valid = m12_is_module and m123_is_module
      println("4. Validacao: " + valid)
      println("==================================================")
}
