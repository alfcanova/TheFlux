use StatStdLib

program (ExampleOfUseStatStdLib_StatSummaryContract) {
      println("==================================================")
      println("  Exemplo: StatSummaryContract (6 Operacoes)")
      println("==================================================")

      mut as list of data: data_pts = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 100.0]

      #L 1. Resumo de 5 numeros de Tukey
      mut as list of data: five = statFiveNumberSummary(data_pts)
      println("1. statFiveNumberSummary:")
      println("   [min, Q1, median, Q3, max]: " + five)

      #L 2. Deteccao de Outliers por IQR (multiplicador 1.5)
      mut as list of data: outliers = statDetectOutliersIqr(data_pts, 1.5)
      println("2. statDetectOutliersIqr(k=1.5): " + outliers)

      #L 3. Tabela de Frequencia
      mut as list of data: cat_data = [1.0, 2.0, 2.0, 3.0, 3.0, 3.0, 4.0]
      mut as map: freq = statFrequencyTable(cat_data)
      println("3. statFrequencyTable([1,2,2,3,3,3,4]):")
      println("   freq[\"1.0\"]: " + freq["1.0"])
      println("   freq[\"2.0\"]: " + freq["2.0"])
      println("   freq[\"3.0\"]: " + freq["3.0"])
      println("   freq[\"4.0\"]: " + freq["4.0"])

      #L 4. Limites das faixas para histograma (5 bins)
      mut as list of data: hist_data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
      mut as list of data: bins = statHistogramBins(hist_data, 5)
      println("4. statHistogramBins(5 bins): " + bins)

      #L 5. Contagens por faixa do histograma
      mut as list of data: counts = statHistogramCounts(hist_data, bins)
      println("5. statHistogramCounts: " + counts)

      #L 6. Describe completo
      mut as list of data: clean = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]
      mut as map: desc = statDescribe(clean)
      println("6. statDescribe:")
      println("   count: " + desc["count"])
      println("   mean: " + desc["mean"])
      println("   std_dev: " + desc["std_dev"])
      println("   min: " + desc["min"])
      println("   q1: " + desc["q1"])
      println("   median: " + desc["median"])
      println("   q3: " + desc["q3"])
      println("   max: " + desc["max"])
      println("   iqr: " + desc["iqr"])
      println("   skewness: " + desc["skewness"])
}
