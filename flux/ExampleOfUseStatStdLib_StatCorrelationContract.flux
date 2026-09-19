use StatStdLib

program (ExampleOfUseStatStdLib_StatCorrelationContract) {
      println("==================================================")
      println("  Exemplo: StatCorrelationContract (6 Operacoes)")
      println("==================================================")

      mut as list of data: x = [1.0, 2.0, 3.0, 4.0, 5.0]
      mut as list of data: y = [2.0, 4.0, 6.0, 8.0, 10.0]

      #L 1. Covariancia Populacional
      mut as float64: cov_pop = statCovariancePopulation(x, y)
      println("1. statCovariancePopulation: " + cov_pop)

      #L 2. Covariancia Amostral
      mut as float64: cov_samp = statCovarianceSample(x, y)
      println("2. statCovarianceSample: " + cov_samp)

      #L 3. Correlacao de Pearson
      mut as float64: pearson = statPearsonCorrelation(x, y)
      println("3. statPearsonCorrelation: " + pearson)

      #L 4. Correlacao de Spearman (por postos)
      mut as list of data: xa = [1.0, 2.0, 3.0, 4.0, 5.0]
      mut as list of data: ya = [5.0, 4.0, 3.0, 2.0, 1.0]
      mut as float64: spearman = statSpearmanCorrelation(xa, ya)
      println("4. statSpearmanCorrelation([1..5], [5..1] inv): " + spearman)

      #L 5. Regressao Linear Simples (y = 1.5x + 1.0 aprox)
      mut as list of data: xr = [1.0, 2.0, 3.0, 4.0, 5.0]
      mut as list of data: yr = [2.5, 4.0, 5.5, 7.0, 8.5]
      mut as map: reg = statLinearRegression(xr, yr)
      println("5. statLinearRegression:")
      println("   slope: " + reg["slope"])
      println("   intercept: " + reg["intercept"])
      println("   r_squared: " + reg["r_squared"])
      println("   std_err: " + reg["std_err"])

      #L 6. Residuos da reta ajustada
      mut as float64: slope_v = 1.5
      mut as float64: intercept_v = 1.0
      mut as list of data: residuals = statLinearResiduals(xr, yr, slope_v, intercept_v)
      println("6. statLinearResiduals: " + residuals)
}
