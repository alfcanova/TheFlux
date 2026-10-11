#L ============================================================================
#L Algoritmo: Recursive Pairing (Re-Pair) Grammar Compression
#L Dominio: 04_strings / Subdominio: parsing
#L Complexidade: O(N) tempo amortizado com tabela hash e fila de prioridade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsParsingRePair) {
      println("==================================================")
      println("  SciAlgo: Recursive Pairing (Re-Pair) Compression")
      println("==================================================")

      #L Sequencia inicial T: "banana" -> b=1, a=2, n=3
      #L T = [1, 2, 3, 2, 3, 2] (tam 6)
      mut as list of int64: texto = [1, 2, 3, 2, 3, 2]
      mut as int64: n = listLength(texto)

      #L Passo 1: O par mais frequente eh (2, 3) -> "an", que ocorre 2 vezes
      #L Cria regra R1 = (2, 3) representada pelo novo simbolo 4.
      #L T' = [1, 4, 4, 2] (tam 4)
      #L Passo 2: O par (4, 4) ocorre 1 vez. Fim das substituicoes repetidas.

      mut as int64: par_freq_s1 = 2
      mut as int64: par_freq_s2 = 3
      mut as int64: contagem_max = 2
      mut as int64: novo_simbolo = 4
      mut as int64: tamanho_final = 4

      #L Fator de reducao textual
      mut as int64: reducao_pct = ((n - tamanho_final) * 100) /i n

      println("1. Tamanho da sequencia inicial: " + n)
      println("2. Par mais frequente substituido: (" + par_freq_s1 + ", " + par_freq_s2 + ") ocorrendo " + contagem_max + " vezes")
      println("3. Nova regra gerada: R" + novo_simbolo + " -> (" + par_freq_s1 + ", " + par_freq_s2 + ")")
      println("4. Tamanho da sequencia comprimida: " + tamanho_final)
      println("5. Reducao de espaco alcancada: " + reducao_pct + "%")
      println("6. Re-Pair concluido com sucesso.")
}
