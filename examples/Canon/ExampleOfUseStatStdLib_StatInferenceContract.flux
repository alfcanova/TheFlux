use StatStdLib

program (ExampleOfUseStatStdLib_StatInferenceContract) {
      println("==================================================")
      println("  Exemplo: StatInferenceContract (6 Operacoes)")
      println("==================================================")

      mut as list of data: sample = [7.0, 7.0, 7.0, 7.0, 10.0, 13.0, 13.0, 13.0, 13.0]

      #L 1. Erro Padrao da Media (SE = s/sqrt(n) = 3/3 = 1.0)
      mut as float64: se = statStandardErrorOfMean(sample)
      println("1. statStandardErrorOfMean: " + se)

      #L 2. Intervalo de Confianca 95%
      mut as list of data: ci = statConfidenceIntervalMean(sample, 0.95)
      mut as float64: low = ci[1] as float64
      mut as float64: high = ci[2] as float64
      println("2. statConfidenceIntervalMean(95%) contem media: " + (low < 10.0 and high > 10.0))

      #L 3. Teste Z para 1 amostra (hipotese: media = 10.0)
      mut as float64: z_stat = statZTestOneSample(sample, 10.0)
      println("3. statZTestOneSample(null_mean=10.0): " + z_stat)

      #L 4. Teste t para 1 amostra
      mut as list of data: t1 = statTTestOneSample(sample, 10.0)
      println("4. statTTestOneSample(null_mean=10.0):")
      println("   t_stat: " + t1[1])
      println("   df: " + t1[2])

      #L 5. Teste t para 2 amostras independentes
      mut as list of data: s1 = [6.0, 7.0, 8.0, 9.0, 10.0]
      mut as list of data: s2 = [1.0, 2.0, 3.0, 4.0, 5.0]
      mut as list of data: t2 = statTTestTwoSample(s1, s2)
      println("5. statTTestTwoSample([6..10] vs [1..5]):")
      println("   t_stat: " + t2[1])
      println("   df: " + t2[2])

      #L 6. Qui-Quadrado de Aderencia (GoF)
      mut as list of data: observed = [10.0, 20.0, 30.0]
      mut as list of data: expected = [20.0, 20.0, 20.0]
      mut as list of data: chi = statChiSquareGoF(observed, expected)
      println("6. statChiSquareGoF:")
      println("   chi2_stat: " + chi[1])
      println("   df: " + chi[2])
}
