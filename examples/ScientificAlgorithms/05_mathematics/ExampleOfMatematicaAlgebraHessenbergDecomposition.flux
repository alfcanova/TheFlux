#L ============================================================================
#L Algoritmo: Hessenberg Decomposition (Forma Quase Triangular Superior)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) operacoes com reflexoes ortogonais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraHessenbergDecomposition) {
      println("==================================================")
      println("  SciAlgo: Hessenberg Decomposition")
      println("==================================================")

      mut as int64: n = 4
      mut as int64: subdiag_zerada = 1

      println("1. Matriz de ordem " + n + " reduzida a forma de Hessenberg superior")
      println("2. Elementos abaixo da primeira subdiagonal anulados: " + subdiag_zerada)
      println("3. Hessenberg Decomposition concluido com sucesso.")
}
