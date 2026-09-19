use FinStdLib

program (ExampleOfUseFinStdLib_FinTimeValueOfMoneyContract) {
      println("==================================================")
      println("  Exemplo: FinTimeValueOfMoneyContract            ")
      println("==================================================")

      mut as FinDecimal: principal = (finFromInt(1000)).val
      mut as float64: taxa = 0.10
      mut as int64: periodos = 2

      #L 1. Juros Simples e Compostos
      mut as FinDecimal: juros_s = (finSimpleInterest(principal, taxa, periodos)).val
      mut as FinDecimal: montante_c = (finCompoundInterest(principal, taxa, periodos)).val
      println("1. Juros Simples (1000 a 10% em 2p): " + (finDecimalToString(juros_s)).val)
      println("   Montante Composto: " + (finDecimalToString(montante_c)).val)

      #L 2. Valor Presente e Valor Futuro
      mut as FinDecimal: pv = (finPresentValue(montante_c, taxa, periodos)).val
      mut as FinDecimal: fv = (finFutureValue(principal, taxa, periodos)).val
      println("2. Valor Presente: " + (finDecimalToString(pv)).val)
      println("   Valor Futuro: " + (finDecimalToString(fv)).val)

      #L 3. Anuidade e Prestacao
      mut as FinDecimal: pmt = (finAnnuityPayment(principal, taxa, periodos)).val
      mut as FinDecimal: fva = (finFutureValueOfAnnuity(pmt, taxa, periodos)).val
      mut as FinDecimal: pva = (finPresentValueOfAnnuity(pmt, taxa, periodos)).val
      println("3. Parcela Anuidade: " + (finDecimalToString(pmt)).val)
      println("   FV da Anuidade: " + (finDecimalToString(fva)).val)
      println("   PV da Anuidade: " + (finDecimalToString(pva)).val)

      #L 4. Fluxo de Caixa: VPL e Payback
      mut as list of data: cfs = [600.0, 600.0]
      mut as float64: npv = (finNetPresentValue(taxa, cfs)).val
      mut as float64: pb = (finPaybackPeriod(principal, cfs)).val
      mut as float64: dpb = (finDiscountedPayback(principal, taxa, cfs)).val
      println("4. VPL dos fluxos [600, 600]: " + ((npv * 100.0) as int64))
      println("   Payback Simples: " + ((pb * 100.0) as int64))
      println("   Payback Descontado: " + ((dpb * 100.0) as int64))

      #L 5. Taxa Interna de Retorno (TIR)
      mut as list of data: cfs_irr = [-100.0, 110.0]
      mut as float64: tir = (finInternalRateOfReturn(cfs_irr)).val
      println("5. TIR [-100, 110]: " + ((tir * 100.0) as int64))
}
