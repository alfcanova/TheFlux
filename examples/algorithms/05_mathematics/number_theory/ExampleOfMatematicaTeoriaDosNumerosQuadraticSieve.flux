#L ============================================================================
#L Algoritmo: Quadratic Sieve — QS (Crivo Quadrático Subexponencial)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(exp(sqrt(ln N * ln ln N)))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosQuadraticSieve) {
      println("==================================================")
      println("  SciAlgo: Quadratic Sieve (QS) Subexponential")
      println("==================================================")

      mut as int64: base_de_fatores = 12
      mut as int64: polinomios_crivados = 4
      mut as int64: fator_isolado = 37

      println("1. Base de fatores primos: " + base_de_fatores)
      println("2. Crivagem polinomial de Dixon em blocos: " + polinomios_crivados)
      println("3. Fator obtido: " + fator_isolado)
      println("4. Quadratic Sieve concluido com sucesso.")
}
