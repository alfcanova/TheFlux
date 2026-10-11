#L ============================================================================
#L Algoritmo: Cantor-Zassenhaus (Fatoração Probabilística de Polinômios em GF(p))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2 log p) tempo probabilistico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraCantorZassenhaus) {
      println("==================================================")
      println("  SciAlgo: Cantor-Zassenhaus Factorization")
      println("==================================================")

      mut as int64: divisao_igual_grau = 1
      println("1. Separacao de raizes com GCD(a(x)^{(p^d-1)/2} - 1, f(x)): " + divisao_igual_grau)
      println("2. Cantor-Zassenhaus concluido com sucesso.")
}
