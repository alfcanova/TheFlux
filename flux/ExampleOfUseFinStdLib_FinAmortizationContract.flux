use FinStdLib

program (ExampleOfUseFinStdLib_FinAmortizationContract) {
      println("==================================================")
      println("  Exemplo: FinAmortizationContract (Sistemas Amort)")
      println("==================================================")

      mut as FinDecimal: principal = (finFromInt(1000)).val
      mut as float64: taxa_anual = 0.12
      mut as int64: meses = 2

      #L 1. Sistema Frances (Tabela Price)
      mut as list of data: price_sched = (finAmortizationPrice(principal, taxa_anual, meses)).val
      mut as AmortizationInstallment: pr1 = price_sched[1] as AmortizationInstallment
      mut as AmortizationInstallment: pr2 = price_sched[2] as AmortizationInstallment
      println("1. Tabela Price (1000 a 12% a.a. em 2 meses):")
      println("   Mes 1: Parcela=" + (finDecimalToString(pr1.payment)).val + " Amort=" + (finDecimalToString(pr1.amortization)).val + " Juros=" + (finDecimalToString(pr1.interest)).val + " Saldo=" + (finDecimalToString(pr1.balance)).val)
      println("   Mes 2: Parcela=" + (finDecimalToString(pr2.payment)).val + " Amort=" + (finDecimalToString(pr2.amortization)).val + " Juros=" + (finDecimalToString(pr2.interest)).val + " Saldo=" + (finDecimalToString(pr2.balance)).val)

      #L 2. Sistema de Amortizacao Constante (SAC)
      mut as list of data: sac_sched = (finAmortizationSac(principal, taxa_anual, meses)).val
      mut as AmortizationInstallment: s1 = sac_sched[1] as AmortizationInstallment
      mut as AmortizationInstallment: s2 = sac_sched[2] as AmortizationInstallment
      println("2. Sistema SAC:")
      println("   Mes 1: Parcela=" + (finDecimalToString(s1.payment)).val + " Amort=" + (finDecimalToString(s1.amortization)).val + " Juros=" + (finDecimalToString(s1.interest)).val + " Saldo=" + (finDecimalToString(s1.balance)).val)
      println("   Mes 2: Parcela=" + (finDecimalToString(s2.payment)).val + " Amort=" + (finDecimalToString(s2.amortization)).val + " Juros=" + (finDecimalToString(s2.interest)).val + " Saldo=" + (finDecimalToString(s2.balance)).val)

      #L 3. Sistema Americano (SAA)
      mut as list of data: saa_sched = (finAmortizationSaa(principal, taxa_anual, meses)).val
      mut as AmortizationInstallment: a1 = saa_sched[1] as AmortizationInstallment
      mut as AmortizationInstallment: a2 = saa_sched[2] as AmortizationInstallment
      println("3. Sistema Americano:")
      println("   Mes 1: Parcela=" + (finDecimalToString(a1.payment)).val + " Amort=" + (finDecimalToString(a1.amortization)).val + " Saldo=" + (finDecimalToString(a1.balance)).val)
      println("   Mes 2: Parcela=" + (finDecimalToString(a2.payment)).val + " Amort=" + (finDecimalToString(a2.amortization)).val + " Saldo=" + (finDecimalToString(a2.balance)).val)

      #L 4. Totais de Amortizacao
      mut as map: totais = (finAmortizationTotals(price_sched)).val
      mut as FinDecimal: tot_p = totais["total_paid"] as FinDecimal
      mut as FinDecimal: tot_a = totais["total_amortization"] as FinDecimal
      mut as FinDecimal: tot_j = totais["total_interest"] as FinDecimal
      println("4. Totais Price:")
      println("   Total Pago: " + (finDecimalToString(tot_p)).val)
      println("   Total Amortizado: " + (finDecimalToString(tot_a)).val)
      println("   Total Juros: " + (finDecimalToString(tot_j)).val)
}
