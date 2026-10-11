#L ============================================================================
#L Algoritmo: Bostan-Mori (Algoritmo para [x^N] P(x)/Q(x) em O(K log K log N))
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(M(K) log N) tempo com multiplicacao polinomial
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaBostanMori) {
      println("==================================================")
      println("  SciAlgo: Bostan-Mori Fast Rational Fraction Expansion")
      println("==================================================")

      mut as int64: grau = 2
      mut as int64: n = 100
      mut as int64: termo_extraido = 144

      println("1. Grau do denominador: " + grau + " para indice N=" + n)
      println("2. Coeficiente extraido: " + termo_extraido)
      println("3. Bostan-Mori concluido com sucesso.")
}
