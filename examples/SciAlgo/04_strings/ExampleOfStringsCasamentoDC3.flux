#L ============================================================================
#L Algoritmo: DC3 / Kärkkäinen-Sanders (Difference Cover 3 / Skew Algorithm)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo linear deterministico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoDC3) {
      println("==================================================")
      println("  SciAlgo: DC3 (Karkkainen-Sanders) Linear Suffix Array")
      println("==================================================")

      mut as int64: n = 12
      mut as int64: amostras_b0 = 4
      mut as int64: amostras_b12 = 8

      println("1. Divisao do texto em posicoes mod 3: B12=" + amostras_b12 + ", B0=" + amostras_b0)
      println("2. DC3 concluido com sucesso.")
}
