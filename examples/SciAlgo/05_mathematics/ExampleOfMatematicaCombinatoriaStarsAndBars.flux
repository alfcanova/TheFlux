#L ============================================================================
#L Algoritmo: Stars and Bars (Método de Bolas e Urnas)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(K) calculo binomial C(n + k - 1, k - 1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaStarsAndBars) {
      println("==================================================")
      println("  SciAlgo: Stars and Bars Combinatorics")
      println("==================================================")

      #L Distribuir n=7 itens identicos em k=3 caixas: C(7 + 3 - 1, 3 - 1) = C(9, 2)
      mut as int64: n = 7
      mut as int64: k = 3
      mut as int64: total_pos = n + k - 1
      mut as int64: c9_2 = (total_pos * (total_pos - 1)) /i 2

      println("1. Itens n=" + n + " e urnas k=" + k)
      println("2. Maneiras de distribuicao: " + c9_2)
      println("3. Stars and Bars concluido com sucesso.")
}
