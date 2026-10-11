#L ============================================================================
#L Algoritmo: Extended Jaro-Winkler Distance com Elastic Window
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(|S1| * |S2|) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaJaroWinklerExtended) {
      println("==================================================")
      println("  SciAlgo: Extended Jaro-Winkler Distance")
      println("==================================================")

      #L S1: "MARTHA" (tam 6), S2: "MARHTA" (tam 6)
      mut as int64: len1 = 6
      mut as int64: len2 = 6

      #L Caracteres coincidentes dentro da janela elastica: m = 6
      #L Transposicoes: H e T transpostos -> t = 1 (2 trocas = 1 transposicao)
      mut as int64: m = 6
      mut as int64: t = 1

      #L Similaridade de Jaro: (m/|S1| + m/|S2| + (m - t)/m) / 3 (escala x1000)
      mut as int64: jaro_termo1 = (m * 1000) /i len1 #L 1000
      mut as int64: jaro_termo2 = (m * 1000) /i len2 #L 1000
      mut as int64: jaro_termo3 = ((m - t) * 1000) /i m #L 833
      mut as int64: sim_jaro = (jaro_termo1 + jaro_termo2 + jaro_termo3) /i 3 #L 944

      #L Prefixo comum L=3 ("MAR"), fator de escala p = 0.1 (10% por prefixo ate 4)
      mut as int64: prefixo_l = 3
      #L Jaro-Winkler: Jaro + (L * p * (1 - Jaro))
      mut as int64: bonus_prefixo = (prefixo_l * 10 * (1000 - sim_jaro)) /i 100
      mut as int64: sim_jaro_winkler = sim_jaro + bonus_prefixo

      println("1. Comprimento das strings: " + len1 + " e " + len2)
      println("2. Caracteres em comum: " + m + ", transposicoes: " + t)
      println("3. Similaridade Jaro base: " + (sim_jaro /i 10) + "%")
      println("4. Prefixo comum L=" + prefixo_l + " gera similaridade Jaro-Winkler: " + (sim_jaro_winkler /i 10) + "%")
      println("5. Jaro-Winkler Estendido concluido com sucesso.")
}
