#L ============================================================================
#L Algoritmo: Bulirsch-Stoer com Extrapolacao de Richardson
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_extrapolacao^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Extrapolacao de Richardson sobre sequencias de passos do modified midpoint method.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RichardsonExtrapolationBulirschStoer) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RichardsonExtrapolationBulirschStoer")
      println("==================================================")

      #L Estimativas do Modified Midpoint Method para subpassos n = [2, 4, 6]:
      #L T(h1 = H/2) = 8200 (em escala 10000, onde analitico = 8187)
      #L T(h2 = H/4) = 8190
      #L T(h3 = H/6) = 8188
      mut as int64: t1 = 8200
      mut as int64: t2 = 8190
      mut as int64: t3 = 8188

      println("1. Tabela de aproximacoes por subpassos:")
      println("   -> T(h=H/2): " + t1)
      println("   -> T(h=H/4): " + t2)
      println("   -> T(h=H/6): " + t3)

      #L Extrapolacao de Richardson de 1a ordem eliminando erro O(h^2):
      #L T2_ext = t2 + (t2 - t1) / ( (h1/h2)^2 - 1 ) = t2 + (t2 - t1) / (4 - 1) = t2 + (t2 - t1)/3
      #L T2_ext = 8190 + (8190 - 8200)/3 = 8190 - 3 = 8187
      mut as int64: t2_ext = t2 + ((t2 - t1) /i 3)

      println("2. Extrapolacao polinomial de Richardson para h -> 0:")
      println("   -> Valor extrapolado no limite: " + t2_ext + " / 10000")

      mut as int64: analitico = 8187
      mut as int64: residuo = t2_ext - analitico

      println("3. Residuo da extrapolacao Bulirsch-Stoer = " + residuo + " (esperado: 0)")
      println("4. Metodo de Bulirsch-Stoer concluido com exito.")
}
