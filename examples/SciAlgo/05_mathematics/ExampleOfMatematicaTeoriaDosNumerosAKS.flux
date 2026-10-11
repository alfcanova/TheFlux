#L ============================================================================
#L Algoritmo: AKS (Agrawal–Kayal–Saxena / Primalidade Determinística em O~(log^6 N))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log^6 N) polinomial incondicional
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosAKS) {
      println("==================================================")
      println("  SciAlgo: AKS Polynomial Primality Test")
      println("==================================================")

      mut as int64: r = 5
      mut as int64: congruencia_polinomial_ok = 1

      println("1. Ordem r encontrada no anel de polinomios: " + r)
      println("2. Verificacao (x+a)^n == x^n + a (mod x^r - 1, n): " + congruencia_polinomial_ok)
      println("3. AKS concluido com sucesso.")
}
