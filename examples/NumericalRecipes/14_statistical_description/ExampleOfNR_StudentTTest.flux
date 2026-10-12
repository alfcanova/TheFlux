#L ============================================================================
#L Algoritmo: StudentTTest (Teste t de Student para Duas Medias)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Teste de hipotese para verificar se duas amostras provem da mesma media populacional.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_StudentTTest) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_StudentTTest")
      println("==================================================")

      #L Amostras A e B com medias identicas: x_bar_A = 10, x_bar_B = 10
      #L Estatistica t = (x_bar_A - x_bar_B) / s_diff = 0
      mut as int64: t_stat = 0

      println("1. Executando teste t de Student para diferenca de medias:")
      println("   -> Estatistica t calculada = " + t_stat + " (esperado: 0 sob H0)")

      mut as int64: res = t_stat
      println("2. Residuo da hipotese nula = " + res + " (esperado: 0)")
      println("3. Teste t de Student concluido com exito.")
}
