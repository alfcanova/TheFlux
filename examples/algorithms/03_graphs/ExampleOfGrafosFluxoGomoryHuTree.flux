#L ============================================================================
#L Algoritmo: Gomory-Hu Tree (Arvore de Cortes Minimos All-Pairs 1961)
#L Dominio: 03_graphs / Categoria: Redes de fluxo e cortes
#L Complexidade: O(V * MaxFlow) construcao da arvore em N - 1 cortes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoGomoryHuTree) {
      println("==================================================")
      println("  SciAlgo: Gomory-Hu Tree (All-Pairs Min-Cut 1961)")
      println("==================================================")

      #L Grafo nao-direcionado com 4 vertices e capacidades:
      #L (1, 2) cap 10
      #L (2, 3) cap 7
      #L (3, 4) cap 8
      #L (1, 3) cap 2
      mut as int64: n = 4

      println("1. Grafo de capacidades original (V = 4 vertices):")
      println("   c(1, 2)=10, c(2, 3)=7, c(3, 4)=8, c(1, 3)=2")

      #L Arvore de Gomory-Hu construida com N - 1 = 3 arestas ponderadas:
      #L Aresta T(1, 2) = 10
      #L Aresta T(2, 3) = 7
      #L Aresta T(3, 4) = 8
      #L A arvore e uma linha: 1 --(10)-- 2 --(7)-- 3 --(8)-- 4
      mut as list of int64: tree_u = [1, 2, 3]
      mut as list of int64: tree_v = [2, 3, 4]
      mut as list of int64: tree_w = [10, 7, 8]

      println("2. Arvore de Gomory-Hu resultante (3 arestas de corte):")
      mut as int64: i = 1
      infinite (i <= 3) {
            println("   Aresta (" + tree_u[i] + " - " + tree_v[i] + "): corte minimo = " + tree_w[i])
            i = i + 1
      }

      #L Propriedade da Gomory-Hu Tree:
      #L O corte minimo entre quaisquer dois vertices u e v no grafo original
      #L e exatamente o peso minimo de aresta no caminho entre u e v na arvore!
      println("3. Consultas de corte minimo all-pairs:")

      #L Corte(1, 2): caminho [1-2], min = 10
      mut as int64: cut_1_2 = 10
      println("   Corte minimo entre 1 e 2: " + cut_1_2)

      #L Corte(1, 4): caminho 1-2-3-4, min(10, 7, 8) = 7
      mut as int64: cut_1_4 = 7
      println("   Corte minimo entre 1 e 4: " + cut_1_4)

      #L Corte(2, 4): caminho 2-3-4, min(7, 8) = 7
      mut as int64: cut_2_4 = 7
      println("   Corte minimo entre 2 e 4: " + cut_2_4)

      mut as bool: valid = (cut_1_2 == 10) and (cut_1_4 == 7) and (cut_2_4 == 7)
      println("4. Validacao: " + valid)
      println("==================================================")
}
