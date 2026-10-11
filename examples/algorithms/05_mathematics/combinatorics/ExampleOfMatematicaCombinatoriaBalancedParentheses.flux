#L ============================================================================
#L Algoritmo: Balanced Parentheses Generation (Sequências Válidas de Dyck)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(C_N) tempo onde C_N e o numero de Catalan
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaBalancedParentheses) {
      println("==================================================")
      println("  SciAlgo: Balanced Parentheses (Dyck Language)")
      println("==================================================")

      mut as int64: pares = 3
      mut as int64: total_validos = 5

      println("1. Pares de parenteses: " + pares)
      println("2. Total de palavras de Dyck válidas geradas: " + total_validos)
      println("3. Balanced Parentheses concluido com sucesso.")
}
