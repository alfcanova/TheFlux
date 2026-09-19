use StatStdLib

program (ExampleOfUseStatStdLib_StatDistributionContract) {
      println("==================================================")
      println("  Exemplo: StatDistributionContract (11 Operacoes)")
      println("==================================================")

      #L 1. Normal PDF em x=0, N(0,1)
      mut as float64: npdf = statNormalPdf(0.0, 0.0, 1.0)
      println("1. statNormalPdf(x=0, N(0,1)) ~ 0.3989: " + (npdf > 0.398 and npdf < 0.400))

      #L 2. Normal CDF: P(Z <= 0) = 0.5
      mut as float64: ncdf = statNormalCdf(0.0, 0.0, 1.0)
      println("2. statNormalCdf(x=0, N(0,1)): " + ncdf)

      #L 3. Normal InvCDF / Probit: Q(0.5) = 0.0
      mut as float64: ninv = statNormalInvCdf(0.5, 0.0, 1.0)
      println("3. statNormalInvCdf(p=0.5, N(0,1)): " + ninv)

      #L 4. Binomial PMF: P(X=3 | n=10, p=0.5)
      mut as float64: bpmf = statBinomialPmf(3, 10, 0.5)
      println("4. statBinomialPmf(k=3, n=10, p=0.5): " + bpmf)

      #L 5. Binomial CDF: P(X<=3 | n=10, p=0.5)
      mut as float64: bcdf = statBinomialCdf(3, 10, 0.5)
      println("5. statBinomialCdf(k=3, n=10, p=0.5): " + bcdf)

      #L 6. Poisson PMF: P(X=2 | lambda=3)
      mut as float64: ppmf = statPoissonPmf(2, 3.0)
      println("6. statPoissonPmf(k=2, lambda=3): " + ppmf)

      #L 7. Poisson CDF: P(X<=2 | lambda=3)
      mut as float64: pcdf = statPoissonCdf(2, 3.0)
      println("7. statPoissonCdf(k=2, lambda=3): " + pcdf)

      #L 8. Exponencial PDF: f(1 | lambda=2)
      mut as float64: epdf = statExponentialPdf(1.0, 2.0)
      println("8. statExponentialPdf(x=1, lambda=2): " + epdf)

      #L 9. Exponencial CDF: F(1 | lambda=2)
      mut as float64: ecdf = statExponentialCdf(1.0, 2.0)
      println("9. statExponentialCdf(x=1, lambda=2): " + ecdf)

      #L 10. Uniforme PDF: f(0.5 | a=0, b=1) = 1.0
      mut as float64: updf = statUniformPdf(0.5, 0.0, 1.0)
      println("10. statUniformPdf(x=0.5, a=0, b=1): " + updf)

      #L 11. Uniforme CDF: F(0.5 | a=0, b=1) = 0.5
      mut as float64: ucdf = statUniformCdf(0.5, 0.0, 1.0)
      println("11. statUniformCdf(x=0.5, a=0, b=1): " + ucdf)
}
