use StatStdLib

program (ExampleOfUseStatStdLib_StatCentralTendencyContract) {
      println("==================================================")
      println("  Exemplo: StatCentralTendencyContract (10 Operacoes)")
      println("==================================================")

      #L 1. Media Aritmetica
      mut as list of data: vals = [10.0, 20.0, 30.0, 40.0, 50.0]
      mut as float64: m = statMean(vals)
      println("1. statMean([10, 20, 30, 40, 50]): " + m)

      #L 2. Media Ponderada
      mut as list of data: w = [1.0, 2.0, 3.0, 4.0, 5.0]
      mut as float64: wm = statWeightedMean(vals, w)
      println("2. statWeightedMean: " + wm)

      #L 3. Media Geometrica
      mut as list of data: gvals = [2.0, 8.0]
      mut as float64: gm = statGeometricMean(gvals)
      println("3. statGeometricMean([2, 8]): " + gm)

      #L 4. Media Harmonica
      mut as list of data: hvals = [2.0, 4.0, 8.0]
      mut as float64: hm = statHarmonicMean(hvals)
      println("4. statHarmonicMean([2, 4, 8]): " + hm)

      #L 5. Mediana (par e impar)
      mut as list of data: evens = [1.0, 2.0, 4.0, 8.0]
      mut as float64: med = statMedian(evens)
      println("5. statMedian([1, 2, 4, 8]): " + med)

      #L 6. Mediana Baixa
      mut as float64: med_low = statMedianLow(evens)
      println("6. statMedianLow([1, 2, 4, 8]): " + med_low)

      #L 7. Mediana Alta
      mut as float64: med_high = statMedianHigh(evens)
      println("7. statMedianHigh([1, 2, 4, 8]): " + med_high)

      #L 8. Moda Unica
      mut as list of data: mvals = [1.0, 2.0, 2.0, 3.0, 3.0, 4.0]
      mut as float64: md = statMode(mvals)
      println("8. statMode([1, 2, 2, 3, 3, 4]): " + md)

      #L 9. Multimoda
      mut as list of data: mmd = statMultimode(mvals)
      println("9. statMultimode([1, 2, 2, 3, 3, 4]): " + mmd)

      #L 10. Media Podada (Trimmed Mean)
      mut as list of data: tvals = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
      mut as float64: tm = statTrimmedMean(tvals, 0.1)
      println("10. statTrimmedMean(0.1 cut): " + tm)
}
