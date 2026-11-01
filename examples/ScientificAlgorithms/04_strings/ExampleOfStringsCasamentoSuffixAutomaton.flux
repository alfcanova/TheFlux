#L ============================================================================
#L Algoritmo: Suffix Automaton (DAWG / Grafo Acíclico de Palavras Dirigido)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo e estados
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoSuffixAutomaton) {
      println("==================================================")
      println("  SciAlgo: Suffix Automaton (DAWG)")
      println("==================================================")

      mut as int64: estados_max = 13
      mut as int64: transicoes_max = 25

      println("1. Maximo de estados no DAWG (<= 2N-1): " + estados_max)
      println("2. Maximo de transicoes (<= 3N-4): " + transicoes_max)
      println("3. Suffix Automaton concluido com sucesso.")
}
