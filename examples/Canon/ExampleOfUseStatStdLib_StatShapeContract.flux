use StatStdLib

program (ExampleOfUseStatStdLib_StatShapeContract) {
      println("==================================================")
      println("  Exemplo: StatShapeContract (6 Operacoes)")
      println("==================================================")

      #L Dados: distribuicao assimetrica a direita
      mut as list of data: data_pts = [2.0, 3.0, 3.0, 4.0, 4.0, 4.0, 5.0, 5.0, 6.0, 10.0]

      #L 1. Assimetria Populacional (Fisher-Pearson)
      mut as float64: skew_pop = statSkewnessPopulation(data_pts)
      println("1. statSkewnessPopulation: " + skew_pop)

      #L 2. Assimetria Amostral Ajustada
      mut as float64: skew_samp = statSkewnessSample(data_pts)
      println("2. statSkewnessSample: " + skew_samp)

      #L 3. Excesso de Curtose Populacional
      mut as float64: kurt_pop = statKurtosisPopulation(data_pts)
      println("3. statKurtosisPopulation: " + kurt_pop)

      #L 4. Excesso de Curtose Amostral Corrigida
      mut as float64: kurt_samp = statKurtosisSample(data_pts)
      println("4. statKurtosisSample: " + kurt_samp)

      #L 5. Momento Bruto de Ordem 2 (E[X^2])
      mut as list of data: simple = [1.0, 2.0, 3.0, 4.0, 5.0]
      mut as float64: raw2 = statRawMoment(simple, 2)
      println("5. statRawMoment([1..5], order=2): " + raw2)

      #L 6. Momento Central de Ordem 2 (= variancia pop, deve ser 2.0)
      mut as float64: cm2 = statCentralMoment(simple, 2)
      println("6. statCentralMoment([1..5], order=2): " + cm2)
}
