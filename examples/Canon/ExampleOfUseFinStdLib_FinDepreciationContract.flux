use FinStdLib

program (ExampleOfUseFinStdLib_FinDepreciationContract) {
      println("==================================================")
      println("  Exemplo: FinDepreciationContract (Depreciacao)   ")
      println("==================================================")

      mut as FinDecimal: custo = (finFromInt(10000)).val
      mut as FinDecimal: residual = (finFromInt(1000)).val
      mut as int64: vida_util = 5

      #L 1. Depreciacao Linear (Straight-Line)
      mut as FinDecimal: dep_linear = (finDepreciationLinear(custo, residual, vida_util)).val
      println("1. Depreciacao Linear Anual (10000, res 1000, 5 anos): " + (finDecimalToString(dep_linear)).val)

      #L 2. Soma dos Digitos dos Anos (SYD)
      mut as FinDecimal: syd_ano1 = (finDepreciationSyd(custo, residual, vida_util, 1)).val
      mut as FinDecimal: syd_ano2 = (finDepreciationSyd(custo, residual, vida_util, 2)).val
      println("2. Metodo SYD:")
      println("   Ano 1: " + (finDecimalToString(syd_ano1)).val)
      println("   Ano 2: " + (finDecimalToString(syd_ano2)).val)

      #L 3. Saldo Duplamente Decrescente (DDB)
      mut as FinDecimal: ddb_ano1 = (finDepreciationDdb(custo, residual, vida_util, 1)).val
      mut as FinDecimal: ddb_ano2 = (finDepreciationDdb(custo, residual, vida_util, 2)).val
      println("3. Metodo DDB:")
      println("   Ano 1: " + (finDecimalToString(ddb_ano1)).val)
      println("   Ano 2: " + (finDecimalToString(ddb_ano2)).val)
}
