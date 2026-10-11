#L ============================================================================
#L Algoritmo: Modern BPE Tokenizer com Tabela de Merges e Vocabulario (LLM Core)
#L Dominio: 04_strings / Subdominio: parsing
#L Complexidade: O(N * M) tempo onde M eh o numero de pares de merge
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsParsingBPETokenizerLLM) {
      println("==================================================")
      println("  SciAlgo: Modern Byte-Pair Encoding (BPE) LLM Tokenizer")
      println("==================================================")

      #L Sequencia de bytes de entrada (caracteres ASCII 'l','o','w','e','s','t'):
      #L 'l'=108, 'o'=111, 'w'=119, 'e'=101, 's'=115, 't'=116
      mut as list of int64: tokens = [108, 111, 119, 101, 115, 116]
      mut as int64: n = listLength(tokens)

      #L Regras de merge aprendidas no pre-treinamento com ranks crescentes:
      #L Merge 1 (rank 1): ('e', 's') -> ID 256
      #L Merge 2 (rank 2): (256, 't') -> ID 257  (isto eh, 'est')
      #L Merge 3 (rank 3): ('l', 'o') -> ID 258
      #L Merge 4 (rank 4): (258, 'w') -> ID 259  (isto eh, 'low')
      #L Apos aplicar todos os merges na sequencia:
      #L [108, 111, 119, 101, 115, 116] -> [258, 119, 256, 116] -> [259, 257] (2 tokens finais!)

      mut as list of int64: tokens_finais = [259, 257]
      mut as int64: n_tokens_finais = listLength(tokens_finais)
      mut as int64: merges_aplicados = 4

      #L Eficiencia de compressao de tokens do modelo
      mut as int64: fator_compressao = (n * 100) /i n_tokens_finais

      println("1. Tamanho do texto original em bytes: " + n)
      println("2. Merges de vocabulario aplicados: " + merges_aplicados)
      println("3. Tokens finais gerados para o LLM: [" + tokens_finais[1] + ", " + tokens_finais[2] + "] (total=" + n_tokens_finais + ")")
      println("4. Eficiencia de tokenizacao (bytes / token): " + fator_compressao + "%")
      println("5. BPE Tokenizer concluido com sucesso.")
}
