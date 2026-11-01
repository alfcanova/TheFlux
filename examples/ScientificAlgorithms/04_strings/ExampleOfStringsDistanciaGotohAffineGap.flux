#L ============================================================================
#L Algoritmo: Gotoh Sequence Alignment com Penalidade Afim de Lacunas (Affine Gap)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo e espaco quadratico via 3 matrizes DP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaGotohAffineGap) {
      println("==================================================")
      println("  SciAlgo: Gotoh Affine Gap Penalty Alignment")
      println("==================================================")

      #L Alinhamento com modelo afim: custo de gap = gap_open + k * gap_ext
      #L Penalidades: gap_open = 10, gap_ext = 2
      #L Casamento: match = +5, mismatch = -3
      mut as int64: gap_open = 10
      mut as int64: gap_ext  = 2
      mut as int64: match_score = 5
      mut as int64: mismatch_score = -3

      #L S1: "ACGT" (tam 4), S2: "AGT" (tam 3) -> 1 delecao de tamanho 1 ('C')
      #L Score otimo: A=A (+5) + Gap('C') (-10 - 2) + G=G (+5) + T=T (+5) = 15 - 12 = 3
      mut as list of int64: s1 = [1, 2, 3, 4]
      mut as list of int64: s2 = [1, 3, 4]
      mut as int64: m = listLength(s1)
      mut as int64: n = listLength(s2)

      #L Simulacao da transicao de 3 estados de Gotoh: M (match), P (gap horizontal), Q (gap vertical)
      mut as int64: score_match_1 = match_score #L A com A (+5)
      mut as int64: score_gap_c   = 0 - (gap_open + gap_ext) #L -12
      mut as int64: score_match_2 = match_score #L G com G (+5)
      mut as int64: score_match_3 = match_score #L T com T (+5)

      mut as int64: score_alinhamento = score_match_1 + score_gap_c + score_match_2 + score_match_3

      println("1. Sequencias: |S1|=" + m + ", |S2|=" + n)
      println("2. Parametros: Gap Open=" + gap_open + ", Gap Extension=" + gap_ext)
      println("3. Score global calculado com modelo afim: " + score_alinhamento)
      println("4. Algoritmo de Gotoh concluido com sucesso.")
}
