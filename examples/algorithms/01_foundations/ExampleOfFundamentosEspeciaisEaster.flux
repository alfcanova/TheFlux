#L ============================================================================
#L Algoritmo: Computus Gregoriano (Meeus/Jones/Butcher Easter Algorithm)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(1) tempo analitico | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisEaster) {
      println("==================================================")
      println("  SciAlgo: Anonymous Gregorian Easter Algorithm")
      println("==================================================")

      mut as int64: y = 2026
      println("1. Ano analisado: " + y)

      #L Passos do algoritmo de Meeus/Jones/Butcher para a Pascoa
      mut as int64: a = y /r 19
      mut as int64: b = y /i 100
      mut as int64: c = y /r 100
      mut as int64: d = b /i 4
      mut as int64: e = b /r 4
      mut as int64: f = (b + 8) /i 25
      mut as int64: g = (b - f + 1) /i 3
      mut as int64: h = (19 * a + b - d - g + 15) /r 30
      mut as int64: i = c /i 4
      mut as int64: k = c /r 4
      mut as int64: l = (32 + 2 * e + 2 * i - h - k) /r 7
      mut as int64: m = (a + 11 * h + 22 * l) /i 451

      mut as int64: month = (h + l - 7 * m + 114) /i 31
      mut as int64: day = ((h + l - 7 * m + 114) /r 31) + 1

      println("2. Domingo de Pascoa calculado para " + y + ":")
      println("   Dia: " + day + " | Mes: " + month + " (Abril)")
      println("3. Validacao: " + (day == 5 and month == 4))
      println("==================================================")
}
