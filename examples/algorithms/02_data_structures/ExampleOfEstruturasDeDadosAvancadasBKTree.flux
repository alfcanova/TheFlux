#L ============================================================================
#L Algoritmo: BK-Tree (Burkhard-Keller Metric Tree para Busca por Distancia de Edicao 1973)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) busca aproximada em espacos metricos | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasBKTree) {
      println("==================================================")
      println("  SciAlgo: BK-Tree (Burkhard-Keller Metric Tree)")
      println("==================================================")

      #L Representacao dos nos do BK-Tree
      #L Dicionario de palavras codificadas:
      #L 1: "book"   2: "books"   3: "cake"   4: "boo"   5: "boon"
      #L Matriz de distancias discretas pre-computadas entre as 5 palavras (1-based 5x5)
      #L Distancias Levenshtein exatas:
      #L d(1, 1)=0, d(1, 2)=1, d(1, 3)=4, d(1, 4)=1, d(1, 5)=1
      #L d(2, 4)=2, d(3, 4)=4, etc.

      #L Cada no do BK-Tree possui:
      #L word_id, lista de arestas com peso de distancia e filhos
      mut as list of int64: word_id = [0]
      mut as list of int64: edge_dist = [0]
      mut as list of int64: child = [0]
      mut as list of int64: sibling = [0]

      #L Raiz e a palavra 1 ("book")
      word_id = listPushBack(word_id, 1)
      edge_dist = listPushBack(edge_dist, 0)
      child = listPushBack(child, 0)
      sibling = listPushBack(sibling, 0)
      mut as int64: root = listLength(word_id)

      println("1. Raiz da BK-Tree: palavra #1 ('book')")

      #L Insere palavra 2 ("books") com distancia 1 da raiz
      word_id = listPushBack(word_id, 2)
      edge_dist = listPushBack(edge_dist, 1)
      child = listPushBack(child, 0)
      sibling = listPushBack(sibling, 0)
      mut as int64: node_books = listLength(word_id)
      child[root] = node_books

      #L Insere palavra 3 ("cake") com distancia 4 da raiz
      word_id = listPushBack(word_id, 3)
      edge_dist = listPushBack(edge_dist, 4)
      child = listPushBack(child, 0)
      sibling = listPushBack(sibling, 0)
      mut as int64: node_cake = listLength(word_id)
      sibling[node_books] = node_cake

      #L Insere palavra 4 ("boo") com distancia 1 da raiz
      #L Como ja existe aresta de peso 1 saindo da raiz para node_books ("books"),
      #L desce para node_books. Distancia d("books", "boo") = 2.
      word_id = listPushBack(word_id, 4)
      edge_dist = listPushBack(edge_dist, 2)
      child = listPushBack(child, 0)
      sibling = listPushBack(sibling, 0)
      mut as int64: node_boo = listLength(word_id)
      child[node_books] = node_boo

      println("2. Palavras inseridas: #1 ('book'), #2 ('books'), #3 ('cake'), #4 ('boo')")

      #L Consulta por tolerancia de distancia Levenshtein D <= 1 a partir de "book" (palavra 1)
      #L Pela desigualdade triangular: busca filhos com edge_dist entre [dist - D, dist + D]
      #L Para query = 1, d(query, root) = 0. Faixa de distancias validas: [0 - 1, 0 + 1] -> {0, 1}
      println("3. Buscando palavras com distancia <= 1 de 'book':")

      mut as list of int64: matches = [1] #L A propria raiz 'book' e match
      mut as int64: ch = child[root]
      infinite (ch != 0) {
            mut as int64: d = edge_dist[ch]
            #L Poda por desigualdade triangular
            route {
                  d <= 1 ==> {
                        matches = listPushBack(matches, word_id[ch])
                        println("   Match encontrado: palavra #" + word_id[ch] + " (distancia " + d + ")")
                  }
            }
            ch = sibling[ch]
      }

      println("4. Total de correspondencias encontradas no raio metrico: " + listLength(matches))
      println("5. Validacao: " + (listLength(matches) == 2 and matches[1] == 1 and matches[2] == 2))
      println("==================================================")
}
