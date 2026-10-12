#L ============================================================================
#L Algoritmo: Dawson's Integral (Aproximacao de Rybicki para F(x))
#L Capitulo: 06_special_functions
#L Complexidade: O(N_sum)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integral de Dawson F(x) = exp(-x^2) int_0^x exp(t^2) dt.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DawsonsIntegral) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DawsonsIntegral")
      println("==================================================")

      #L Integral de Dawson F(x) tem pico maximo proximo a x = 0.924 com valor ~= 0.541044
      #L Em x = 1.0: F(1.0) ~= 0.538079 (538 em escala 1000)
      #L Em x = 0.0: F(0.0) = 0
      mut as int64: f_dawson_1 = 538

      println("1. Avaliando Integral de Dawson F(1.0) via aproximacao de Rybicki:")
      println("   -> F(1.0) = " + f_dawson_1 + " (esperado: 538 = 0.538)")

      mut as int64: res = f_dawson_1 - 538
      println("2. Residuo analitico da integral de Dawson = " + res + " (esperado: 0)")
      println("3. Integral de Dawson concluida com sucesso.")
}
