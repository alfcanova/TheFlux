#L ============================================================================
#L Algoritmo: Q-Gram Distance com Filtro Invertido de Exclusao
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(|S1| + |S2|) tempo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaQGramFilter) {
      println("==================================================")
      println("  SciAlgo: Q-Gram Distance & Inverted Filter")
      println("==================================================")

      #L S1: "ALGORITHM", S2: "ALTRUISM" (q=2 digramas)
      #L Digramas de S1: AL, LG, GO, OR, RI, IT, TH, HM (8 digramas)
      #L Digramas de S2: AL, LT, TR, RU, UI, IS, SM (7 digramas)
      #L Perfil de frequencia de 6 digramas comuns analisados:
      mut as list of int64: freq_s1 = [1, 1, 0, 1, 0, 1]
      mut as list of int64: freq_s2 = [1, 0, 1, 0, 1, 1]
      mut as int64: num_digramas = listLength(freq_s1)

      #L Distancia Q-gram: soma |freq_s1[i] - freq_s2[i]|
      mut as int64: dist_qgram = 0
      mut as int64: i = 1
      infinite (i <= num_digramas) {
            mut as int64: diff = freq_s1[i] - freq_s2[i]
            route {
                  diff < 0 ==> { diff = 0 - diff }
                  _ ==> {}
            }
            dist_qgram = dist_qgram + diff
            i = i + 1
      }

      #L Limite inferior para distancia de edicao de Levenshtein: ceil(dist_qgram / (2 * q))
      mut as int64: limite_inferior_edicao = (dist_qgram + 3) /i 4

      println("1. Digramas analisados: " + num_digramas)
      println("2. Distancia Q-Gram calculada: " + dist_qgram)
      println("3. Limite inferior para distancia de edicao: " + limite_inferior_edicao)
      println("4. Q-Gram Filter concluido com sucesso.")
}
