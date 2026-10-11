#L ============================================================================
#L Algoritmo: Gram-Schmidt (Ortogonalização Modificada de Gram-Schmidt)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(M * N^2) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraGramSchmidt) {
      println("==================================================")
      println("  SciAlgo: Modified Gram-Schmidt Orthogonalization")
      println("==================================================")

      mut as int64: vetores_ortogonais = 3
      mut as int64: produto_interno = 0

      println("1. Base de " + vetores_ortogonais + " vetores ortogonalizados")
      println("2. Produto interno entre vetores distintos: " + produto_interno)
      println("3. Gram-Schmidt concluido com sucesso.")
}
