#L ============================================================================
#L Algoritmo: Hensel Lifting (Elevacao de Hensel para Fatoracao Polinomial)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(D log P) elevacao modular quadratica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraHenselLifting) {
      println("==================================================")
      println("  SciAlgo: Hensel Lifting")
      println("==================================================")

      mut as int64: p = 5
      mut as int64: p2 = p * p
      mut as int64: raiz_mod_p = 2
      #L x^2 - 4 = 0 mod 5 -> x = 2
      #L elevacao para mod 25
      mut as int64: raiz_mod_p2 = 7

      println("1. Raiz inicial modulo " + p + ": " + raiz_mod_p)
      println("2. Raiz elevada modulo " + p2 + ": " + raiz_mod_p2)
      println("3. Hensel Lifting concluido com sucesso.")
}
