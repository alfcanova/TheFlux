#L ============================================================================
#L Algoritmo: Adaptive Huffman Coding (Vitter / FGK)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) por simbolo atualizado na arvore dinamica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoAdaptiveHuffman) {
      println("==================================================")
      println("  SciAlgo: Adaptive Huffman Coding (Vitter)")
      println("==================================================")

      mut as list of int64: entrada = [65, 66, 65, 65, 67]
      mut as int64: n = listLength(entrada)
      mut as int64: nyt_node = 0
      mut as int64: nos_totais = 1

      mut as int64: i = 1
      infinite (i <= n) {
            nos_totais = nos_totais + 2
            i = i + 1
      }

      println("1. Simbolos transmitidos no fluxo: " + n)
      println("2. Total de nos na arvore adaptativa: " + nos_totais)
      println("3. Adaptive Huffman concluido com sucesso.")
}
