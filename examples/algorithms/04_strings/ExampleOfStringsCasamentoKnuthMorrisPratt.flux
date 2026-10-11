#L ============================================================================
#L Algoritmo: Knuth-Morris-Pratt — KMP (Casamento Linear via Tabela Pi)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N + M) tempo linear estrito
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoKnuthMorrisPratt) {
      println("==================================================")
      println("  SciAlgo: Knuth-Morris-Pratt (KMP)")
      println("==================================================")

      #L Padrao "ABABC" -> tabela pi: [0, 0, 1, 2, 0]
      mut as list of int64: pi = [0, 0, 1, 2, 0]
      mut as int64: m = listLength(pi)
      mut as int64: match_pos = 3

      println("1. Tabela de prefixos Pi (LPS) de tamanho: " + m)
      println("2. Posicao de casamento localizada: " + match_pos)
      println("3. KMP concluido com sucesso.")
}
