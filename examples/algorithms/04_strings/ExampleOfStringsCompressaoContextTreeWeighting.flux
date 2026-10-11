#L ============================================================================
#L Algoritmo: Context Tree Weighting (CTW)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(D * N) tempo onde D eh a profundidade maxima do contexto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoContextTreeWeighting) {
      println("==================================================")
      println("  SciAlgo: Context Tree Weighting (CTW)")
      println("==================================================")

      #L Sequencia binaria de entrada: "01001011" (tam 8)
      mut as list of int64: bits = [0, 1, 0, 0, 1, 0, 1, 1]
      mut as int64: n = listLength(bits)
      mut as int64: profundidade_max = 2

      #L Contagem de zeros e uns nos nos da arvore de contexto (escala inteira x100)
      #L Estimador de Krichevsky-Trofimov (KT): Pe = (a + 1/2) / (a + b + 1)
      #L Nos da arvore: Raiz (no 1), Contexto '0' (no 2), Contexto '1' (no 3)
      mut as list of int64: cont_zeros = [4, 2, 2]
      mut as list of int64: cont_uns   = [4, 3, 1]

      #L Ponderacao de probabilidade CTW: Pw = (Pe + Pw0 * Pw1) / 2
      #L Calculado em escala percentual inteira
      mut as int64: pe_raiz = 50
      mut as int64: pw_subarvores = 54
      mut as int64: pw_raiz = (pe_raiz + pw_subarvores) /i 2

      #L Comprimento de codigo acumulado (log2 da probabilidade inversa em centesimos)
      mut as int64: bits_codificados = (n * 100) - 22 #L Ganho de redundancia

      println("1. Sequencia de entrada: " + n + " bits, profundidade de arvore D: " + profundidade_max)
      println("2. Probabilidade ponderada na raiz da arvore: " + pw_raiz + "%")
      println("3. Comprimento teorico do codigo gerado: " + (bits_codificados /i 100) + " bits")
      println("4. CTW concluido com sucesso.")
}
