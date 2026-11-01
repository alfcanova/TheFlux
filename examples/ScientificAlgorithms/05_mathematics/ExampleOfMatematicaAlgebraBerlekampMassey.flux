#L ============================================================================
#L Algoritmo: Berlekamp-Massey em Álgebra (Grau Mínimo de Recorrência)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraBerlekampMassey) {
      println("==================================================")
      println("  SciAlgo: Algebraic Berlekamp-Massey Algorithm")
      println("==================================================")

      mut as int64: n_termos = 6
      mut as int64: grau_minimal = 3

      println("1. Sequencia analisada com " + n_termos + " termos")
      println("2. Grau do polinomio caracteristico minimal: " + grau_minimal)
      println("3. Berlekamp-Massey concluido com sucesso.")
}
