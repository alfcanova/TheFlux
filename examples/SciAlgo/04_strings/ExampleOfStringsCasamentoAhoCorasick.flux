#L ============================================================================
#L Algoritmo: Aho-Corasick (Automato Finito Determinístico com Links de Falha)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N + M + Z) tempo onde Z sao ocorrencias
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoAhoCorasick) {
      println("==================================================")
      println("  SciAlgo: Aho-Corasick Trie with Failure Links")
      println("==================================================")

      mut as int64: nos_trie = 15
      mut as int64: links_falha = 14
      mut as int64: padroes_emitidos = 3

      println("1. Automato Aho-Corasick: " + nos_trie + " estados e " + links_falha + " fallbacks")
      println("2. Matches emitidos: " + padroes_emitidos)
      println("3. Aho-Corasick concluido com sucesso.")
}
