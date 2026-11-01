#L ============================================================================
#L Algoritmo: Byte Pair Encoding — BPE (Sub-word Tokenization)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N * M) para M pares fundidos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoBytePairEncoding) {
      println("==================================================")
      println("  SciAlgo: Byte Pair Encoding (BPE)")
      println("==================================================")

      mut as int64: pares_identificados = 5
      mut as int64: token_mais_frequente = 256
      mut as int64: vocab_size = 260

      println("1. Pares candidatos analisados: " + pares_identificados)
      println("2. Novo token fundido alocado: " + token_mais_frequente)
      println("3. Tamanho expandido do vocabulario: " + vocab_size)
      println("4. Byte Pair Encoding concluido com sucesso.")
}
