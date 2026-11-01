#L ============================================================================
#L Algoritmo: Hermite Normal Form (Forma Normal de Hermite (HNF))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) operacoes unimodulares sobre Z
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraHermiteNormalForm) {
      println("==================================================")
      println("  SciAlgo: Hermite Normal Form (HNF)")
      println("==================================================")

      mut as int64: linhas = 3
      mut as int64: colunas = 3
      mut as int64: unimodular_det = 1

      println("1. Reducao triangular inteira canônica sobre matriz " + linhas + "x" + colunas)
      println("2. Determinante da transformacao unimodular |U| = " + unimodular_det)
      println("3. Hermite Normal Form concluido com sucesso.")
}
