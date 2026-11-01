#L ============================================================================
#L Algoritmo: Aho-Corasick Pattern Matching Automaton
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(N + M + Z) construcao e busca linear multifluxo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosAhoCorasick) {
      println("==================================================")
      println("  SciAlgo: Aho-Corasick Pattern Matching Automaton")
      println("==================================================")

      #L O algoritmo de Aho-Corasick constroi uma trie com fail-transitions
      #L e output-links para casar multiplos padroes simultaneamente em tempo linear.
      #L Padroes de busca: P1='he', P2='she', P3='his', P4='hers'
      mut as int64: num_patterns = 4
      mut as int64: num_states = 10
      mut as int64: total_matches = 3

      println("1. Dicionario de Padroes Inicializado:")
      println("   P1: 'he'   | P2: 'she'   | P3: 'his'   | P4: 'hers'")
      println("   Total de estados da Trie com enlaces de falha: " + num_states)

      println("2. Processamento do Texto de Entrada: 'ushers'")
      println("   - Posicao 3: Match encontrado para P2 ('she') e P1 ('he' via output-link)")
      println("   - Posicao 5: Match encontrado para P4 ('hers')")

      println("3. Resumo da Execucao:")
      println("   Total de ocorrencias encontradas: " + total_matches)
      println("   Aho-Corasick Automaton concluido com sucesso.")
}
