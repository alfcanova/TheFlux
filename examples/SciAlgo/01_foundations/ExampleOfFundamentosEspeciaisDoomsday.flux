#L ============================================================================
#L Algoritmo: Doomsday Rule (Regra do Juizo Final de John Conway 1973)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(1) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisDoomsday) {
      println("==================================================")
      println("  SciAlgo: Conway's Doomsday Rule")
      println("==================================================")

      #L Data a ser calculada: 04 de Outubro de 2026 (dia, mes, ano)
      mut as int64: day = 4
      mut as int64: month = 10
      mut as int64: year = 2026

      println("1. Data de entrada: " + day + "/" + month + "/" + year)

      #L 1. Determina a ancora secular do seculo C = year / 100
      mut as int64: c = year /i 100
      mut as int64: c_mod4 = c /r 4
      #L Ancora: (5 * (C % 4) + 2) % 7
      mut as int64: anchor = (5 * c_mod4 + 2) /r 7
      println("2. Ancora secular do seculo " + (c * 100) + ": " + anchor + " (2 = Terca)")

      #L 2. Determina o Doomsday do ano Y = year % 100
      mut as int64: y = year /r 100
      mut as int64: a = y /i 12
      mut as int64: b = y /r 12
      mut as int64: d = b /i 4
      mut as int64: doomsday_year = (anchor + a + b + d) /r 7
      println("3. Doomsday calculado para o ano " + year + ": " + doomsday_year + " (6 = Sabado)")

      #L 3. Dias-ancora mensais do Doomsday:
      #L 4/4, 6/6, 8/8, 10/10, 12/12
      #L Para Outubro (mes 10), o Doomsday e o dia 10
      mut as int64: month_anchor = 10
      #L Adiciona +70 (multiplo de 7) para garantir operando estritamente positivo em todos os backends
      mut as int64: diff_days = (day - month_anchor) + 70
      mut as int64: mod_diff = diff_days /r 7

      #L Dia da semana (0 = Domingo, 1 = Segunda, ..., 6 = Sabado)
      mut as int64: day_of_week = (doomsday_year + mod_diff) /r 7
      println("4. Dia da semana calculado (0 = Domingo): " + day_of_week)
      println("5. Validacao: " + (doomsday_year == 6 and day_of_week == 0))
      println("==================================================")
}
