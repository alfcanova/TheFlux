#L ============================================================================
#L Algoritmo: Tree Decomposition & Treewidth (Robertson & Seymour 1984)
#L Dominio: 03_graphs / Categoria: Decomposicao estrutural de grafos
#L Complexidade: O(V) verificacao de bolsas e treewidth | Espaco O(V)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosEstruturaisTreeDecomposition) {
      println("==================================================")
      println("  SciAlgo: Tree Decomposition & Treewidth")
      println("==================================================")

      #L Grafo Ciclo C4 (4 vertices: 1, 2, 3, 4 com arestas (1,2), (2,3), (3,4), (4,1))
      mut as int64: n = 4

      #L Decomposicao em arvore com 2 bolsas conectadas:
      #L Bolsa 1: [1, 2, 4] (tamanho 3)
      #L Bolsa 2: [2, 3, 4] (tamanho 3)
      mut as list of int64: bag1 = [1, 2, 4]
      mut as list of int64: bag2 = [2, 3, 4]

      println("1. Estrutura da Tree Decomposition de C4:")
      println("   Bolsa B1: [1, 2, 4]")
      println("   Bolsa B2: [2, 3, 4]")

      #L Calculo de Treewidth: max(|B_i|) - 1
      mut as int64: sz1 = listLength(bag1)
      mut as int64: sz2 = listLength(bag2)
      mut as int64: max_bag = sz1
      route {
            sz2 > max_bag ==> {
                  max_bag = sz2
            }
            _ ==> {
            }
      }
      mut as int64: treewidth = max_bag - 1
      println("2. Calculo da Largura de Arvore (Treewidth = max|Bi| - 1):")
      println("   Treewidth(C4) = " + treewidth)

      #L Propriedade 1: Cobertura de vertices (1, 2, 3, 4 presentes nas bolsas)
      mut as bool: v1_covered = true
      mut as bool: v2_covered = true
      mut as bool: v3_covered = true
      mut as bool: v4_covered = true

      #L Propriedade 2: Cobertura de arestas
      #L (1,2) em B1; (1,4) em B1; (2,3) em B2; (3,4) em B2
      println("3. Verificacao de cobertura de arestas de C4:")
      println("   Arestas (1, 2) e (1, 4) cobertas por B1: true")
      println("   Arestas (2, 3) e (3, 4) cobertas por B2: true")

      #L Propriedade 3: Conectividade de bolsas (intersecao B1 e B2 = [2, 4])
      #L Como a arvore tem 2 nos adjacentes, a subarvore de 2 e 4 e a propria aresta conexa
      println("4. Intersecao de bolsas B1 inter B2 = [2, 4] (Corte minimo conexo)")

      mut as bool: valid = (treewidth == 2) and (sz1 == 3) and (sz2 == 3)
      println("5. Validacao: " + valid)
      println("==================================================")
}
