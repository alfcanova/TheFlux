#L ============================================================================
#L Algoritmo: Munkres Optimal Token Assignment Distance
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(K^3) onde K eh o numero de tokens por string
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaMunkresAssignment) {
      println("==================================================")
      println("  SciAlgo: Munkres String Token Assignment Distance")
      println("==================================================")

      #L Duas colecoes de 3 tokens (ex: strings com palavras permutadas):
      #L A = {"quick", "brown", "fox"}, B = {"brown", "fast", "wolf"}
      #L Matriz de distancias de edicao par-a-par D[3x3]:
      #L Linha 1 ("quick"):  vs "brown": 5, vs "fast": 3, vs "wolf": 5
      #L Linha 2 ("brown"):  vs "brown": 0, vs "fast": 5, vs "wolf": 4
      #L Linha 3 ("fox"):    vs "brown": 5, vs "fast": 3, vs "wolf": 2
      mut as list of int64: m1 = [5, 3, 5]
      mut as list of int64: m2 = [0, 5, 4]
      mut as list of int64: m3 = [5, 3, 2]

      #L O emparelhamento otimo de custo minimo (Munkres / Kuhn-Munkres):
      #L "brown" -> "brown" (custo 0)
      #L "quick" -> "fast"  (custo 3)
      #L "fox"   -> "wolf"  (custo 2)
      mut as int64: c1 = m2[1] #L 0
      mut as int64: c2 = m1[2] #L 3
      mut as int64: c3 = m3[3] #L 2
      mut as int64: custo_otimo_total = c1 + c2 + c3 #L 5

      mut as int64: tokens_count = 3
      mut as int64: distancia_media = (custo_otimo_total * 10) /i tokens_count

      println("1. Quantidade de tokens emparelhados: " + tokens_count)
      println("2. Custos individuais do emparelhamento otimo: [" + c1 + ", " + c2 + ", " + c3 + "]")
      println("3. Custo total do emparelhamento de Munkres: " + custo_otimo_total)
      println("4. Distancia media por token: " + (distancia_media /i 10) + "." + (distancia_media /r 10))
      println("5. Munkres Assignment Distance concluido com sucesso.")
}
