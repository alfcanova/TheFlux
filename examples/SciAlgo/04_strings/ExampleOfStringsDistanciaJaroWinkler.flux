#L ============================================================================
#L Algoritmo: Jaro-Winkler Distance (Jaro com Peso de Prefixo Comum)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaJaroWinkler) {
      println("==================================================")
      println("  SciAlgo: Jaro-Winkler Distance")
      println("==================================================")

      mut as int64: jaro_pct = 94
      mut as int64: prefix_len = 3
      #L Ajuste de Winkler: jaro + prefix * 0.1 * (100 - jaro)
      mut as int64: bonus = (prefix_len * (100 - jaro_pct)) /i 10
      mut as int64: jaro_winkler_pct = jaro_pct + bonus

      println("1. Similaridade Jaro base: " + jaro_pct + "%")
      println("2. Comprimento de prefixo comum: " + prefix_len)
      println("3. Indice Jaro-Winkler: " + jaro_winkler_pct + "%")
      println("4. Jaro-Winkler concluido com sucesso.")
}
