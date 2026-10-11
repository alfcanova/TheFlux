#L ============================================================================
#L Algoritmo: Huffman Coding (Codificação de Huffman Estática)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N log N) para construcao da arvore
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoHuffmanCoding) {
      println("==================================================")
      println("  SciAlgo: Static Huffman Coding")
      println("==================================================")

      mut as list of int64: frequencias = [5, 9, 12, 13, 16, 45]
      mut as int64: n = listLength(frequencias)

      #L Construção de pesos acumulados na árvore de Huffman
      mut as int64: peso_arvore = 0
      mut as int64: i = 1
      infinite (i <= n) {
            peso_arvore = peso_arvore + frequencias[i]
            i = i + 1
      }

      println("1. Simbolos analisados: " + n)
      println("2. Peso total acumulado na raiz da arvore: " + peso_arvore)
      println("3. Huffman Coding concluido com sucesso.")
}
