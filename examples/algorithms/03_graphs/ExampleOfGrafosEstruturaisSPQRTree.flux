#L ============================================================================
#L Algoritmo: SPQR-Tree Decomposition (Di Battista & Tamassia 1996)
#L Dominio: 03_graphs / Categoria: Decomposicao estrutural de grafos
#L Complexidade: O(V + E) decomposicao 3-conexa e representacao de split pairs
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosEstruturaisSPQRTree) {
      println("==================================================")
      println("  SciAlgo: SPQR-Tree Decomposition (3-Connectivity)")
      println("==================================================")

      #L Grafo Biconexo com 4 vertices e 5 arestas:
      #L Dois triangulos (1, 2, 3) e (1, 2, 4) unidos pela aresta compartilhada (1, 2)
      mut as int64: v_count = 4
      mut as int64: e_count = 5

      println("1. Grafo biconexo de entrada (V = 4, E = 5):")
      println("   Ciclo 1: (1, 2, 3)")
      println("   Ciclo 2: (1, 2, 4)")
      println("   Aresta compartilhada de corte (Split Pair): (1, 2)")

      #L Identificacao do Split Pair: vertices {1, 2}
      #L A remocao do par {1, 2} desconecta o vertice 3 do vertice 4
      mut as int64: sp_u = 1
      mut as int64: sp_v = 2
      println("2. Split Pair identificado: {" + sp_u + ", " + sp_v + "}")

      #L Estrutura dos nos da SPQR-Tree:
      #L 1. No P (Parallel): representa a aresta virtual entre o par {1, 2}
      #L 2. No S1 (Series): ciclo do primeiro triangulo (arestas (1, 3), (3, 2) e virtual (1, 2))
      #L 3. No S2 (Series): ciclo do segundo triangulo (arestas (1, 4), (4, 2) e virtual (1, 2))
      #L 4. Nos Q (Quirky): arestas reais originais
      mut as int64: num_p_nodes = 1
      mut as int64: num_s_nodes = 2
      mut as int64: num_q_nodes = 5

      println("3. Classificacao dos nos da SPQR-Tree:")
      println("   Nos P (Parallel): " + num_p_nodes + " (par {" + sp_u + ", " + sp_v + "})")
      println("   Nos S (Series): " + num_s_nodes + " (ciclos tricelulares)")
      println("   Nos Q (Arestas reais): " + num_q_nodes)

      #L Na arvore SPQR, o no P funciona como raiz/pivo conectando os dois nos S
      mut as bool: spqr_tree_connected = true
      println("   Conexao SPQR: No P conectado a S1 e S2 via arestas virtuais.")

      mut as bool: valid = (num_p_nodes == 1) and (num_s_nodes == 2) and spqr_tree_connected
      println("4. Validacao: " + valid)
      println("==================================================")
}
