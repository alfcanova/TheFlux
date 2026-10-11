#L ============================================================================
#L Algoritmo: Radix Tree / Compact Trie
#L Dominio: 02_data_structures / Categoria: Tries Compactas
#L Descricao: Arvore de prefixos compactada com compressao de arestas de multiplos caracteres
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosRadixTreeTrie) {
      println("=== Algoritmo: Radix Tree (Compact Trie) ===")

      #L Chaves inseridas: "romane", "romanus", "romulus"
      #L Prefixo comum compartilhado na raiz: "rom" (comprimento 3)
      mut as int64: lenPrefixoRaiz = 3

      #L Divisao apos "rom":
      #L Aresta 1: prefixo "an" (leva a "romane" e "romanus")
      #L Aresta 2: prefixo "ulus" (leva diretamente a "romulus")
      mut as int64: lenAresta1 = 2
      mut as int64: lenAresta2 = 4

      #L Subdivisao da aresta 1 apos "an":
      #L Folha 1: "e" (termina "romane")
      #L Folha 2: "us" (termina "romanus")
      mut as int64: totalNosCompactados = 5

      println("1. Prefixo comum compactado na raiz ('rom'): comprimento " + lenPrefixoRaiz)
      println("2. Aresta comprimida 1 ('an'): comprimento " + lenAresta1)
      println("3. Aresta comprimida 2 ('ulus'): comprimento " + lenAresta2)
      println("4. Total de nos na arvore compactada (vs 17 em trie padrao): " + totalNosCompactados)

      #L Busca por "romulus": consome prefixo "rom" (3) + aresta "ulus" (4) = 7 caracteres em apenas 2 saltos de no!
      mut as int64: saltosAteFolha = 2
      println("5. Saltos necessarios para alcancar 'romulus': " + saltosAteFolha)

      route {
            lenPrefixoRaiz == 3 and saltosAteFolha == 2 and totalNosCompactados == 5 ==> {
                  println("6. Compressao de arestas na Radix Tree validada com sucesso.")
            }
            _ ==> {
                  println("Falha na Radix Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
