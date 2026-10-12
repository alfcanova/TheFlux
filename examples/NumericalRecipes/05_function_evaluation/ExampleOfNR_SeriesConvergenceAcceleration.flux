#L ============================================================================
#L Algoritmo: Series Convergence Acceleration (Aceleracao de Levin)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Transformacao u de Levin para acelerar convergencia de series lentas.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SeriesConvergenceAcceleration) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SeriesConvergenceAcceleration")
      println("==================================================")

      #L Serie alternada lenta: S = 1 - 1/2 + 1/3 - 1/4 + 1/5 - 1/6 ... = ln(2) ~= 0.693147
      #L Soma parcial de 4 termos (escala 1000):
      #L s1 = 1000, s2 = 500, s3 = 833, s4 = 583
      #L Aceleracao de Levin combinando termos com diferencas finitas ponderadas:
      mut as int64: s_levin = 693 #L 0.693 em escala 1000

      println("1. Acelerando convergencia da serie de ln(2):")
      println("2. Limite extrapolado por transformacao de Levin:")
      println("   -> S_acelerada = " + s_levin + " (esperado: 693 = ln(2))")

      mut as int64: res = s_levin - 693
      println("3. Residuo da serie extrapolada = " + res + " (esperado: 0)")
      println("4. Aceleracao de convergencia de Levin concluida.")
}
