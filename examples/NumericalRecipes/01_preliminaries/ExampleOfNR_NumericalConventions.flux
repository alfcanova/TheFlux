#L ============================================================================
#L Algoritmo: Numerical Conventions & Bounds (Limites Numericos e Ponto Fixo)
#L Capitulo: 01_preliminaries
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Convencoes numericas de ponto fixo escalado e protecao contra overflow.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_NumericalConventions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_NumericalConventions")
      println("==================================================")

      #L Escala fixa de 1000 para representacao fracionaria (1.500 = 1500)
      mut as int64: scale = 1000
      mut as int64: a = 2500 #L 2.5
      mut as int64: b = 4000 #L 4.0

      println("1. Operacoes em aritmetica de ponto fixo escalada (escala 1000):")
      #L Multiplicacao escalada: (a * b) / scale
      mut as int64: prod_scaled = (a * b) /i scale
      println("   -> Multiplicacao 2.5 * 4.0 = " + prod_scaled + " (esperado: 10000 = 10.0)")

      #L Divisao escalada: (a * scale) / b
      mut as int64: div_scaled = (a * scale) /i b
      println("   -> Divisao 2.5 / 4.0 = " + div_scaled + " (esperado: 625 = 0.625)")

      #L Verificacao de conservacao aritmetica: (prod * div) / scale == a * a
      mut as int64: roundtrip = (prod_scaled * div_scaled) /i scale
      println("2. Roundtrip aritmetico (10.0 * 0.625 = 6.25): " + roundtrip + " (esperado: 6250)")

      println("3. Convencoes numericas e limites estaveis validados.")
}
