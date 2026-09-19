use FinStdLib

program (ExampleOfUseFinStdLib_FinRateContract) {
      println("==================================================")
      println("  Exemplo: FinRateContract (Taxas e Conversoes)   ")
      println("==================================================")

      mut as float64: taxa_nominal = 0.12
      mut as int64: m = 12

      #L 1. Taxa Efetiva Anual a partir da Nominal Mensal
      mut as float64: taxa_efetiva = (finEffectiveRate(taxa_nominal, m)).val
      println("1. Taxa Efetiva (12% nom cap 12x): " + ((taxa_efetiva * 10000.0) as int64))

      #L 2. Taxa Nominal a partir da Efetiva
      mut as float64: rec_nominal = (finNominalRate(taxa_efetiva, m)).val
      println("2. Taxa Nominal recuperada: " + ((rec_nominal * 10000.0) as int64))

      #L 3. Conversao entre Periodos (Mensal 12 -> Semestral 2)
      mut as float64: taxa_conv = (finConvertRate(taxa_nominal, 12, 2)).val
      println("3. Conversao (12p para 2p): " + ((taxa_conv * 10000.0) as int64))

      #L 4. Taxa Real (Fisher: nominal vs inflacao)
      mut as float64: inflacao = 0.04
      mut as float64: taxa_real = (finRealRate(0.10, inflacao)).val
      println("4. Taxa Real (10% nom vs 4% inf): " + ((taxa_real * 10000.0) as int64))

      #L 5. Capitalizacao Continua (e^(r*t))
      mut as FinDecimal: principal = (finFromInt(1000)).val
      mut as FinDecimal: fv_cont = (finContinuousCompounding(principal, 0.05, 2.0)).val
      println("5. Capitalizacao Continua (1000 a 5% por 2 anos): " + (finDecimalToString(fv_cont)).val)

      #L 6. Conversoes a partir da Taxa Mensal (1.00% a.m.)
      mut as float64: i_mensal = 0.01
      mut as float64: i_dia_de_mes = (finMonthlyToDailyRate(i_mensal, 30)).val
      mut as float64: i_ano_de_mes = (finMonthlyToAnnualRate(i_mensal)).val
      println("6. Mensal (1.00% a.m.) -> Diaria (30d): " + (finFormatPercent(i_dia_de_mes, 4)).val)
      println("   Mensal (1.00% a.m.) -> Anual (12m): " + (finFormatPercent(i_ano_de_mes, 2)).val)

      #L 7. Conversoes a partir da Taxa Anual (12.00% a.a.)
      mut as float64: i_anual = 0.12
      mut as float64: i_mes_de_ano = (finAnnualToMonthlyRate(i_anual)).val
      mut as float64: i_dia_de_ano360 = (finAnnualToDailyRate(i_anual, 360)).val
      mut as float64: i_dia_de_ano252 = (finAnnualToDailyRate(i_anual, 252)).val
      println("7. Anual (12.00% a.a.) -> Mensal (12m): " + (finFormatPercent(i_mes_de_ano, 4)).val)
      println("   Anual (12.00% a.a.) -> Diaria (360d comercial): " + (finFormatPercent(i_dia_de_ano360, 4)).val)
      println("   Anual (12.00% a.a.) -> Diaria (252d uteis): " + (finFormatPercent(i_dia_de_ano252, 4)).val)

      #L 8. Conversoes a partir da Taxa Diaria (0.04% a.d.)
      mut as float64: i_diaria = 0.0004
      mut as float64: i_mes_de_dia = (finDailyToMonthlyRate(i_diaria, 30)).val
      mut as float64: i_ano_de_dia = (finDailyToAnnualRate(i_diaria, 360)).val
      println("8. Diaria (0.04% a.d.) -> Mensal (30d): " + (finFormatPercent(i_mes_de_dia, 2)).val)
      println("   Diaria (0.04% a.d.) -> Anual (360d): " + (finFormatPercent(i_ano_de_dia, 2)).val)

      #L 9. Helper Geral de Taxa Equivalente (1% a.m. para Semestral 6m)
      mut as float64: i_semestral = (finRateEquivalent(i_mensal, 6.0, 1.0)).val
      println("9. Taxa Equivalente Geral (1% a.m. -> 6 meses): " + (finFormatPercent(i_semestral, 2)).val)
}
