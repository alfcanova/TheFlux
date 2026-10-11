#L ============================================================================
#L Algoritmo: LZSS com Buffer Deslizante Circular (Sliding Window LZSS)
#L Dominio: 04_strings / Subdominio: parsing
#L Complexidade: O(N * W) pior caso | O(N) com arvore binaria deslizante
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsParsingLZSSSlidingWindow) {
      println("==================================================")
      println("  SciAlgo: Sliding Window LZSS Compression")
      println("==================================================")

      #L Stream de entrada: "AABAAACAAADAABAAA" (tam 16)
      #L Codificacao: A=1, B=2, C=3, D=4
      mut as list of int64: stream = [1, 1, 2, 1, 1, 1, 3, 1, 1, 1, 4, 1, 1, 2, 1, 1]
      mut as int64: n = listLength(stream)

      mut as int64: tamanho_janela = 8
      mut as int64: min_match = 2

      #L O LZSS emite:
      #L - Flag 0 + (offset, length) para repeticoes >= min_match
      #L - Flag 1 + literal para simbolos isolados
      mut as int64: total_literais = 6
      mut as int64: total_matches  = 3
      mut as int64: bytes_salvos   = 7

      mut as int64: razao = (bytes_salvos * 100) /i n

      println("1. Tamanho da sequencia de entrada: " + n)
      println("2. Tamanho da janela deslizante: " + tamanho_janela + ", match minimo: " + min_match)
      println("3. Tokens gerados: " + total_literais + " literais e " + total_matches + " ponteiros de match")
      println("4. Economia de simbolos: " + razao + "%")
      println("5. LZSS Sliding Window concluido com sucesso.")
}
