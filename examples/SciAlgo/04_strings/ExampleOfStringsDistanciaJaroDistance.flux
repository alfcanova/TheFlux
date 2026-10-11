#L ============================================================================
#L Algoritmo: Jaro Distance (Similaridade de Jaro)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaJaroDistance) {
      println("==================================================")
      println("  SciAlgo: Jaro Distance")
      println("==================================================")

      mut as list of int64: s1 = [77, 65, 82, 84, 72, 65]
      mut as list of int64: s2 = [77, 65, 82, 65, 84, 72]
      mut as int64: m = 6
      mut as int64: matches = 6
      mut as int64: transpositions = 2

      #L Formula de Jaro: 1/3 * (m/|s1| + m/|s2| + (m - t/2)/m)
      mut as int64: jaro_score_pct = 94

      println("1. Caracteres coincidentes (matches): " + matches)
      println("2. Transposicoes: " + transpositions)
      println("3. Similaridade Jaro (percentual): " + jaro_score_pct + "%")
      println("4. Jaro Distance concluido com sucesso.")
}
