use StatStdLib

program (ExampleOfUseStatStdLib_StatDispersionContract) {
      println("==================================================")
      println("  Exemplo: StatDispersionContract (11 Operacoes)")
      println("==================================================")

      mut as list of data: data_pts = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]

      #L 1. Variancia Populacional
      mut as float64: vp = statVariancePopulation(data_pts)
      println("1. statVariancePopulation: " + vp)

      #L 2. Variancia Amostral
      mut as float64: vs = statVarianceSample(data_pts)
      println("2. statVarianceSample: " + vs)

      #L 3. Desvio Padrao Populacional
      mut as float64: sp = statStdDevPopulation(data_pts)
      println("3. statStdDevPopulation: " + sp)

      #L 4. Desvio Padrao Amostral
      mut as float64: ss = statStdDevSample(data_pts)
      println("4. statStdDevSample: " + ss)

      #L 5. Amplitude (Range)
      mut as float64: rng = statRange(data_pts)
      println("5. statRange: " + rng)

      #L 6. Minimo
      mut as float64: mn = statMin(data_pts)
      println("6. statMin: " + mn)

      #L 7. Maximo
      mut as float64: mx = statMax(data_pts)
      println("7. statMax: " + mx)

      #L 8. IQR (Amplitude Interquartil)
      mut as float64: iqr = statIQR(data_pts)
      println("8. statIQR: " + iqr)

      #L 9. Desvio Absoluto Medio (MAD da Media)
      mut as float64: mad_mean = statMeanAbsoluteDeviation(data_pts)
      println("9. statMeanAbsoluteDeviation: " + mad_mean)

      #L 10. Desvio Absoluto Mediano (MAD da Mediana)
      mut as float64: mad_med = statMedianAbsoluteDeviation(data_pts)
      println("10. statMedianAbsoluteDeviation: " + mad_med)

      #L 11. Coeficiente de Variacao
      mut as float64: cv = statCoefficientOfVariation(data_pts)
      println("11. statCoefficientOfVariation: " + cv)
}
